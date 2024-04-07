

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.dKqgg8X9.js","_app/immutable/chunks/index.nxe-6-_U.js","_app/immutable/chunks/vendor.u30FvZHK.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
