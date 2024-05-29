

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/league/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.rLkbjHuK.js","_app/immutable/chunks/index.BDC5Hs46.js","_app/immutable/chunks/vendor.WQKtcqWe.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
