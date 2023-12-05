

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.95791e4e.js","_app/immutable/chunks/index.4471504d.js","_app/immutable/chunks/vendor.4ad70c61.js"];
export const stylesheets = ["_app/immutable/assets/index.d0c5a4ab.css"];
export const fonts = [];
