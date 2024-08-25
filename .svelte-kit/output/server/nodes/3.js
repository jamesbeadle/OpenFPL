

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.0Iqc41iz.js","_app/immutable/chunks/index.da0eIH1V.js","_app/immutable/chunks/vendor.0zqpWa_t.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
