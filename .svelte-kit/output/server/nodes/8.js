

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.687fe253.js","_app/immutable/chunks/index.70c0e864.js","_app/immutable/chunks/vendor.fac29999.js"];
export const stylesheets = ["_app/immutable/assets/index.636c12c5.css"];
export const fonts = [];
