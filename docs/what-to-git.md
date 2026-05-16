# What To Git

## Good candidates

- markdown rule files such as `CLAUDE.md` and `AGENTS.md`
- `config/claude/CLAUDE.md`
- `config/codex/AGENTS.md`
- reusable prompts and handoff templates
- setup scripts
- verification scripts
- skill manifests
- vendored custom skills that you own or want pinned, grouped by product under `skills/vendored/`

## Do not commit

- API keys
- auth tokens
- browser cookies
- SSH private keys
- `.env` files with secrets
- local caches and logs
- machine-specific absolute paths

## Skill rule of thumb

- bundled skills: do not commit
- curated reinstallable skills: manifest is enough
- custom or private skills: vendor them into `skills/vendored/`
- Claude-only skills should stay under `skills/vendored/claude/`
- Codex-only skills should stay under `skills/vendored/codex/`
- shared non-product skills should stay under `skills/vendored/agents/`
