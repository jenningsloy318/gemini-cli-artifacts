---
description: A comprehensive, coordinator-driven development workflow with parallel agent execution for implementing features, fixing bugs, improving performance, or refactoring code. This workflow can be used globally with any project management system including Google Antigravity.
---

---

# Super-Dev

A comprehensive, coordinator-driven development workflow with parallel agent execution for implementing features, fixing bugs, improving performance, or refactoring code. This workflow can be used globally with any project management system including Google Antigravity.

## Table of Contents
1. [Workflow Overview](#workflow-overview)
2. [Entry Point](#entry-point)
3. [Phase-by-Phase Execution](#phase-by-phase-execution)
4. [Agent Reference](#agent-reference)
5. [Quality Gates](#quality-gates)
6. [Documentation Rules](#documentation-rules)
7. [Integration Guide](#integration-guide)

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

### When to Use This Workflow

Activate when asked to:
- [ ] Fix a bug or issue
- [ ] Fix build warnings or errors
- [ ] Implement a new feature
- [ ] Improve an existing feature
- [ ] Improve performance
- [ ] Resolve deprecation warnings
- [ ] Refactor code

### Core Principles

1. **Coordinator-Driven**: A central authority orchestrates all phases
2. **Parallel Execution**: Development and QA run simultaneously when possible
3. **Quality Gates**: Each phase has strict criteria before proceeding
4. **Documentation-First**: All work is tracked and documented throughout
5. **Incremental Progress**: Small, verifiable steps with commits at phase boundaries

---

## Entry Point

### Step 1: Initialize Workflow

**Command**: `init-super-dev-workflow`

**Parameters**:
- `task_type`: "feature|bug|refactor|improvement"
- `task_description`: Detailed description of what needs to be done
- `spec_directory`: Path to specification directory (optional, will be created if not exists)

**Output**: Workflow initialization with task ID and working directory

---

## Phase-by-Phase Execution

### Phase 1: Specification Setup

**Purpose**: Define specification directory and naming convention

**Activities**:
- [ ] Analyze project structure
- [ ] Identify existing specification patterns
- [ ] Define spec-name for this initiative (descriptive name)
- [ ] Generate spec-index number for this initiative (format: 001, 002, 003...)
- [ ] Create specification directory: `specification/[spec-index]-[spec-name]/`
- [ ] Create index.md file in the spec directory with metadata

**Specification Directory Structure**:
```
specification/
└── [spec-index]-[spec-name]/
    ├── index.md                               # Master index for this specification
    ├── [phase-index]-requirements.md         # Phase 2: Requirements
    ├── [phase-index]-research-report.md      # Phase 3: Research findings
    ├── [phase-index]-debug-analysis.md       # Phase 3: Debug analysis (if bug)
    ├── [phase-index]-assessment.md           # Phase 4: Code assessment
    ├── [phase-index]-architecture.md         # Phase 5: Architecture (optional)
    ├── [phase-index]-design-spec.md          # Phase 6: UI/UX design (optional)
    ├── [phase-index]-specification.md        # Phase 7: Technical specification
    ├── [phase-index]-implementation-plan.md  # Phase 7: Implementation plan
    ├── [phase-index]-task-list.md            # Phase 7: Task tracking
    └── [phase-index]-implementation-summary.md # Phase 11: Implementation summary
```

**File Naming Rules**:
- **Spec Index**: Three-digit zero-padded number (e.g., 001, 002, 003...)
- **Phase Index**: Three-digit zero-padded number starting from 001 (e.g., 001 for Phase 1, 002 for Phase 2, 003 for Phase 3, etc.)
- **File Format**: `[phase-index]-[document-name].md`
- Only create files for phases that are actually executed

**Output**:
- Specification directory defined as: `specification/[spec-index]-[spec-name]/`
- `specification/[spec-index]-[spec-name]/index.md` - Index file

**Quality Gate**: Specification directory must be created with index.md file

---

### Phase 2: Requirements Clarification

**Agent**: `requirements-clarifier`

**Purpose**: Gather and clarify all requirements

**Activities**:
- [ ] Extract functional requirements
- [ ] Identify non-functional requirements
- [ ] Define acceptance criteria
- [ ] Identify dependencies and constraints
- [ ] Clarify edge cases

**Output**: `[phase-index]-requirements.md`

**Quality Gate**: All requirements must be clear, testable, and approved

---

### Phase 3: Research

**Agent**: `research-agent`

**Purpose**: Research best practices, documentation, and patterns

**Activities**:
- [ ] Get current timestamp and context
- [ ] Search for relevant documentation
- [ ] Identify best practices
- [ ] Find similar implementations
- [ ] Research potential solutions
- [ ] Flag deprecated information

**Output**: `[phase-index]-research-report.md` with freshness scores

**Quality Gate**: Must have current, relevant information for implementation

---

### Phase 3: Debug Analysis (For Bugs Only)

**Agent**: `debug-analyzer`

**Purpose**: Systematic root cause analysis for bugs

**Activities**:
- [ ] Collect evidence of the issue
- [ ] Reproduce the problem
- [ ] Analyze error patterns
- [ ] Use grep for text pattern search
- [ ] Use ast-grep for structural analysis
- [ ] Identify root cause

**Output**: `[phase-index]-debug-analysis.md`

**Quality Gate**: Root cause must be identified with evidence

---

### Phase 4: Code Assessment

**Agent**: `code-assessor`

**Purpose**: Assess existing codebase for architecture and patterns

**Activities**:
- [ ] Analyze existing architecture
- [ ] Identify relevant patterns
- [ ] Assess framework usage
- [ ] Use grep for pattern matching
- [ ] Use ast-grep for structural analysis
- [ ] Track file coverage percentage

**Output**: `[phase-index]-assessment.md`

**Quality Gate**: Must understand existing patterns and integration points

---

### Phase 5: Architecture Design (For Complex Features - Optional)

**Agent**: `architecture-agent`

**Purpose**: Design architecture for complex features

**Activities**:
- [ ] Create module decomposition
- [ ] Define interfaces
- [ ] Design data flow
- [ ] Create Architecture Decision Records (ADRs)
- [ ] Validate design against requirements

**Output**: `[phase-index]-architecture.md` and ADRs

**Quality Gate**: Architecture must be validated against requirements

---

### Phase 6: UI/UX Design (For Features with UI - Optional)

**Agent**: `ui-ux-designer`

**Purpose**: Create UI/UX design specifications

**Activities**:
- [ ] Create wireframes
- [ ] Define interaction patterns
- [ ] Specify accessibility requirements
- [ ] Design responsive layouts
- [ ] Create design tokens

**Output**: `[phase-index]-design-spec.md`

**Quality Gate**: Design must meet accessibility and usability requirements

---

### Phase 7: Specification Writing

**Agent**: `spec-writer`

**Purpose**: Write comprehensive technical specification

**Activities**:
- [ ] Create technical specification
- [ ] Define implementation plan
- [ ] Create task breakdown
- [ ] Document API changes
- [ ] Specify test requirements

**Output**:
- `[phase-index]-specification.md`
- `[phase-index]-implementation-plan.md`
- `[phase-index]-task-list.md`

**Quality Gate**: Specification must be complete and actionable

---

### Phase 6: Specification Review

**Agent**: `coordinator`

**Purpose**: Review all specification documents

**Activities**:
- [ ] Validate alignment with requirements
- [ ] Check for completeness
- [ ] Verify testability
- [ ] Ensure feasibility
- [ ] Approve or request revisions

**Output**: Review decision and any required changes

**Quality Gate**: All specifications must be approved before implementation

---

### Phase 7: Execution & QA (PARALLEL)

**Critical**: Execute BOTH agents in parallel

#### Agent 1: Development Executor
**Type**: `dev-executor`

**Purpose**: Implement code changes

**Activities**:
- [ ] Implement features according to spec
- [ ] Invoke specialist developers as needed
- [ ] Follow coding standards
- [ ] Write implementation notes
- [ ] Handle build queue (Rust/Go: one at a time)

#### Agent 2: QA Agent
**Type**: `qa-agent`

**Purpose**: Testing and verification

**Activities**:
- [ ] Plan test strategy
- [ ] Write unit tests
- [ ] Set up integration tests
- [ ] Configure E2E tests if needed
- [ ] Verify acceptance criteria

**Output**:
- Implemented code
- Test suite
- Progress tracking

**Quality Gate**: Code must pass all tests and meet acceptance criteria

---

### Phase 8: Code Review

**Agent**: `code-reviewer`

**Purpose**: Specification-aware code review

**Activities**:
- [ ] Review code against specification
- [ ] Check for security vulnerabilities
- [ ] Assess performance implications
- [ ] Verify maintainability
- [ ] Check test coverage
- [ ] Review acceptance criteria

**Output**: Code review report with:
- Severity levels
- Evidence
- Verdict

**Iteration Rule**:
- If verdict is "Blocked" or "Changes Requested"
- OR any Critical/High/Medium findings exist
- OR any acceptance criteria are Not Met/Partial
→ **RE-ENTER Phase 7**

**Quality Gate**: Must be "Approved" or "Approved with Comments" with only Low/Info findings

---

### Phase 9: Documentation Update

**Agent**: `docs-executor`

**Purpose**: Update all documentation after approval

**Execution Model**: Sequential batch processing

**Activities**:
- [ ] Update task list completion status
- [ ] Document implementation summary
- [ ] Update specification with any deviations
- [ ] Integrate review findings
- [ ] Create final report

**Output**: Updated:
- `[phase-index]-task-list.md` (created in Phase 5, updated in Phase 9)
- `[phase-index]-implementation-summary.md` (created in Phase 9)
- `[phase-index]-specification.md` (created in Phase 5, updated in Phase 9)

**Quality Gate**: All documentation must be current and accurate

---

### Phase 10: Cleanup

**Agent**: `coordinator`

**Purpose**: Clean up temporary files and unused code

**Activities**:
- [ ] Remove temporary files
- [ ] Delete unused code
- [ ] Clean up test artifacts
- [ ] Verify no debugging code remains

**Output**: Clean working directory

**Quality Gate**: Working directory must be clean

---

### Phase 11: Commit & Push

**Agent**: `coordinator`

**Purpose**: Commit and push all changes

**Activities**:
- [ ] Stage all relevant files: `git add [files]`
- [ ] Create descriptive commit message
- [ ] Commit changes: `git commit`
- [ ] Push to remote: `git push`
- [ ] Verify clean state: `git status`

**Output**: Committed and pushed changes

**CRITICAL**: Never mark workflow complete without committing and pushing

---

### Phase 12: Final Verification

**Agent**: `coordinator`

**Purpose**: Verify all artifacts are complete

**Checklist**:
- [ ] All specification documents created
- [ ] Implementation summary complete
- [ ] No missing code or files
- [ ] All changes committed
- [ ] All changes pushed to remote
- [ ] Git status clean

**Output**: Final verification report

---

## Agent Reference

### Coordinator Agent (Central Authority)

| Agent | Purpose | Key Responsibilities |
|-------|---------|---------------------|
| `coordinator` | Central orchestrator | • Manages all phases<br>• Assigns tasks to specialists<br>• Monitors execution<br>• Enforces quality gates<br>• Performs final verification |

### Executor Agents

| Agent | Purpose | Execution Mode | When Used |
|-------|---------|----------------|-----------|
| `dev-executor` | Development implementation | Parallel (Phase 8) | Always |
| `qa-agent` | Testing and verification | Parallel (Phase 8) | Always |
| `docs-executor` | Documentation updates | Sequential (Phase 10) | After Phase 9 approval |

### Workflow Agents

| Agent | Purpose | Output |
|-------|---------|--------|
| `requirements-clarifier` | Gather requirements | Requirements document |
| `research-agent` | Research with current context | Research report |
| `search-agent` | Multi-source search | Search results |
| `debug-analyzer` | Root cause analysis | Debug analysis |
| `code-assessor` | Assess codebase | Assessment report |
| `code-reviewer` | Specification-aware review | Code review |
| `architecture-agent` | Design architecture | Architecture docs |
| `ui-ux-designer` | Create UI/UX specs | Design specifications |
| `spec-writer` | Write specifications | Technical specs |

### Developer Agents (Specialists)

| Agent | Purpose | Languages/Frameworks |
|-------|---------|---------------------|
| `rust-developer` | Rust systems programming | Rust 1.75+, Tokio, axum |
| `golang-developer` | Go backend development | Go 1.21+, stdlib, gin, chi |
| `frontend-developer` | Web frontend development | React 19, Next.js 15, TypeScript, Tailwind v4 |
| `backend-developer` | Backend/API development | Node.js/TS, Python, FastAPI, databases |
| `android-developer` | Android app development | Kotlin, Jetpack Compose, MVVM |
| `ios-developer` | iOS app development | Swift, SwiftUI, async/await |
| `windows-app-developer` | Windows desktop development | C#/.NET 8+, WinUI 3, WPF |
| `macos-app-developer` | macOS desktop development | Swift, SwiftUI, AppKit |

---

## Quality Gates

### Phase Completion Criteria

Each phase must meet these criteria before proceeding:

1. **Phase 1**: Specification directory exists
2. **Phase 2**: Requirements are clear and approved
3. **Phase 3**: Research is current and relevant
4. **Phase 3** (Debug Analysis): Root cause identified (bugs only)
5. **Phase 4**: Code patterns understood
6. **Phase 4.3**: Architecture validated (complex features)
7. **Phase 4.5**: Design meets requirements (UI features)
8. **Phase 5**: Specification is complete
9. **Phase 6**: All documents approved
10. **Phase 7**: Code implemented and tests pass
11. **Phase 8**: Code review approved
12. **Phase 9**: Documentation updated
13. **Phase 10**: Working directory clean
14. **Phase 11**: Changes committed and pushed
15. **Phase 12**: All artifacts verified

### Iteration Rules

- **Phase 7-8 Loop**: Continue until:
  - Code review verdict is "Approved" or "Approved with Comments"
  - Only Low/Info severity findings remain
  - All acceptance criteria are met

- **Build Queue (Rust/Go)**: Only one build at a time to prevent resource conflicts

---

## Documentation Rules

### MANDATORY: Update at Every Milestone

**At every phase boundary, update these documents:**

#### 1. Task List (`spec-[spec-index]-p5-task-list.md`)
- [ ] Mark completed tasks with `[x]`
- [ ] Add any new tasks discovered
- [ ] Note blocked or deferred tasks with reasons
- [ ] Update spec-index file with phase completion status

#### 2. Implementation Summary (`spec-[spec-index]-p9-implementation-summary.md`)
- [ ] Add completed work to "Code Changes" section
- [ ] Document technical decisions
- [ ] Record challenges and solutions

#### 3. Specification (`spec-[spec-index]-p5-specification.md`)
- [ ] Update affected sections with `[UPDATED: date]` marker
- [ ] Document why changes were necessary

### FORBIDDEN Actions
- ❌ Completing a milestone without updating task list
- ❌ Moving to next phase with outdated implementation summary
- ❌ Changing implementation without updating specification

---

## Integration Guide

### Using with Google Antigravity

1. **Import this workflow** into your Antigravity workspace
2. **Create a new project** using the "Super Dev Workflow" template
3. **Initialize workflow** with task details
4. **Follow phase-by-phase execution** as outlined

### Customization

You can customize:
- **Agent implementations**: Replace with your preferred AI agents
- **Document templates**: Modify to match your project's style
- **Quality criteria**: Adjust based on project requirements
- **Integration points**: Add your own tools and systems

### Required Integrations

To use this workflow effectively, you need:
- **Git repository**: For version control
- **File system**: For storing specifications and code
- **Agent system**: For executing specialized agents
- **Notification system**: For phase gate approvals

### Minimal Setup

```bash
# Clone or create your project
git clone <your-repo>
cd <your-project>

# Create specification directory
mkdir -p specification

# Initialize workflow
init-super-dev-workflow --task-type="feature" --task-description="Your task here"
```

### Example Commands

```bash
# Start a new feature
super-dev init --type=feature --description="Add user authentication"

# Check current phase
super-dev status

# Advance to next phase
super-dev next-phase

# View all documents
super-dev docs

# Force completion (use with caution)
super-dev complete --force
```

---

## Quick Reference

### Workflow Commands

| Command | Purpose |
|---------|---------|
| `init` | Initialize new workflow |
| `status` | Show current phase and status |
| `next-phase` | Advance to next phase |
| `docs` | View all documentation |
| `review` | Trigger code review |
| `complete` | Mark workflow complete |

### Phase Checkpoints

- [ ] **Phase 1**: Spec directory ready
- [ ] **Phase 2**: Requirements clarified
- [ ] **Phase 3**: Research complete
- [ ] **Phase 3** (Debug Analysis): Debug analyzed (if bug)
- [ ] **Phase 4**: Code assessed
- [ ] **Phase 4.3**: Architecture designed (if complex)
- [ ] **Phase 4.5**: UI/UX designed (if UI feature)
- [ ] **Phase 5**: Specification written
- [ ] **Phase 6**: Specification reviewed
- [ ] **Phase 7**: Code implemented & tested
- [ ] **Phase 8**: Code reviewed and approved
- [ ] **Phase 9**: Documentation updated
- [ ] **Phase 10**: Cleanup complete
- [ ] **Phase 11**: Changes committed
- [ ] **Phase 12**: Final verification passed

### Required Documents

**Specification Directory Structure**:
1. `specification/[spec-index]-[spec-name]/` - Directory containing all specification documents
2. `specification/[spec-index]-[spec-name]/index.md` - Index file tracking all documents in this specification

**Phase Documents** (within spec directory):
3. `[phase-index]-requirements.md` - Requirements document (Phase 2)
4. `[phase-index]-research-report.md` - Research findings (Phase 3)
5. `[phase-index]-debug-analysis.md` - Debug analysis (if bug, Phase 3)
6. `[phase-index]-assessment.md` - Code assessment (Phase 4)
7. `[phase-index]-architecture.md` - Architecture design (if needed, Phase 5)
8. `[phase-index]-design-spec.md` - UI/UX design (if needed, Phase 6)
9. `[phase-index]-specification.md` - Technical specification (Phase 7)
10. `[phase-index]-task-list.md` - Task tracking (Phase 7)
11. `[phase-index]-implementation-plan.md` - Implementation plan (Phase 7)
12. `[phase-index]-implementation-summary.md` - Implementation notes (Phase 11)

---

## Success Criteria

A workflow is successful when:

1. **All phases completed** in order
2. **Quality gates passed** at each checkpoint
3. **Documentation updated** throughout
4. **Code reviewed and approved**
5. **Changes committed and pushed**
6. **Working directory clean**
7. **All acceptance criteria met**

---

*This workflow is designed to be adaptable to any project type while maintaining rigorous quality standards and comprehensive documentation.*
