

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.o-QS1DhD.js","_app/immutable/chunks/index.ogLk6Jcd.js","_app/immutable/chunks/vendor.NjG0H_a9.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
