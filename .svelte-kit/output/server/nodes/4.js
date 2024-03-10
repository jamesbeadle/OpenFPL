

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.YB-NZBEN.js","_app/immutable/chunks/index.a6faKSO3.js","_app/immutable/chunks/vendor.d6TNTlGA.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
