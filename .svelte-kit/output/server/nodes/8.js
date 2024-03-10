

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.Ml74BKwW.js","_app/immutable/chunks/index.a6faKSO3.js","_app/immutable/chunks/vendor.d6TNTlGA.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
