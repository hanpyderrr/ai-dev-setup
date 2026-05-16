# What To Git

## Good candidates

- markdown rule files such as `CLAUDE.md` and `AGENTS.md`
- reusable prompts and handoff templates
- setup scripts
- verification scripts
- skill manifests
- vendored custom skills that you own or want pinned

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
