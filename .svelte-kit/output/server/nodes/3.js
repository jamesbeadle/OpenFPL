

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.owNX-Y_m.js","_app/immutable/chunks/index.qylRMdwI.js","_app/immutable/chunks/vendor.Dea5ReM1.js"];
export const stylesheets = ["_app/immutable/assets/index.AeUbcvqf.css"];
export const fonts = [];
