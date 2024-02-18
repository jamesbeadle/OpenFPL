

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.egRKtIKh.js","_app/immutable/chunks/index.w9uq1ufn.js","_app/immutable/chunks/vendor.B6wEBH_A.js"];
export const stylesheets = ["_app/immutable/assets/index.482clYIt.css"];
export const fonts = [];
