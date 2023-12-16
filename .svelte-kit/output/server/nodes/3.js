

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.3d57b944.js","_app/immutable/chunks/index.9f0003df.js","_app/immutable/chunks/vendor.2e93f72a.js"];
export const stylesheets = ["_app/immutable/assets/index.fa34df7c.css"];
export const fonts = [];
