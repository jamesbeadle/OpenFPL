

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.tIw-WiMd.js","_app/immutable/chunks/index.HYJJcQs3.js","_app/immutable/chunks/vendor.kTC6Sc8q.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
