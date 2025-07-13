import { serve } from 'https://deno.land/std/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js'

serve(async (req) => {
  const { email, password, name, user_type, store_name, phone } = await req.json()

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  const { data: user, error } = await supabase.auth.admin.createUser({
    email,
    password,
    email_confirm: true
  })

  if (error) return new Response(JSON.stringify({ error }), { status: 400 })

  await supabase.from('profiles').insert({
    id: user.user.id,
    name,
    user_type,
    store_name,
    phone
  })

  return new Response(JSON.stringify({ user }), { status: 200 })
})
