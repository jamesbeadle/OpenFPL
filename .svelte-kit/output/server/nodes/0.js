

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.6936fe10.js","_app/immutable/chunks/index.4471504d.js","_app/immutable/chunks/vendor.4ad70c61.js"];
export const stylesheets = ["_app/immutable/assets/index.d0c5a4ab.css"];
export const fonts = [];
