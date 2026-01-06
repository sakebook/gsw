# Contributing to gsw

First off, thanks for taking the time to contribute! 🎉

The following is a set of guidelines for contributing to `gsw`. These are mostly guidelines, not rules. Use your best judgment and feel free to propose changes to this document in a pull request.

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for `gsw`.

- **Check existing issues** to see if the bug has already been reported.
- **Use a clear and descriptive title** for the issue to identify the problem.
- **Describe the reproduction steps** in as much detail as possible.
- **Include your environment**: OS (macOS/Linux), Shell (Bash/Zsh), and `gcloud` version.

### Suggesting Enhancements

- **Use a clear and descriptive title** for the issue.
- **Provide a step-by-step description of the suggested enhancement** in as much detail as possible.
- **Explain why this enhancement would be useful** to most `gsw` users.

### Pull Requests

1.  Fork the repo and create your branch from `main`.
2.  If you've added code that should be tested, add tests.
3.  Ensure your code passes existing tests: `./test/run_tests.sh` (if available) or verify manually.
4.  Make sure your code lints with [ShellCheck](https://www.shellcheck.net/).
5.  Issue that pull request!

## Styleguides

### Shell Scripts

- Use 2 spaces for indentation.
- Prefer `[[ ]]` over `[ ]` for tests in Bash/Zsh.
- Quoting variables is generally a good idea.
