

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.e6eZWMSL.js","_app/immutable/chunks/index.6mmH6rcs.js","_app/immutable/chunks/vendor.OtnoaPiB.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
