

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.EpoaT7lA.js","_app/immutable/chunks/index.JNhoELr1.js","_app/immutable/chunks/vendor.zEFa4HNp.js"];
export const stylesheets = ["_app/immutable/assets/index.J-R-LVDQ.css"];
export const fonts = [];
