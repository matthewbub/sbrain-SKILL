---
name: second-brain
description: Save notes, ideas, and project context to the Second Brain API using the bundled shell CLI. Use when the user asks to store memory, log context, capture a thought, or post structured note data to their brain endpoint.
---

# Second Brain

Use the bundled CLI script instead of hand-writing API calls.

## Script

- Primary path (installed skill): `$CODEX_HOME/skills/second-brain/sbrain.sh`
- Local development fallback: `/Volumes/git/portfolio-projects/mattbub.com/.agents/skills/second-brain/scripts/sbrain.sh`
- Alternate fallback: `/Volumes/git/mattbub.com/second-brain/sbrain.sh`

If the script is not executable, run `chmod +x <script-path>`.

## Workflow

Step 1.

Review the current working tree changes (unstaged + untracked) and write a concise markdown summary for Mat.

Primary source:
- The actual git diff/status in this repo (unstaged and untracked files).

Context source:
- Prompt/chat history, only to explain intent behind the changes when needed.

What to include:
- What changed in the code right now.
- Why those changes were made (inferred from chat history).
- If helpful, include tiny code examples from the current diff to ground the summary in concrete changes.

Constraints:
- 1-2 short paragraphs max.
- Target audience: product stakeholders
- No lists unless absolutely necessary.
- Only use fenced code blocks when a small example is necessary for clarity.
- No meta narration about your role, process, use of git, or tone changes.
- Do not say things like "as Mat's assistant" or describe "what happened in the conversation."
- Keep it direct, technical, and specific to the current working tree.

Voice:
- First person ("I") for the assistant.
- Refer to the user as "Mat".

Bridge from Step 1 to script call:
- Use the Step 1 summary as `context` exactly as written.
- Preserve `context` text as-is, including punctuation and line breaks.
- Generate `title` from the commit message subject line (Conventional Commits format) you will use in Step 2.
- Resolve `project` automatically, in this order, unless the user explicitly provides `project`:
  1) `package.json` `name`
  2) `go.mod` module path basename
  3) `pyproject.toml` project name
  4) current working directory name (basename of `$PWD`)
- Do not ask the user for required fields during normal operation. This skill should run with zero additional user input.
- Run the script with quoted arguments:
   - `<script-path> --title "<title>" --context "<context>" --project "<project>"`
   - If project resolution fails, omit `--project` and allow the script default from CWD.
- Add optional fields only when provided by the user:
   - `--commits "<commits>"`
   - `--tags "<tags>"`
- Return the API response to the user and include the created record ID when present.

Step 2.

Run git diff, group changes sensibly, and commit using Conventional Commits:
https://www.conventionalcommits.org/en/v1.0.0/

## Rules

- Prefer the script over direct `curl`.
- Use `--api-url` or `SBRAIN_API_URL` only when the user asks to target a different environment.
- Build the Conventional Commit subject from current changes before calling `sbrain.sh`, then use that same subject for both the script `--title` and the git commit message.
- Invoke `sbrain.sh` as a side effect of Step 1 (using the Step 1 summary as `context`) before executing the Step 2 commit command.
