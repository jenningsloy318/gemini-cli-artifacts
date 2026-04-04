# Go Coding Standards

## Philosophy

- **Simplicity Over Cleverness**: Obvious code is better than "smart" code.
- **Errors are Values**: Handle errors explicitly as first-class data.
- **Composition Over Inheritance**: Use interfaces and struct embedding.
- **Useful Zero Values**: Types should be usable immediately without complex initialization.

## Patterns

### Error Handling
- Use `fmt.Errorf("context: %w", err)` for wrapping.
- Use `errors.Is(err, target)` for sentinel checks.
- Use `errors.As(err, &target)` for type assertions.
- NEVER ignore errors with `_` unless explicitly documented.

### Interfaces
- **Accept Interfaces, Return Structs**: Decouple dependencies at the consumer level.
- **Consumer-Defined**: Define interfaces in the package that *uses* them.
- **Small Interfaces**: Prefer single-method interfaces (`io.Reader`, `Closer`).

### Concurrency
- **Share memory by communicating**: Use channels for coordination.
- **Context Propagation**: Always pass `context.Context` as the first parameter for cancellation/timeouts.
- **Leak Prevention**: Ensure goroutines can exit on context cancellation.
- **Graceful Shutdown**: Handle `os.Signal` to finish active work before exiting.

## Performance
- **Preallocation**: `make([]T, 0, length)` for known sizes.
- **Strings**: Use `strings.Builder` or `strings.Join` for concatenations in loops.
- **Swiss Tables**: Leverages Go 1.24+ optimized maps.

## Tooling
- **Format**: `gofmt -s -w .` and `goimports -w .`
- **Lint**: `golangci-lint run` (with `modernize` enabled).
- **Test**: `go test -race -cover ./...`
