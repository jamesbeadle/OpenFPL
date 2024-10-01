

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.DITL_QUn.js","_app/immutable/chunks/index.B0GKUW4m.js","_app/immutable/chunks/vendor.C9CV3yCY.js"];
export const stylesheets = ["_app/immutable/assets/index.gfW9IbEE.css"];
export const fonts = [];
