

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.4ed3f25d.js","_app/immutable/chunks/index.42c4853a.js","_app/immutable/chunks/vendor.ba002651.js"];
export const stylesheets = ["_app/immutable/assets/index.7da67a43.css"];
export const fonts = [];
