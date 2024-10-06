

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.DwxSfPg8.js","_app/immutable/chunks/index.Ctk6tIDP.js","_app/immutable/chunks/vendor.BSx235g1.js"];
export const stylesheets = ["_app/immutable/assets/index.TTx05D_Z.css"];
export const fonts = [];
