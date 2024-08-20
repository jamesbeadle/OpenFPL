

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.tKVrUaDh.js","_app/immutable/chunks/index.9M7wT2CU.js","_app/immutable/chunks/vendor.GjvzQAiu.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
