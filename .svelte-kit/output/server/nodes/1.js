

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.-3iH6rGU.js","_app/immutable/chunks/index.utDmJjgZ.js","_app/immutable/chunks/vendor.hqR8Z7_2.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
