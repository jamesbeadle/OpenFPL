

export const index = 17;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/17.u1g1FFsL.js","_app/immutable/chunks/index.dDIByRlH.js","_app/immutable/chunks/vendor.CsTuDYPM.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
