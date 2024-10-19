

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.Dk74wjLs.js","_app/immutable/chunks/index.R6bHNU-6.js","_app/immutable/chunks/vendor.D7luhzul.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
