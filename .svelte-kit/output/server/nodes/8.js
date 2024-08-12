

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.x5GvTn9P.js","_app/immutable/chunks/index.k8zBPlRD.js","_app/immutable/chunks/vendor.yRvkhq3Q.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
