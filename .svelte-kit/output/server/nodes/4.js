

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.l-NbKVHB.js","_app/immutable/chunks/index._UGd1eFH.js","_app/immutable/chunks/vendor.BHJNs63B.js"];
export const stylesheets = ["_app/immutable/assets/index.VpFtjrHf.css"];
export const fonts = [];
