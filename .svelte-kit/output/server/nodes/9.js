

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.lfbAl_m_.js","_app/immutable/chunks/index.j3aVO89K.js","_app/immutable/chunks/vendor.Q3vq-qGh.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
