

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.MXFm_yIs.js","_app/immutable/chunks/index.6ADZDNjw.js","_app/immutable/chunks/vendor.wM4XiVQC.js"];
export const stylesheets = ["_app/immutable/assets/index.USi8Uar5.css"];
export const fonts = [];
