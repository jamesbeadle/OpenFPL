export const index = 9;
let component_cache;
export const component = async () =>
  (component_cache ??= (
    await import("../entries/pages/profile/_page.svelte.js")
  ).default);
export const imports = [
  "_app/immutable/nodes/9.BlP23SjN.js",
  "_app/immutable/chunks/index.BD1-Avof.js",
  "_app/immutable/chunks/vendor.D6LFIRIk.js",
];
export const stylesheets = ["_app/immutable/assets/index.DI_gyc2R.css"];
export const fonts = [];
