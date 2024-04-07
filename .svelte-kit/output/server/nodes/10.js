

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10._eS0hJu-.js","_app/immutable/chunks/index.Kzc8PEeV.js","_app/immutable/chunks/vendor.w4HYmK7F.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
