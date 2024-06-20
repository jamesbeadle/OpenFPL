

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.pXhfRsqv.js","_app/immutable/chunks/index.qylRMdwI.js","_app/immutable/chunks/vendor.Dea5ReM1.js"];
export const stylesheets = ["_app/immutable/assets/index.AeUbcvqf.css"];
export const fonts = [];
