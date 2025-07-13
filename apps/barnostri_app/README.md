# Barnostri App

Flutter client for the Barnostri project.

## Setup

1. Run `./setup_environment.sh` from the repository root to install Flutter and system dependencies. The script formats `packages/shared_models` and `apps/barnostri_app` automatically.
2. Fetch dependencies:
   ```bash
   (cd apps/barnostri_app && flutter pub get)
   (cd packages/shared_models && dart pub get)
   ```
3. Copy `supabase-config.example.json` to `supabase-config.json`.
   The example already includes the demo Supabase URL and anon key.

## Running

From `apps/barnostri_app` run one of:

```bash
flutter run -d chrome            # Web
flutter run -d android-emulator  # Android
flutter run -d ios               # iOS (macOS only)
```

## Tests

```bash
flutter test
flutter test packages/shared_models
```

Run integration tests on Chrome (requires Chrome installed) with:

```bash
flutter test integration_test -d chrome
```

For Android emulators or connected devices (a configured emulator or device must be running) execute to verify navigation and responsive layouts on Android:

```bash
flutter test integration_test -d android-emulator  # or the device id
```

On macOS you can also run on an iOS simulator or device to confirm the same behavior on iOS:

```bash
flutter test integration_test -d ios
```
