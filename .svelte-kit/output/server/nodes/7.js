

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.HS32GRHJ.js","_app/immutable/chunks/index.1ZgjW72Q.js","_app/immutable/chunks/vendor.K5IsSh_p.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
