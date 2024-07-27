

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.9V5oTanW.js","_app/immutable/chunks/index.-MYzqSv-.js","_app/immutable/chunks/vendor.WEyKxPNU.js"];
export const stylesheets = ["_app/immutable/assets/index.o9HS5YSy.css"];
export const fonts = [];
