# Instructions for Barnostri Agents

This repository is organized as a monorepo. Use the following guidelines when contributing.

## Coding Guidelines
- Follow DRY and SOLID principles.
- Keep Flutter code formatted with `dart format`.
- Prefer Riverpod for new state management code.
- Organize features under `apps/barnostri_app/lib/src` using the pattern described in `docs/README.md`.
- Shared data models live in `packages/shared_models`.

## Tasks
See the `tasks/` directory for task specific instructions. Each agent should tick items in the corresponding checklist.
=======
# Repo Guidelines

All contributors must follow these rules:

- Use **DRY** and **SOLID** principles.
- Keep the monorepo organized as documented in `docs/ARCHITECTURE_PLAN.md`.
- Always run `dart format .` and `flutter analyze` before committing.
- Document progress by updating the checklists in `docs/tasks/`.
- If tests are added in the future, run them before each commit.

## Agents

### RepoManager
- Manage folder structure and configuration files.
- Maintain `packages/shared_models` and Supabase directories.
- Ensure CI scripts and tooling stay up to date.

### AppDeveloper
- Implement and refactor Flutter features as described in the architecture plan.
- Use the shared package for models and services.
- Follow Riverpod for state management and GoRouter for navigation.

### SupabaseDev
- Maintain SQL migrations and seed data.
- Configure `supabase/supabase-config.json` per environment.
- Keep RLS policies and functions under version control.

