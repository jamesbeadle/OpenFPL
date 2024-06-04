

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.DXyDoU-N.js","_app/immutable/chunks/index.RVOQLkcq.js","_app/immutable/chunks/vendor.0zYlMq3w.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
