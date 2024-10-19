

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.7POTCv_C.js","_app/immutable/chunks/index.dt38MbyP.js","_app/immutable/chunks/vendor.91b5nc10.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
