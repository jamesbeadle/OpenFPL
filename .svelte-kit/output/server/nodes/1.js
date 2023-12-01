

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.ad58378a.js","_app/immutable/chunks/index.245a0e92.js","_app/immutable/chunks/stores.1b616741.js","_app/immutable/chunks/singletons.b097b3f7.js","_app/immutable/chunks/index.c203a7c8.js"];
export const stylesheets = [];
export const fonts = [];
