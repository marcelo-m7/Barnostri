# Supabase Functions

Este diretório contém funções Edge utilizadas pelo projeto.

## create_user_profile

Função para criar usuário autenticado e registro correspondente na tabela `profiles` de forma atômica.

### Deploy local

Execute `supabase functions deploy create_user_profile` para publicar a função. Certifique-se de definir as variáveis `SUPABASE_URL` e `SUPABASE_SERVICE_ROLE_KEY` nas configurações do projeto no painel do Supabase.

### Teste

É possível testar localmente com:

```bash
supabase functions serve create_user_profile --no-verify-jwt
```

Em outro terminal, envie uma requisição:

```bash
curl -X POST http://localhost:54321/functions/v1/create_user_profile \
  -d '{"email":"test@example.com","password":"123456","name":"Test","user_type":"cliente"}'
```
