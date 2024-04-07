

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.vMRY9M7P.js","_app/immutable/chunks/index.nxe-6-_U.js","_app/immutable/chunks/vendor.u30FvZHK.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
