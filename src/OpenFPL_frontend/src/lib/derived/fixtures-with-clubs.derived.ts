import { derived } from "svelte/store";
import { fixtureStore } from "../stores/fixture-store";
import { clubStore } from "../stores/club-store";
import type {
  ClubDTO,
  FixtureDTO,
} from "../../../../external_declarations/data_canister/data_canister.did";

export interface FixtureWithClubs extends FixtureDTO {
  homeClub?: ClubDTO;
  awayClub?: ClubDTO;
}

export const fixtureWithClubsStore = derived(
  [fixtureStore, clubStore],
  ([$fixtureStore, $clubStore]) => {
    if (!$fixtureStore?.length || !$clubStore?.length) {
      return [];
    }
    return $fixtureStore.map((fixture) => {
      const homeClub = $clubStore.find(
        (club) => Number(club.id) === Number(fixture.homeClubId),
      );
      const awayClub = $clubStore.find(
        (club) => Number(club.id) === Number(fixture.awayClubId),
      );

      return {
        ...fixture,
        homeClub,
        awayClub,
      } as FixtureWithClubs;
    });
  },
);
