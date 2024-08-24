

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.AeQoeuxs.js","_app/immutable/chunks/index.u2HdCmYI.js","_app/immutable/chunks/vendor.e8KLDKIj.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
