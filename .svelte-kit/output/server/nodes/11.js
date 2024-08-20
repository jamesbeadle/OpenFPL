

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.kxS1hvYw.js","_app/immutable/chunks/index.fqyUADka.js","_app/immutable/chunks/vendor.e5d0A_G1.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
