

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.D44ty7CZ.js","_app/immutable/chunks/index.qylRMdwI.js","_app/immutable/chunks/vendor.Dea5ReM1.js"];
export const stylesheets = ["_app/immutable/assets/index.AeUbcvqf.css"];
export const fonts = [];
