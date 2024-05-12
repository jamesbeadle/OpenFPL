

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.nsHHv8sJ.js","_app/immutable/chunks/index.dKPzEeoZ.js","_app/immutable/chunks/vendor.r9SrMjFO.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
