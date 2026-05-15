# Environment Setup

Get your development environment running so you can work on the FastAPI Workshop.

## Why does a project need its own environment?

Every Python project depends on specific versions of external libraries. Without isolation, installing one project's dependencies can break another project on the same machine — or different developers end up with different library versions, causing bugs that are impossible to reproduce.

A **virtual environment** solves this: it creates a self-contained folder that holds Python and all the libraries for one project. When you activate it, Python commands use that folder instead of whatever is installed globally. This means:

- Your project always runs with exactly the right library versions.
- You can safely install, upgrade, or remove packages without affecting anything else.
- Anyone else who clones the repo gets the exact same setup.

In this workshop we use **[`uv`](https://docs.astral.sh/uv/)** — a fast, modern tool that manages both Python itself and your project's virtual environment. You can think of it as a replacement for [pip](https://pip.pypa.io/en/stable/), `venv`, and `pyenv` combined — see the [uv concepts overview](https://docs.astral.sh/uv/concepts/projects/) for a fuller picture.

---

## Install prerequisites

You need two tools before anything else:

- **Git** — for cloning the repository and tracking changes.
- **[`uv`](https://docs.astral.sh/uv/getting-started/installation/)** — for managing Python and all project dependencies (no separate Python install required).

<details id="prerequisites-macos" class="platform-macos">
<summary>macOS</summary>
Install Homebrew — the standard package manager for macOS.
Skip this line if you already have it.

```bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install git
brew install uv
```

</details>

<details id="prerequisites-windows" class="platform-windows">
<summary>Windows</summary>

1. Download and run the [Git for Windows](https://git-scm.com/download/win) installer.
2. Install `uv` by running this in PowerShell — it downloads and runs the official installer script:

```powershell

powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

> Open a **new** terminal after installation so the `uv` command becomes available.

</details>

<details id="prerequisites-linux" class="platform-linux">
<summary>Linux</summary>

Install Git using your distro's package manager (Ubuntu/Debian shown here):

```bash

sudo apt update && sudo apt install -y git
```

Download and run the official `uv` installer:

```bash

curl -LsSf https://astral.sh/uv/install.sh | sh
```

> Restart your terminal (or run `source $HOME/.local/bin/env`) after installing `uv` so your shell picks it up.

</details>

**Verify both tools are available:**

```bash

git --version
uv --version
```

`git --version` should print something like `git version 2.x.x`, and `uv --version` something like `uv 0.x.x`.

---

## Install dependencies

Now you'll create a virtual environment and install all the libraries the project needs.

**Create and activate the virtual environment:**

<details id="venv-macos" class="platform-macos">
<summary>macOS</summary>

Create the virtual environment (this creates a `.venv/` folder in your project directory):

```bash

uv venv
```

Activate it (tells your shell to use that folder for Python commands):

```bash

source .venv/bin/activate
```

</details>

<details id="venv-windows" class="platform-windows">
<summary>Windows</summary>

Create the virtual environment (this creates a `.venv\` folder in your project directory):

```powershell

uv venv
```

Activate it (tells your shell to use that folder for Python commands):

```powershell

.venv\Scripts\activate
```

</details>

<details id="venv-linux" class="platform-linux">
<summary>Linux</summary>

Create the virtual environment (this creates a `.venv/` folder in your project directory):

```bash

uv venv
```

Activate it (tells your shell to use that folder for Python commands):

```bash

source .venv/bin/activate
```

</details>

**Verify the virtual environment is active:**

Once the virtual environment is activated, your terminal prompt will show `(.venv)` — that's how you know it's working.

Another way to verify is to run:

```bash

which python
```

On Windows, use `where python` instead.

The output should point to the Python inside your `.venv` folder, for example: `/path/to/your/project/.venv/bin/python`

**Install all project dependencies:**

```bash

uv sync --extra all
```

This reads the dependency list declared in [`pyproject.toml`](../pyproject.toml) and installs every library at the exact version the project expects. The `--extra all` flag includes optional groups like development tools and test runners. It also installs FastAPI itself in [**editable mode**](https://setuptools.pypa.io/en/latest/userguide/development_mode.html), meaning your source-code changes take effect immediately — no reinstall needed.

---

## Verify everything works

Run the test suite to confirm your setup is working end-to-end:

```bash

bash scripts/test.sh
```

This script sets the right environment variables and runs `pytest` across all test files. A successful setup produces output ending with something like:

```
===== N passed in Xs =====
```

> **Note:** Some tests may fail — that's expected! The workshop includes pre-seeded bugs for you to find and fix. What matters here is that the test runner starts and finishes without a setup error.

You can also run a single test as a quick sanity check:

```bash

PYTHONPATH=./docs_src pytest tests/test_application.py -v
```

The `PYTHONPATH=./docs_src` prefix tells Python where to find the tutorial example files that the tests import from.

---

## Setup checklist

- Git installed and working
- `uv` installed and working
- Repository cloned
- `uv sync --extra all` succeeds
- `bash scripts/test.sh` runs without setup errors

---

## Useful links

- [uv Documentation](https://docs.astral.sh/uv/)
- [Git Installation Guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [FastAPI Contributing Guide](https://fastapi.tiangolo.com/contributing/)
