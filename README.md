# CI/CD Secret Scanner Workflow

## Mission & Purpose

This repository serves as a foundational component of the CI/CD secure supply chain. Its primary mission is to **proactively prevent sensitive data leaks**—such as API keys, credentials, and tokens—from entering our codebases.

In modern cloud-native development, the accidental exposure of secrets is a critical vulnerability. This project mitigates that risk by implementing a "shift-left" security strategy, integrating advanced secret scanning at two critical checkpoints:

1.  **Local Development**: Checking code on the developer's machine before it is ever committed.
2.  **Continuous Integration**: Verifying every push and pull request to ensure no secrets slipped through.

## Key Features

### 🛡️ Automated Secret Detection (Trivy)

We utilize [Trivy](https://github.com/aquasecurity/trivy), a comprehensive security scanner, to detect hardcoded secrets like passwords, API keys, and tokens. Trivy is configured to scan the repository for potential leaks.

**Feature Update:** We have implemented **Aggressive Secret Scanning** rules to detect a broader range of potential secrets (high entropy strings, generic password variables, etc.), including Low, Medium, High, and Critical severities.

### 🪝 Robust Pre-commit Hooks

To maintain a high standard of code hygiene and security, this repository comes configured with a suite of **pre-commit hooks**. These hooks run automatically every time `git commit` is executed, performing the following checks:

- **Whitespace Trimming**: Removes trailing whitespace to prevent diff noise.
- **File Endings**: Ensures files end with a newline character.
- **YAML Validation**: Verifies the syntax of `yaml` files.
- **Large File Check**: Prevents the accidental commit of large binaries.

### 🤖 GitHub Actions Workflow

A dedicated CI/CD workflow (`.github/workflows/main.yml`) is set up to run Trivy on `push` and `pull_request` events. This ensures that even if a pre-commit hook is bypassed, the CI pipeline will catch and block insecure code from being merged.

## Getting Started

### Prerequisites

- [Python](https://www.python.org/downloads/) (for pre-commit)
- [Git](https://git-scm.com/)

### Installation

1.  **Install pre-commit**:

    ```bash
    pip install pre-commit
    ```

2.  **Install the git hooks**:
    Run this command in the root of the repository to set up the hooks:
    ```bash
    pre-commit install
    ```

### Usage

Once installed, the hooks will run automatically on `git commit`. You can also trigger them manually on all files:

```bash
pre-commit run --all-files
```

If Trivy detects a secret, the commit will be blocked. You must remove the secret and try committing again.

## License

Copyright © 2026 OrbitCluster. All rights reserved.

## Usage as GitHub Action

This repository can be used as a [Composite Action](https://docs.github.com/en/actions/creating-actions/creating-a-composite-action) to instantly add secret scanning to your own workflows.

### Example Workflow

Add the following step to your `.github/workflows/pipeline.yml`:

```yaml
jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0 # Important: Trivy usually scans current changes, but fetch-depth 0 is good practice

      - name: Run Secret Scanner
        uses: orbitcluster/oc-cicd-secretscanner-workflow@v1.0.0
        with:
          fetch-depth: 0 # Optional: Set fetch-depth for the internal checkout if not already checked out
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

### Inputs

| Input          | Description                                                                            | Default               |
| :------------- | :------------------------------------------------------------------------------------- | :-------------------- |
| `fetch-depth`  | Number of commits to fetch. `0` fetches all history (recommended for secret scanning). | `0`                   |
| `github-token` | GitHub Token (`${{ secrets.GITHUB_TOKEN }}`) for commenting on PRs.                    | `${{ github.token }}` |
