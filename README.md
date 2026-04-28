# Codexception

> A Codex skill that turns hard-won session discoveries into reusable skill candidates.

---

## The Problem with Losing Session Knowledge

Some useful discoveries only appear after real work:

| What gets lost | Why it matters |
|---|---|
| Misleading errors | The next session may chase the same false lead |
| Project conventions | Future work may ignore local patterns that were already learned |
| Tool workarounds | Small setup details can cost a lot of time twice |
| Verification paths | A fix is less useful if nobody remembers how it was proved |

**Codexception** gives Codex a selective way to capture those lessons as staged skill candidates, without polluting the active skill library.

---

## What the skill does

Codexception guides Codex to:
- review completed work for reusable discoveries
- skip ordinary one-off tasks
- search existing skills before creating a new candidate
- separate skill-worthy knowledge from project docs, session logs, or notes
- draft a complete `SKILL.md` using a reusable template
- stage candidates under `~/.codex/skill-candidates/`
- report every staged candidate for user review
- promote approved candidates into `~/.codex/skills/learned/`

---

## When to use it

Use this skill when you want Codex to:
- save a lesson as a skill candidate
- extract a reusable workflow from a solved problem
- review what a session learned
- capture a debugging path that should not be rediscovered later
- turn project-specific process knowledge into a future-loadable Codex skill

Typical examples:
- a misleading error message had a non-obvious root cause
- a tool needed a specific setup step that was not obvious from docs
- a project had a repeatable local workflow that future Codex sessions should know
- a research or manuscript process stabilized into a reusable pattern

Do **not** use it for:
- ordinary documentation lookups
- unverified guesses
- one-off decisions with no future reuse
- secrets, credentials, PHI, or private data
- details that belong in `AGENTS.md`, `doc/`, `task_plan.md`, or a session log

---

## Key behaviors

Codexception is deliberately conservative:
- **Finish first**: complete the user's requested work before extracting lessons
- **Be selective**: most tasks should not become skills
- **Search before staging**: check existing skills so duplicates do not accumulate
- **Stage by default**: create candidates under `~/.codex/skill-candidates/`
- **Report every extraction**: tell the user what was staged, where it lives, and why it may be useful
- **Promote only after review**: merge candidates into `~/.codex/skills/learned/` only after explicit user approval
- **Verify honestly**: mark what worked, what was tested, and what remains unverified
- **Protect sensitive data**: remove secrets, credentials, private URLs, and unnecessary internal details

---

## Candidate Output

A staged skill candidate should include:
- a specific `name`
- a description with clear trigger conditions
- the problem it solves
- context and symptoms
- the solution or workflow
- verification status
- caveats and when not to use it
- references when web or docs were used

The best descriptions include exact signals future Codex sessions can match:
- error messages
- file names
- commands
- framework names
- dataset conventions
- workflow names

---

## Installation

### Step 1: Install the skill

Copy the `codexception` folder into your personal Codex skills directory:

```bash
git clone https://github.com/dddavid4real/Codexception.git
cd Codexception
cp -R codexception ~/.codex/skills/
```

After copying, start a new Codex session or reload your current one so the skill list refreshes.

### Step 2: Optional hook reminder

The skill can activate through normal skill matching. The hook is optional.

Use the hook when you want Codex to remind itself after every prompt to check whether the completed work produced reusable knowledge.

1. Enable Codex hooks in `~/.codex/config.toml`:

```toml
[features]
codex_hooks = true
```

2. Make the activator executable:

```bash
chmod +x ~/.codex/skills/codexception/scripts/codexception-activator.sh
```

3. Add this `UserPromptSubmit` hook to `~/.codex/hooks.json`:

If `~/.codex/hooks.json` already exists, merge the `UserPromptSubmit` block into it instead of replacing the whole file.

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.codex/skills/codexception/scripts/codexception-activator.sh",
            "timeout": 10,
            "statusMessage": "Checking for reusable learning"
          }
        ]
      }
    ]
  }
}
```

The same hook JSON is included in `codexception/hooks.json.example`.

If your hook runner does not expand `~`, replace it with the absolute path to your home directory.

The hook only reminds Codex to evaluate whether extraction is useful. It does not create or promote active skills by itself.

After changing hooks or config, restart Codex.

## Usage

Invoke Codexception directly when a session taught something worth preserving:

```text
Use Codexception to save this as a skill candidate.
```

```text
Use Codexception. What did we learn from this debugging session?
```

```text
Stage a Codexception skill candidate for this workflow.
```

Codexception can also be used after non-obvious debugging, trial-and-error discovery, or project-specific process discoveries.

---

## Expected Candidate Structure

Codexception stages candidates like this:

```text
~/.codex/
`-- skill-candidates/
    `-- 2026-04-28_example-skill/
        `-- SKILL.md
```

Promotion is separate and approval-based:

```text
~/.codex/
`-- skills/
    `-- learned/
        `-- example-skill/
            `-- SKILL.md
```

The staging step is the safety layer. It gives you a reviewable artifact before anything joins the active skill inventory.

## Review And Promotion

Every extracted skill candidate should be reported to the user before promotion.

A good report includes:
- the staged candidate path
- why the candidate may be useful
- whether it is new, a variant, or a possible replacement
- verification status

After review, promote an approved candidate into the active learned inventory:

```bash
mkdir -p ~/.codex/skills/learned/<slug>
cp ~/.codex/skill-candidates/<date>_<slug>/SKILL.md ~/.codex/skills/learned/<slug>/SKILL.md
```

If the destination already exists, compare first and ask before overwriting.

After promotion, restart Codex so the skill list reloads.

## Acknowledgement

Codexception is the Codex-native adaptation of Claudeception: https://github.com/blader/Claudeception

Claudeception introduced the core idea of using agent sessions as a source of reusable skill knowledge instead of letting hard-won discoveries disappear after the session ends.

---

## What a successful run should produce

A good Codexception run usually ends with:
- zero staged candidates when nothing was reusable
- one to three staged candidates when the session produced reusable knowledge
- a clear reason for each staged candidate
- user review before active promotion
- no duplicate of an existing skill
- no secrets or private data
- honest verification notes
- active promotion only after explicit approval

## License

MIT. See [LICENSE](./LICENSE).
