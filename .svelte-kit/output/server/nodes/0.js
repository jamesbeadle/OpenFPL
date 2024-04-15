

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.9hWBv8Fb.js","_app/immutable/chunks/index.1ZgjW72Q.js","_app/immutable/chunks/vendor.K5IsSh_p.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
