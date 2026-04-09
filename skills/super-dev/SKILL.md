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
  version: "3.7.20"
  repository: https://github.com/jenningsloy318/gemini-cli-artifacts
  keywords:
    - development
    - workflow
    - subagents
    - tech-lead
    - parallel-execution
    - hooks
    - git-worktree
    - requirement-clarification
    - isolation
    - writer-validator
    - parallel-docs
    - dual-validation
    - proactive-indexing
    - single-turn-parallel
    - index-discovery
    - specialist-selection
    - multi-domain-parallel
    - domain-detection
    - sequential-specification
---

# Super Dev Workflow

A team-based development system where the Tech Lead acts as Tech Lead, orchestrating specialized subagents who work in their own independent context loops, returning structured results to the main session.

**Announce at start:** YOU MUST say "I'm using the super-dev skill with super-dev subagents to systematically implement this task." at the beginning of every run.

## Mandatory Worktree Enforcement (NEW in v3.1.2)

Super-dev now strictly enforces that ALL development work happens inside a git worktree.

- **Phase 1 Identification:** Before doing any work, the Tech Lead MUST define:
  - `SPEC_INDEX`: Next sequential index (e.g., `01`).
  - `FEATURE_NAME`: Kebab-case name of the task (e.g., `auth-fix`).
  - `SPEC_NAME`: `${SPEC_INDEX}-${FEATURE_NAME}` (e.g., `01-auth-fix`).
  - `BRANCH_NAME`: `${SPEC_NAME}` (Identical to SPEC_NAME, e.g., `01-auth-fix`).
  - `WORKTREE_DIR`: `.worktree/${SPEC_NAME}` (Directory part identical to SPEC_NAME, e.g., `.worktree/01-auth-fix`).
- **Explicit Creation:** Tech Lead MUST run `git worktree add -b ${BRANCH_NAME} ${WORKTREE_DIR}`.
- **Strict Isolation:** Once the worktree is created, ALL subsequent labor (Phases 2-11) MUST occur within that worktree. Any edit to the main repository tree during these phases is a VIOLATION.
- **Mandatory Navigation:** Subagents are explicitly instructed to `cd` into `${WORKTREE_DIR}` at the start of every session. NAVIGATION is mandatory, not just switching branches.
- **Global Rule:** The `dev-rules` skill makes worktree navigation a mandatory initial step for all agents.
- **Verification:** Agents are required to verify their environment using `git worktree list`.

## Specification Directory Naming Convention (NEW in v3.4.2)

To maintain a clear audit trail and logical order, all files created within the specification directory (`${WORKTREE_DIR}/specification/${SPEC_NAME}/`) MUST follow a strict sequential naming convention:

- **Format:** `[doc-index]-[descriptive-name].md`
- **Doc Index Discovery (NEW in v3.7.4)**: At the start of every document-producing phase, the Tech Lead MUST run `ls` on the spec directory to identify the current highest index.
- **Proactive Indexing**: The Tech Lead proactively assigns the next sequential number (`prev + 1`) and defines the **EXACT** filename before spawning subagents.
- **Normalization**: The `doc-validator` remains as a safety layer to ensure **NO GAPS** exist, even if phases are skipped.
- **Example Indexing:**
  - `[doc-index]-requirements.md`
  - `02-behavior-scenarios.md` (Note: Gap-free even if phase skipped)
  - `03-research.md`
  - `[doc-index]-assessment.md`
  - `05-specification.md`
  - `06-implementation-plan.md`
  - `07-handoff.md`

## Single-Turn Parallel Writer-Validator Strategy (NEW in v3.5.0)

To ensure maximum document quality and speed, every phase that produces a document MUST employ a **Single-Turn Parallel** dual-agent strategy.

### Execution Pattern (v3.7.8):

1.  **Index Discovery**: Tech Lead runs `ls` to find the last index.
2.  **Filename Definition**: Tech Lead defines the EXACT target filename (e.g., `05-specification.md`).
3.  **Single-Turn Spawning (MANDATORY)**: The Tech Lead MUST issue BOTH subagent delegation calls (Writer + Validator) in a **SINGLE RESPONSE**.
4.  **Collaborative loop**:
    - The **Writer** drafts the document using the EXACT filename provided.
    - The **Validator** (`doc-validator`) waits for the file to appear and then reviews it using the **Dual-Validation** method.
    - **Validation**: The Validator MUST verify that the assigned index is strictly incremental and has NO GAPS.
    - If validation fails, the Validator provides explicit fix instructions to the Writer.
    - The Writer applies fixes and notifies the Validator.
5.  **Phase Exit**: The phase is complete ONLY when the Validator reports a "PASS" verdict to the Tech Lead.

### Dual-Validation Method (NEW in v3.3.1):

The `doc-validator` MUST perform two distinct types of validation for every document:

- **Programmatic**: Execute the relevant gate script from `scripts/gates/` (e.g., `gate-bdd.sh`).
- **Qualitative**: Perform deep LLM analysis against phase goals, project standards, and previous artifacts.
  A "PASS" verdict requires success in BOTH methods.

### Mandatory Role Mapping (v3.7.16):

| Phase | Document                       | Writer Agent                  | Validator Agent | Gate Script            |
| ----- | ------------------------------ | ----------------------------- | --------------- | ---------------------- |
| 2     | `[doc-index]-requirements.md`  | `requirements-clarifier`      | `doc-validator` | `gate-requirements.sh` |
| 2.5   | `[doc-index]-scenarios.md`     | `bdd-scenario-writer`         | `doc-validator` | `gate-bdd.sh`          |
| 3     | `[doc-index]-research.md`      | `research-agent`              | `doc-validator` | (N/A)                  |
| 5     | `[doc-index]-assessment.md`    | `code-assessor`               | `doc-validator` | (N/A)                  |
| 6     | `[doc-index]-specification.md` | `spec-writer`                 | `doc-validator` | `gate-spec-trace.sh`   |
| 6     | `[doc-index]-plan.md`          | `spec-writer`                 | `doc-validator` | `gate-spec-trace.sh`   |
| 6     | `[doc-index]-task-list.md`     | `spec-writer`                 | `doc-validator` | `gate-spec-trace.sh`   |
| 8     | **Specialist(s)**              | **Implementation Specialist** | `qa-agent`      | `gate-build.sh`        |
| 10    | Documentation Updates          | `docs-executor`               | `doc-validator` | `gate-docs-drift.sh`   |
| 10.5  | `[doc-index]-handoff.md`       | `handoff-writer`              | `doc-validator` | (N/A)                  |

### Phase 8 Implementation Architecture (3-Tier)

The Tech Lead MUST select the implementation model based on **Domain Detection Algorithm**:

1.  **Analyze Task List**: Read `task-list.md` from the spec directory.
2.  **Detect Domains**: For each task, check target file extensions:
    - `.rs` / `Cargo.toml` → **rust-developer**
    - `.go` / `go.mod` → **golang-developer**
    - `.tsx` / `.jsx` / `.css` / `next.config` → **frontend-developer**
    - `.py` / `.fastapi` / `routes/` → **backend-developer**
    - `.swift` / `ios/` → **ios-developer**
    - `.kt` / `android/` → **android-developer**
    - `.xaml` / `.csproj` → **windows-app-developer**
    - `.swift` + `macOS target` → **macos-app-developer**
3.  **Group Tasks**: Bundle tasks by detected domain.
4.  **Execute Model Selection**:

```text
  SINGLE-DOMAIN (e.g., all Rust):
  ┌──────────┐
  │Tech Lead │─── analyzes tasks ──→ all .rs files
  └────┬─────┘
       │
       ▼
  ┌──────────────┐
  │rust-developer│  ← direct spawn, no middleman
  │(all tasks)   │
  └──────────────┘

  MULTI-DOMAIN (e.g., Rust backend + React frontend):
  ┌──────────┐
  │Tech Lead │─── analyzes tasks ──→ T1-T3: .rs files
  └──┬────┬──┘                       T4-T5: .tsx files
     │    │
     ▼    ▼         ← PARALLEL, both direct spawn
  ┌──────────────┐  ┌────────────────────┐
  │rust-developer│  │frontend-developer  │
  │(T1, T2, T3)  │  │(T4, T5)            │
  └──────────────┘  └────────────────────┘

  UNKNOWN/AMBIGUOUS DOMAIN:
  ┌──────────┐
  │Tech Lead │─── can't determine domain
  └────┬─────┘
       │
       ▼
  ┌──────────────┐
  │dev-executor  │  ← fallback, existing behavior
  │(does its own │    (internally routes to specialists)
  │ detection)   │
  └──────────────┘
```

## Mandatory Requirement Clarification (NEW in v3.0.9)

To ensure technical integrity and eliminate ambiguity, **Phase 2 (Requirements)** now mandates the use of the `clarify` skill.

- **SOP Integration:** The Tech Lead MUST invoke `activate_skill(name: "clarify")` at the start of Phase 2.
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

---

**For detailed phase-by-phase implementation, Execution Rules, and JSON Tracking schema, see:** `/agents/tech-lead.md`
