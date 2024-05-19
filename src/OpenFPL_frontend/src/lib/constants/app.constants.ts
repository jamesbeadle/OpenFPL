export const localIdentityCanisterId: string | null | undefined = import.meta
  .env.VITE_INTERNET_IDENTITY_CANISTER_ID as string | null | undefined;

export const AUTH_MAX_TIME_TO_LIVE = BigInt(
  60 * 60 * 1000 * 1000 * 1000 * 24 * 14,
);

export const AUTH_POPUP_WIDTH = 576;
export const AUTH_POPUP_HEIGHT = 625;

export const AUTH_TIMER_INTERVAL = 1000;
export const CODE_TIMER_INTERVAL = 10000;

export const SECONDS_IN_MINUTE = 60;
export const MINUTES_IN_HOUR = 60;
export const HOURS_IN_DAY = 24;
export const DAYS_IN_NON_LEAP_YEAR = 365;
