

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.wXJspHa7.js","_app/immutable/chunks/index.n9iZZNnf.js","_app/immutable/chunks/vendor.qtukVZee.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
