

export const index = 18;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/18.nyeLP8nX.js","_app/immutable/chunks/index.2rImChHa.js","_app/immutable/chunks/vendor.e6fgO4QA.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
