

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.An1X4lJy.js","_app/immutable/chunks/index.CIUF4qHH.js","_app/immutable/chunks/vendor.BgTLETNM.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
