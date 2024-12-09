

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.C9glKvYG.js","_app/immutable/chunks/index.CnfouH-G.js","_app/immutable/chunks/vendor.B9uk1_6A.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
