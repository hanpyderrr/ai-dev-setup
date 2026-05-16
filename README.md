# AI Dev Setup

This repo is for cross-machine setup of your Claude and Codex workflows.

It tracks:
- Claude global configuration
- Codex global configuration
- reusable markdown rules and templates
- setup and verification scripts
- skill install manifests
- vendored custom skills that you own or want pinned

It does not track:
- API keys
- auth caches
- browser cookies
- SSH private keys
- machine-specific logs and caches

## Recommended flow

1. Clone this repo on a new machine.
2. Run `bootstrap.ps1`.
3. Sign in to Claude, Codex, GitHub CLI, and any connectors manually.
4. Run `check-env.ps1`.
5. Copy project-level templates into each repo as needed.

## Repo layout

- `bootstrap.ps1`: install and restore entry point
- `check-env.ps1`: verify required tools and folders
- `config/claude/CLAUDE.md`: Claude global instruction file
- `config/codex/AGENTS.md`: Codex global instruction file
- `config/skills/skills-manifest.json`: source of truth for skills
- `scripts/export-claude-config.ps1`: copy local Claude global config into this repo
- `scripts/export-codex-config.ps1`: copy local Codex global config into this repo
- `scripts/export-custom-skills.ps1`: copy local custom skills and global config into this repo
- `scripts/restore-vendored-skills.ps1`: restore vendored skills and global config on a new machine
- `skills/vendored/claude/`: pinned Claude skills you want to carry across machines
- `skills/vendored/codex/`: pinned Codex skills you want to carry across machines
- `skills/vendored/agents/`: shared agent skills outside one product's config tree
- `templates/`: reusable markdown templates
- `docs/`: setup notes and guardrails

## Notes

- Product-bundled skills under `.codex/skills/.system` should not be committed.
- Curated skills can usually be reinstalled by name.
- Custom or private skills should be vendored into `skills/vendored/`.
- Re-login is still required for Claude, Codex, GitHub, Google Drive, and other connectors.
- Keep Claude-specific controller workflows under `skills/vendored/claude/`.
- Keep Codex-native guidance and skills under `config/codex/` and `skills/vendored/codex/`.
