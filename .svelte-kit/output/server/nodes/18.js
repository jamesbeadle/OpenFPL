

export const index = 18;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/18.eSVJb4tn.js","_app/immutable/chunks/index.ehj_5cji.js","_app/immutable/chunks/vendor._tr-LwYv.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
