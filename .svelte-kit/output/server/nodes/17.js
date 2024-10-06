

export const index = 17;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/17.C2axt2AP.js","_app/immutable/chunks/index.Ctk6tIDP.js","_app/immutable/chunks/vendor.BSx235g1.js"];
export const stylesheets = ["_app/immutable/assets/index.TTx05D_Z.css"];
export const fonts = [];
