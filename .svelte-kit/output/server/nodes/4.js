

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.BNDnSVQ8.js","_app/immutable/chunks/index.DztcKuaD.js","_app/immutable/chunks/vendor.BB55vOkI.js"];
export const stylesheets = ["_app/immutable/assets/index.yn7f-zCh.css"];
export const fonts = [];
