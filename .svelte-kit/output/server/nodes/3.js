

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.y8DA3Rzt.js","_app/immutable/chunks/index.6PFyDfqI.js","_app/immutable/chunks/vendor.RPzEtDgp.js"];
export const stylesheets = ["_app/immutable/assets/index.T2MyJ15X.css"];
export const fonts = [];
