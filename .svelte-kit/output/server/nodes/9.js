

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.Bxd8w_J0.js","_app/immutable/chunks/index.CrMKidH7.js","_app/immutable/chunks/vendor.CdBGaFpM.js"];
export const stylesheets = ["_app/immutable/assets/index.Rv2hwZu0.css"];
export const fonts = [];
