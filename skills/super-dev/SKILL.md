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
  version: "3.7.7"
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
---

# Super Dev Workflow

A team-based development system where the Tech Lead acts as Team Lead, orchestrating specialized subagents who work in their own independent context loops, returning structured results to the main session.

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
- **Doc Index Discovery (NEW in v3.7.4)**: At the start of every document-producing phase, the Tech Lead MUST run `ls` on the spec directory to identify the current highest index.
- **Proactive Indexing**: The Tech Lead proactively assigns the next sequential number (`prev + 1`) and defines the **EXACT** filename before spawning subagents.
- **Normalization**: The `doc-validator` remains as a safety layer to ensure **NO GAPS** exist, even if phases are skipped.
- **Example Indexing:**
  - `01-requirements.md`
  - `02-behavior-scenarios.md` (Note: Gap-free even if phase skipped)
  - `03-research.md`
  - `04-assessment.md`
  - `05-specification.md`
  - `06-implementation-plan.md`
  - `07-handoff.md`

## Single-Turn Parallel Writer-Validator Strategy (NEW in v3.5.0)

To ensure maximum document quality and speed, every phase that produces a document MUST employ a **Single-Turn Parallel** dual-agent strategy.

### Execution Pattern (v3.7.4):

1.  **Index Discovery**: Team Lead runs `ls` to find the last index.
2.  **Filename Definition**: Team Lead defines the EXACT target filename (e.g., `05-specification.md`).
3.  **Single-Turn Spawning (MANDATORY)**: The Team Lead MUST issue BOTH subagent delegation calls (Writer + Validator) in a **SINGLE RESPONSE**.
4.  **Collaborative loop**:
    - The **Writer** drafts the document using the EXACT filename provided.
    - The **Validator** (`doc-validator`) waits for the file to appear and then reviews it using the **Dual-Validation** method.
    - **Validation**: The Validator MUST verify that the assigned index is strictly incremental and has NO GAPS.
    - If validation fails, the Validator provides explicit fix instructions to the Writer.
    - The Writer applies fixes and notifies the Validator.
5.  **Phase Exit**: The phase is complete ONLY when the Validator reports a "PASS" verdict to the Team Lead.

### Dual-Validation Method (NEW in v3.3.1):

The `doc-validator` MUST perform two distinct types of validation for every document:

- **Programmatic**: Execute the relevant gate script from `scripts/gates/` (e.g., `gate-bdd.sh`).
- **Qualitative**: Perform deep LLM analysis against phase goals, project standards, and previous artifacts.
  A "PASS" verdict requires success in BOTH methods.

### Mandatory Role Mapping (v3.7.7):

| Phase | Document                       | Writer Agent                  | Validator Agent | Gate Script            |
| ----- | ------------------------------ | ----------------------------- | --------------- | ---------------------- |
| 2     | `[doc-index]-requirements.md`  | `requirements-clarifier`      | `doc-validator` | `gate-requirements.sh` |
| 2.5   | `[doc-index]-scenarios.md`     | `bdd-scenario-writer`         | `doc-validator` | `gate-bdd.sh`          |
| 3     | `[doc-index]-research.md`      | `research-agent`              | `doc-validator` | (N/A)                  |
| 5     | `[doc-index]-assessment.md`    | `code-assessor`               | `doc-validator` | (N/A)                  |
| 6     | `[doc-index]-specification.md` | `spec-writer`                 | `doc-validator` | `gate-spec-trace.sh`   |
| 7     | `[doc-index]-plan.md`          | `spec-writer`                 | `doc-validator` | `gate-spec-trace.sh`   |
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
4.  **Execute Model**:
    - **SINGLE-DOMAIN**: Direct spawn of one specialist (e.g., `rust-developer`) for all tasks.
    - **MULTI-DOMAIN**: Parallel direct spawn of multiple specialists. Tasks MUST be explicitly partitioned.
    - **UNKNOWN/AMBIGUOUS**: Fallback to `dev-executor`.

## Mandatory Requirement Clarification (NEW in v3.0.9)

To ensure technical integrity and eliminate ambiguity, **Phase 2 (Requirements)** now mandates the use of the `clarify` skill.

...
| Phase | Subagent | Role |
| ----- | ---------------------- | ----------------------------------------------------------------------------- |
| 2 | requirements-clarifier | **Product Thinker (YC Partner Mode):** Challenge framing, gather requirements |
| 2.5 | bdd-scenario-writer | Write BDD behavior scenarios from acceptance criteria |
| 3 | research-agent | **Research Scout:** Multi-source research with freshness scoring |
| 4 | debug-analyzer | Root cause analysis (bugs only) |
| 5 | code-assessor | Assess architecture, style, frameworks |
| 5.3 | architecture-agent | **Eng Manager:** Design architecture with readiness dashboard |
| 5.4 | product-designer | Coordinate architecture + UI design together |
| 5.5 | ui-ux-designer | Create UI/UX design (UI only) |
| 6 | spec-writer | Write spec, plan, task list |
| 8 | **Specialist(s)** | **Implementation Specialists** (Multi-domain parallel detection) |
| 8 | qa-agent | **QA Lead:** Plan tests, run tests + browser smoke tests |
| 9 | code-reviewer | **Staff Engineer:** Spec-aware review focused on production-risk bugs |
| 9 | adversarial-reviewer | **Red Team:** Multi-lens adversarial challenge with Destructive Action Gate |
| 10 | docs-executor | Update documentation |
| 10.5 | handoff-writer | Generate session handoff document |
| Any | investigator | **Detective:** Bounded 4-phase investigation for mid-execution unknowns |

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
- [ ] Phase 8:  Implementation
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

...
| 8 | Writing code, running tests | **Specialized Specialist(s)** (via Domain Detection) + `qa-agent` |
...

```
Phase 8:  Implementation (DELEGATED) → Delegate to Specialized Specialist(s) + qa-agent
```

...
**Iteration Rule: Phase 8/9 Loop**

**Loop until:** Critical=0, High=0, Medium=0, AcceptanceCriteriaMet, ScenarioCoverageMet (100%), CodeReviewVerdict=Approved, AdversarialVerdict=PASS

**Triggers (re-enter Phase 8 if):**
...
