

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/fixture-validation/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.16cadfab.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/system-store.3e6f7264.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/toast-store.fd13d56a.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/team-store.1a48175b.js","_app/immutable/chunks/governance-store.52c78378.js","_app/immutable/chunks/player-store.f468e323.js","_app/immutable/chunks/fixture-store.f607ef65.js"];
export const stylesheets = [];
export const fonts = [];
