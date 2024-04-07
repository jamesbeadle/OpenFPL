

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.SI6NC4yQ.js","_app/immutable/chunks/index.nxe-6-_U.js","_app/immutable/chunks/vendor.u30FvZHK.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
