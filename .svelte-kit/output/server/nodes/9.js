

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.BzHnkezb.js","_app/immutable/chunks/index.DGE_BOuz.js","_app/immutable/chunks/vendor.BB0dFjMb.js"];
export const stylesheets = ["_app/immutable/assets/index.DknT4k6x.css"];
export const fonts = [];
