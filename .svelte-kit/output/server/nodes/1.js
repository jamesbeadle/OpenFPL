

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.1ogd4B6g.js","_app/immutable/chunks/index.kgQGjviq.js","_app/immutable/chunks/vendor.7R22MGa5.js"];
export const stylesheets = ["_app/immutable/assets/index.2U5fRpra.css"];
export const fonts = [];
