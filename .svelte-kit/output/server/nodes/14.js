

export const index = 14;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/14.q0yznCA5.js","_app/immutable/chunks/index.4bTzNb5F.js","_app/immutable/chunks/vendor.V0D70jEF.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
