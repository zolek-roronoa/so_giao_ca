-- Sổ Giao Ca: chạy toàn bộ file này một lần trong Supabase > SQL Editor
create table if not exists public.docs(
  coll text not null, id text not null, data jsonb not null default '{}'::jsonb,
  primary key(coll,id));
alter table public.docs enable row level security;
alter table public.docs replica identity full;

create or replace function public.is_member() returns boolean
language sql security definer set search_path=public stable as $$
  select exists(select 1 from docs where coll='members' and id=auth.uid()::text) $$;

create or replace function public.no_members() returns boolean
language sql security definer set search_path=public stable as $$
  select not exists(select 1 from docs where coll='members') $$;

create or replace function public.can_manage() returns boolean
language sql security definer set search_path=public stable as $$
  select exists(
    select 1 from docs m
    where m.coll='members' and m.id=auth.uid()::text
      and (m.data->>'role'='admin' or exists(
        select 1 from docs r
        where r.coll='roles' and r.id=m.data->>'role'
          and (coalesce((r.data->'perms'->>'users')::boolean,false)
            or coalesce((r.data->'perms'->>'roles')::boolean,false))))) $$;

drop policy if exists docs_select on public.docs;
create policy docs_select on public.docs for select to authenticated
  using (coll in ('members','roles','requests') or public.is_member());

drop policy if exists docs_items on public.docs;
create policy docs_items on public.docs for all to authenticated
  using (coll='items' and public.is_member())
  with check (coll='items' and public.is_member());

drop policy if exists docs_manage on public.docs;
create policy docs_manage on public.docs for all to authenticated
  using (coll in ('members','roles') and public.can_manage())
  with check (coll in ('members','roles') and public.can_manage());

-- Người đăng ký đầu tiên tự thành Admin
drop policy if exists docs_bootstrap on public.docs;
create policy docs_bootstrap on public.docs for insert to authenticated
  with check (coll='members' and id=auth.uid()::text and public.no_members());

drop policy if exists docs_req_own on public.docs;
create policy docs_req_own on public.docs for all to authenticated
  using (coll='requests' and id=auth.uid()::text)
  with check (coll='requests' and id=auth.uid()::text);

drop policy if exists docs_req_mgr on public.docs;
create policy docs_req_mgr on public.docs for delete to authenticated
  using (coll='requests' and public.can_manage());

alter publication supabase_realtime add table public.docs;
