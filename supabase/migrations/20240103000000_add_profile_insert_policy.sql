create policy "Users can create their profile" on profiles
  for insert with check (auth.uid() = id);
