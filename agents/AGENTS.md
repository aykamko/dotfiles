# Glossary

Here is a glossary of custom terms or phrases I use and what they mean for you:

- "yeet this change": "Please commit the change with a good message (always prefer a new commit rather than amending), `gt submit` it with Graphite, and update the PR description on Github"
- "sweep my PR comments": "Please look at the comments I left for you on the Github PR, address each one, yeet the change, and then comment+resolve each of the comments in Github. If a comment reads more like an open question, pause before yeeting to talk to me about it"
- "riff": "Let's brainstorm without writing code. You are welcome to search and run experiments, but don't change the checked-in code. Just talk to me."

# Instructions for figma/figma repo

Our repo uses subfolder AGENTS.md files that define scoped conventions and workflows. When planning work that concentrates in specific top-level subfolders check for AGENTS.md files in those subfolders and proactively load them into context before beginning implementation work.

Whenever you create or update a Github PR (through Graphite or directly), always include the Github URL to the PR in your reply to me. Makes it easy for me to click and open my browser.

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

# Prose

If you are Claude, please respect the following triple-quoted directive. If you are a Codex/GPT model, feel free to ignore.

"""
When you write technical text (documentation, READMEs, runbooks, procedures, error messages, release notes, reports), obey these rules from ASD-STE100 Simplified Technical English:
CLASSIFY FIRST. Procedural text tells the reader what to do: imperative mood, maximum 20 words per sentence, one instruction per sentence. Descriptive text explains: simple tenses, maximum 25 words per sentence, one topic per paragraph, maximum six sentences per paragraph. Never mix the two in one passage.
VERBS. Use only: infinitive, imperative, simple present, simple past, simple future, past participle as adjective. No present perfect ("has completed" → "completed"). No "-ing" verb forms ("making it easy" → new sentence). Active voice; passive only in descriptions when the agent is unknown. Approved modals: can, will, must. Banned: should, would, may, might, could. For "should": write "must" if required, delete if optional.
SENTENCES. Keep complete grammar: no contractions, keep articles, keep "that" ("make sure that the file exists"). Put conditions before commands, with a comma: "If the test fails, read the log." No semicolons — write two sentences. Use a vertical list for more than two items or steps.
WORDS. One word, one meaning, for the whole document: use "make sure that" for the check/verify/confirm concept, because the dictionary rejects all three as verbs. Noun chains of maximum three words; break longer ones with prepositions ("the timeout value for the connection pool"). Delete words that carry no fact: simply, seamlessly, robust, powerful, comprehensive, leverage, "in order to", "it is worth noting". Replace: utilize → use, prior to → before, in the event that → if, e.g. → for example. American spelling.
WARNINGS. Command or condition first, then the risk: "Do not run this against production. The command deletes rows."
NEVER TOUCH. Code blocks, identifiers, CLI commands, file paths, quoted error messages, product names. Each counts as one word toward sentence limits. Facts too: when the source does not give a number or a cause, keep the general statement — do not invent specifics.
SELF-CHECK before returning: scan for contractions, "has been", "should", ", making", semicolons. Count words in your three longest sentences and split any over the limit. Collapse synonym rotation.
Do not apply these rules to marketing copy or brand writing.
"""
