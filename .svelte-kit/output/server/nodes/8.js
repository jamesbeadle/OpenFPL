

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.bTeh1p6v.js","_app/immutable/chunks/index.ehj_5cji.js","_app/immutable/chunks/vendor._tr-LwYv.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
