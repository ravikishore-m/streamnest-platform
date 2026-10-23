# Contributing

## Privacy (strict)

Do not commit personal or site-internal data. See `docs/PRIVACY.md`.

## Git commits — authorship (strict)

- Commit as the human operator only.
- **Do not** add `Co-authored-by:` trailers for Cursor, Copilot, or any AI agent.
- If a tool injects an agent co-author trailer, remove it before push.

## Change flow

1. Branch from `main`.
2. Validate locally (helm lint, terraform fmt/validate where applicable).
3. Open a PR; keep secrets and inventory out of the diff.
4. Promote the **same image digest** after validation on the single cluster.
