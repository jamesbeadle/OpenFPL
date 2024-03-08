

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.WUs5WCW1.js","_app/immutable/chunks/index.j3aVO89K.js","_app/immutable/chunks/vendor.Q3vq-qGh.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
