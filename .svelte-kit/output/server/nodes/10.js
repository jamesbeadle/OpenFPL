

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.7fa33883.js","_app/immutable/chunks/index.890f1dc0.js","_app/immutable/chunks/vendor.7d16b6fe.js"];
export const stylesheets = ["_app/immutable/assets/index.70305e57.css"];
export const fonts = [];
