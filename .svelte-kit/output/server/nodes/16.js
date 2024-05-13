

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.3uoQ6DSk.js","_app/immutable/chunks/index.DCjn-uHv.js","_app/immutable/chunks/vendor.eVHOQmaJ.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
