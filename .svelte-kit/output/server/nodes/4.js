

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.Cbx3Dfcf.js","_app/immutable/chunks/index.dt38MbyP.js","_app/immutable/chunks/vendor.91b5nc10.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
