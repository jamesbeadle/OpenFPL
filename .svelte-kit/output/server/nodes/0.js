

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.CWhHhu_S.js","_app/immutable/chunks/index.BtVKuKsN.js","_app/immutable/chunks/vendor.BovjFFJw.js"];
export const stylesheets = ["_app/immutable/assets/index.CJCc5hpr.css"];
export const fonts = [];
