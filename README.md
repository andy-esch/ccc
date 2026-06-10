# Claude Code in a container

Run Claude Code inside Docker while editing a project on your host filesystem via
a bind mount. Auth uses a subscription OAuth token so no browser is needed inside
the container.

## Prerequisites

- Docker Desktop (`docker` + `docker compose`)
- [`just`](https://github.com/casey/just) — `brew install just`
- Claude Code on the host (only to generate the token once)

## One-time setup

```sh
cp .env.example .env       # then edit it
just token                 # runs `claude setup-token` on the host (opens browser)
# paste the printed token into CLAUDE_CODE_OAUTH_TOKEN in .env
# set PROJECT_DIR in .env to the absolute path of the project you want to work on
just build
```

## Daily use

```sh
just cc            # start Claude Code in /workspace (your PROJECT_DIR)
just cc --help     # pass args through to claude
just shell         # bash shell inside the container
```

## How it works

- **Project files** — `PROJECT_DIR` is bind-mounted to `/workspace`. Changes made
  in the container appear immediately on your host, and vice versa.
- **Auth & state** — credentials, history, and settings live in the
  `claude-config` named volume at `/home/node/.claude`, so they survive
  `docker compose down` and image rebuilds.
- **macOS note** — on the host, Claude Code stores credentials in the macOS
  Keychain (not a file), so they can't be bind-mounted into a Linux container.
  That's why we use a token (`CLAUDE_CODE_OAUTH_TOKEN`) instead.

## Auth alternatives

- **API key** — leave `CLAUDE_CODE_OAUTH_TOKEN` blank and set `ANTHROPIC_API_KEY`
  in `.env` (Anthropic Console, pay-as-you-go).
- **Log in inside the container** — `just login` runs `/login` in the container
  (paste-code flow); the credentials persist in the `claude-config` volume.

## Maintenance

```sh
just down          # stop/remove the container
just clean         # also delete the config volume (forces re-login)
just build         # rebuild after changing the Dockerfile
```
