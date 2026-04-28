---
name: codexception
description: |
  Extract reusable Codex skills from completed work sessions. Use when the user asks
  to save a lesson as a skill, extract a skill, review what was learned, create a
  reusable workflow from a solved problem, or after non-obvious debugging,
  workarounds, trial-and-error discovery, or project-specific process discoveries.
  Creates reviewed candidate skills for Codex, usually under ~/.codex/skill-candidates
  before promotion into ~/.codex/skills/learned.
metadata:
  source: migrated-from-claudeception
  version: "0.2.0"
---

# Codexception

Extract reusable knowledge from a completed Codex session and turn it into a
Codex skill candidate. Be selective: most tasks should not become skills.

This is the Codex-native equivalent of Claudeception. It preserves the same core
function: evaluate work sessions for reusable discoveries, search existing skills,
and codify high-value lessons into future-loadable skills. The main intentional
difference is safety: Codexception stages candidate skills before promotion into
the active skill inventory.

## When To Extract

Extract only when the work produced knowledge that is:

- reusable: likely to help with future tasks
- non-trivial: required investigation, debugging, failed attempts, or synthesis
- specific: has clear trigger conditions, symptoms, file patterns, or commands
- verified: the solution actually worked, or the skill clearly marks what remains unverified
- safe: contains no secrets, credentials, private patient data, or unnecessary internal URLs

Good candidates include:

- misleading error messages and the real root cause
- project-specific conventions not already documented
- multi-step workflows that prevented repeated mistakes
- tool integration details that documentation did not make obvious
- research or manuscript workflows that have stable trigger conditions

Skip extraction for:

- ordinary documentation lookups
- one-off decisions with no future reuse
- unverified guesses
- project details better stored in `AGENTS.md`, `doc/`, `task_plan.md`, or `notes/session-logs/`
- anything containing sensitive data

## Workflow

1. Finish the user's requested work first.
2. Identify 0-3 candidate lessons from the session.
3. Search existing skills before creating anything:

```sh
rg --files -g 'SKILL.md' "$HOME/.codex/skills" "$HOME/.agents/skills" .agents/skills 2>/dev/null
rg -i "keyword|exact error|tool name|project marker" "$HOME/.codex/skills" "$HOME/.agents/skills" .agents/skills 2>/dev/null
```

4. Decide whether to create a new candidate, update an existing skill, or skip.
5. For technology-specific knowledge that may have changed, verify with current primary sources.
6. Draft the skill candidate using `resources/skill-template.md`.
7. Save candidates to `~/.codex/skill-candidates/<YYYY-MM-DD>_<slug>/SKILL.md`.
8. Report every staged candidate to the user with the candidate path, short reason, and verification status.
9. Ask the user to review and approve promotion. Do not promote a candidate into the active skill inventory in the same turn it was staged unless the user has already explicitly approved that exact candidate.

## Retrospective Mode

When the user invokes Codexception explicitly, asks "what did we learn?", or says
"save this as a skill":

1. Review the current session for extractable knowledge.
2. Identify candidate skills with brief justifications.
3. Prioritize the highest-value, most reusable candidates.
4. Stage candidate skills for the top 1-3 candidates.
5. Summarize what was staged, what was skipped, and why.
6. Ask the user to review staged candidates before any promotion into the active skill inventory.

## Self-Reflection Prompts

Use these checks after substantial work:

- What did I learn that was not obvious before starting?
- If I faced this exact problem again, what would I wish I knew?
- What symptom, error message, file pattern, or workflow led to the solution?
- Is this a project convention, a general reusable pattern, or just a one-off note?
- Would this be better as a skill, a project doc update, a session log, or no artifact?

## Where To Save

Use these locations:

- staged candidate: `~/.codex/skill-candidates/<date>_<slug>/SKILL.md`
- active user skill after explicit user approval: `~/.codex/skills/learned/<slug>/SKILL.md`
- project skill after approval: `<repo>/.agents/skills/<slug>/SKILL.md`

Prefer staged candidates by default. Promotion changes the active skill library and should be deliberate.

## Review And Promotion Flow

Staging and promotion are separate actions.

After staging any candidate:

1. Report the candidate path.
2. Explain why it may be worth keeping.
3. State whether it is new, a variant, or a possible replacement.
4. Ask the user to review and approve promotion.
5. Stop there unless the user has already approved that exact promotion.

When the user approves a staged candidate, promote it to the active learned inventory:

```sh
mkdir -p "$HOME/.codex/skills/learned/<slug>"
cp "$HOME/.codex/skill-candidates/<date>_<slug>/SKILL.md" "$HOME/.codex/skills/learned/<slug>/SKILL.md"
```

Before promotion:

- if the destination does not exist, create it
- if the destination already exists, compare the files and ask before overwriting
- if the candidate is meant to update an existing active skill, preserve the old skill unless the user approves replacement

After promotion:

- report the active skill path
- tell the user to restart Codex so the skill list reloads
- leave the staged candidate in place unless the user asks to archive or remove it

## Create Or Update Decision

| Existing match | Action |
| --- | --- |
| No related skill | Create a new candidate |
| Same trigger and same fix | Update existing skill only with approval |
| Same trigger, different root cause | Create a new candidate and add see-also notes |
| Same domain, related variant | Add a variant only with approval |
| Existing skill is stale or wrong | Mark candidate as replacement and explain why |

## Candidate Skill Requirements

Every candidate must include:

- specific `name` and `description`
- problem
- context and trigger conditions
- solution
- verification
- example or minimal repro when useful
- notes, caveats, and when not to use it
- references when web or docs were used

Description quality matters most. Include exact error messages, file names, commands,
framework names, dataset conventions, or workflow names that should cause future
semantic matching.

## Review Checklist

Before staging a candidate, verify:

- description has clear trigger conditions
- solution is actionable
- verification status is honest
- no secrets, credentials, PHI, private tokens, or unnecessary internal URLs
- it does not duplicate an existing skill
- it belongs in a skill rather than a project doc or session log
- references are included when external sources were used
- current best practices are checked when the topic is version-sensitive

## Skill Lifecycle

Skills should evolve:

- patch: wording, typo, or formatting fix
- minor: new scenario, variant, or edge case
- major: breaking change, deprecation, or replacement

When an existing skill is updated or replaced, note the reason in the candidate's
`Notes` section and add see-also links when useful.

## Hook Behavior

If a Codex `UserPromptSubmit` hook is installed, it should only remind Codex to evaluate
whether extraction may be useful. The hook must not create or promote active skills by
itself.

For a stricter workflow, a `Stop` hook may ask Codex to continue once and stage a
candidate after a high-value discovery. Keep this opt-in because it can interrupt normal
turn completion.

## Hook Setup

To get Claudeception-style automatic evaluation, install the hook script and enable
Codex hooks:

1. Ensure this skill lives at `~/.codex/skills/codexception`.
2. Ensure the activator is executable:

```sh
chmod +x ~/.codex/skills/codexception/scripts/codexception-activator.sh
```

3. Enable hooks in `~/.codex/config.toml`:

```toml
[features]
codex_hooks = true
```

4. Add the `UserPromptSubmit` hook from `hooks.json.example` to
`~/.codex/hooks.json`, or merge the equivalent hook into an existing hooks file.

Restart Codex after installing or changing skills and hooks.
