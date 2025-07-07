# Barnostri Monorepo

Este repositório segue uma estrutura de **monorepo**. O app Flutter encontra-se em `apps/barnostri_app` e os recursos de backend Supabase em `supabase/`.

```
apps/
  barnostri_app/
    lib/
      core/
      modulos/
      widgets/
    pubspec.yaml
packages/
  shared_models/
supabase/
  sql/
```

### Diretórios

- **apps/barnostri_app**: código Flutter organizado por features.
- **packages/shared_models**: modelos e utilidades compartilhadas.
- **supabase/**: scripts SQL e configurações do banco.
