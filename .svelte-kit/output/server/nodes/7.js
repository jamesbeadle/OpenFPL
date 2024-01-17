

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.37eecb10.js","_app/immutable/chunks/index.277e188d.js","_app/immutable/chunks/vendor.ef104abe.js"];
export const stylesheets = ["_app/immutable/assets/index.bda5f1d2.css"];
export const fonts = [];
