

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.Mi5rVKjH.js","_app/immutable/chunks/index.KlHAJ4Kk.js","_app/immutable/chunks/vendor.dgHSIReW.js"];
export const stylesheets = ["_app/immutable/assets/index.nydp0CLI.css"];
export const fonts = [];
