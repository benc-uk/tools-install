# Agent guide

## Purpose and scope

This is a minimal, opinionated collection of one-shot Bash installers, not a package manager. Users clone the repository and run individual scripts. Prefer official binary downloads; use explicit apt setup when system integration is necessary.

- Keep tool-specific choices visible in each script. Reuse [_lib.sh](./_lib.sh) for genuinely shared behaviour, not a new launcher, manifest or plugin framework.
- Follow the user-facing contract and documented exceptions in [README.md](./README.md). Preserve version/channel defaults and SDK layouts unless the requested change includes them.
- Check the worktree before editing. Preserve existing edits and deletions; do not restore removed tools or recreate templates.
- Keep catalogue changes deliberate. A renamed upstream project, different vendor or different release channel is not an automatic fallback.
- [_backup.sh](./_backup.sh) is a personal helper, not an installer or validation command. Do not run it to save changes.

## Creating or updating an installer

Use an existing script with the same installation shape as a reference:

| Shape | Reference |
|---|---|
| Raw executable with architecture-specific naming | [bicep.sh](./bicep.sh) |
| Archive containing a binary | [helm.sh](./helm.sh) |
| Versioned, nested archive layout | [gh.sh](./gh.sh) |
| Major channel versus exact release | [azcopy.sh](./azcopy.sh) |
| System package repository | [node.sh](./node.sh) |

1. Verify the official upstream repository, release tags, asset names, archive members, executable name and version command. Check x86_64 and ARM64 separately; do not infer availability by substituting text in a URL. Check runtime dependencies too.
2. Use `#!/bin/bash`, `set -euo pipefail`, and the adjacent library-loading pattern from the reference scripts. Scripts must work from outside the checkout and with spaces in paths. New installers must be executable.
3. Set `NAME` and `CMD` after sourcing the library. Use `VERSION_USAGE`, `INSTALL_NOTES` and `DEFAULT_INSTALL_DIR` only when needed.
4. Call `init_binary DEFAULT "$@"` for `[version] [install-dir]`, or `init_system DEFAULT "$@"` for a version-only system/managed install. An empty system default means no positional arguments. Run initialization before network access or other side effects so help and invalid arguments are safe.
5. Validate tool-specific arguments and prerequisites before `pre_run`. Use `require_commands`; do not silently install missing helper dependencies. Distinguish exact versions from major/channel selectors and reject arguments the installer cannot honour.
6. Resolve releases with the existing helpers. `github_version` returns a version with the declared prefix removed; its default prefix is `v`, and an empty prefix means an unprefixed tag. Keep the download tag and filename consistent. Use checked JSON parsing, not grep/sed over API JSON.
7. Use `ARCH` (`amd64` or `arm64`) and `asset_arch` for explicit upstream naming. Missing builds must fail clearly, never select another architecture or silently change versions.
8. Call `pre_run` to create `WORK_DIR`, then `download`, `unpack` where needed, and `install_binary` for the expected file. Use the existing system helpers (`as_root`, `add_apt_repo`, `microsoft_repo`, `apt_install`) for package installs.
9. Finish with `post_run` and the correct local-only version arguments. It checks the installed executable, not an arbitrary PATH match; set `INSTALLED_CMD` for system/package-specific paths. Do not require a cluster, daemon, login or account just to verify a CLI.

For maintenance assessments, inspect release dates, default-branch commits, development branches and maintainer responses. Repository `updated_at` or `pushed_at` alone does not establish active maintenance.

## Safety and behavioural boundaries

- Never download the shared library at runtime or pipe downloaded setup scripts into a shell. Keep necessary official bootstrap exceptions explicit and documented.
- Use the HTTPS download helpers and private staging. Do not write downloads directly over installed executables, extract into the final directory, use fixed temporary filenames or delete shared temporary-file globs.
- Preserve cleanup on failure and interruption. If a script needs extra traps, retain the shared cleanup behaviour.
- Standalone binary replacement is staged on the destination filesystem. Do not claim transactional rollback for multi-file installs, package operations or failed post-install version checks.
- Ordinary user-directory installs must not escalate privileges. Do not edit shell profiles, change login shells or grant group membership automatically; print setup instructions instead.
- Surface failures with useful errors and non-zero exits. Do not swallow HTTP, JSON, extraction or verification errors with success-shaped fallbacks.
- Binary checksum/signature verification is currently deferred. Do not claim HTTPS, a version probe or successful extraction provides authenticity verification.

## Tests and catalogue changes

- Add or update offline cases in [tests/run.sh](./tests/run.sh) alongside installer changes. The fixture controls are in [tests/fixtures/curl](./tests/fixtures/curl); external commands are denied unless deliberately mocked.
- Cover default and pinned versions, tag prefixes, both architecture mappings or explicit unsupported errors, archive members, installed executable paths and version arguments. Include failure/cleanup cases when changing shared helpers.
- Help must stay network-free and side-effect-free. Failed download/extraction must preserve an existing binary, and no test may modify the user's actual home or system installation.
- Shared helpers affect every installer: run the complete check command after changing them.
- When adding/removing a script, update its README exceptions, index and explicit test cases. Generate index entries with `bash _list.sh`; the tests compare the README index with this output. Avoid a second tool catalogue.
- Keep this guide current when helper contracts or validation workflows change.

## Validation

From the repository root:

```bash
bash tests/check.sh
git diff --check
```

The check script runs Bash syntax validation, ShellCheck and offline regression tests. Dependencies and the container alternative are documented in [README.md](./README.md#maintaining-the-scripts).

If dependencies are missing, prefer the existing disposable test environment:

```bash
podman build -t localhost/tools-install-test -f tests/Containerfile .
podman run --rm --network none localhost/tools-install-test
```

Docker may be used instead. Rebuild after edits so the image contains the current checkout. Clean up only test resources created for the task; never prune shared containers, images or volumes.

CI is defined in [.github/workflows/check.yml](./.github/workflows/check.yml). Live download/install checks belong in disposable containers or VMs, not on the development host. Report exactly what was tested: fixture-based ARM64 selection is not live ARM64 execution, and a version probe does not prove a hosted service works.
