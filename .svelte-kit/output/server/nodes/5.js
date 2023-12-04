

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.5a46d52d.js","_app/immutable/chunks/index.f5253aac.js","_app/immutable/chunks/vendor.fc72631d.js"];
export const stylesheets = ["_app/immutable/assets/index.288e289d.css"];
export const fonts = [];
