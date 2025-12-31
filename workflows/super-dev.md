---
description: A comprehensive, coordinator-driven development workflow with parallel agent execution for implementing features, fixing bugs, improving performance, or refactoring code. Includes mandatory development rules and philosophy.
---

# Super-Dev Workflow

A comprehensive, coordinator-driven development workflow with parallel agent execution for implementing features, fixing bugs, improving performance, or refactoring code. This workflow serves as the central orchestration manual for the "Coordinator Agent".

## Table of Contents
1. [Development Rules & Philosophy](#development-rules--philosophy)
2. [Workflow Overview](#workflow-overview)
3. [Entry Point](#entry-point)
4. [Phase-by-Phase Execution](#phase-by-phase-execution)
5. [Agent Reference](#agent-reference)
6. [Quality Gates](#quality-gates)
7. [Integration Guide](#integration-guide)

---

## Development Rules & Philosophy

**Trigger:** Phase 0 of the workflow.
**Mandate:** These rules MUST be followed for all development work.

### 1. Figma MCP Integration Rules
When implementing designs from Figma:
1. **Required Flow**:
   - Run `get_design_context` first.
   - If truncated, run `get_metadata` then re-fetch specific nodes.
   - Run `get_screenshot` for visual reference.
   - **Only then** download assets and start implementation.
2. **Implementation Rules**:
   - Treat Figma output as a representation, not final code.
   - Replace Tailwind utility classes with project design tokens.
   - Reuse existing components; do not duplicate.
   - Validate 1:1 visual parity against the screenshot.

### 2. MCP Script Usage
Use wrapper scripts via Bash instead of direct MCP tool calls (except `current_time`).
- **Exa**: `python3 ${CLAUDE_PLUGIN_ROOT}/scripts/exa/exa_search.py`
- **DeepWiki**: `python3 ${CLAUDE_PLUGIN_ROOT}/scripts/deepwiki/deepwiki_structure.py`
- **Context7**: `python3 ${CLAUDE_PLUGIN_ROOT}/scripts/context7/context7_docs.py`
- **GitHub**: `python3 ${CLAUDE_PLUGIN_ROOT}/scripts/github/github_search_code.py`

### 3. Time & Search Rules
- **Time MCP**: In every prompt, add the current date and time as extra context.
- **Codebase Search**: **Prefer ast-grep** for structural code search. Use it to find patterns (`useState`, API calls) and deprecated usage.

### 4. Git Rules (CRITICAL)
- **Safety**: Never create GitHub Actions. Do not commit to git cache.
- **Atomic Commits**: `git add file1 file2` (only edited files). **NEVER** `git add -A`.
- **Checkpoints**:
  - Stash before major phases/refactoring.
  - Commit after **every** completed task.
  - Verify `git status` is clean before phase transitions.
- **Recovery**: Use `git reflog` or `git stash pop` if files are lost.

### 5. Documentation Update Rules (MANDATORY)
All specification documents MUST be updated as work progresses:
1. **Task List (`[index]-task-list.md`)**: Mark tasks complete immediately.
2. **Implementation Summary (`[index]-implementation-summary.md`)**: Update after EACH milestone.
3. **Specification (`[index]-specification.md`)**: Update with `[UPDATED: YYYY-MM-DD]` if implementation deviates.

**Enforcement**:
❌ **FORBIDDEN**: Completing tasks without updating the task list.
❌ **FORBIDDEN**: Committing code without corresponding doc updates.

### 6. Development Philosophy
- **Incremental**: Small, compilable, atomic commits.
- **First Principles**: Question assumptions. Build from ground truth.
- **New Requirements**: Discuss solution -> ASCII Diagram -> User Confirmation -> Code.
- **Bug Reporting**: Always ask for: 1. Steps to Reproduce, 2. Expected vs Actual, 3. Environment.
- **Decision Priority**: Testability > Readability > Consistency > Simplicity > Reversibility.

---

## Workflow Overview

### Architecture
```
                    ┌─────────────────┐
                    │   Super Dev     │
                    │    Workflow     │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   Coordinator   │ ◄── Central Authority
                    │     Agent       │
                    └────────┬────────┘
                             │
    ┌────────────────────────┼────────────────────────┐
    │                        │                        │
    ▼                        ▼                        ▼
┌─────────┐            ┌─────────┐            ┌─────────┐
│Planning │            │Analysis │            │Execution│
│ Agents  │            │ Agents  │            │ Agents  │
└─────────┘            └─────────┘            └─────────┘
```

### Core Principles
1. **Coordinator-Driven**: A central authority orchestrates all phases. No unauthorized stops.
2. **Parallel Execution**: Development and QA run simultaneously in Phase 8.
3. **Documentation-First**: All work is tracked and documented throughout.
4. **Quality Gates**: Strict criteria before proceeding to the next phase.

---

## Entry Point

**Command**: `super-dev:coordinator` or `init-super-dev-workflow`

**Parameters**:
- `task_type`: "feature|bug|refactor|improvement"
- `task_description`: Detailed description.
- `spec_directory`: Optional path.

---

## Phase-by-Phase Execution

### Phase 0: Apply Dev Rules
**Agent**: `super-dev:dev-rules`
- Establish coding standards, git practices, and quality guidelines.

### Phase 1: Specification Setup
**Purpose**: Define specification directory structure.
**Output**: `specification/[spec-index]-[spec-name]/index.md`

### Phase 2: Requirements Clarification
**Agent**: `super-dev:requirements-clarifier`
**Output**: `[doc-index]-requirements.md`

### Phase 3: Research (Time MCP Enhanced)
**Agent**: `super-dev:research-agent`
**Activities**: 
- Get current timestamp, filter by recency, flag deprecated info.
- **MANDATORY**: Provide 3-5 options with detailed comparisons and let the user pick the best fit.
**Output**: `[doc-index]-research-report.md`

### Phase 4: Debug Analysis (For Bugs)
**Agent**: `super-dev:debug-analyzer`
**Activities**: Root cause analysis using `grep` (text) and `ast-grep` (structure).
**Output**: `[doc-index]-debug-analysis.md`

### Phase 5: Code Assessment
**Agent**: `super-dev:code-assessor`
**Activities**: Analyze architecture and patterns using `grep`/`ast-grep`.
**Output**: `[doc-index]-assessment.md`

### Phase 5.3: Architecture Design (Optional/Complex)
**Agent**: `super-dev:architecture-agent`
**Activities**: **MANDATORY**: Provide 3-5 options with detailed comparisons and let the user pick the best fit.
**Output**: `[doc-index]-architecture.md` and ADRs.

### Phase 5.5: UI/UX Design (Optional/UI)
**Agent**: `super-dev:ui-ux-designer`
**Activities**: **MANDATORY**: Provide 3-5 options with detailed comparisons and let the user pick the best fit.
**Output**: `[doc-index]-design-spec.md`

### Phase 6: Specification Writing
**Agent**: `super-dev:spec-writer`
**Output**: 
- `[doc-index]-specification.md`
- `[doc-index]-implementation-plan.md`
- `[doc-index]-task-list.md`

### Phase 7: Specification Review
**Agent**: `super-dev:coordinator`
**Action**: Validate alignment with requirements.

### Phase 8: Execution & QA (PARALLEL)
**CRITICAL**: The Coordinator invokes TWO agents in PARALLEL.

**Agent 1: `super-dev:dev-executor`**
- Implements code features.
- Invokes specialist developers (Rust, Go, React, etc.).
- Handles Build Queue (Rust/Go: one at a time).

**Agent 2: `super-dev:qa-agent`**
- Plans test strategy.
- Writes and executes unit/integration tests parallel to dev.

**Output**: Implemented code and passing test suite.

### Phase 9: Code Review (Loop)
**Agent**: `super-dev:code-reviewer`
**Rule**: Spec-aware review.
**Iteration**: 
- If **Blocked/Changes Requested** OR **Critical/High findings** OR **Acceptance Criteria Fail**:
  → **RE-ENTER Phase 8**.
- Proceed only when "Approved" (Low/Info only).

### Phase 10: Documentation Update (Sequential)
**Agent**: `super-dev:docs-executor`
**Timing**: Runs AFTER code review approval.
**Action**: Batch update all docs (Task List, Summary, Spec).

### Phase 11: Cleanup
**Agent**: `super-dev:coordinator`
**Action**: Remove temp files, unused code.

### Phase 12: Commit & Push
**Agent**: `super-dev:coordinator`
**Action**: 
1. `git add [files]` (modified only).
2. `git commit -m "..."`.
3. `git push`.
4. Verify `git status` is clean.

### Phase 13: Final Verification
**Agent**: `super-dev:coordinator`
**Checklist**: All artifacts present, code pushed, status clean.

---

## Agent Reference

### Coordinator Agent
| Agent | Role |
|-------|------|
| `coordinator` | Central Orchestrator. Manages phases, build queue, and final verification. |

### Executor Agents
| Agent | Role | Phase |
|-------|------|-------|
| `dev-executor` | Code Implementation | Phase 8 (Parallel) |
| `qa-agent` | Testing & Verification | Phase 8 (Parallel) |
| `docs-executor` | Documentation Updates | Phase 10 (Sequential) |

### Analysis & Planning Agents
- `requirements-clarifier`
- `research-agent` (Time MCP)
- `search-agent`
- `debug-analyzer` (grep/ast-grep)
- `code-assessor` (grep/ast-grep)
- `architecture-agent`
- `ui-ux-designer`
- `spec-writer`
- `code-reviewer`

### Specialist Developers
- `rust-developer`, `golang-developer`, `frontend-developer`, `backend-developer`, `android-developer`, `ios-developer`, `windows-app-developer`, `macos-app-developer`.

---

## Quality Gates

1. **Phase 1**: Spec directory exists.
2. **Phase 2-7**: Docs approved.
3. **Phase 8**: Code compiles, tests pass.
4. **Phase 9**: Review Approved (No Critical/High issues).
5. **Phase 10**: Docs synced with code.
6. **Phase 12**: Clean git status, pushed to remote.

---

## Integration Guide

### Quick Start
```bash
# Initialize workflow
init-super-dev-workflow --task-type="feature" --task-description="Add user auth"
```

### Status Check
```bash
super-dev status
```