

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.CuS2U1_E.js","_app/immutable/chunks/index.BB6ZhWXN.js","_app/immutable/chunks/vendor.CG1_BYgQ.js"];
export const stylesheets = ["_app/immutable/assets/index.gfW9IbEE.css"];
export const fonts = [];
