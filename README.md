# AI Dev Setup

This repo is for cross-machine setup of your Claude/Codex workflow.

It tracks:
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
- `config/skills/skills-manifest.json`: source of truth for skills
- `scripts/export-custom-skills.ps1`: copy local custom skills into this repo
- `scripts/restore-vendored-skills.ps1`: restore vendored skills on a new machine
- `skills/vendored/`: pinned custom skills you want to carry across machines
- `templates/`: reusable markdown templates
- `docs/`: setup notes and guardrails

## Notes

- Product-bundled skills under `.codex/skills/.system` should not be committed.
- Curated skills can usually be reinstalled by name.
- Custom or private skills should be vendored into `skills/vendored/`.
- Re-login is still required for Claude, Codex, GitHub, Google Drive, and other connectors.
