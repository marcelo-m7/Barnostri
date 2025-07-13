# Supabase Functions

This directory contains Edge Functions used by Barnostri.

## Deploying

1. Install the [Supabase CLI](https://supabase.com/docs/guides/cli).
2. Authenticate with `supabase login` and set your project ref using `supabase link --project-ref <ref>`.
3. Deploy the `create_user_profile` function:
   ```bash
   supabase functions deploy create_user_profile
   ```
   The command must be run from the repository root or inside `supabase/`.

The function will be available at `https://<project>.functions.supabase.co/create_user_profile` once deployed.
