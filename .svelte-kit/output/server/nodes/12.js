

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/my-leagues/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.3ttw3Ray.js","_app/immutable/chunks/index.znL2XGaf.js","_app/immutable/chunks/vendor.VSivMjZb.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
