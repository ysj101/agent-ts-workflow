function quoteFiles(files) {
  return files.map((file) => JSON.stringify(file)).join(" ")
}

export default {
  "*.{js,cjs,mjs,ts,tsx,jsx,json,jsonc,md,css,scss,html,yml,yaml}": (files) => {
    if (files.length === 0) {
      return []
    }

    return `biome check --write --no-errors-on-unmatched --files-ignore-unknown=true ${quoteFiles(files)}`
  },
  "*.{js,cjs,mjs,ts,tsx,jsx}": (files) => {
    if (files.length === 0) {
      return []
    }

    return `oxlint --quiet ${quoteFiles(files)}`
  },
  "*": () => ["pnpm run typecheck"],
}
