

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/status/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.lp-wDMT7.js","_app/immutable/chunks/index.ltbeZL92.js","_app/immutable/chunks/vendor.PqoAZjCC.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
