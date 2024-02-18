

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.Id21S0wx.js","_app/immutable/chunks/index.w9uq1ufn.js","_app/immutable/chunks/vendor.B6wEBH_A.js"];
export const stylesheets = ["_app/immutable/assets/index.482clYIt.css"];
export const fonts = [];
