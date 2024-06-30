

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.q1stZiq8.js","_app/immutable/chunks/index.KlHAJ4Kk.js","_app/immutable/chunks/vendor.dgHSIReW.js"];
export const stylesheets = ["_app/immutable/assets/index.nydp0CLI.css"];
export const fonts = [];
