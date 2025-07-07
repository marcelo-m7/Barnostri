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

