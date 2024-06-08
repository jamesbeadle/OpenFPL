

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.J6dWOmdu.js","_app/immutable/chunks/index.wXjPbdew.js","_app/immutable/chunks/vendor.f5cRldcM.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
