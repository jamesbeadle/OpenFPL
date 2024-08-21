

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.1V5kQuvk.js","_app/immutable/chunks/index.KgS0LIsc.js","_app/immutable/chunks/vendor.QDup3kzN.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
