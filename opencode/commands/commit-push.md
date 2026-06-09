---
description: Analyze changes, generate conventional commit message, stage, commit, and push
agent: Build
---

## Commit and Push Workflow

Analyze the current git changes, generate a meaningful commit message following conventional commits, then stage, commit, and push all changes.

### Step 1: Analyze Changes

Run these commands to understand what has changed:

```bash
git status
git diff --stat
git diff --cached --stat
```

Review both staged and unstaged changes to understand the full scope of modifications.

### Step 2: Generate Commit Message

Based on the analysis, generate a conventional commit message following this format:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Code style changes (formatting, missing semi-colons, etc)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvement
- `test`: Adding or correcting tests
- `build`: Changes to build system or external dependencies
- `ci`: Changes to CI configuration files and scripts
- `chore`: Other changes that don't modify src or test files
- `revert`: Reverts a previous commit

**Rules:**
- Use lowercase for the type and scope
- Keep the subject line under 72 characters
- Use imperative mood in the description ("add feature" not "added feature")
- Reference issue numbers in the footer when applicable

### Step 3: Stage All Changes

```bash
git add .
```

### Step 4: Commit with Generated Message

```bash
git commit -m "<type>(<scope>): <description>" -m "<optional body>"
```

### Step 5: Push to Current Branch

```bash
git push
```

### Step 6: Report Results

Provide a summary of what was done:
- Files changed
- Commit hash
- Branch pushed to
- Any warnings or issues encountered

## Example Output

```
✅ Changes committed and pushed successfully

Commit: abc1234 - feat(auth): add JWT token refresh logic
Branch: main
Files changed: 3
  - src/auth/token.ts (modified)
  - src/auth/types.ts (modified)
  - tests/auth.test.ts (modified)
```
