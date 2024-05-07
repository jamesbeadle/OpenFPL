

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.kx8-1HlD.js","_app/immutable/chunks/index.JNhoELr1.js","_app/immutable/chunks/vendor.zEFa4HNp.js"];
export const stylesheets = ["_app/immutable/assets/index.J-R-LVDQ.css"];
export const fonts = [];
