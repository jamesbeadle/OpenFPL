

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.lIpRN0OX.js","_app/immutable/chunks/index.Y6f1pQlh.js","_app/immutable/chunks/vendor.AgI9z-mT.js"];
export const stylesheets = ["_app/immutable/assets/index.B4GYfJYv.css"];
export const fonts = [];
