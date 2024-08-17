

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.uhybB9Hf.js","_app/immutable/chunks/index.fzCehOls.js","_app/immutable/chunks/vendor.m7hUIDoA.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
