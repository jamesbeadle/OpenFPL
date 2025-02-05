import { expect, test } from "vitest";
import { OpenFPL_backend } from "./actor";

test("1. SystemState Test", async () => {
  const result = await OpenFPL_backend.getSystemState();
  console.log("SystemState: ", result);
  expect(result).toBeDefined();
});

test("2. AppStatus Test", async () => {
  const result = await OpenFPL_backend.getAppStatus();
  console.log("AppStatus: ", result);
  expect(result).toBeDefined();
});

test("3. DataHashes Test", async () => {
  const result = await OpenFPL_backend.getDataHashes();
  console.log("DataHashes: ", result);
  expect(result).toBeDefined();
});
