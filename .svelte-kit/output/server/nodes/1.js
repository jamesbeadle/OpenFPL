

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.mHk0oEoI.js","_app/immutable/chunks/index.6ADZDNjw.js","_app/immutable/chunks/vendor.wM4XiVQC.js"];
export const stylesheets = ["_app/immutable/assets/index.USi8Uar5.css"];
export const fonts = [];
