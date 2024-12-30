

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.C0EJ60kX.js","_app/immutable/chunks/index.DztcKuaD.js","_app/immutable/chunks/vendor.BB55vOkI.js"];
export const stylesheets = ["_app/immutable/assets/index.yn7f-zCh.css"];
export const fonts = [];
