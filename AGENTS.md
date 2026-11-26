# Repository notes

- This is the TEI XSLT 3.0 transformation library, not a conventional app: format directories contain the core transforms, while `profiles/` supplies profile-specific overrides. Follow the relevant `build-to.xml`/`build-from.xml` wiring when tracing a transform.
- Root `make test` runs the legacy suite in `Test/` after building shared files (`build`, `common`, `names`). For a focused legacy check, run `make -C Test <target>` (for example, `test-latex`, `test-fo`, or `test-from-docx`).
- `Test/Makefile` compares generated files in `actual-results/` with checked-in `expected-results/` by default. To inspect a full run before comparisons, use `make -C Test clean && make -C Test DIFFNOW=0`, then diff the two directories; normalize/inspect output before updating expected results.
- The newer Ant suite is `make test2` at the root, or `ant test` / `ant testSeries` in `Test2/`; use `ant <target>` there for a focused format suite (such as `ant odd` or `ant docx`). `test` runs suites in parallel; `testSeries` is easier to debug.
- `make clean` is not a harmless build cleanup: it removes release/dist output and test artifacts (including `Test/actual-results`). Check for local generated or untracked work before running it.
- Prerequisites and tool checks: `make check` checks Perl, `xmllint`, and Ant (1.9+; XeTeX is optional). The legacy tests also invoke tools such as Saxon, Jing, `tidy`, and format-specific utilities; CI uses the `ghcr.io/teic/jenkins:dev` container. See `README.md` and `.github/workflows/test.yml` for the verified setup and CI commands.
