

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.d-cVacqt.js","_app/immutable/chunks/index.u2HdCmYI.js","_app/immutable/chunks/vendor.e8KLDKIj.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
