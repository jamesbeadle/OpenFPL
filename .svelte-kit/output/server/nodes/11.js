

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/my-leagues/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.3eim-Gpt.js","_app/immutable/chunks/index.qDuaNaTX.js","_app/immutable/chunks/vendor.Dx-udI4k.js"];
export const stylesheets = ["_app/immutable/assets/index.VpFtjrHf.css"];
export const fonts = [];
