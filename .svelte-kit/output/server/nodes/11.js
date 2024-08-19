

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.ZF8Skh6C.js","_app/immutable/chunks/index.5DpeR8Q3.js","_app/immutable/chunks/vendor.TeNPyxUw.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
