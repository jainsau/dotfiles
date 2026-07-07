/**
 * Pi bridge — spawns `pi --mode rpc` as a subprocess and translates its
 * event stream to agent-sh's bus protocol.
 *
 * Vendored in dotfiles. Uses the same RPC protocol as pi-acp (nvim bridge).
 * ponytail: no npm deps needed — just child_process + readline over stdio.
 */
import type { ExtensionContext } from "agent-sh/types";
import { spawn, type ChildProcess } from "node:child_process";
import * as readline from "node:readline";
import { randomUUID } from "node:crypto";
import { existsSync, readFileSync } from "node:fs";
import { resolve as resolvePath } from "node:path";

const TOOL_KINDS: Record<string, string> = {
  bash: "execute",
  read: "read",
  ls: "read",
  find: "read",
  grep: "search",
  edit: "execute",
  write: "execute",
};
const kindForTool = (name: string): string => TOOL_KINDS[name] ?? "execute";

type DiffLineRecord = { type: "context" | "added" | "removed"; oldNo: number | null; newNo: number | null; text: string };
type DiffHunkRecord = { lines: DiffLineRecord[] };
type DiffResultRecord = { hunks: DiffHunkRecord[]; added: number; removed: number; isIdentical: boolean; isNewFile: boolean };

function buildDiffFromTexts(oldText: string, newText: string, isNewFile: boolean): DiffResultRecord | null {
  if (oldText === newText) return null;
  // Simple line diff without external dep
  const oldLines = oldText.split("\n");
  const newLines = newText.split("\n");
  const allLines: DiffLineRecord[] = [];
  let added = 0, removed = 0;
  const max = Math.max(oldLines.length, newLines.length);
  // ponytail: naive O(n) diff — ceiling: large files with interleaved changes.
  //   upgrade path: import "diff" package for proper LCS-based diffing.
  let oi = 0, ni = 0;
  while (oi < oldLines.length || ni < newLines.length) {
    if (oi < oldLines.length && ni < newLines.length && oldLines[oi] === newLines[ni]) {
      allLines.push({ type: "context", oldNo: oi + 1, newNo: ni + 1, text: oldLines[oi]! });
      oi++; ni++;
    } else if (oi < oldLines.length && (ni >= newLines.length || oldLines[oi] !== newLines[ni])) {
      allLines.push({ type: "removed", oldNo: oi + 1, newNo: null, text: oldLines[oi]! });
      removed++;
      oi++;
    } else {
      allLines.push({ type: "added", oldNo: null, newNo: ni + 1, text: newLines[ni]! });
      added++;
      ni++;
    }
  }
  if (allLines.length === 0) return null;
  return { hunks: [{ lines: allLines }], added, removed, isIdentical: false, isNewFile };
}

function parsePiDiff(raw: unknown): DiffResultRecord | null {
  if (typeof raw !== "string" || raw.length === 0) return null;
  const hunks: DiffHunkRecord[] = [];
  let current: DiffLineRecord[] = [];
  let added = 0, removed = 0;
  let hasOriginal = false;
  let delta = 0;
  const flush = () => { if (current.length > 0) hunks.push({ lines: current }); current = []; };
  for (const line of raw.split("\n")) {
    if (line.length === 0) continue;
    const prefix = line[0];
    const rest = line.slice(1);
    if (prefix === " " && rest.trim() === "...") { flush(); continue; }
    const m = rest.match(/^\s*(\d+)\s(.*)$/);
    if (!m) continue;
    const num = parseInt(m[1]!, 10);
    const text = m[2]!;
    if (prefix === "+") { current.push({ type: "added", oldNo: null, newNo: num, text }); added++; delta++; }
    else if (prefix === "-") { current.push({ type: "removed", oldNo: num, newNo: null, text }); removed++; delta--; hasOriginal = true; }
    else if (prefix === " ") { current.push({ type: "context", oldNo: num, newNo: num + delta, text }); hasOriginal = true; }
  }
  flush();
  if (hunks.length === 0) return null;
  return { hunks, added, removed, isIdentical: added + removed === 0, isNewFile: !hasOriginal };
}

/** Minimal RPC client for pi --mode rpc */
class PiRpc {
  private child: ChildProcess;
  private pending = new Map<string, { resolve: (v: any) => void; reject: (e: Error) => void }>();
  private eventHandlers: Array<(event: any) => void> = [];
  private disposed = false;

  constructor(child: ChildProcess) {
    this.child = child;
    const rl = readline.createInterface({ input: child.stdout! });
    rl.on("line", (line) => {
      if (!line.trim()) return;
      let msg: any;
      try { msg = JSON.parse(line); } catch { return; }
      if (msg?.type === "response" && typeof msg.id === "string") {
        const p = this.pending.get(msg.id);
        if (p) { this.pending.delete(msg.id); p.resolve(msg); return; }
      }
      for (const h of this.eventHandlers) h(msg);
    });
    child.on("exit", () => {
      const err = new Error("pi process exited");
      for (const [, p] of this.pending) p.reject(err);
      this.pending.clear();
    });
  }

  static async spawn(cwd: string): Promise<PiRpc> {
    const child = spawn("pi", ["--mode", "rpc", "--no-themes", "--no-context-files"], {
      cwd,
      stdio: "pipe",
      env: process.env,
    });
    await new Promise<void>((resolve, reject) => {
      const onSpawn = () => { child.off("error", onError); resolve(); };
      const onError = (err: Error) => { child.off("spawn", onSpawn); reject(err); };
      child.once("spawn", onSpawn);
      child.once("error", onError);
    });
    return new PiRpc(child);
  }

  private async request(payload: any): Promise<any> {
    const id = randomUUID();
    const msg = JSON.stringify({ ...payload, id }) + "\n";
    return new Promise((resolve, reject) => {
      this.pending.set(id, { resolve, reject });
      this.child.stdin!.write(msg);
    });
  }

  async prompt(message: string): Promise<void> {
    const res = await this.request({ type: "prompt", message, images: [] });
    if (!res.success) throw new Error(res.error ?? "prompt failed");
  }

  async abort(): Promise<void> {
    const res = await this.request({ type: "abort" });
    if (!res.success) throw new Error(res.error ?? "abort failed");
  }

  async compact(): Promise<void> {
    const res = await this.request({ type: "compact" });
    if (!res.success) throw new Error(res.error ?? "compact failed");
  }

  async getState(): Promise<any> {
    const res = await this.request({ type: "get_state" });
    if (!res.success) throw new Error(res.error ?? "get_state failed");
    return res.data;
  }

  async getAvailableModels(): Promise<any> {
    const res = await this.request({ type: "get_available_models" });
    if (!res.success) throw new Error(res.error ?? "get_available_models failed");
    return res.data;
  }

  async setModel(provider: string, modelId: string): Promise<void> {
    const res = await this.request({ type: "set_model", provider, modelId });
    if (!res.success) throw new Error(res.error ?? "set_model failed");
  }

  async setThinkingLevel(level: string): Promise<void> {
    const res = await this.request({ type: "set_thinking_level", level });
    if (!res.success) throw new Error(res.error ?? "set_thinking_level failed");
  }

  onEvent(handler: (event: any) => void): () => void {
    this.eventHandlers.push(handler);
    return () => { this.eventHandlers = this.eventHandlers.filter((h) => h !== handler); };
  }

  dispose(): void {
    if (this.disposed) return;
    this.disposed = true;
    try { this.child.kill("SIGTERM"); } catch {}
  }
}

export default function activate(ctx: ExtensionContext): void {
  const { bus, call } = ctx;
  const cwd = process.cwd();

  let rpc: PiRpc | null = null;
  let booting = true;

  const PI_THINKING_LEVELS = ["off", "minimal", "low", "medium", "high", "xhigh"] as const;

  const pendingArgs = new Map<string, any>();
  const pendingWriteSnapshot = new Map<string, { oldContent: string; isNewFile: boolean }>();

  const boot = async () => {
    try {
      rpc = await PiRpc.spawn(cwd);

      let fullResponseText = "";

      rpc.onEvent((event: any) => {
        // Filter out pi's internal UI events (contain ANSI codes, not for agent-sh)
        if (event.type === "extension_ui_request") return;
        if (event.type === "turn_start" || event.type === "turn_end") return;
        if (event.type === "message_start") return;

        switch (event.type) {
          case "agent_start":
            fullResponseText = "";
            break;

          case "message_update": {
            const ame = event.assistantMessageEvent;
            if (ame?.type === "text_delta") {
              bus.emitTransform("agent:response-chunk", {
                blocks: [{ type: "text" as const, text: ame.delta }],
              });
              fullResponseText += ame.delta;
            } else if (ame?.type === "thinking_delta") {
              bus.emit("agent:thinking-chunk", { text: ame.delta });
            }
            break;
          }

          case "message_end": {
            const msg = event.message;
            if (msg?.role === "assistant" && Array.isArray(msg.content)) {
              const groupMap = new Map<string, Array<{ name: string }>>();
              for (const block of msg.content) {
                if (block?.type === "toolCall" && typeof block.name === "string") {
                  const kind = kindForTool(block.name);
                  if (!groupMap.has(kind)) groupMap.set(kind, []);
                  groupMap.get(kind)!.push({ name: block.name });
                }
              }
              if (groupMap.size > 0) {
                const groups = Array.from(groupMap.entries()).map(([kind, tools]) => ({ kind, tools }));
                bus.emit("agent:tool-batch", { groups });
              }
            }
            break;
          }

          case "tool_execution_start": {
            if (event.toolCallId) pendingArgs.set(event.toolCallId, event.args);
            if (event.toolName === "write" && event.toolCallId && typeof event.args?.path === "string") {
              const abs = resolvePath(cwd, event.args.path);
              let oldContent = "";
              let isNewFile = true;
              if (existsSync(abs)) {
                try { oldContent = readFileSync(abs, "utf8"); isNewFile = false; } catch {}
              }
              pendingWriteSnapshot.set(event.toolCallId, { oldContent, isNewFile });
            }
            bus.emit("agent:tool-started", {
              title: event.toolName,
              name: event.toolName,
              toolCallId: event.toolCallId,
              kind: kindForTool(event.toolName),
              rawInput: event.args,
            });
            break;
          }

          case "tool_execution_update": {
            const pr = event.partialResult as { content?: Array<{ type: string; text?: string }> } | undefined;
            if (pr?.content) {
              for (const c of pr.content) {
                if (c.type === "text" && c.text) {
                  bus.emit("agent:tool-output-chunk", { chunk: c.text });
                }
              }
            }
            break;
          }

          case "tool_execution_end": {
            const args = event.toolCallId ? pendingArgs.get(event.toolCallId) : undefined;
            if (event.toolCallId) pendingArgs.delete(event.toolCallId);
            let resultDisplay: { body?: { kind: "diff"; diff: unknown; filePath: string } } | undefined;
            if (event.toolName === "edit" && typeof args?.path === "string") {
              const parsed = parsePiDiff(event.result?.details?.diff);
              if (parsed) resultDisplay = { body: { kind: "diff", diff: parsed, filePath: args.path } };
            } else if (event.toolName === "write" && typeof args?.path === "string" && !event.isError) {
              const snap = event.toolCallId ? pendingWriteSnapshot.get(event.toolCallId) : undefined;
              if (event.toolCallId) pendingWriteSnapshot.delete(event.toolCallId);
              if (snap) {
                const newContent = typeof args.content === "string" ? args.content : "";
                const built = buildDiffFromTexts(snap.oldContent, newContent, snap.isNewFile);
                if (built) resultDisplay = { body: { kind: "diff", diff: built, filePath: args.path } };
              }
            }
            bus.emit("agent:tool-completed", {
              toolCallId: event.toolCallId,
              exitCode: event.isError ? 1 : 0,
              kind: kindForTool(event.toolName),
              rawOutput: event.result,
              resultDisplay,
            });
            break;
          }

          case "agent_end":
            bus.emitTransform("agent:response-done", { response: fullResponseText });
            bus.emit("agent:processing-done", {});
            break;
        }
      });

      booting = false;
      const state = await rpc.getState().catch(() => null);
      const model = state?.model;
      bus.emit("agent:info", {
        name: "pi",
        version: state?.version ?? "rpc",
        model: model ? `${model.provider}/${model.id}` : undefined,
      });
    } catch (err) {
      booting = false;
      bus.emit("ui:error", {
        message: `pi-bridge: failed to spawn pi — ${err instanceof Error ? err.message : String(err)}`,
      });
    }
  };

  type ListenerEntry = { kind: "on" | "pipe"; event: string; fn: Function };
  const listeners: ListenerEntry[] = [];

  const wireListeners = () => {
    const onSubmit = async ({ query }: any) => {
      if (!rpc) {
        bus.emit("agent:error", { message: booting ? "pi is still starting up..." : "pi session not initialized" });
        bus.emit("agent:processing-done", {});
        return;
      }
      bus.emit("agent:query", { query });
      bus.emit("agent:processing-start", {});
      const ctxText = String(call("query-context:build") ?? "").trim();
      const final = ctxText ? `${ctxText}\n\n${query}` : query;
      try {
        await rpc.prompt(final);
      } catch (err) {
        bus.emit("agent:error", { message: err instanceof Error ? err.message : String(err) });
        bus.emit("agent:processing-done", {});
      }
    };

    const onCancel = async () => { await rpc?.abort().catch(() => {}); };
    const onReset = async () => {
      rpc?.dispose();
      rpc = null;
      booting = true;
      await boot();
    };

    const onListModels = async () => {
      if (!rpc) return { models: [], active: null };
      try {
        const data = await rpc.getAvailableModels();
        const state = await rpc.getState();
        return {
          models: (data?.models ?? []).map((m: any) => ({ id: m.id, provider: m.provider })),
          active: state?.model ? { id: state.model.id, provider: state.model.provider } : null,
        };
      } catch { return { models: [], active: null }; }
    };

    const onSwitchModel = async ({ id, provider }: { id: string; provider: string }) => {
      if (!rpc) return;
      try {
        await rpc.setModel(provider, id);
        bus.emit("agent:info", { name: "pi", version: "rpc", model: `${provider}/${id}` });
        bus.emit("ui:info", { message: `Model: ${provider}/${id}` });
        bus.emit("config:changed", {});
      } catch (err) {
        bus.emit("ui:error", { message: `Failed to switch model: ${err instanceof Error ? err.message : String(err)}` });
      }
    };

    const onGetThinking = async () => {
      const state = await rpc?.getState().catch(() => null);
      const level = state?.thinkingLevel ?? "off";
      return { level, levels: [...PI_THINKING_LEVELS], supported: true };
    };

    const onSetThinking = async ({ level }: { level: string }) => {
      if (!rpc) return;
      if (!PI_THINKING_LEVELS.includes(level as any)) {
        bus.emit("ui:error", { message: `Unknown thinking level: ${level}. Use: ${PI_THINKING_LEVELS.join(", ")}` });
        return;
      }
      try {
        await rpc.setThinkingLevel(level);
        bus.emit("config:changed", {});
      } catch (err) {
        bus.emit("ui:error", { message: `Failed: ${err instanceof Error ? err.message : String(err)}` });
      }
    };

    bus.on("agent:submit", onSubmit);
    bus.on("agent:cancel-request", onCancel);
    bus.on("agent:reset-session", onReset);
    bus.on("config:switch-model", onSwitchModel as any);
    bus.on("config:set-thinking", onSetThinking as any);
    bus.onPipe("config:get-models", onListModels as any);
    bus.onPipe("config:get-thinking", onGetThinking as any);
    listeners.push(
      { kind: "on", event: "agent:submit", fn: onSubmit },
      { kind: "on", event: "agent:cancel-request", fn: onCancel },
      { kind: "on", event: "agent:reset-session", fn: onReset },
      { kind: "on", event: "config:switch-model", fn: onSwitchModel },
      { kind: "on", event: "config:set-thinking", fn: onSetThinking },
      { kind: "pipe", event: "config:get-models", fn: onListModels },
      { kind: "pipe", event: "config:get-thinking", fn: onGetThinking },
    );
  };

  const unwireListeners = () => {
    for (const { kind, event, fn } of listeners) {
      if (kind === "pipe") bus.offPipe(event as any, fn as any);
      else bus.off(event as any, fn as any);
    }
    listeners.length = 0;
  };

  bus.emit("agent:register-backend", {
    name: "pi",
    start: async () => {
      await boot();
      wireListeners();
      bus.emit("command:register", {
        name: "/compact",
        description: "Compact pi's session context",
        handler: async () => {
          if (!rpc) return;
          try { await rpc.compact(); bus.emit("ui:info", { message: "(compacted)" }); }
          catch (err) { bus.emit("ui:info", { message: `(${err instanceof Error ? err.message : String(err)})` }); }
        },
      });
      bus.emit("command:register", {
        name: "/context",
        description: "Show pi's context budget usage",
        handler: async () => {
          if (!rpc) return;
          try {
            const state = await rpc.getState();
            const usage = state?.contextUsage;
            if (!usage) { bus.emit("ui:info", { message: "Context: not available yet" }); return; }
            const pct = usage.contextWindow > 0 ? Math.round((usage.tokens / usage.contextWindow) * 100) : 0;
            bus.emit("ui:info", {
              message: `Active context: ~${usage.tokens.toLocaleString()} tokens / ${usage.contextWindow.toLocaleString()} budget (${pct}%)`,
            });
          } catch { bus.emit("ui:info", { message: "Context: unavailable" }); }
        },
      });
    },
    kill: () => {
      bus.emit("command:unregister", { name: "/compact" });
      bus.emit("command:unregister", { name: "/context" });
      unwireListeners();
      rpc?.dispose();
      rpc = null;
      booting = true;
    },
  });
}
