

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.NbgIks8n.js","_app/immutable/chunks/index._UGd1eFH.js","_app/immutable/chunks/vendor.BHJNs63B.js"];
export const stylesheets = ["_app/immutable/assets/index.VpFtjrHf.css"];
export const fonts = [];
