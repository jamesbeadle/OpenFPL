

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.69654884.js","_app/immutable/chunks/index.4471504d.js","_app/immutable/chunks/vendor.4ad70c61.js"];
export const stylesheets = ["_app/immutable/assets/index.d0c5a4ab.css"];
export const fonts = [];
