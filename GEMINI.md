# Super Dev Gemini Extension

A comprehensive coordinator-driven development workflow extension for Gemini CLI with parallel agent execution for implementing features, fixing bugs, and refactoring code.

**v2.2.0 — Enhanced with 2026 AI Development Best Practices**

## Overview

This extension provides a systematic development workflow orchestrated by a **Coordinator Agent** that:

- Assigns tasks to specialized sub-agents
- Enforces quality gates at each phase
- Manages build queues and parallel execution (dev + qa + docs)

## Usage

Invoke the `super-dev` skill to start the orchestrated workflow:
"I'm using the super-dev skill to systematically implement this task: [task description]"

## Sub-Agents

The extension includes several specialized sub-agents:

- `coordinator`: Central orchestrator for all workflow phases.
- `dev-executor`: Implements code changes.
- `backend-developer`: Expert backend developer for Node.js/Python.
- `qa-agent`: Plans and runs tests.
- `docs-executor`: Updates documentation.
- `architecture-agent`: Designs system architecture.
- `ui-ux-designer`: Creates UI/UX specifications.
- `spec-writer`: Writes technical specifications.
- `research-agent`: Conducts multi-source research.
- `code-reviewer`: Performs specification-aware reviews.
- `adversarial-reviewer`: Challenges implementations from critical lenses.
- `bdd-scenario-writer`: Generates BDD scenarios.
- `investigator`: Root-cause analysis for mid-execution unknowns.

## Available Skills

- `super-dev`: Main entry point for the development workflow.
- `dev-rules`: Core coding standards and git practices.
- `tdd-workflow`: Test-driven development methodology.
- `security-review`: Security checklists and patterns.
- `adversarial-review`: Multi-lens critical challenge.
- `verify`: Interactive feature verification.
- `careful`: Safety guardrails for destructive commands.
- `freeze`: Directory restriction for debugging.

## Workflow Phases

1.  **Requirements Clarification** (`requirements-clarifier`)
2.  **BDD Scenario Writing** (`bdd-scenario-writer`)
3.  **Research** (`research-agent`)
4.  **Debug Analysis** (if bug) (`debug-analyzer`)
5.  **Code Assessment** (`code-assessor`)
6.  **Architecture & UI/UX Design** (`architecture-agent`, `ui-ux-designer`)
7.  **Specification Writing** (`spec-writer`)
8.  **Execution & QA** (`dev-executor`, `qa-agent`)
9.  **Code & Adversarial Review** (`code-reviewer`, `adversarial-reviewer`)
10. **Documentation Update** (`docs-executor`)
11. **Handoff Writing** (`handoff-writer`)
12. **Commit & Merge** (Coordinator)

## Configuration

The extension auto-detects project settings on first run and stores them in `${extensionPath}/data/config.json`.

## Maintenance Rules

- **Patch Versioning:** Each time a modification is made to the codebase, the extension's patch version MUST be incremented in `gemini-extension.json`, `agents/coordinator.md`, and `skills/super-dev/SKILL.md` before committing changes.
