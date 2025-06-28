-- This file documents the database schema that the application expects.
-- You can run this file in your Supabase SQL editor to create the necessary tables.

-- Agents Table: Stores the configuration for each AI agent.
create table if not exists
  public.agents (
    id uuid not null default gen_random_uuid (),
    created_at timestamp with time zone not null default now(),
    name text not null,
    specialty text not null,
    prompt text not null,
    icon text not null default 'Bot'::text,
    avatar text not null,
    avatar_hint text null,
    is_active boolean not null default true,
    language text not null default 'pt-BR'::text,
    user_id uuid null,
    ficha_tecnica jsonb null,
    constraint agents_pkey primary key (id)
  ) tablespace pg_default;

-- Messages Table: Stores the conversation history for each agent.
create table if not exists
  public.messages (
    id uuid not null default gen_random_uuid (),
    created_at timestamp with time zone not null default now(),
    agent_id uuid not null,
    role text not null,
    content text not null,
    constraint messages_pkey primary key (id),
    constraint messages_agent_id_fkey foreign key (agent_id) references agents (id) on delete cascade
  ) tablespace pg_default;


-- Gmail History Table: Stores generated Gmail variations and associated info.
create table if not exists
  public.gmail_history (
    id uuid not null default gen_random_uuid (),
    created_at timestamp with time zone not null default now(),
    email text not null,
    original_email text not null,
    site_name text null,
    description text null,
    password text null,
    is_pinned boolean not null default false,
    constraint gmail_history_pkey primary key (id)
  ) tablespace pg_default;

-- Transcript History Table: Stores YouTube video transcripts.
create table if not exists
  public.transcript_history (
    id uuid not null default gen_random_uuid (),
    created_at timestamp with time zone not null default now(),
    youtube_url text not null,
    transcript text not null,
    constraint transcript_history_pkey primary key (id)
  ) tablespace pg_default;

-- Translation History Table: Stores text translations.
create table if not exists
  public.translation_history (
    id uuid not null default gen_random_uuid (),
    created_at timestamp with time zone not null default now(),
    source_text text not null,
    translated_text text not null,
    target_language text not null,
    constraint translation_history_pkey primary key (id)
  ) tablespace pg_default;

-- Important Sites Table: Stores a list of important links.
create table if not exists
  public.important_sites (
    id uuid not null default gen_random_uuid (),
    created_at timestamp with time zone not null default now(),
    name text not null,
    url text not null,
    constraint important_sites_pkey primary key (id)
  ) tablespace pg_default;

-- Enable Row Level Security (RLS) for all tables.
-- By default, this will deny all access. You need to create policies to allow access.
alter table public.agents enable row level security;
alter table public.messages enable row level security;
alter table public.gmail_history enable row level security;
alter table public.transcript_history enable row level security;
alter table public.translation_history enable row level security;
alter table public.important_sites enable row level security;

-- Example RLS Policy: Allow public read access to agents.
-- You will need to create appropriate policies for all tables based on your app's logic.
create policy "Allow public read-only access to agents"
on public.agents for select
to anon, authenticated
using (true);

-- Allow all operations for authenticated users on their own data.
-- This is just an example. You'll need policies for each table.
-- create policy "Allow individual user access"
-- on public.agents for all
-- using (auth.uid() = user_id)
-- with check (auth.uid() = user_id);

-- This command ensures that the service_role key (used in storage.ts) can bypass RLS.
-- It's a good practice to confirm this setting.
-- By default, service_role has admin privileges.
