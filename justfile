# Claude Code in a container — common commands. Run `just` to list recipes.

set dotenv-load := true

# Show available recipes
default:
    @just --list

# Build the container image
build:
    docker compose build

# Start Claude Code interactively in /workspace (e.g. `just cc --help`)
cc *ARGS:
    docker compose run --rm cc claude {{ARGS}}

# Open a bash shell inside the container
shell:
    docker compose run --rm cc bash

# Generate a subscription OAuth token ON THE HOST (needs a browser), then paste
# the printed value into CLAUDE_CODE_OAUTH_TOKEN in your .env file.
token:
    @echo "Running 'claude setup-token' on the host — copy the token into .env"
    claude setup-token

# Fallback: log in INSIDE the container (paste-code flow); persists in the volume
login:
    docker compose run --rm cc claude /login

# Stop and remove any running container for this project
down:
    docker compose down

# Remove the persisted Claude config volume (forces re-login next time)
clean:
    docker compose down -v
