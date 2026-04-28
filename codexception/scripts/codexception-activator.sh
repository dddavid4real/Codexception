#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF'
MANDATORY CODEXCEPTION EVALUATION REQUIRED

After completing this user request, evaluate whether the work produced reusable
knowledge worth saving as a Codex skill candidate.

Evaluate only after finishing the user's requested work:
1. Did this require non-obvious debugging, investigation, or trial and error?
2. Would this help with a future similar task?
3. Are the trigger conditions specific and the solution verified?

If yes to any question above, invoke the codexception skill after completing the
user request. Stage candidates under ~/.codex/skill-candidates/. Do not promote
them into the active skills directory without explicit user approval.

If no, do nothing.
EOF
