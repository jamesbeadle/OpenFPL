

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.7eb9015a.js","_app/immutable/chunks/index.709e150e.js","_app/immutable/chunks/vendor.915501b0.js"];
export const stylesheets = ["_app/immutable/assets/index.507befdb.css"];
export const fonts = [];
