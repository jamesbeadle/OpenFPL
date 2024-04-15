

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.vJXiF_Jw.js","_app/immutable/chunks/index.1ZgjW72Q.js","_app/immutable/chunks/vendor.K5IsSh_p.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
