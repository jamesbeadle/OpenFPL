

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.pJePekiJ.js","_app/immutable/chunks/index.jujRCk2m.js","_app/immutable/chunks/vendor.DBoHS05S.js"];
export const stylesheets = ["_app/immutable/assets/index.482clYIt.css"];
export const fonts = [];
