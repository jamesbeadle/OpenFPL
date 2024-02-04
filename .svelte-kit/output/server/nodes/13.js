

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.C0S3eWTS.js","_app/immutable/chunks/index.6ADZDNjw.js","_app/immutable/chunks/vendor.wM4XiVQC.js"];
export const stylesheets = ["_app/immutable/assets/index.USi8Uar5.css"];
export const fonts = [];
