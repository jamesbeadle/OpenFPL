-- Pin search_path on the trigger function (security advisor 0011).
create or replace function public.set_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = public
as $$
begin
	new.updated_at = now();
	return new;
end;
$$;

-- is_admin() is only meant to be called from RLS policies, not via REST RPC
-- (security advisors 0028, 0029).
revoke execute on function public.is_admin() from anon, authenticated, public;
grant execute on function public.is_admin() to postgres, service_role;
