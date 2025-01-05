

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.C7QQKw6x.js","_app/immutable/chunks/index.BtVKuKsN.js","_app/immutable/chunks/vendor.BovjFFJw.js"];
export const stylesheets = ["_app/immutable/assets/index.CJCc5hpr.css"];
export const fonts = [];
