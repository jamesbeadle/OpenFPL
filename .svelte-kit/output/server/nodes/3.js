

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.fh7ex16X.js","_app/immutable/chunks/index.k8zBPlRD.js","_app/immutable/chunks/vendor.yRvkhq3Q.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
