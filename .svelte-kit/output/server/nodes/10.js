

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/league/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.3MdmjY4Q.js","_app/immutable/chunks/index.fgbIxJ77.js","_app/immutable/chunks/vendor.y-ZjmoEQ.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
