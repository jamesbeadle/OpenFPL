

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.2f41adda.js","_app/immutable/chunks/index.1caa8ee0.js","_app/immutable/chunks/vendor.c859d4b1.js"];
export const stylesheets = ["_app/immutable/assets/index.c143d844.css"];
export const fonts = [];
