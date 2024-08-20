

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.i8GL7cVK.js","_app/immutable/chunks/index.znL2XGaf.js","_app/immutable/chunks/vendor.VSivMjZb.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
