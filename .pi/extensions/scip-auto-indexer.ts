import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  // Command to quickly generate a SCIP index for the current directory
  // This pairs perfectly with the pi-agent-scip tools you already installed
  pi.registerCommand("scip-index", {
    description: "Generate a SCIP index for the current repository so the agent can navigate it",
    handler: async (args, ctx) => {
      ctx.ui.notify("Detecting language and generating SCIP index...", "info");
      
      // Auto-detect language
      const isGo = (await pi.exec("ls", ["go.mod"], { cwd: ctx.cwd })).code === 0;
      const isTs = (await pi.exec("ls", ["package.json"], { cwd: ctx.cwd })).code === 0;
      const isPy = (await pi.exec("ls", ["requirements.txt"], { cwd: ctx.cwd })).code === 0 || 
                   (await pi.exec("ls", ["pyproject.toml"], { cwd: ctx.cwd })).code === 0;

      let cmd = "";
      if (isGo) {
        cmd = "scip-go";
      } else if (isTs) {
        cmd = "npx @sourcegraph/scip-typescript index";
      } else if (isPy) {
        cmd = "scip-python index .";
      } else {
        ctx.ui.notify("Could not detect supported SCIP language (Go, TS, Python)", "error");
        return;
      }

      const res = await pi.exec("bash", ["-c", cmd], { cwd: ctx.cwd, timeout: 60000 });
      
      if (res.code === 0) {
        ctx.ui.notify("SCIP index generated successfully! SCIP tools are now ready.", "info");
      } else {
        ctx.ui.notify(`Failed to generate SCIP index: ${res.stderr || res.stdout}`, "error");
      }
    }
  });

  // We also add a hint to the prompt so the agent knows to ask you to run this if it needs to
  pi.on("before_agent_start", async (event, ctx) => {
    return {
      systemPrompt: event.systemPrompt + "\n\nIf you need to navigate this codebase using SCIP but the index is missing or stale, ask the user to run `/scip-index`."
    };
  });
}
