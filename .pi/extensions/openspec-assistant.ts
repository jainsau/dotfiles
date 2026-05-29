import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  // 1. Auto-validation on edit/write
  pi.on("tool_result", async (event, ctx) => {
    if (event.toolName !== "edit" && event.toolName !== "write") return;
    
    const path = (event.input as any).path as string;
    if (!path || !path.includes("openspec/changes/")) return;

    // Extract the change name from the path (e.g. openspec/changes/<change-name>/...)
    const match = path.match(/openspec\/changes\/([^\/]+)/);
    if (!match) return;
    const changeName = match[1];

    ctx.ui.setStatus("openspec", `Validating ${changeName}...`);
    
    // Run openspec validate
    const result = await pi.exec("openspec", ["validate", changeName], { cwd: ctx.cwd });
    
    ctx.ui.setStatus("openspec", "");

    if (result.code !== 0) {
      // Validation failed! Inject the error back into the LLM's result
      const currentText = event.content?.find(c => c.type === "text")?.text || "File updated.";
      
      return {
        content: [
          { 
            type: "text", 
            text: `${currentText}\n\n⚠️ **OpenSpec Validation Failed**:\n\`\`\`\n${result.stderr || result.stdout}\n\`\`\`\n\nPlease fix these schema/validation errors immediately.` 
          }
        ],
        isError: true // Mark as error so the LLM attempts a fix
      };
    }
  });

  // 2. Command wrapper for easy access
  pi.registerCommand("openspec", {
    description: "Run OpenSpec commands directly from Pi (e.g., /openspec status)",
    handler: async (args, ctx) => {
      const argsList = args ? args.split(" ") : ["list"];
      const res = await pi.exec("openspec", argsList, { cwd: ctx.cwd });
      ctx.ui.notify(res.stdout || res.stderr, res.code === 0 ? "info" : "error");
    }
  });
}
