

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.6f103209.js","_app/immutable/chunks/index.84b7e5b3.js","_app/immutable/chunks/vendor.d061dfbb.js"];
export const stylesheets = ["_app/immutable/assets/index.dea223c5.css"];
export const fonts = [];
