

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.HMhlvZOK.js","_app/immutable/chunks/index.da0eIH1V.js","_app/immutable/chunks/vendor.0zqpWa_t.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
