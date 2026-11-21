// gta6-clipper-01 — entry program (program/v1, Node 22, stdlib only, no network).
//
// What it does: validates the clip production package in this repository
// (clip-plan.json, script.md, description.txt, ffmpeg-commands.sh, VIDEO.json,
// thumbnail.svg) and writes deterministic copies to the output directory.
// It does NOT upload anything and does NOT fetch anything: the video itself
// is produced and uploaded by a human, from a YouTube channel, following
// clip-plan.json. See README.md for the blocker.
//
// Grader contract: `node /bot/main.ts`, no network, read-only repo at /bot,
// empty writable /output, 60 s wall budget. Exit 0 on success.
import { copyFileSync, existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const botDir = process.env.MAKEFUN_BOT_DIR ?? dirname(fileURLToPath(import.meta.url));
const outDir = process.env.MAKEFUN_OUTPUT_DIR ?? join(botDir, ".local-output");

const FILES = [
  "clip-plan.json",
  "script.md",
  "description.txt",
  "ffmpeg-commands.sh",
  "VIDEO.json",
  "thumbnail.svg",
  "package.json",
] as const;

function fail(message: string): never {
  throw new Error(message);
}

function main(): void {
  mkdirSync(outDir, { recursive: true });

  // 1. Every file of the package must exist and be non-empty.
  for (const name of FILES) {
    const path = join(botDir, name);
    if (!existsSync(path)) fail(`missing file: ${name}`);
    if (readFileSync(path, "utf8").length === 0) fail(`empty file: ${name}`);
  }

  // 2. clip-plan.json must parse and carry the production contract.
  const plan = JSON.parse(readFileSync(join(botDir, "clip-plan.json"), "utf8")) as {
    competition?: unknown;
    format?: { duration_seconds?: unknown };
    beats?: unknown[];
  };
  if (plan.competition !== "gta6-clipper-01") fail("clip-plan.json: wrong competition");
  if (plan.format?.duration_seconds !== 30) fail("clip-plan.json: duration must be 30s");
  if (!Array.isArray(plan.beats) || plan.beats.length !== 5) fail("clip-plan.json: need 5 beats");

  // 3. VIDEO.json must parse and name a YouTube Shorts URL (placeholder until upload).
  const video = JSON.parse(readFileSync(join(botDir, "VIDEO.json"), "utf8")) as { url?: unknown };
  if (typeof video.url !== "string" || !video.url.startsWith("https://www.youtube.com/shorts/")) {
    fail("VIDEO.json: url must be https://www.youtube.com/shorts/<id>");
  }

  // 4. The description must carry the bounty's required line (checked exactly).
  const description = readFileSync(join(botDir, "description.txt"), "utf8");
  const requiredLine =
    "Made by my AI agent for a $500 bounty on make.fun, where you can earn money making clips with AI: https://make.fun/bounty/gta6-clipper-01";
  if (!description.includes(requiredLine)) fail("description.txt: missing required make.fun line");
  if (!description.includes("$500 bounty")) fail("description.txt: missing $500 bounty");

  // 5. Deterministic outputs: byte copies of the package + a fixed action log.
  // No wall-clock time, no randomness, no network — two runs write identical bytes.
  for (const name of FILES) {
    copyFileSync(join(botDir, name), join(outDir, name));
  }
  const actionLog = {
    competition: "gta6-clipper-01",
    program: "gta6-clipper-01/main.ts",
    validated_files: [...FILES],
    checks: [
      "all package files present and non-empty",
      "clip-plan.json parses: competition gta6-clipper-01, 30s, 5 beats",
      "VIDEO.json parses: YouTube Shorts URL",
      "description.txt carries the required make.fun line and $500 bounty",
    ],
    video_status: "awaiting_upload",
    video_url: video.url,
    note: "This program validates the production package only. Producing the video (ffmpeg) and uploading it to YouTube are human steps — see README.md.",
  };
  writeFileSync(join(outDir, "action-log.json"), `${JSON.stringify(actionLog, null, 2)}\n`, "utf8");
}

main();
