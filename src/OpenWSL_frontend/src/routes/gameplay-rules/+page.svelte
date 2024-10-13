<script lang="ts">
  import Layout from "../Layout.svelte";
</script>

<Layout>
  <div class="bg-panel rounded-md p-4 mt-4">
    <h1 class="default-header">OpenWSL Gameplay Rules</h1>
    <div>
      <p class="my-2">
        Please see the below OpenWSL fantasy football gameplay rules.
      </p>

      <p class="my-2">
        Each user begins with £300m to purchase players for their team. The
        value of a player can go up or down depending on how the player is rated
        in the DAO. Provided a certain voting threshold is reached for either a
        £0.25m increase or decrease, the player's value will change in that
        gameweek. A players value can only change when the season is active 
        (the first game has kicked off and the final game has not finished).
      </p>

      <p class="my-2">
        Each team has 11 players, with no more than 2 selected from any single
        team. The team must be in a valid formation, with 1 goalkeeper, 3-5
        defenders, 3-5 midfielders and 1-3 strikers.
      </p>

      <p class="my-2">
        Users will setup their team before the gameweek deadline each week. When
        playing OpenWSL, users have the chance to win FPL tokens depending on
        how well the players in their team perform.
      </p>

      <p class="my-2">In January, a user can change their entire team once.</p>

      <p class="my-2">
        A user is allowed to make 3 transfers per week which are never carried
        over.
      </p>

      <p class="my-2">
        Each week a user can select a star player. This player will receive
        double points for the gameweek. If one is not set by the start of the
        gameweek it will automatically be set to the most valuable player in
        your team.
      </p>

      <h2 class="default-sub-header">Points</h2>
      <p class="my-2">
        The user can get the following points during a gameweek for their team:
      </p>

      <table class="w-full border-collapse striped mb-8 mt-4">
        <tr>
          <th class="text-left px-4 py-2">For</th>
          <th class="text-left">Points</th>
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Appearing in the game.</td>
          <td>5</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Every 3 saves a goalkeeper makes.</td>
          <td>5</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Goalkeeper or defender cleansheet.</td
          >
          <td>10</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Forward scores a goal.</td>
          <td>10</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2"
            >Midfielder or Forward assists a goal.</td
          >
          <td>10</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Midfielder scores a goal.</td>
          <td>15</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2"
            >Goalkeeper or defender assists a goal.</td
          >
          <td>15</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2"
            >Goalkeeper or defender scores a goal.</td
          >
          <td>20</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Goalkeeper saves a penalty.</td>
          <td>20</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2"
            >Player is highest scoring player in match.</td
          >
          <td>25</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Player receives a red card.</td>
          <td>-20</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Player misses a penalty.</td>
          <td>-15</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2"
            >Each time a goalkeeper or defender concedes 2 goals.</td
          >
          <td>-15</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2">A player scores an own goal.</td>
          <td>-10</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2">A player receives a yellow card.</td>
          <td>-5</td>
        </tr>
      </table>

      <h2 class="default-sub-header">Bonuses</h2>
      <p class="my-2">
        A user can play 1 bonus per gameweek. Each season a user starts with the
        following 8 bonuses:
      </p>

      <table class="w-full border-collapse striped mb-8 mt-4">
        <tr>
          <th class="text-left px-4 py-2">Bonus</th>
          <th class="text-left">Description</th>
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Goal Getter</td>
          <td
            >Select a player you think will score in a game to receive a X3
            mulitplier for each goal scored.</td
          >
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Pass Master</td>
          <td
            >Select a player you think will assist in a game to receive a X3
            mulitplier for each assist.</td
          >
        </tr>
        <tr>
          <td class="text-left px-4 py-2">No Entry</td>
          <td
            >Select a goalkeeper or defender you think will keep a clean sheet
            to receive a X3 multipler on their total score.</td
          >
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Team Boost</td>
          <td
            >Receive a X2 multiplier from all players from a single club that
            are in your team.</td
          >
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Safe Hands</td>
          <td
            >Receive a X3 multiplier on your goalkeeper if they make 5 saves in
            a match.</td
          >
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Captain Fantastic</td>
          <td
            >Receive a X2 multiplier on your team captain's score if they score
            a goal in a match.</td
          >
        </tr>
        <tr>
          <td class="text-left px-4 py-2">One Nation</td>
          <td>Receive a X2 multiplier for players of a selected nationality.</td
          >
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Prospects</td>
          <td>Receive a X2 multiplier for players under the age of 21.</td>
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Brace Bonus</td>
          <td
            >Receive a X2 multiplier on a player's score if they score 2 or more
            goals in a game. Applies to every player who scores a brace.</td
          >
        </tr>
        <tr>
          <td class="text-left px-4 py-2">Hat Trick Hero</td>
          <td
            >Receive a X3 multiplier on a player's score if they score 3 or more
            goals in a game. Applies to every player who scores a hat-trick.</td
          >
        </tr>
      </table>
    </div>
  </div>
</Layout>

<style>
  .striped tr:nth-child(odd) {
    background-color: rgba(46, 50, 58, 0.6);
  }
</style>
