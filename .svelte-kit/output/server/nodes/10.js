

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.2c65a69c.js","_app/immutable/chunks/index.f5253aac.js","_app/immutable/chunks/vendor.fc72631d.js"];
export const stylesheets = ["_app/immutable/assets/index.288e289d.css"];
export const fonts = [];
