

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.1ct1uLAB.js","_app/immutable/chunks/index.74J6A-kT.js","_app/immutable/chunks/vendor.f35N99Jf.js"];
export const stylesheets = ["_app/immutable/assets/index.2U5fRpra.css"];
export const fonts = [];
