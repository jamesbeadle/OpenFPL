

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.ZOng3KKY.js","_app/immutable/chunks/index.xMNskjAN.js","_app/immutable/chunks/vendor.DOxKcT2h.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
