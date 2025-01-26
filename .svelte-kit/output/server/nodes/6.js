

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.B2AULh0-.js","_app/immutable/chunks/index.DcHETxNh.js","_app/immutable/chunks/vendor.sTHJaCMS.js"];
export const stylesheets = ["_app/immutable/assets/index.BnVD0ddi.css"];
export const fonts = [];
