

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.ge_FMvgj.js","_app/immutable/chunks/index.JNhoELr1.js","_app/immutable/chunks/vendor.zEFa4HNp.js"];
export const stylesheets = ["_app/immutable/assets/index.J-R-LVDQ.css"];
export const fonts = [];
