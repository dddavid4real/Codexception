## [0.1.1] - 2026-04-28

### Documentation
- Moved optional hook setup next to installation in `README.md`.
- Expanded hook setup into concrete config, chmod, hook JSON, and restart steps.
- Clarified that existing `hooks.json` files should be merged instead of replaced.
- Replaced the hardcoded local hook path in `hooks.json.example` with a home-relative path.

## [0.1.0] - 2026-04-28

### Features
- Created the Codex-native adaptation of Claudeception.
- Added selective session-learning extraction into staged skill candidates.
- Added default staging under `~/.codex/skill-candidates/` before any active skill promotion.
- Included reusable candidate template resources.
- Included example Codex hook and config files for automatic evaluation reminders.

### Design Rationale
- Preserve Claudeception's core session-learning idea while adapting it to Codex skill paths and conventions.
- Make promotion into active skills explicit and approval-based.
- Keep the installed skill self-contained so copying only `codexception/` into `~/.codex/skills/` is enough.

### Notes & Caveats
- Most sessions should not produce new skills.
- Hook setup is optional and should only remind Codex to evaluate extraction.
- Candidate staging is the default safety layer.
