

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/canisters/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.pqk0dqGl.js","_app/immutable/chunks/index.6Yh0ZiaA.js","_app/immutable/chunks/vendor.CP6HMVig.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
