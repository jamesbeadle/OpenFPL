

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.837ee6b9.js","_app/immutable/chunks/index.42c4853a.js","_app/immutable/chunks/vendor.ba002651.js"];
export const stylesheets = ["_app/immutable/assets/index.7da67a43.css"];
export const fonts = [];
