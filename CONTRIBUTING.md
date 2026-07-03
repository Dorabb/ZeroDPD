# Contributing to ZeroDPD

## Development Workflow

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit changes: `git commit -am 'Add your feature'`
4. Push to branch: `git push origin feature/your-feature`
5. Submit a pull request

## Code Standards

### Java/Spring Boot
- Follow Google Java Style Guide
- Use meaningful variable names
- Add comprehensive JavaDoc comments
- Implement proper error handling

### Python
- Follow PEP 8
- Use type hints
- Write unit tests with pytest
- Maintain > 80% code coverage

### React/TypeScript
- Use functional components
- Follow Airbnb JavaScript style guide
- Implement proper error boundaries
- Test components with React Testing Library

## Testing Requirements

- Unit tests: > 80% coverage
- Integration tests for API endpoints
- E2E tests for critical workflows

Run tests:
```bash
make test
```

## Commit Messages

Use conventional commits:
```
feat: add new feature
fix: fix a bug
docs: update documentation
test: add tests
refactor: refactor code
```

## Pull Request Process

1. Update documentation
2. Add/update tests
3. Ensure CI/CD passes
4. Request code review
5. Address feedback

## License

By contributing, you agree that your contributions will be licensed under the project's proprietary license.
