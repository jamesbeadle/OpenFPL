import type { BonusType } from "$lib/enums/BonusType";

export type Bonus = {
  id: number;
  name: string;
  description: string;
  image: string;
  selectionType: BonusType;
  isUsed: boolean;
  usedGameweek: number;
};
