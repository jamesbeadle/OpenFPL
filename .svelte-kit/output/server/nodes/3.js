

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.Y2ZYhzv8.js","_app/immutable/chunks/index.ntISEaP_.js","_app/immutable/chunks/vendor.eCqgVxq_.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
