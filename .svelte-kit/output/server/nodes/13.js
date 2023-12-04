

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.5fc7e649.js","_app/immutable/chunks/index.f5253aac.js","_app/immutable/chunks/vendor.fc72631d.js"];
export const stylesheets = ["_app/immutable/assets/index.288e289d.css"];
export const fonts = [];
