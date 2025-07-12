# Barnostri Architecture Plan

This project uses a Flutter + Supabase monorepo. The mobile app and backend resources live together and shared code sits inside packages.

**Supported platforms**: the Barnostri app is built with Flutter and runs from a
single codebase on **Android**, **iOS** and the **Web**. The commands below
illustrate how to launch each target.

```bash
cd apps/barnostri_app
flutter run -d chrome            # Web
flutter run -d android-emulator  # Android
flutter run -d ios               # iOS (requires macOS)
```

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
│   ├── supabase-config.example.json
│   └── supabase-config.json (ignored)
```

## Flutter App
- Organize each feature into `presentation`, `domain` and `data` layers.
- Use Riverpod for state management and GoRouter for navigation.
- Import models and repositories from `packages/shared_models`.

## Supabase
- All SQL migrations live under `supabase/migrations/` and are versioned with the Supabase CLI.
- Example data goes in `supabase/seed/`.
- Edge functions (if any) stay under `supabase/functions/`.
- Environment variables are stored in `apps/barnostri_app/supabase/supabase-config.json` (one per environment). Copy them from `supabase-config.example.json` and keep the file untracked.

## Packages
- `packages/shared_models` exposes models and repository helpers shared by the apps.
- Both the customer and admin apps import this package to avoid duplication.
