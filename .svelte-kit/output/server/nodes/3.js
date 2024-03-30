

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.1NId8B3Y.js","_app/immutable/chunks/index.dcAY751U.js","_app/immutable/chunks/vendor.ARjw3wWQ.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
