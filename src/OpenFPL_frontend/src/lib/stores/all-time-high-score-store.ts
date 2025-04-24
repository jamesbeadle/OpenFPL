import { AllTimeHighScoreService } from "$lib/services/all-time-high-score-service";
import type {
  AllTimeHighScores,
  GetAllTimeHighScores,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createAllTimeHighScoresStore() {
  async function getAllTimeHighScores(
    dto: GetAllTimeHighScores,
  ): Promise<AllTimeHighScores | undefined> {
    return new AllTimeHighScoreService().getAllTimeHighScores(dto);
  }

  return {
    getAllTimeHighScores,
  };
}

export const allTimeHighScoresStore = createAllTimeHighScoresStore();
