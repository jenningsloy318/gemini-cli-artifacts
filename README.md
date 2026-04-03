# Super Dev Gemini Extension

A comprehensive coordinator-driven development workflow for Gemini CLI, using specialized subagents to implement features, fix bugs, and refactor code.

## 🚀 Getting Started

### 1. Enable Sub-agents (Required)
This extension relies on the experimental sub-agent capabilities in Gemini CLI. You must enable this in your global settings.

Edit your `~/.gemini/settings.json`:
```json
{
  "experimental": {
    "enableAgents": true
  }
}
```
Or set the environment variable for your session:
```bash
export GEMINI_EXPERIMENTAL_ENABLE_AGENTS=true
```

### 2. Installation
Install the extension via the Gemini CLI:
```bash
gemini extension install https://github.com/jenningsloy318/gemini-cli-artifacts
```

### 3. Configuration
Run the following command to set up your project preferences:
```bash
gemini extension config super-dev
```
This will prompt you for:
- **Exa API Key**: Used by the `research-agent` for web/code search.
- **OpenAI API Key**: Used for creating vector embeddings of your codebase.
- **GitHub Token**: Used for repository searches.

The configuration is saved to `${GEMINI_EXTENSION_DATA}/config.json` for future sessions.

## 🛠 Usage

To start a development workflow, simply use keywords like "implement", "build", or "add feature" in your prompt, or explicitly call the skill:

> "I'm using the super-dev skill to build a new dashboard page with a sidebar and charts."

### Workflow Phases
1. **Research & Requirements**: The `requirements-clarifier` and `research-agent` map the task and project context.
2. **BDD Scenarios**: `bdd-scenario-writer` generates behavioral scenarios for your approval.
3. **Architecture & Design**: `architecture-agent` and `ui-ux-designer` create technical specifications.
4. **Implementation**: `dev-executor` writes the code in a specialized git worktree.
5. **Quality Gates**: `qa-agent` runs build/test scripts and ensures all programmatic gates pass.
6. **Review**: `code-reviewer` and `adversarial-reviewer` audit the implementation for risks.
7. **Documentation**: `docs-executor` updates documentation to match the new code.
8. **Merge**: The Coordinator merges the verified worktree back to your main branch.

## 📂 Project Structure
- `agents/`: Definitions for specialized subagents.
- `skills/`: Skill instructions and logic.
- `scripts/gates/`: Programmatic validation scripts used during transitions.
- `templates/`: Configuration and specification templates.

## 🛡 Security & Safety
- All development work is performed in a **git worktree** (`.worktree/`) to keep your main branch clean until verification is complete.
- Programmatic gates (`gate-build.sh`, `gate-review.sh`, etc.) enforce quality before any merge happens.
- Sensitive information like API keys are stored securely in your local environment, never committed.
