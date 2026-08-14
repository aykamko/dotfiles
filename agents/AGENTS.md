# Glossary

Here is a glossary of custom terms or phrases I use and what they mean for you:

- "yeet this change": "Please commit the change with a good message (always prefer a new commit rather than amending), `gt submit` it with Graphite, and update the PR description on Github"
- "sweep my PR comments": "Please look at the comments I left for you on the Github PR, address each one, yeet the change, and then comment+resolve each of the comments in Github. If a comment reads more like an open question, pause before yeeting to talk to me about it"

# Instructions for figma/figma repo

Our repo uses subfolder AGENTS.md files that define scoped conventions and workflows. When planning work that concentrates in specific top-level subfolders check for AGENTS.md files in those subfolders and proactively load them into context before beginning implementation work.

# Git branches

When making new git branches for me, always prefix the branch name with `akamko/`. For example: `akamko/my-cool-feature`

# PR descriptions

When creating PR descriptions from scratch (or when replacing the Figma template), always us this format:

```
## 👨 Aleks Description

FILL ME IN

---

## 🤖 {AGENT} Description

AGENT DESCRIPTION GOES HERE
```
Replace `AGENT DESCRIPTION GOES HERE` with your description. Leave `FILL ME IN` alone for myself to fill out.

If you are Claude, `{AGENT}` should be `Claude`. If you are Codex/GPT, `{AGENT}` should be Codex.

When making changes or updates to the PR description, never touch my
human-written description (Aleks Description) without asking me first. If you
believe my description is factually incorrect or out-of-date, please let me
know, but do not change my words without asking me first.
