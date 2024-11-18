

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.DjDsWysy.js","_app/immutable/chunks/index.CnuGqOJ4.js","_app/immutable/chunks/vendor.DLVNmxxu.js"];
export const stylesheets = ["_app/immutable/assets/index.Rv2hwZu0.css"];
export const fonts = [];
