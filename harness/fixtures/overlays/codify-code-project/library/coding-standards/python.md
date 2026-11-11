# Python Coding Standard

## Scope

Python 3.12 programs and their tests, in `*.py` files.

## File and Folder Structure

1. `pyproject.toml`
2. `src/<module>/__init__.py`
3. `src/<module>/main.py`
4. `src/<module>/config.py`
5. `tests/test_<module>.py`

## Rules

1. Code must pass ruff with default rules.
2. Credentials must come from environment variables only.
3. Functions must have type hints on every argument.

## Tests

Tests: required

Tests use pytest with one test file per module.

Test path: `tests/test_<module>.py`
