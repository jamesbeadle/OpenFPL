

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.P5zdML0H.js","_app/immutable/chunks/index.dcAY751U.js","_app/immutable/chunks/vendor.ARjw3wWQ.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
