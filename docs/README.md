# Barnostri Monorepo

Este repositório contém o aplicativo Flutter e todos os recursos do Supabase em um único monorepo.

```
apps/
  barnostri_app/
    lib/
      src/
        core/
        features/
    pubspec.yaml
packages/
  shared_models/
    lib/src/models/
    lib/src/services/
supabase/
  migrations/
  seed/
  functions/
  supabase-config.json
```
### Diretórios

- **apps/barnostri_app**: código Flutter organizado por features.
- **packages/shared_models**: modelos e utilidades compartilhadas.
- **supabase/**: scripts SQL e configurações do banco.

=======

Consulte `docs/ARCHITECTURE_PLAN.md` para o plano detalhado de arquitetura e as tarefas em `docs/tasks/` para acompanhar o progresso.
