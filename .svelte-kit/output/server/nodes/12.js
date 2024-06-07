

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.asJl1Oih.js","_app/immutable/chunks/index.uc3NKJ_S.js","_app/immutable/chunks/vendor.QrgYFMi7.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
