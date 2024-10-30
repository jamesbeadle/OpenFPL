

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.DluW0ZZ_.js","_app/immutable/chunks/index.nMHJqSL4.js","_app/immutable/chunks/vendor.BPMT0Cwu.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
