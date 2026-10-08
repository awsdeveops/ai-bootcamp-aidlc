# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A human-in-the-loop AI-DLC workflow, defined entirely in prompts and config. There is no application code and no build, lint or test setup. It contains agents, a skill, a hook, a short generic rules file, and one sample requirement (HC-102, patient self-service appointment rescheduling). Do not add code or choose a stack unless the user supplies one.

## How the pieces fit together

- `.claude/agents/ai-workflow-agent.md` is the orchestrator. The lifecycle is: requirement, inception, readiness, human clarification, READY, planning, human approval, construction, testing, verification, human acceptance. It delegates each stage and never decides consequential questions itself.
- `.claude/agents/requirement-readiness-agent.md` handles Inception only. It reviews `requirements/requirements.md`, asks the Product Owner one question at a time, and decides READY or NOT READY. On READY it creates `.claude/REQUIREMENT_READY` and `requirements/<requirement-id>-clarifications.md`, then stops. It does not start Planning or Construction.
- `.claude/skills/jira-requirement-review/SKILL.md` is the checklist the readiness agent calls. It forces a fixed five-section output and forbids code, technology choices and invented rules.
- `.claude/settings.json` registers a **Stop hook** that runs `.claude/hooks/check-requirement-ready.ps1`. The hook exits with code 2, blocking the end of every turn, unless `.claude/REQUIREMENT_READY` exists.
- `generic_prompt.md` contains generic engineering rules. When performing  engineering work, read and follow these rules in addition to the
  applicable AIDLC agent and skill instructions.
- `requirements/` holds the original requirement and, once READY, the clarifications file with confirmed answers, acceptance criteria, units of work, open items and sign-off.

## Things that are easy to get wrong

- **Each lifecycle stage has its own agent, and each stops at its boundary.** `ai-workflow-agent` delegates to `requirement-readiness-agent` (Inception), `engineering-planner-agent` (Planning, ends at human approval), `engineering-agent` (Construction and Testing, ends after the tests run) and `verification-agent` (Verification, ends before human acceptance). The agents do not start the next stage themselves, and the planner and engineering agents also refuse to run without `.claude/REQUIREMENT_READY`.
- **`.claude/REQUIREMENT_READY` is an approval marker, not a build artifact.** Create it, containing `READY`, only when the readiness decision is READY. Never create it just to silence the Stop hook. Delete it to reopen the review.
- **The hook prints to stdout, not stderr.** When it blocks, the harness shows "No stderr output", which hides the actual message ("BLOCKED: Requirement has not been approved as READY").
- **The hook path is relative** (`.claude/hooks/...`), so it only works when Claude Code runs from the repo root.
- **Never modify the original requirement.** Clarifications go in the separate clarifications file. Never answer on the Product Owner's behalf, and record only confirmed answers.
- **Conflicting sources:** if two requirement documents disagree, ask which is authoritative instead of picking one. `JIRA_2.pdf` (ticket ADH-2) is an older, thinner version of the same feature as HC-102. It has no text layer, so it has to be rendered to an image to be read (Poppler's `pdftoppm`).
