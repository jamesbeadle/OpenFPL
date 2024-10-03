

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.Br5UK3C7.js","_app/immutable/chunks/index.DiFqqUrQ.js","_app/immutable/chunks/vendor.dIk-dp_B.js"];
export const stylesheets = ["_app/immutable/assets/index.TTx05D_Z.css"];
export const fonts = [];
