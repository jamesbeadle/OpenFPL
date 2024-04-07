

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.hJ0fKiXN.js","_app/immutable/chunks/index.ylFwoe15.js","_app/immutable/chunks/vendor.0tTkDG0T.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
