# OpenFPL

A free, open fantasy Premier League game. Pick an 11-player squad within a £100M budget, score on real-world player performance, and climb weekly, monthly, and season leaderboards — solo or in private leagues with friends.

OpenFPL is a pure consumer of [FootballGod](https://github.com/jamesbeadle/FootballGod) data. It does not scrape, store, or judge football facts itself — it reacts to canonical data via the FootballGod API and webhooks.

## Stack

- **Frontend**: SvelteKit 2 + Svelte 5 + Tailwind CSS 4
- **Backend**: Supabase (Postgres + Auth + Edge Functions + Cron)
- **Hosting**: Vercel
- **Auth**: Google login (managers); admin allowlist (admins)
- **Data source**: FootballGod API + webhooks (fixtures, events, players, clubs)

## Core ideas

- **Idempotent, self-healing scoring.** OpenFPL reacts to FootballGod webhooks but also reconciles on a schedule. A dropped webhook never leaves a manager with a wrong score.
- **Snapshot-based scoring.** Teams are locked at each gameweek deadline. Scoring always works from the snapshot, never from the current live team.
- **Public live scores.** Provisional scores during live fixtures are visible to anyone, logged in or not.
- **Free, no real money.** No prizes, no entry fees, no gambling, no NFTs.

## Repository layout

```
.
├── docs/
│   └── SCOPE.md              # Full product scope, epics, user stories
├── src/
│   ├── app.html, app.css, app.d.ts
│   ├── hooks.server.ts       # Supabase SSR + auth guard
│   ├── lib/
│   │   ├── supabase.ts       # Browser Supabase client
│   │   └── types/database.ts # Generated types (pnpm db:types)
│   └── routes/               # SvelteKit routes
├── supabase/
│   ├── config.toml           # Supabase CLI config
│   ├── migrations/           # Versioned DB migrations
│   └── functions/            # Edge functions (added later)
├── static/                   # Static assets
├── .env.example
├── package.json
├── svelte.config.js
├── tsconfig.json
└── vite.config.ts
```

## Status

Foundation scaffold in place. See [`docs/SCOPE.md`](docs/SCOPE.md) for the full specification: domain model, scoring rules, the 10 bonuses, all 34 user stories across 8 epics, and dependencies on FootballGod.

## Getting started

### Prerequisites

- Node.js 22+ (use `nvm use` if you have nvm)
- [pnpm](https://pnpm.io/installation) 9+
- [Supabase CLI](https://supabase.com/docs/guides/cli) (for local DB + types generation)

### Setup

```bash
# 1. Install dependencies
pnpm install

# 2. Copy env and fill in your Supabase project keys
cp .env.example .env.local

# 3. (Optional) Start local Supabase stack
supabase start

# 4. Apply migrations to local (or push to hosted with `supabase db push`)
supabase db reset

# 5. Generate TypeScript types from the schema
pnpm db:types

# 6. Run the dev server
pnpm dev
```

App runs at <http://localhost:5173>.

### Hosted Supabase project

This repo ships a `supabase/` folder that works with both local and hosted Supabase.

```bash
# Link to your hosted project (one-time)
supabase link --project-ref YOUR-PROJECT-REF

# Push migrations to hosted
supabase db push

# Generate types from hosted
supabase gen types typescript --project-id YOUR-PROJECT-REF > src/lib/types/database.ts
```

## Scripts

| Script | What it does |
|---|---|
| `pnpm dev` | Run the dev server (Vite + SvelteKit) |
| `pnpm build` | Production build |
| `pnpm preview` | Preview the production build locally |
| `pnpm check` | Type-check the project |
| `pnpm lint` | Prettier + ESLint check |
| `pnpm format` | Auto-format with Prettier |
| `pnpm db:types` | Regenerate `src/lib/types/database.ts` from local Supabase |

## Roles

- **Visitor** — anyone browsing the public site without logging in
- **Manager** — a logged-in user with a fantasy team
- **League Admin** — a Manager who has created a private league
- **Admin** — the operator, managing the system via the admin panel
- **System** — the automated scoring and leaderboard engine reacting to FootballGod events

## Dependencies on FootballGod

OpenFPL cannot function without FootballGod. Required FootballGod capabilities:

- FG-011 — fixtures by gameweek
- FG-012 — events by fixture
- FG-013 — player roster
- FG-014 — clubs
- FG-015 / FG-016 — fixture-finalised webhook
- FG-008 — disallowed-event handling (via webhook)

## License

See [`LICENSE`](LICENSE).
