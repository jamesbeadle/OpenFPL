import adapter from "@sveltejs/adapter-static";
import { vitePreprocess } from "@sveltejs/kit/vite";
import autoprefixer from "autoprefixer";
import { readFileSync } from "fs";
import tailwindcss from "tailwindcss";
import { fileURLToPath } from "url";

const file = fileURLToPath(new URL("package.json", import.meta.url));
const json = readFileSync(file, "utf8");
const { version } = JSON.parse(json);

const filesPath = (path) => `src/OpenFPL_frontend/${path}`;

/** @type {import('@sveltejs/kit').Config} */
const config = {
  preprocess: vitePreprocess({
    postcss: {
      plugins: [tailwindcss(), autoprefixer],
    },
  }),
  kit: {
    adapter: adapter({
      fallback: "index.html",
      precompress: false,
    }),
    files: {
      assets: filesPath("static"),
      hooks: {
        client: filesPath("src/hooks.client"),
        server: filesPath("src/hooks.server"),
      },
      lib: filesPath("src/lib"),
      params: filesPath("src/params"),
      routes: filesPath("src/routes"),
      serviceWorker: filesPath("src/service-worker"),
      appTemplate: filesPath("src/app.html"),
      errorTemplate: filesPath("src/error.html"),
    },
  },
  serviceWorker: {
    register: false,
  },
  version: {
    name: version,
  },
  trailingSlash: "always",
};
export default config;
