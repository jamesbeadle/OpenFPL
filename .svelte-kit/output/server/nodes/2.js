

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.Br5B0Q6o.js","_app/immutable/chunks/index.CrMKidH7.js","_app/immutable/chunks/vendor.CdBGaFpM.js"];
export const stylesheets = ["_app/immutable/assets/index.Rv2hwZu0.css"];
export const fonts = [];
