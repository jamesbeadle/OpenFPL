

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.B9ccudyZ.js","_app/immutable/chunks/index.BtVKuKsN.js","_app/immutable/chunks/vendor.BovjFFJw.js"];
export const stylesheets = ["_app/immutable/assets/index.CJCc5hpr.css"];
export const fonts = [];
