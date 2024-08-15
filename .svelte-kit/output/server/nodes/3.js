

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.hvw4ZOAN.js","_app/immutable/chunks/index.eaLArCFx.js","_app/immutable/chunks/vendor.qbE2CGIj.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
