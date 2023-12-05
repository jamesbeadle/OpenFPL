

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.8e239bcf.js","_app/immutable/chunks/index.e5a74962.js","_app/immutable/chunks/vendor.e707e0a3.js"];
export const stylesheets = ["_app/immutable/assets/index.e87a5613.css"];
export const fonts = [];
