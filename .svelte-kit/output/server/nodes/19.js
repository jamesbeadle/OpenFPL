

export const index = 19;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/19.eT5uYOc7.js","_app/immutable/chunks/index.74J6A-kT.js","_app/immutable/chunks/vendor.f35N99Jf.js"];
export const stylesheets = ["_app/immutable/assets/index.2U5fRpra.css"];
export const fonts = [];