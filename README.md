# Gemini CLI Artifacts Extension

A comprehensive Gemini CLI extension that provides specialized commands for the entire software development lifecycle, from research and architecture to implementation and documentation.

## Features

### 🏗️ Architecture & Design
- **Architecture Design** (`/architecture:design`): Create comprehensive architecture specifications with ADRs
- **UI/UX Design** (`/ui-ux:design`): Design user interfaces with complete specifications
- **Code Assessment** (`/code:assess`): Analyze existing codebase patterns and standards

### 🔍 Research & Analysis
- **Research** (`/research`): Comprehensive research on best practices and patterns
- **Debug Analysis** (`/debug:analyze`): Systematic root cause analysis for bugs

### 💻 Development & Quality
- **Implementation** (`/implement`): Parallel development and QA execution
- **Code Review** (`/code:review`): Deep code review with git diff analysis

### 📚 Documentation
- **Documentation** (`/docs:update`): Sequential documentation updates after implementation

## Installation

1. Clone this repository:
```bash
git clone https://github.com/jenningsloy318/gemini-cli-artifacts.git
cd gemini-cli-artifacts
```

2. Install the extension:
```bash
gemini extension install https://github.com/jenningsloy318/gemini-cli-artifacts
```

3. Verify installation:
```bash
gemini extension list
```

## Usage

Each command is designed to work as part of a complete development workflow:

### 1. Research Phase
```bash
/research "React hooks best practices 2024"
```

### 2. Architecture Phase
```bash
/architecture:design "Implement real-time collaboration feature"
```

### 3. Assessment Phase
```bash
/code:assess
```

### 4. Implementation Phase
```bash
/implement
```

### 5. Review Phase
```bash
/code:review
```

### 6. Documentation Phase
```bash
/docs:update
```

## Command Structure

All commands follow a consistent format:
- **PERSONA**: Defines the expert role
- **OBJECTIVE**: Clear task goal
- **INSTRUCTIONS**: Step-by-step guidance
- **OUTPUT**: Structured output format

## Configuration

You can customize the extension behavior by editing `extension.toml`:

```toml
[extension.settings]
auto_save = true
output_format = "markdown"
parallel_execution = true
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your improvements
4. Submit a pull request

## License

MIT License - see LICENSE file for details.

## Repository

https://github.com/jenningsloy318/gemini-cli-artifacts
