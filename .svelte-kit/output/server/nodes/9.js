

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9._QuWK81h.js","_app/immutable/chunks/index.BB6ZhWXN.js","_app/immutable/chunks/vendor.CG1_BYgQ.js"];
export const stylesheets = ["_app/immutable/assets/index.gfW9IbEE.css"];
export const fonts = [];
