

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.K6CUuSfY.js","_app/immutable/chunks/index.MQH2gfZ4.js","_app/immutable/chunks/vendor.4VcRK3Ws.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
