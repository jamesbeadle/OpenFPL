

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.d916d44e.js","_app/immutable/chunks/index.f5253aac.js","_app/immutable/chunks/vendor.fc72631d.js"];
export const stylesheets = ["_app/immutable/assets/index.288e289d.css"];
export const fonts = [];
