<div class="m-4">
  <h1 class="default-header my-4">System Architecture</h1>

  <p class="my-2">
    OpenFPL is a progressive web application, built with Svelte and Motoko. The
    Github is publicly available <a
      class="underline"
      href="github.com/jamesbeadle/openfpl">here</a
    >. OpenFPL's architecture is designed for scalability and efficiency,
    ensuring robust performance even as user numbers grow. Here's how the system
    is structured:
  </p>

  <h2 class="default-sub-header mt-4">Main Backend Canister</h2>
  <p class="my-2">
    OpenFPL' Main Backend Canister stores indexes for a manager's principal and
    canister Id for efficient data retrieval. The Main Backend Canister also
    stores a dictionary of each users principal and username for efficient
    existing username checks.
  </p>
  <p class="my-2">
    The Main Backend canister also stores a list of each unique manager canister
    to enable efficient grouped lookups. Even with 10m users the Main Backend
    Canister only uses 2GB of its available storage, however it is likely that
    the players and user indexes are refactored into their own canisters after
    the SNS sale but before the season starts.
  </p>

  <h2 class="default-sub-header mt-4">Manager Data</h2>
  <p class="my-2">
    A snapshot of a fantasy team is around 147 bytes. So if a manager's players
    for 100 seasons that is a total history of 546 KB (100 x 38 x 147 bytes).
    With the manager's current team, including a 100KB profile picture a manager
    object could take around 646KB of space.
  </p>
  <p class="my-2">
    This means a 96GB canister could theoretically hold around 155,826 managers.
    We divide the canister into 12 partitions and limit the number of managers
    in each partition to 1,000. This gives plenty of storage and calculation
    overhead for future features.
  </p>
  <h2 class="default-sub-header mt-4">Leaderboard Data</h2>
  <p class="my-2">
    A leaderboard canister holds an array of leaderboard entries, with each
    entry taking up roughly 121 bytes of space. This means the leaderboard
    canister can hold over 35m entries within its 4GB heap memory, more than 3
    times the players of the market leading game.
  </p>
</div>
