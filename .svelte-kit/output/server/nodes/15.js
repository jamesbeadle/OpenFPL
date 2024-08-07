

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.r25hEaEi.js","_app/immutable/chunks/index.kgQGjviq.js","_app/immutable/chunks/vendor.7R22MGa5.js"];
export const stylesheets = ["_app/immutable/assets/index.2U5fRpra.css"];
export const fonts = [];
