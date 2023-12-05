

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.f300353c.js","_app/immutable/chunks/index.4a9b45ea.js","_app/immutable/chunks/vendor.e7469dd9.js"];
export const stylesheets = ["_app/immutable/assets/index.5a3bf4ba.css"];
export const fonts = [];
