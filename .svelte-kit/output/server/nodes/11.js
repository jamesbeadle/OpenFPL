

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.8ggY8QPS.js","_app/immutable/chunks/index.nMHJqSL4.js","_app/immutable/chunks/vendor.BPMT0Cwu.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
