

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.g1G2wTCM.js","_app/immutable/chunks/index.Ya9GbuY1.js","_app/immutable/chunks/vendor.HOizhr7_.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
