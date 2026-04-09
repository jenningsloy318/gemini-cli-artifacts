---
name: go-quality
description: Run comprehensive Go quality checks including formatting, linting, race detection, and coverage analysis.
---

# Go Quality Command

This command executes a full suite of Go quality tools to ensure compliance with project standards and idiomatic patterns.

## Execution Steps

1.  **Format Check**:
    ```bash
    gofmt -s -l .
    ```
    (Use `gofmt -s -w .` to fix issues)

2.  **Imports Check**:
    ```bash
    goimports -l .
    ```
    (Use `goimports -w .` to fix issues)

3.  **Static Analysis**:
    ```bash
    go vet ./...
    ```

4.  **Comprehensive Linting**:
    ```bash
    golangci-lint run
    ```
    (Ensure `modernize` analyzer is enabled in `.golangci.yml`)

5.  **Race Detection**:
    ```bash
    go test -race ./...
    ```

6.  **Coverage Analysis**:
    ```bash
    go test -coverprofile=coverage.out ./...
    go tool cover -func=coverage.out
    ```

## Usage in Workflow

- **Phase 8 (Implementation)**: Run after implementation to verify correctness and style.
- **Phase 9 (Review)**: Use to provide empirical evidence for code review findings.
- **Pre-Commit**: Always ensure all checks pass before merging.

## Quality Gates

- **Zero Lint Errors**: `golangci-lint` must pass with no findings.
- **Race Free**: `go test -race` must pass with zero detected races.
- **Coverage**: Aim for ≥80% overall coverage.
- **Idiomaticity**: Checks for `any` over `interface{}`, `errors.Is/As` usage, and `omitzero` tags (Go 1.24).
