

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.kVn8D599.js","_app/immutable/chunks/index.-MYzqSv-.js","_app/immutable/chunks/vendor.WEyKxPNU.js"];
export const stylesheets = ["_app/immutable/assets/index.o9HS5YSy.css"];
export const fonts = [];
