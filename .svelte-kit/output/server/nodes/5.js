

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.07L58GEQ.js","_app/immutable/chunks/index.9uTZlj9k.js","_app/immutable/chunks/vendor.3SsiJdFi.js"];
export const stylesheets = ["_app/immutable/assets/index.y5qdcPzo.css"];
export const fonts = [];
