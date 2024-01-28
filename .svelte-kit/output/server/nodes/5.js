

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.9d139dbc.js","_app/immutable/chunks/index.983a729b.js","_app/immutable/chunks/vendor.4f7561fe.js"];
export const stylesheets = ["_app/immutable/assets/index.28121524.css"];
export const fonts = [];
