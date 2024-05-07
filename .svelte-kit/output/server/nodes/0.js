

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.tASSdyn9.js","_app/immutable/chunks/index.JNhoELr1.js","_app/immutable/chunks/vendor.zEFa4HNp.js"];
export const stylesheets = ["_app/immutable/assets/index.J-R-LVDQ.css"];
export const fonts = [];
