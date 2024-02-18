

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.scWSN73U.js","_app/immutable/chunks/index.pU7Jugnz.js","_app/immutable/chunks/vendor.fqwirlyn.js"];
export const stylesheets = ["_app/immutable/assets/index.482clYIt.css"];
export const fonts = [];
