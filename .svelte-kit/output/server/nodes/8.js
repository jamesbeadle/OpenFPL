

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.Dz9NemI5.js","_app/immutable/chunks/index.BtVKuKsN.js","_app/immutable/chunks/vendor.BovjFFJw.js"];
export const stylesheets = ["_app/immutable/assets/index.CJCc5hpr.css"];
export const fonts = [];
