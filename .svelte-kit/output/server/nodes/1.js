

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.Yg0-3Fps.js","_app/immutable/chunks/index.HYJJcQs3.js","_app/immutable/chunks/vendor.kTC6Sc8q.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
