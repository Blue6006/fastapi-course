# Submitting a Pull Request

Package your fix into a clean pull request so it can be reviewed, tested, and merged.

## The development workflow

When working on a shared repository — even your own — the standard practice is to never commit directly to `main`. Instead, every change goes through a short cycle:

1. **Branch** — create an isolated branch for the change you're working on.
2. **Commit** — record your changes with a descriptive message.
3. **Push** — upload the branch to GitHub.
4. **Pull Request** — open a PR to merge your branch into `main`.

This keeps `main` always in a working state, gives you a place to review your own diff before merging, and makes it easy to discard a change if something goes wrong — just delete the branch.

A **pull request** is a proposal: "here are the changes I made, please review them and merge them into the main branch." Even when you're the only developer, PRs are useful: they trigger automated checks, give you a final review moment, and create a clean history of what changed and why.

---

## Create a feature branch

```bash

git checkout -b fix/validation-status-code
```

`-b` creates a new branch and immediately switches to it. The name follows a common convention: a short prefix (`fix/`, `feat/`, `chore/`) followed by a slug describing the change.

Confirm you're on the right branch:

```bash

git branch
```

The current branch is marked with `*`.

> You can do all of this from the IDE using the [git popup](project-hub://git) — create branches, switch between them, and push without leaving your editor.

---

## Stage and commit your changes

Git tracks changes in two steps: **staging** (choosing what to include) and **committing** (recording the snapshot permanently).

**Review what you changed:**

```bash

git diff
```

This shows every line you added or removed since the last commit. Read through it — if something looks unintentional, fix it before continuing.

**Stage only the files you meant to change:**

```bash

git add <file-you-changed>
```

Avoid `git add .` until you're sure everything in the working directory belongs in this commit. Staging selectively keeps commits focused and easy to review.

**Verify what's staged:**

```bash

git status
```

Files listed under *Changes to be committed* will go into the next commit. Files under *Changes not staged* will not.

**Write a clear commit message:**

```bash

git commit -m "Fix: return 404 when requested item does not exist"
```

### What makes a good commit message?

A commit message is permanent documentation. It should explain **what** changed and **why** — not just restate the diff.

| | Example |
|---|---|
| ✅ Good | `Fix: return 404 when requested item does not exist` |
| ✅ Good | `Fix: prevent duplicate usernames by adding unique constraint` |
| ❌ Too vague | `fixed bug` |
| ❌ Describes the diff, not the reason | `changed status code in router` |

A common format is:

```
<type>: <short summary in present tense>

<optional body explaining why the change was needed>
```

Types: `Fix`, `Feat`, `Refactor`, `Test`, `Docs`, `Chore`.

> You can also stage files, review the diff, and write your commit message from the [commit tool window](project-hub://commit-tw) in the IDE.

---

## Push to GitHub

Your commit lives only on your local machine until you push it:

```bash

git push origin fix/validation-status-code
```

- `origin` is the default name Git gives to the remote repository this project was cloned from.
- GitHub will create the branch on the remote if it doesn't exist yet.

If this is your first push for this branch, Git may ask you to set an upstream with `--set-upstream`. Run the command it prints — this links your local branch to the remote one so future `git push` and `git pull` work without arguments.

---

## Open the pull request

You can open a pull request from the IDE using the [pull request tool window](project-hub://pull-request). To do it from the GitHub web UI instead:

1. Go to your repository on GitHub.
2. GitHub usually shows a yellow banner: **"Compare & pull request"** — click it. If it's gone, switch to your branch and click **"Contribute → Open pull request"**.
3. Set the **base branch** to `main`.
4. Fill in the PR description:

```markdown
## What was broken
<Describe the symptom — what did the user see? What HTTP status code was returned vs. what they expected?>

## What I changed
<Which file, which line, what was wrong and what you fixed>

## How I verified
<Which tests you ran, what the result was>
```

A clear description means you can understand a change months later without re-reading the diff.

---

## Review CI results

After you open the PR, GitHub runs automated checks — linting, type checks, and the full test suite. You can watch them on the PR page.

Run the same checks locally first to catch problems before the CI bots do:

```bash

# Run the full test suite
uv run bash scripts/test.sh

# Run lint checks
uv run bash scripts/lint.sh
```

**If a check fails:**

1. Read the output — CI tells you exactly which file and line failed.
2. Fix the issue locally.
3. Commit and push again — the PR automatically picks up the new commit:

```bash

git add <files-you-changed>
git commit -m "Fix: <what you changed>"
git push origin fix/validation-status-code
```

---

## Pull request checklist

- Feature branch created (not working on `main`)
- Changes reviewed with `git diff` before staging
- Only relevant files staged and committed
- Commit message is descriptive (explains what and why)
- Branch pushed to GitHub
- Pull request opened against `main`
- PR description includes what was broken, what changed, how verified
- `uv run bash scripts/test.sh` passes locally
- `uv run bash scripts/lint.sh` passes locally

---

## How open-source collaboration works: forks and upstreams

When contributing to a project you *don't* own — like the real FastAPI repository — the workflow adds two extra steps, because you don't have permission to push branches directly to the original repo.

The full open-source workflow looks like this:

1. **Fork** — create your own copy of the repository on GitHub (button on the repo page).
2. **Clone** — download your fork to your local machine.
3. **Branch** — create a feature branch, same as above.
4. **Commit** — record your changes.
5. **Push** — push to *your fork* (not the original).
6. **Pull Request** — open a PR from your fork's branch into the original repo's `main`.

### Two remotes: `origin` and `upstream`

> **Note:** The commands below are for illustration only — do not run them in this project. This repository is not a fork, so there is no upstream to add.

Once you clone your fork, your local repo knows about one remote by default: `origin`, which points to your fork.

To stay up to date with changes in the original repo, you add a second remote called `upstream`:

```
git remote add upstream https://github.com/fastapi/fastapi.git
```

Fetch and merge the latest changes from the original before starting new work:

```
git fetch upstream
git merge upstream/main
```

This keeps your fork in sync and avoids merge conflicts when you open a PR.

### Opening the PR

When you push your branch and open a PR on GitHub, you'll need to set:

- **Base repository**: the original repo (e.g., `fastapi/fastapi`)
- **Base branch**: `main`
- **Head repository**: your fork (e.g., `your-username/fastapi`)
- **Compare branch**: your feature branch

Everything else — filling in the description, reviewing CI, iterating on feedback — works exactly the same as the single-repo workflow above.

---

## Useful links

- [FastAPI Contributing Guide](https://fastapi.tiangolo.com/contributing/)
- [GitHub: Creating a pull request from a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork)
- [Conventional Commits specification](https://www.conventionalcommits.org/en/v1.0.0/)
- [Git branching basics](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell)
