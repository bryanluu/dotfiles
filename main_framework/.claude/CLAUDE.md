# User preferences (global — all projects)

## Commit messages

- Keep commit message titles at most 50 characters (count any `:gitmoji:` prefix).
- If Claude authored or modified the code contents, acknowledge the authoring model (for example, Qwen 3.8) in the commit message, e.g. a trailing line like `Generated with Claude Code (Qwen 3.8)`.

## Web verification with Playwright

- Playwright (global npm, v1.62.1 via nvm) with bundled Chromium + headless shell in `~/.cache/ms-playwright/` is installed on this Fedora 44 machine. Use it for verifying web apps: `playwright screenshot <url> <file>`, or small Node scripts for DOM/console/network checks.
- "BEWARE: your OS is not officially supported ... (ubuntu24.04 fallback)" messages are cosmetic — the browser works fine; ignore them.
- Never use `npx playwright install --with-deps` on this Fedora box (it shells out to apt and aborts); if a shared library is ever missing, install it via dnf instead.
