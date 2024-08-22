

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/league/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.vWDOqJBT.js","_app/immutable/chunks/index.-wuPQcx1.js","_app/immutable/chunks/vendor.dogSTwof.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
