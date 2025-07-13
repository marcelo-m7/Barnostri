create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text,
  phone text,
  user_type text check (user_type in ('cliente', 'lojista')),
  store_name text,
  created_at timestamp default now()
);

alter table profiles enable row level security;

create policy "Users can access their profile" on profiles
  for all
  using (auth.uid() = id)
  with check (auth.uid() = id);
