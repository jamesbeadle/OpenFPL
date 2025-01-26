

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.BtdlReXm.js","_app/immutable/chunks/index.DcHETxNh.js","_app/immutable/chunks/vendor.sTHJaCMS.js"];
export const stylesheets = ["_app/immutable/assets/index.BnVD0ddi.css"];
export const fonts = [];
