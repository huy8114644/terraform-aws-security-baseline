# Contributing

Create a focused branch from the target branch, such as `docs/portfolio-standards`, `fix/flow-log-permissions`, or `feat/module-output`. Keep infrastructure changes reviewable and describe their security and cost implications.

Use Conventional Commits: `feat:`, `fix:`, `docs:`, `test:`, or `chore:` followed by a concrete summary. Open a pull request using the repository template. A reviewer should check the actual diff and evidence before merge; do not invent reviews or approvals.

Run `make lint`, `make test` and `make scan`. Record commands, tool versions, results and any failures or checks you could not run. Static scanner findings must be fixed or explicitly discussed; never report an unrun check as passed. No cloud access is needed for these commands. Consumer-root plan evidence is optional unless infrastructure behavior changes, and requires an authorized account. Redact sensitive values, state and account-specific details before sharing plans.

Document required inputs, compatibility constraints and runtime limitations when changing modules. Do not commit credentials, state, plan files, or claims of compliance without attributable audit evidence. CI validates source configuration and does not deploy. A GitHub review can only be claimed when a real reviewer has submitted one.
