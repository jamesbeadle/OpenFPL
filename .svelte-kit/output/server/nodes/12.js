

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.2ybIJdt_.js","_app/immutable/chunks/index.-MYzqSv-.js","_app/immutable/chunks/vendor.WEyKxPNU.js"];
export const stylesheets = ["_app/immutable/assets/index.o9HS5YSy.css"];
export const fonts = [];
