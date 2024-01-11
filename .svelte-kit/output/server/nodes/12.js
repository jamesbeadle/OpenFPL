

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.49e9f8a3.js","_app/immutable/chunks/index.49c8e29f.js","_app/immutable/chunks/vendor.26951c50.js"];
export const stylesheets = ["_app/immutable/assets/index.16e1cfcd.css"];
export const fonts = [];
