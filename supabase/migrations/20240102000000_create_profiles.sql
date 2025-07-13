-- Create profiles table
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text,
  phone text,
  user_type text check (user_type in ('cliente', 'lojista')),
  store_name text,
  created_at timestamp default now()
);

-- Enable Row Level Security (RLS)
alter table profiles enable row level security;

-- Allow users to view their own profile
create policy "Users can view their profile" on profiles
  for select using (auth.uid() = id);

-- Allow users to update their own profile
create policy "Users can update their profile" on profiles
  for update using (auth.uid() = id) with check (auth.uid() = id);

