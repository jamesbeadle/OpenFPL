

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.Ppw6o-4v.js","_app/immutable/chunks/index.A_tjfFnn.js","_app/immutable/chunks/vendor.4uM27dGr.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
