# Contributing

## Git commits — authorship (strict)

- Commit as the human operator only.
- **Do not** add `Co-authored-by:` trailers for Cursor, Copilot, or any AI agent.
- **Do not** amend history solely to insert agent co-authors.
- If a tool injects an agent co-author trailer, remove it before push.

## Change flow

1. Branch from `main`.
2. Validate locally (helm lint, terraform fmt/validate, ansible syntax where applicable).
3. Open a PR; staging GitOps updates go through review.
4. Production promotion uses the **same image digest** tested in staging.
