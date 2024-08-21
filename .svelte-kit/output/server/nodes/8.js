

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.G4gqXh4Q.js","_app/immutable/chunks/index.Rxai5QA1.js","_app/immutable/chunks/vendor.OYOS_pBX.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
