# OpenFPL

A free, open fantasy Premier League game. Pick an 11-player squad within a £100M budget, score on real-world player performance, and climb weekly, monthly, and season leaderboards — solo or in private leagues with friends.

OpenFPL is a pure consumer of [FootballGod](https://github.com/jamesbeadle/FootballGod) data. It does not scrape, store, or judge football facts itself — it reacts to canonical data via the FootballGod API and webhooks.

## Stack

- **Frontend**: SvelteKit + Tailwind CSS
- **Backend**: Supabase (Postgres + Auth + Edge Functions + Cron)
- **Hosting**: Vercel
- **Auth**: Google login (managers); admin allowlist (admins)
- **Data source**: FootballGod API + webhooks (fixtures, events, players, clubs)

## Core ideas

- **Idempotent, self-healing scoring.** OpenFPL reacts to FootballGod webhooks but also reconciles on a schedule. A dropped webhook never leaves a manager with a wrong score.
- **Snapshot-based scoring.** Teams are locked at each gameweek deadline. Scoring always works from the snapshot, never from the current live team.
- **Public live scores.** Provisional scores during live fixtures are visible to anyone, logged in or not.
- **Free, no real money.** No prizes, no entry fees, no gambling, no NFTs.

## Repository layout (planned)

```
.
├── docs/
│   └── SCOPE.md          # Full product scope, epics, user stories
├── apps/
│   └── web/              # SvelteKit frontend (TBD)
├── supabase/
│   ├── migrations/       # Database schema migrations
│   └── functions/        # Edge functions (webhook handlers, scoring, cron)
└── README.md
```

Folder structure will fill in as implementation begins.

## Status

Pre-implementation. Scope is locked — see [`docs/SCOPE.md`](docs/SCOPE.md) for the full specification: domain model, scoring rules, the 10 bonuses, all 34 user stories across 8 epics, and dependencies on FootballGod.

## Roles

- **Visitor** — anyone browsing the public site without logging in
- **Manager** — a logged-in user with a fantasy team
- **League Admin** — a Manager who has created a private league
- **Admin** — the operator, managing the system via the admin panel
- **System** — the automated scoring and leaderboard engine reacting to FootballGod events

## Dependencies

OpenFPL cannot function without FootballGod. Required FootballGod capabilities:

- FG-011 — fixtures by gameweek
- FG-012 — events by fixture
- FG-013 — player roster
- FG-014 — clubs
- FG-015 / FG-016 — fixture-finalised webhook
- FG-008 — disallowed-event handling (via webhook)

## License

See [`LICENSE`](LICENSE).
