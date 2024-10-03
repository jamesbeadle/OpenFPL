

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/league/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.CPVooVAJ.js","_app/immutable/chunks/index.DiFqqUrQ.js","_app/immutable/chunks/vendor.dIk-dp_B.js"];
export const stylesheets = ["_app/immutable/assets/index.TTx05D_Z.css"];
export const fonts = [];
