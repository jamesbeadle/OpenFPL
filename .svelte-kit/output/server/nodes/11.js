

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.C_GnhnAX.js","_app/immutable/chunks/index.DGE_BOuz.js","_app/immutable/chunks/vendor.BB0dFjMb.js"];
export const stylesheets = ["_app/immutable/assets/index.DknT4k6x.css"];
export const fonts = [];
