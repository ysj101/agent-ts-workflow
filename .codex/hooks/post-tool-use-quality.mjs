import { execFileSync } from "node:child_process"
import fs from "node:fs"
import path from "node:path"

const biomeExtensions = new Set([
  ".ts",
  ".tsx",
  ".js",
  ".jsx",
  ".mjs",
  ".cjs",
  ".json",
  ".jsonc",
  ".css"
])

const oxlintExtensions = new Set([".ts", ".tsx", ".js", ".jsx", ".mjs", ".cjs"])
const ignoredPrefixes = ["dist/", "node_modules/", "screenshots/"]

function run(command, args, cwd) {
  return execFileSync(command, args, {
    cwd,
    encoding: "utf8",
    stdio: ["ignore", "pipe", "pipe"]
  }).trim()
}

function splitLines(value) {
  return value
    .split("\n")
    .map((line) => line.trim())
    .filter(Boolean)
}

function changedFiles(cwd) {
  const tracked = splitLines(
    run("git", ["diff", "--name-only", "--diff-filter=ACMRTUXB"], cwd)
  )
  const staged = splitLines(
    run("git", ["diff", "--cached", "--name-only", "--diff-filter=ACMRTUXB"], cwd)
  )
  const untracked = splitLines(run("git", ["ls-files", "--others", "--exclude-standard"], cwd))

  return [...new Set([...tracked, ...staged, ...untracked])]
    .filter((file) => !ignoredPrefixes.some((prefix) => file.startsWith(prefix)))
    .filter((file) => fs.existsSync(path.join(cwd, file)))
}

function filesForExtensions(files, allowedExtensions) {
  return files.filter((file) => allowedExtensions.has(path.extname(file)))
}

function main() {
  const cwd = run("git", ["rev-parse", "--show-toplevel"], process.cwd())
  const files = changedFiles(cwd)

  if (files.length === 0) {
    process.stdout.write("PostToolUse: no changed files to check\n")
    return
  }

  const biomeFiles = filesForExtensions(
    files.filter((file) => !file.startsWith(".codex/")),
    biomeExtensions
  )
  if (biomeFiles.length > 0) {
    execFileSync("pnpm", ["exec", "biome", "format", "--write", ...biomeFiles], {
      cwd,
      stdio: "inherit"
    })
  }

  const oxlintFiles = filesForExtensions(files, oxlintExtensions)
  if (oxlintFiles.length > 0) {
    execFileSync("pnpm", ["exec", "oxlint", ...oxlintFiles], {
      cwd,
      stdio: "inherit"
    })
  }
}

main()
