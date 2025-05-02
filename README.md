# ZeroLens GitHub Actions Example

This repository is a **minimal, self-contained example** demonstrating how to scan a compiled binary with [ZeroLens](https://www.netrise.io/products/zerolens) from a GitHub Actions workflow.

> **Why this repo?**  
> We frequently get asked _"What does a **good** ZeroLens workflow look like?"_. Rather than pasting snippets in chat, we built a tiny C program, wired up a build step, and added the official `netriseinc/zerolens-action` so you can copy-paste and go.

---

## What the workflows do

| Workflow                                | Trigger                                                 | Purpose                                                                                                                                     |
| --------------------------------------- | ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `.github/workflows/zls-scan.yml`        | Any push that touches `src/main.c` (or manual dispatch) | Builds `src/main.c`, scans the resulting binary, gates on policy, and uploads a human-readable report **and** SARIF artifacts for download. |
| `.github/workflows/sarif-code-scan.yml` | Pushes to branches prefixed with `EX05*`                | Same as above **but** also uploads the SARIF file to the GitHub Security tab so violations show up in the _Code Scanning_ UI.               |

Both workflows follow the same 3-step pattern:

1. **Build** – compile your firmware / application.
2. **Scan** – call ZeroLens.
3. **Publish** – echo policy output, upload artifacts, or update the Security tab.

Feel free to copy whichever flavour fits your project best.

---

## Quick start for your own repository

1. **Add the secret**  
   Create a repository secret named `ZEROLENS_TOKEN` that contains your ZeroLens API token.
   This is found in the github UI under Settings -> Secrets and Variables -> Actions -> New repository secret.

2. **Copy the workflow**  
   Copy either of the provided workflow YAML files into your project under `.github/workflows/` and tweak:

   ```yaml
   with:
     token: ${{ secrets.ZEROLENS_TOKEN }} # required – your API token
     binary: build/app.bin # required – the file to scan
     sarif_path: out/app.sarif # optional – save SARIF output
     warn_on_cwe: CWE-134 # optional – downgrade specific CWEs to warnings.  does not break the build.
     fail_on_cwe: CWE-121,CWE-122 # optional – fail the build if these CWEs are found.
     max_findings: 10 # optional – fail if more than N findings
     ai_analysis: true # optional – enable AI-generated remediation advice.  must be enabled in your zerolens account.
     wait: true # optional – block until the scan finishes (recommended)
     comment_pr: true # optional – comment on pull requests with a summary
     github_token: ${{ github.token }} # optional – auto-filled by Actions for PR comments
   ```

3. **Adjust your build step**  
   Replace the `make` command (or the C example entirely) with whatever you need to produce the binary you want scanned.

4. **Push**  
   Push a commit and watch your first scan appear in the Actions tab 🎉.

---

## Frequently asked questions

<details>
<summary>Can I scan multiple files in one job?</summary>
Yes – loop over the `zerolens-action` step or run multiple jobs. For most projects scanning the main artifact is sufficient, but you can scan as many as you like.
</details>

<details>
<summary>How long does a scan take?</summary>
It depends on binary size; most embedded images finish in a few minutes. Using `wait: true` simplifies your pipeline by blocking until the job is done.
</details>

<details>
<summary>Do I need SARIF?</summary>
Optional but recommended. Enabling it unlocks GitHub's *Code Scanning* UI and integrates findings into pull-requests.
</details>

<details>
<summary>Why do you disable <code>_FORTIFY_SOURCE</code> in the demo Makefile?</summary>
Purely to keep the example trivial and reproducible. Your production build should keep all the hardening flags you normally use.
</details>

---

## Repository layout

```
├── src/main.c                # 5-line C program with a few deliberate flaws
├── Makefile                  # compiles main.c to build/app.bin
├── .github
│   └── workflows
│       ├── zls-scan.yml      # generic scan workflow
│       └── sarif-code-scan.yml # scan + upload to GitHub Security tab
└── README.md                 # you are here
```

---

Made with ❤️ by the **NetRise** team. Stay secure!
