

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.CpOnyrMj.js","_app/immutable/chunks/index.BtVKuKsN.js","_app/immutable/chunks/vendor.BovjFFJw.js"];
export const stylesheets = ["_app/immutable/assets/index.CJCc5hpr.css"];
export const fonts = [];
