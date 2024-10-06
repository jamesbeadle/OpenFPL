

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.VmzEDjGQ.js","_app/immutable/chunks/index.Ctk6tIDP.js","_app/immutable/chunks/vendor.BSx235g1.js"];
export const stylesheets = ["_app/immutable/assets/index.TTx05D_Z.css"];
export const fonts = [];
