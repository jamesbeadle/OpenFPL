

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.fLL3S4I-.js","_app/immutable/chunks/index.j3aVO89K.js","_app/immutable/chunks/vendor.Q3vq-qGh.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
