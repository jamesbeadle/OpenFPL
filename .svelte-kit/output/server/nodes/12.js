

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/my-leagues/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.zexhklR9.js","_app/immutable/chunks/index.8B52ealf.js","_app/immutable/chunks/vendor.9t0CBOOp.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
