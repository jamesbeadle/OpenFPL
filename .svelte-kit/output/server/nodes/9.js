

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.Ggq9pJnj.js","_app/immutable/chunks/index.da0eIH1V.js","_app/immutable/chunks/vendor.0zqpWa_t.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
