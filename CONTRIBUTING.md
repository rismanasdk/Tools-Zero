# Contributing to Tools Zero

Thank you for your interest in contributing to Tools Zero.

This project is a small Linux-focused toolkit wrapper for security tools such as `nmap`, `sqlmap`, `hydra`, `gobuster`, and others. Contributions are welcome for bug fixes, documentation improvements, new wrappers, menu updates, installation improvements, and quality-of-life changes.

## Before You Start

- Only contribute features and examples intended for authorized and legal security testing.
- Keep changes focused. Small pull requests are easier to review and merge.
- If you plan to add a new tool or make a large structural change, open an issue first so the approach can be discussed.

## Development Setup

1. Fork the repository.
2. Clone your fork:

```bash
git clone <your-fork-url>
cd tools-zero
```

3. Make sure `python3` is installed.
4. Install the external security tools you need for local testing.
5. If you want the helper launcher, run:

```bash
bash scripts/install_tools.sh
```

## Project Layout

- `main.py` starts the application.
- `cli.py` contains the CLI/menu execution flow.
- `menu.py` contains menu rendering logic.
- `toolkit/` stores wrapper scripts grouped by tool.
- `scripts/` contains install and uninstall helpers.

## Recommended Workflow

1. Create a feature branch:

```bash
git checkout -b feature/short-description
```

2. Make your changes.
3. Verify the relevant files locally.
4. Commit with a clear message.
5. Push your branch and open a pull request.

## Coding Guidelines

- Prefer simple, readable Python and shell scripts.
- Keep naming consistent with the existing structure.
- Reuse shared helpers where possible instead of duplicating logic.
- When adding a new wrapper, place it in the matching subdirectory under `toolkit/`.
- Update `README.md` if the change affects installation, usage, or available features.
- Update help files when adding new commands or menu options.

## Verification

Please run the checks that make sense for your change before opening a pull request.

For shell scripts:

```bash
bash -n scripts/install_tools.sh
bash -n scripts/uninstall_tools.sh
```

For Python entrypoints:

```bash
python3 -m py_compile main.py cli.py menu.py banner.py runtime_utils.py
```

If you change a specific wrapper, also test that workflow manually from the menu or by running the related script directly.

## Pull Request Checklist

- The change solves one clear problem.
- The code is readable and consistent with the project.
- Relevant documentation has been updated.
- Basic local verification has been completed.
- The pull request description explains what changed and how it was tested.

## Reporting Issues

When opening an issue, please include:

- A short summary of the problem
- Steps to reproduce it
- Expected behavior
- Actual behavior
- Your OS and relevant tool versions if applicable

## Responsible Use

Tools Zero wraps utilities that can be dangerous if misused. By contributing, you agree to keep changes aligned with lawful, authorized, and ethical security testing.
