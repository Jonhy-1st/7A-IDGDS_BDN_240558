# Repository Guidelines

## Project Structure & Module Organization

This repository contains database coursework organized by practice. `Practica 02/` and `Practica 03/` each hold `scripts/` for database changes, `queries/` for verification, and `backups/` for SQL exports. Practice 03 also includes `seeds/` (CSV/XLSX import data) and `reportes/` (Markdown reports and a CSV mapping). The root `readme.md` tracks the course practices. There is no separate application source tree.

## Build, Test, and Development Commands

There is no build system or automated test suite. Work with the SQL files using MySQL 8.x-compatible tooling. Review a script before execution, select the intended database explicitly, and run verification queries afterward. For example, import a backup into a disposable local database with `mysql -u <user> -p <database> < "Practica 03/backups/Respaldo_inicio_P03.sql"`. Do not use production credentials or apply destructive scripts to a live database.

## Coding Style & Naming Conventions

Keep SQL readable and consistent with neighboring files: uppercase SQL keywords, one statement per line where practical, and comments that explain purpose, target database, and execution assumptions. Use descriptive `snake_case` filenames that identify the action or query, such as `consultas_verificacion_db_user.sql`. Keep practice-specific work inside its corresponding directory. Preserve seed column order and encoding when editing import files.

## Testing Guidelines

Validate database changes manually in a disposable MySQL instance. Run the related files under `queries/` after applying a script and inspect affected rows, privileges, or triggers as appropriate. For data transformations, compare row counts and sample values before and after. No test naming or coverage requirement is configured.

## Commit & Pull Request Guidelines

Recent history uses short, practice-focused commit subjects, commonly `BDN` or `Practica 03 - BDN`. Continue with concise subjects that identify the practice and change. A pull request should describe the database effect, list scripts and data files changed, note any required execution order or assumptions, and include verification results. Avoid attaching exports that contain real credentials or unreviewed personal data.

## Security & Configuration

SQL exports and scripts may contain account details, privilege changes, or operational data. Never add real passwords, tokens, or host credentials; replace them with safe placeholders in examples. Treat backups and seed files as potentially sensitive, and review their contents before sharing or committing updates.
