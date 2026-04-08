---
name: super-dev
description: >
  Use when implementing features, fixing bugs, refactoring code, optimizing performance,
  resolving deprecations, or any multi-step development task requiring planning, implementation,
  testing, and review. Orchestrates specialized subagents through research, architecture,
  coding, QA, code review, and documentation phases. Triggers on: "implement", "build",
  "fix bug", "refactor", "add feature", "develop this", "help me build", "add functionality",
  "optimize performance", "resolve deprecation", "systematic development".
  Do NOT trigger on: simple questions ("what does this code do?"), file searches
  ("where is the auth function?"), one-off commands ("run the tests"), code explanations,
  quick edits, or non-development tasks.
license: MIT
compatibility: Requires Gemini CLI with experimental subagents enabled (experimental.enableAgents=true). Git required for worktree management.
metadata:
  author: Jennings Liu
  version: "3.4.4"
  repository: https://github.com/jenningsloy318/gemini-cli-artifacts
  keywords:
    - development
    - workflow
    - subagents
    - coordinator
    - parallel-execution
    - hooks
    - git-worktree
    - requirement-clarification
    - isolation
    - writer-validator
    - parallel-docs
    - dual-validation
    - proactive-indexing
---

# Super Dev Workflow

A team-based development system where the Coordinator acts as Team Lead, orchestrating specialized subagents who work in their own independent context loops, returning structured results to the main session.

**Announce at start:** YOU MUST say "I'm using the super-dev skill with super-dev subagents to systematically implement this task." at the beginning of every run.

## Mandatory Worktree Enforcement (NEW in v3.1.2)

Super-dev now strictly enforces that ALL development work happens inside a git worktree.

- **Phase 1 Identification:** Before doing any work, the Team Lead MUST define:
  - `SPEC_INDEX`: Next sequential index (e.g., `01`).
  - `FEATURE_NAME`: Kebab-case name of the task (e.g., `auth-fix`).
  - `SPEC_NAME`: `${SPEC_INDEX}-${FEATURE_NAME}` (e.g., `01-auth-fix`).
  - `BRANCH_NAME`: `${SPEC_NAME}` (Identical to SPEC_NAME, e.g., `01-auth-fix`).
  - `WORKTREE_DIR`: `.worktree/${SPEC_NAME}` (Directory part identical to SPEC_NAME, e.g., `.worktree/01-auth-fix`).
- **Explicit Creation:** Team Lead MUST run `git worktree add -b ${BRANCH_NAME} ${WORKTREE_DIR}`.
- **Strict Isolation:** Once the worktree is created, ALL subsequent labor (Phases 2-11) MUST occur within that worktree. Any edit to the main repository tree during these phases is a VIOLATION.
- **Mandatory Navigation:** Subagents are explicitly instructed to `cd` into `${WORKTREE_DIR}` at the start of every session. NAVIGATION is mandatory, not just switching branches.
- **Global Rule:** The `dev-rules` skill makes worktree navigation a mandatory initial step for all agents.
- **Verification:** Agents are required to verify their environment using `git worktree list`.

## Specification Directory Naming Convention (NEW in v3.4.2)

To maintain a clear audit trail and logical order, all files created within the specification directory (`${WORKTREE_DIR}/specification/${SPEC_NAME}/`) MUST follow a strict sequential naming convention:

- **Format:** `[doc-index]-[descriptive-name].md`
- **Proactive Indexing (NEW in v3.4.2)**: The Team Lead MUST track the current highest index and proactively assign the next sequential number (`prev + 1`) to every new document delegation. Do NOT wait for the validator to fix gaps.
- **Normalization**: The `doc-validator` remains as a safety layer to ensure **NO GAPS** exist in the indexing, even if phases are skipped.
- **Example Indexing:**
  - `01-requirements.md`
  - `02-behavior-scenarios.md` (Note: Gap-free even if phase skipped)
  - `03-research.md`
  - `04-assessment.md`
  - `05-specification.md`
  - `06-implementation-plan.md`
  - `07-handoff.md`

The Team Lead is responsible for adapting to any renames reported by the validator.

## Parallel Writer-Validator Strategy (NEW in v3.3.0)

To ensure maximum document quality and technical accuracy, every phase that produces a document MUST employ a **Parallel Writer-Validator** dual-agent strategy. Self-checks by the writer are FORBIDDEN as a substitute for peer review.

### Execution Pattern:

1.  **Index Assignment (v3.4.2)**: Before spawning, the Team Lead determines the next sequential index (e.g., if `01-...` exists, the next is `02-...`).
2.  **Parallel Spawning**: The Team Lead spawns BOTH the designated **Writer Agent** and the **`doc-validator`** subagent in parallel, passing the target filename (with the assigned index) to both.
3.  **Collaborative loop**:
    - The **Writer** drafts/updates the document using the assigned index.
    - The **Validator** reviews the draft using the **Dual-Validation** method.
    - **Validation**: The Validator MUST verify that the assigned index is strictly incremental and has NO GAPS.
    - If validation fails, the Validator provides explicit fix instructions to the Writer.
    - The Writer applies fixes and notifies the Validator.
4.  **Phase Exit**: The phase is complete ONLY when the Validator reports a "PASS" verdict to the Team Lead.

### Dual-Validation Method (NEW in v3.3.1):

The `doc-validator` MUST perform two distinct types of validation for every document:

- **Programmatic**: Execute the relevant gate script from `scripts/gates/` (e.g., `gate-bdd.sh`).
- **Qualitative**: Perform deep LLM analysis against phase goals, project standards, and previous artifacts.
  A "PASS" verdict requires success in BOTH methods.

### Mandatory Role Mapping (v3.4.2):

| Phase | Document                       | Writer Agent             | Validator Agent | Gate Script            |
| ----- | ------------------------------ | ------------------------ | --------------- | ---------------------- |
| 2     | `[doc-index]-requirements.md`  | `requirements-clarifier` | `doc-validator` | `gate-requirements.sh` |
| 2.5   | `[doc-index]-scenarios.md`     | `bdd-scenario-writer`    | `doc-validator` | `gate-bdd.sh`          |
| 3     | `[doc-index]-research.md`      | `research-agent`         | `doc-validator` | (N/A)                  |
| 5     | `[doc-index]-assessment.md`    | `code-assessor`          | `doc-validator` | (N/A)                  |
| 6     | `[doc-index]-specification.md` | `spec-writer`            | `doc-validator` | `gate-spec-trace.sh`   |
| 7     | `[doc-index]-plan.md`          | `spec-writer`            | `doc-validator` | `gate-spec-trace.sh`   |
| 10    | Documentation Updates          | `docs-executor`          | `doc-validator` | `gate-docs-drift.sh`   |
| 10.5  | `[doc-index]-handoff.md`       | `handoff-writer`         | `doc-validator` | (N/A)                  |

## Mandatory Requirement Clarification (NEW in v3.0.9)

To ensure technical integrity and eliminate ambiguity, **Phase 2 (Requirements)** now mandates the use of the `clarify` skill.

- **SOP Integration:** The Coordinator MUST invoke `activate_skill(name: "clarify")` at the start of Phase 2.
- **Prompt Mode Enforcement:** Use the `clarify` Prompt Mode SOP (Wittgenstein language decomposition -> Socratic triple-query -> Polanyi tacit extraction) to turn the user's initial request into a structured technical directive.
- **Output Validation:** Phase 2 is NOT complete until the user confirms the `clarify` structural assembly output (Type, Goal, Core Info, Constraints, Implicit Preferences, Acceptance Criteria).

## Hook-Driven Quality Gates (NEW in v3.0.1)

Super-dev now integrates deep hooks to automate quality control and protect your project.

### Automated Protections (BeforeTool)

- **Dangerous Command Block:** Blocks `rm -rf`, `git reset --hard`, etc., before they execute.
- **Sensitive File Protection:** Prevents accidental edits to `.env`, `package-lock.json`, and other critical files.
- **Phase Integrity Check:** Automatically verifies that previous phase artifacts exist before starting a new phase (e.g., checks for requirements before starting BDD).
- **PR Quality Gate:** Blocks PR creation via GitHub MCP if tests are failing.

### Automated Cleanup (AfterTool)

- **Auto-Format:** Runs Prettier (or project formatter) automatically after every file edit.
- **Auto-Lint:** Runs ESLint (or project linter) and reports errors back to the agent immediately.
- **Command Logging:** Maintains an audit trail of every bash command run in `${extensionPath}/data/command-log.txt`.

### Atomic Task Commits (Stop)

- **Auto-Commit:** Automatically commits changes after each task completion with a `chore(ai): apply Gemini CLI edit` message.

## Prerequisites

**Subagents must be enabled in your `settings.json`:**

```json
{
  "experimental": {
    "enableAgents": true
  }
}
```

Or enable via environment variable:

```bash
export GEMINI_EXPERIMENTAL_ENABLE_AGENTS=true
```

## First-Run Configuration

On the first invocation of super-dev, check for a project configuration file:

### Detection

```bash
# Check for existing config
CONFIG_PATH="${extensionPath}/data/config.json"
if [ ! -f "$CONFIG_PATH" ]; then
  echo "First-run detected - configuration needed"
fi
```

### Setup Flow

If `${extensionPath}/data/config.json` does not exist:

1. **Announce**: "This is the first run of super-dev. Let me set up your project configuration."
2. **Auto-detect** what you can from the project:
   - Language: Check for `package.json` (Node), `Cargo.toml` (Rust), `go.mod` (Go), `pyproject.toml` (Python), etc.
   - Framework: Check for `next.config.*` (Next.js), `vite.config.*` (Vite), `angular.json` (Angular), etc.
   - Package manager: Check for `bun.lockb`, `pnpm-lock.yaml`, `yarn.lock`, `package-lock.json`
   - Test runner: Check for `jest.config.*`, `vitest.config.*`, `playwright.config.*`, `.pytest.ini`
3. **Ask user to confirm** detected values and fill in missing ones using `ask_user`
4. **Write config** to `${extensionPath}/data/config.json`
5. **Continue** with the normal workflow

### Subsequent Runs

On subsequent runs, read `${extensionPath}/data/config.json` silently and apply preferences. Do NOT ask again unless the user runs `/super-dev configure`.

## Architecture Overview

```
                    ┌─────────────────┐
                    │   Coordinator   │ ◄── Team Lead (Orchestration Only)
                    │   (Main Agent)  │     Delegates to Subagents
                    └────────┬────────┘     Manages shared task list file
                             │              Synthesizes subagent results
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│   Planning    │   │   Analysis    │   │  Execution    │
│   Subagents   │   │   Subagents   │   │  Subagents    │
│ - Research    │   │ - Debug       │   │ - Dev         │
│ - Requirements│   │ - Assessment  │   │ - QA          │
│ - Architecture│   │ - Code Review │   │ - Docs        │
│ - UI/UX       │   │               │   │               │
└───────────────┘   └───────────────┘   └───────────────┘
   Isolated context    Isolated context    Isolated context
   Returns summary     Returns summary     Returns summary
```

## Main Agent vs Subagents

|                  | Main Agent (Coordinator)  | Subagents                       |
| ---------------- | ------------------------- | ------------------------------- |
| **Context**      | Full session history      | Independent/Fresh context       |
| **Tools**        | Full toolset access       | Specialized/Restricted toolsets |
| **Coordination** | Orchestrates phases       | Executes atomic tasks           |
| **Best for**     | Strategic decision making | Deep technical focus            |

## When to Use

**ACTIVATE for** (multi-step development requiring planning + implementation):

- Bug fixes, build warnings/errors
- New features, improvements
- Performance optimization
- Deprecation resolution
- Refactoring large codebases

**DO NOT ACTIVATE for** (these are too simple for a full workflow):

- "What does this code do?" → Simple explanation, no dev workflow needed
- "Where is the auth function?" → File search, use `grep_search`/`glob` directly
- "Run the tests" → Single command, use `run_shell_command` directly
- "Fix this typo" → Trivial edit, use `replace` directly
- "Explain this error" → Q&A, no workflow needed

## Success Criteria

Grade each completed workflow run against these three dimensions:

### Outcome (Baseline — if this fails, nothing else matters)

- Feature/fix implemented correctly and works as intended
- All existing tests pass; new tests cover new functionality
- Code review resolves all Critical, High, and Medium issues to zero
- BDD scenario coverage: 100% of scenarios have corresponding passing tests
- Documentation updated to reflect changes
- Handoff document generated in spec directory (`11-handoff.md`)

### Efficiency (Undervalued — two correct runs can differ 3x in cost)

- Phase iteration loops < 3 (Phase 8/9 loop)
- Subagents used for high-volume or speculative work
- Team Lead NEVER performs agent work directly (delegation enforcement)
- No redundant phase execution or unnecessary retries

### Style & Instructions (Conventions followed)

- Git worktree created with branch name matching worktree name
- **MANDATORY**: ALL work (code, tests, docs) done inside the worktree
- **ENFORCEMENT**: Every session starts with `cd [worktree-path]`
- Spec directory structure followed inside worktree
- Workflow tracking JSON maintained and updated per phase
- Commit messages follow project conventions
- All work done inside the worktree, never in main repo

## Workflow Phases

```
- [ ] Phase 0:  Apply Dev Rules
- [ ] Phase 1:  Specification Setup (worktree + subagent config)
- [ ] MANDATORY: Navigate to Worktree (ALL agents: cd .worktree/...)
- [ ] Phase 2:  Requirements Clarification
- [ ] GATE:     Requirements Completeness (gate-requirements.sh)
- [ ] Phase 2.5: BDD Scenario Writing (MANDATORY, user confirmation required)
- [ ] GATE:     BDD Scenario Quality (gate-bdd.sh)
- [ ] Phase 3:  Research (options presentation)
- [ ] Phase 4:  Debug Analysis (bugs only)
- [ ] Phase 5:  Code Assessment
- [ ] Phase 5.3: Architecture Design (arch only)
- [ ] Phase 5.4: Product Design (arch + UI together)
- [ ] Phase 5.5: UI/UX Design (UI only)
- [ ] Phase 6:  Specification Writing
- [ ] GATE:     Spec-to-BDD Traceability (gate-spec-trace.sh)
- [ ] Phase 7:  Specification Review
- [ ] Phase 8:  Execution & QA (DELEGATED subagents)
- [ ] GATE:     Build & Test Pass (gate-build.sh)
- [ ] Phase 9:  Code Review + Adversarial Review (DELEGATED subagents)
- [ ] GATE:     Review Verdicts (gate-review.sh)
- [ ] Phase 10: Documentation Update
- [ ] GATE:     Documentation-Code Drift (gate-docs-drift.sh)
- [ ] Phase 10.5: Handoff Writing (MANDATORY)
- [ ] Phase 11: Cleanup & Validation
- [ ] Phase 12: Commit & Merge to Main
- [ ] Phase 13: Final Verification (worktree preserved)
```

**Phase 5.3/5.4/5.5 Selection:**

- Architecture ONLY → Phase 5.3 (`architecture-agent`)
- UI ONLY → Phase 5.5 (`ui-ux-designer`)
- BOTH → Phase 5.4 (`product-designer`) - coordinates both agents together

**Iteration Rule:** YOU MUST loop Phase 8/9 until Critical=0, High=0, Medium=0, code review verdict is Approved, adversarial verdict is PASS, ALL acceptance criteria are met, AND BDD scenario coverage is 100%. NEVER proceed to Phase 10 with unresolved issues, a REJECT/CONTESTED verdict, or uncovered scenarios.

**MANDATORY Phase 9 → 12 Transition Sequence (NEVER skip or reorder):**
After Phase 9 passes, you MUST execute these phases in strict order. Do NOT jump to Phase 12.

1. **Run gate-review.sh** → Must PASS (exit 0)
2. **Phase 10:** Delegate to `docs-executor` → Wait for completion
3. **Run gate-docs-drift.sh** → Must PASS (exit 0)
4. **Phase 10.5:** Delegate to `handoff-writer` → Wait for completion
5. **Phase 11:** Verify all tasks complete, worktree preserved
6. **Phase 11.5:** Present summary to user for confirmation
7. **ONLY THEN** proceed to Phase 12 (commit & merge)

## Verification Gates (MANDATORY)

Gates are **programmatic quality checks** that run between phases to catch problems early. Each gate is a script in `${extensionPath}/scripts/gates/` that exits 0 (PASS) or 1 (FAIL).

**CRITICAL:** Gates are NON-NEGOTIABLE. If a gate fails, the Team Lead MUST NOT proceed to the next phase. Instead, loop back to the failing phase and fix the issue.

### Gate Execution

```bash
# Run any gate script
bash ${extensionPath}/scripts/gates/<gate-name>.sh <spec-dir>
```

### Gate Failure Handling

1. Gate fails → Team Lead reports which gate and which checks failed
2. Team Lead delegates a subagent to fix the failing phase
3. After fix, re-run the gate
4. Only proceed when gate returns PASS (exit 0)

## Entry Point: Team Lead Coordinator

**ROLE:** Your current session becomes the Team Lead (Coordinator).

**To start:**

```
"I'm using super-dev. I will assume the Coordinator role to implement: [task]"
```

## Team Lead Responsibilities (Delegate Mode)

**SYSTEM OVERRIDE: DELEGATION MODE ENABLED**

### Worktree Isolation Rule (CRITICAL)

**Once the Git worktree is created in Phase 1, ALL work from Phase 2 through Phase 11 MUST occur inside that worktree.**

1. **Subagent Working Directory**: Every `generalist` call MUST include the worktree path and a mandatory `cd` instruction as the first step of the request.
2. **Context Passing**: The Coordinator MUST track the worktree path in the session context and pass it to every subagent.
3. **No Main Tree Edits**: Any edit to the main repository tree (outside the worktree) during Phases 2-11 is a **VIOLATION** of the isolation policy.

**CRITICAL PRIME DIRECTIVE:**
You are the **Team Lead**, NOT an individual contributor.
Your core function is to **manage resources**, not perform labor.
You MUST suppress the urge to "just fix it yourself".

**THE "HANDS-OFF" RULE:**
From **Phase 2 onwards**, you are FORBIDDEN from using these tools for implementation, debugging, or research tasks:

- `replace` - file editing
- `write_file` - file creation
- `run_shell_command` - command execution
- `grep_search` - code searching
- `glob` - file pattern matching
- `read_file` - reading files for implementation analysis

You MUST ONLY use these tools for:

1. Phase 0/1 Setup (creating directories, worktrees)
2. Phase 12 Git Operations (merge, commit)
3. Project Management (reading status, updating task lists, tool calls)

**HOW TO DELEGATE TO SUBAGENTS:**
Use the **`generalist` tool** (or specialized subagent tools like `codebase_investigator`) with a clear request:

```
generalist(request: "Act as the [Agent Name] subagent. Your instructions are located at [agent-md-path]. Task: [task]")
```

**IF YOU CATCH YOURSELF DOING THE WORK:**

- STOP immediately
- Ask: "Which subagent handles this?"
- Use the **`generalist` tool** to delegate to that subagent.

**CRITICAL ENFORCEMENT:** Team Lead operates in orchestration-only mode. The ONLY way to do work in Phases 2-11 is via delegation tools.

✅ **CAN (Phases 0-1 only):**

- Phase 0: Apply dev rules
- Phase 1: Execute specification setup (worktree, spec dir, workflow JSON)

✅ **CAN (All phases - orchestration only):**

- Use **`generalist`** or **`codebase_investigator`** to delegate tasks
- Create/Update shared task list file
- Synthesize findings from subagent results
- Coordinate phase transitions
- Commit and merge (Phase 12)

❌ **CANNOT (Phases 2-11) - DELEGATE INSTEAD:**

- **NEVER edit files directly** → Delegate to `dev-executor` or `docs-executor`
- **NEVER run commands directly** → Delegate to `dev-executor` or `qa-agent`
- **NEVER perform research directly** → Delegate to `research-agent` or `codebase_investigator`
- **NEVER write specifications** → Delegate to `spec-writer`
- **NEVER do code assessment** → Delegate to `code-assessor` or `codebase_investigator`
- **NEVER do architecture design** → Delegate to `architecture-agent`
- **NEVER do UI/UX design** → Delegate to `ui-ux-designer`
- **NEVER do debug analysis** → Delegate to `debug-analyzer`
- **NEVER do code review** → Delegate to `code-reviewer`
- **NEVER do adversarial review** → Delegate to `adversarial-reviewer`

## Subagent Roles

| Phase | Subagent               | Role                                                                          |
| ----- | ---------------------- | ----------------------------------------------------------------------------- |
| 2     | requirements-clarifier | **Product Thinker (YC Partner Mode):** Challenge framing, gather requirements |
| 2.5   | bdd-scenario-writer    | Write BDD behavior scenarios from acceptance criteria                         |
| 3     | research-agent         | **Research Scout:** Multi-source research with freshness scoring              |
| 4     | debug-analyzer         | Root cause analysis (bugs only)                                               |
| 5     | code-assessor          | Assess architecture, style, frameworks                                        |
| 5.3   | architecture-agent     | **Eng Manager:** Design architecture with readiness dashboard                 |
| 5.4   | product-designer       | Coordinate architecture + UI design together                                  |
| 5.5   | ui-ux-designer         | Create UI/UX design (UI only)                                                 |
| 6     | spec-writer            | Write spec, plan, task list                                                   |
| 8     | dev-executor           | Implement code (concurrent with `qa-agent`)                                   |
| 8     | qa-agent               | **QA Lead:** Plan tests, run tests + browser smoke tests                      |
| 9     | code-reviewer          | **Staff Engineer:** Spec-aware review focused on production-risk bugs         |
| 9     | adversarial-reviewer   | **Red Team:** Multi-lens adversarial challenge with Destructive Action Gate   |
| 10    | docs-executor          | Update documentation                                                          |
| 10.5  | handoff-writer         | Generate session handoff document                                             |
| Any   | investigator           | **Detective:** Bounded 4-phase investigation for mid-execution unknowns       |

## Key Concepts

### Shared Task List (File-based)

- Coordinator maintains a `specification/[name]/task-list.md` file.
- Subagents read this file to understand their current context.
- Coordinator updates the file after each delegation returns.

### Option Presentation

YOU MUST present 3-5 options to the user in Phases 3, 5.3, 5.4, 5.5. NEVER skip option presentation.
In Phase 5.4, ALWAYS present COMBINED architecture+UI options together.

### BDD Scenario Propagation Rule

`01.1-behavior-scenarios.md` MUST be passed as input to ALL downstream phases after Phase 2.5.

## Investigation Protocol (Any Phase — On-Demand)

**Subagent:** `investigator` — can be delegated by any phase agent or Coordinator when unknowns arise.

### Auto-Trigger Conditions

Delegate to `investigator` when:

- **Loop detection**: Same error 2x with different fix attempts.
- **Doc mismatch**: API/library behaves differently than docs.
- **Missing dependency**: Required config/package not in assessment.
- **Opaque failure**: Build/test error with no obvious cause.

## Phase 10: Documentation Update (MANDATORY)

**Delegated to:** `docs-executor`

**CRITICAL:** This phase MUST be executed after Phase 9 passes. NEVER jump from Phase 9 to Phase 12.

## Phase 12: Commit & Merge to Main

**Executed by:** Coordinator (Main Agent)

**PRE-CONDITION CHECK (MANDATORY):**
Verify Phase 8, 9, 10, 10.5, and 11 are complete before starting Phase 12.

**CRITICAL — Specification Directory Commit Rule:**
The `specification/[spec-index]-[spec-name]/` directory MUST always be committed. It contains the evidence of the systematic workflow.

## Troubleshooting

| Issue                     | Solution                                                 |
| ------------------------- | -------------------------------------------------------- |
| Subagent hits token limit | Use `codebase_investigator` for smaller, scoped searches |
| Delegation loop           | Assume Coordinator role and resolve manually             |
| Gate failure              | Loop back to the relevant phase and fix the artifact     |

---

**For detailed phase-by-phase implementation, see:** `${extensionPath}/agents/coordinator.md`
