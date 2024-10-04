

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.DNHS-Q8J.js","_app/immutable/chunks/index.CBno4y7n.js","_app/immutable/chunks/vendor.DSVolzRZ.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
