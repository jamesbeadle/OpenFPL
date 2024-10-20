

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.BCuPT5TC.js","_app/immutable/chunks/index.DaeqkaXP.js","_app/immutable/chunks/vendor.CLV0qwmn.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
