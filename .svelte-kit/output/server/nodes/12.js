

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/my-leagues/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.3v-i_WpO.js","_app/immutable/chunks/index.da0eIH1V.js","_app/immutable/chunks/vendor.0zqpWa_t.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
