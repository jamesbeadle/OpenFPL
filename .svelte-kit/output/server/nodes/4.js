

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.a7e42bfa.js","_app/immutable/chunks/index.42c4853a.js","_app/immutable/chunks/vendor.ba002651.js"];
export const stylesheets = ["_app/immutable/assets/index.7da67a43.css"];
export const fonts = [];
