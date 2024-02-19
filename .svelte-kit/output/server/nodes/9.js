

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.l6Vk6jwB.js","_app/immutable/chunks/index._1CzA47p.js","_app/immutable/chunks/vendor.VvLgQlZw.js"];
export const stylesheets = ["_app/immutable/assets/index.482clYIt.css"];
export const fonts = [];
