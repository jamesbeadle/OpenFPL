

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.Sq8iKHtY.js","_app/immutable/chunks/index.6PFyDfqI.js","_app/immutable/chunks/vendor.RPzEtDgp.js"];
export const stylesheets = ["_app/immutable/assets/index.T2MyJ15X.css"];
export const fonts = [];
