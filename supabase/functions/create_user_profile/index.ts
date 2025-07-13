import { serve } from "https://deno.land/std@0.192.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
  try {
    const { email, password, ...profile } = await req.json();
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false,
        },
      }
    );

    const { data: userData, error: signUpError } =
      await supabase.auth.admin.createUser({ email, password, email_confirm: true });

    if (signUpError || !userData?.user) {
      return new Response(
        JSON.stringify({ error: signUpError?.message ?? "User not created" }),
        { status: 400 }
      );
    }

    const { error: profileError } = await supabase
      .from("profiles")
      .insert({ id: userData.user.id, ...profile });

    if (profileError) {
      await supabase.auth.admin.deleteUser(userData.user.id);
      return new Response(JSON.stringify({ error: profileError.message }), {
        status: 400,
      });
    }

    return new Response(
      JSON.stringify({ id: userData.user.id }),
      { headers: { "Content-Type": "application/json" } }
    );
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), { status: 500 });
  }
});
