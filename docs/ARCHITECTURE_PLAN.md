# Barnostri Architecture Plan

This project uses a Flutter + Supabase monorepo. The mobile app and backend resources live together and shared code sits inside packages.

```
barnostri/
├── apps/
│   └── barnostri_app/
│       ├── lib/
│       │   └── src/
│       │       ├── core/
│       │       └── features/
│       │           └── <feature>/
│       │               ├── presentation/
│       │               ├── domain/
│       │               └── data/
│       ├── android/
│       ├── ios/
│       ├── web/
│       └── pubspec.yaml
├── packages/
│   └── shared_models/
│       ├── lib/src/models/
│       ├── lib/src/repositories/
│       └── lib/src/utils/
├── supabase/
│   ├── migrations/
│   ├── seed/
│   ├── functions/
├── apps/barnostri_app/supabase/
│   └── supabase-config.json
```

## Flutter App
- Organize each feature into `presentation`, `domain` and `data` layers.
- Use Riverpod for state management and GoRouter for navigation.
- Import models and repositories from `packages/shared_models`.

## Supabase
- All SQL migrations live under `supabase/migrations/` and are versioned with the Supabase CLI.
- Example data goes in `supabase/seed/`.
- Edge functions (if any) stay under `supabase/functions/`.
- Environment variables are stored in `apps/barnostri_app/supabase/supabase-config.json` (one per environment).

## Packages
- `packages/shared_models` exposes models and repository helpers shared by the apps.
- Both the customer and admin apps import this package to avoid duplication.

## Next Steps
1. Create the folders above if they do not exist.
2. Move current models and Supabase helpers to `packages/shared_models`.
3. Split SQL files into migrations and seed data.
4. Update the Flutter app imports to use the shared package.
5. Configure CI to run `dart format` and `flutter analyze`.

This plan provides a clean separation of concerns and makes it easier to scale the project.
