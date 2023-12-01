

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.cda2a105.js","_app/immutable/chunks/index.245a0e92.js","_app/immutable/chunks/stores.1b616741.js","_app/immutable/chunks/singletons.b097b3f7.js","_app/immutable/chunks/index.c203a7c8.js","_app/immutable/chunks/team-store.fd743fd2.js","_app/immutable/chunks/Helpers.5827f282.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/fixture-store.e0823489.js","_app/immutable/chunks/Layout.24679a1a.js","_app/immutable/chunks/governance-store.8aefbe67.js"];
export const stylesheets = ["_app/immutable/assets/Layout.c34298fa.css"];
export const fonts = [];
