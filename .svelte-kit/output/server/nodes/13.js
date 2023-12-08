

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.4375d2b2.js","_app/immutable/chunks/index.709e150e.js","_app/immutable/chunks/vendor.915501b0.js"];
export const stylesheets = ["_app/immutable/assets/index.507befdb.css"];
export const fonts = [];
