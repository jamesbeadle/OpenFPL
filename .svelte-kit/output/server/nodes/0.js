

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.BjXZcxxW.js","_app/immutable/chunks/index.BnNPB6u7.js","_app/immutable/chunks/vendor.RfIxuPRH.js"];
export const stylesheets = ["_app/immutable/assets/index.Rv2hwZu0.css"];
export const fonts = [];
