import { openDB, type IDBPDatabase } from "idb";
import { browser } from "$app/environment";
import type { ProfileDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

const DB_NAME = "openFPLUserProfileDB";
const DB_VERSION = 1;
const STORE_NAME = "userProfiles";
const PROFILE_KEY = "user_profile_data";

let dbPromise: Promise<IDBPDatabase> | null = null;

if (browser) {
  dbPromise = openDB(DB_NAME, DB_VERSION, {
    upgrade(db) {
      if (!db.objectStoreNames.contains(STORE_NAME)) {
        db.createObjectStore(STORE_NAME);
      }
    },
  });
}

export async function getProfileFromDB(): Promise<ProfileDTO | undefined> {
  if (!browser || !dbPromise) return undefined;
  const db = await dbPromise;
  return db.get(STORE_NAME, PROFILE_KEY);
}

export async function setProfileToDB(profile: ProfileDTO): Promise<void> {
  if (!browser || !dbPromise) return;
  const db = await dbPromise;
  await db.put(STORE_NAME, profile, PROFILE_KEY);
}

export async function clearProfileFromDB(): Promise<void> {
  if (!browser || !dbPromise) return;
  const db = await dbPromise;
  await db.delete(STORE_NAME, PROFILE_KEY);
}
