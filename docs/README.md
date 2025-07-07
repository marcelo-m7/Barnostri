# Barnostri Monorepo

Este repositório segue uma estrutura de **monorepo**. O app Flutter encontra-se em `apps/barnostri_app` e os recursos de backend Supabase em `supabase/`.

```
barnostri/
├── apps/
│   └── barnostri_app/
│       ├── lib/
│       ├── android/ios/web/
│       └── pubspec.yaml
├── supabase/
│   ├── migrations/
│   ├── seed/
│   ├── functions/
│   └── supabase-config.json
└── packages/
    └── shared_models/
        └── lib/
```

Os modelos de dados e serviços reutilizáveis ficam em `packages/shared_models`.
Scripts SQL e dados de seed residem em `supabase/`.
