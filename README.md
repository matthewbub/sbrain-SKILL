# Second Brain Skill

This repository contains a **Codex Skill** called `second-brain`.

Skills are modular folders that teach an agent how to do a specific job through a required `SKILL.md` instruction file, plus optional scripts/resources. Learn more at [skills.sh](https://skills.sh/).

## What this skill does

`second-brain` helps capture project notes and change context by posting structured entries to a Second Brain API.

In this repo, the skill includes:

- `SKILL.md`: trigger metadata + workflow instructions
- `scripts/sbrain.sh`: shell CLI that sends notes to the API
- `agents/openai.yaml`: UI metadata for skill pickers/chips

## CLI quick start

Run from this repo:

```sh
chmod +x scripts/sbrain.sh
./scripts/sbrain.sh \
  --title "Homepage copy refresh" \
  --context "Updated hero copy and CTA language to improve clarity."
```

## Required arguments

- `--title` - entry title
- `--context` - entry body/context

## Optional arguments

- `--project` - project name (defaults to current directory name)
- `--commits` - commit metadata string
- `--tags` - tags metadata string
- `--api-url` - override API base URL
- `-h`, `--help` - show help

## API URL behavior

The script uses this precedence:

1. `--api-url`
2. `SBRAIN_API_URL` environment variable
3. default: `https://sbrain-production.up.railway.app`

## Skill usage in Codex

When this skill is installed in `$CODEX_HOME/skills/second-brain`, Codex can trigger it when users ask to store memory, log project context, or save a thought to their Second Brain endpoint.
