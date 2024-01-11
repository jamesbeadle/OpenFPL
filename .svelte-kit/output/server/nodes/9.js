

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.e79049d8.js","_app/immutable/chunks/index.49c8e29f.js","_app/immutable/chunks/vendor.26951c50.js"];
export const stylesheets = ["_app/immutable/assets/index.16e1cfcd.css"];
export const fonts = [];
