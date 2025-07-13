# Supabase Functions

Esta pasta contém as edge functions utilizadas no projeto.

## Implantação da função `create_user_profile`

1. Instale o [Supabase CLI](https://supabase.com/docs/guides/cli).
2. Faça login e vincule seu projeto:
   ```bash
   supabase login
   supabase link --project-ref <PROJECT_ID>
   ```
3. Para publicar a função execute:
   ```bash
   supabase functions deploy create_user_profile
   ```
4. Para testar localmente utilize:
   ```bash
   supabase functions serve create_user_profile
   ```

A função requer as variáveis `SUPABASE_URL` e `SUPABASE_SERVICE_ROLE_KEY` no ambiente de execução.
