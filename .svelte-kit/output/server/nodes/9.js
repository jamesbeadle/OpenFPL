

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.Huh4JLzu.js","_app/immutable/chunks/index.Rt14yxHq.js","_app/immutable/chunks/vendor.PiJdbqeB.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
