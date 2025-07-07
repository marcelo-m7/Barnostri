# Agents Guide

This repository hosts the **Barnostri** monorepo. The project contains a Flutter
application and Supabase backend configuration. Follow the tasks below to keep
all modules organized.

## Agents
- `flutter-dev-agent` – maintains the Flutter code under `apps/`.
- `supabase-agent` – maintains SQL migrations, seeds and functions under `supabase/`.
- `docs-agent` – updates documentation inside `docs/`.

## Checklist
- [ ] Move Supabase SQL files into `supabase/migrations` and seeds into
  `supabase/seed`.
- [ ] Extract shared models and services to `packages/shared_models`.
- [ ] Update the Flutter app to depend on the shared package.
- [ ] Document new architecture in `docs/README.md`.
- [ ] Provide environment config in `supabase/supabase-config.json`.
- [ ] Keep this checklist updated as tasks are completed.

## Coding Guidelines
- Use **DRY** and **SOLID** principles.
- Format Dart code with `dart format .`.
- Run `flutter analyze` before committing (if Flutter is available).
- Write descriptive commit messages.
