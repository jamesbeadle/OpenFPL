

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.v-xH1HwA.js","_app/immutable/chunks/index.n9iZZNnf.js","_app/immutable/chunks/vendor.qtukVZee.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
