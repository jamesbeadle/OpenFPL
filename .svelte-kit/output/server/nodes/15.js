

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/status/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.r64lmnzF.js","_app/immutable/chunks/index.B0GKUW4m.js","_app/immutable/chunks/vendor.C9CV3yCY.js"];
export const stylesheets = ["_app/immutable/assets/index.gfW9IbEE.css"];
export const fonts = [];
