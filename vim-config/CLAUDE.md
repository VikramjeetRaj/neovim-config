# Working rules for this repo

- Keep configuration modular: core modules belong in `config/`; shared autoload helpers in `autoload/`.
- Update the relevant README sections and add a dated Changelog entry for every change.
- Preserve the source Neovim shortcuts unless a Vim limitation makes it impossible; document differences.
- Run `sh scripts/validate.sh` after changes. Never download tools implicitly on startup.
