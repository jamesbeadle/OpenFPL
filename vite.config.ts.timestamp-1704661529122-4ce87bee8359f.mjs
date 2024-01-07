// vite.config.ts
import { NodeModulesPolyfillPlugin } from "file:///home/james/OpenFPL/node_modules/@esbuild-plugins/node-modules-polyfill/dist/index.js";
import inject from "file:///home/james/OpenFPL/node_modules/@rollup/plugin-inject/dist/es/index.js";
import { sveltekit } from "file:///home/james/OpenFPL/node_modules/@sveltejs/kit/src/exports/vite/index.js";
import {
  defineConfig,
  loadEnv,
} from "file:///home/james/OpenFPL/node_modules/vite/dist/node/index.js";
import { readFileSync } from "fs";
import { dirname, join, resolve } from "path";
import { fileURLToPath } from "url";
var __vite_injected_original_import_meta_url =
  "file:///home/james/OpenFPL/vite.config.ts";
var file = fileURLToPath(
  new URL("package.json", __vite_injected_original_import_meta_url)
);
var json = readFileSync(file, "utf8");
var { version } = JSON.parse(json);
var network = process.env.DFX_NETWORK ?? "local";
var readCanisterIds = ({ prefix }) => {
  const canisterIdsJsonFile = ["ic", "staging"].includes(network)
    ? join(process.cwd(), "canister_ids.json")
    : join(process.cwd(), ".dfx", "local", "canister_ids.json");
  try {
    const config2 = JSON.parse(readFileSync(canisterIdsJsonFile, "utf-8"));
    return Object.entries(config2).reduce((acc, current) => {
      const [canisterName, canisterDetails] = current;
      return {
        ...acc,
        [`${prefix ?? ""}${canisterName.toUpperCase()}_CANISTER_ID`]:
          canisterDetails[network],
      };
    }, {});
  } catch (e) {
    console.warn(`Could not get canister ID from ${canisterIdsJsonFile}: ${e}`);
    return {};
  }
};
var config = {
  plugins: [sveltekit()],
  resolve: {
    alias: {
      $declarations: resolve("./src/declarations"),
    },
  },
  css: {
    preprocessorOptions: {
      scss: {
        additionalData: `
          @use "./node_modules/@dfinity/gix-components/dist/styles/mixins/media";
          @use "./node_modules/@dfinity/gix-components/dist/styles/mixins/text";
        `,
      },
    },
  },
  build: {
    target: "es2020",
    rollupOptions: {
      output: {
        manualChunks: (id) => {
          const folder = dirname(id);
          const lazy = ["@dfinity/nns", "@dfinity/nns-proto"];
          if (
            ["@sveltejs", "svelte", "@dfinity/gix-components", ...lazy].find(
              (lib) => folder.includes(lib)
            ) === void 0 &&
            folder.includes("node_modules")
          ) {
            return "vendor";
          }
          if (
            lazy.find((lib) => folder.includes(lib)) !== void 0 &&
            folder.includes("node_modules")
          ) {
            return "lazy";
          }
          return "index";
        },
      },
      // Polyfill Buffer for production build
      plugins: [
        inject({
          modules: { Buffer: ["buffer", "Buffer"] },
        }),
      ],
    },
  },
  // proxy /api to port 4943 during development
  server: {
    proxy: {
      "/api": "http://localhost:4943",
    },
  },
  optimizeDeps: {
    esbuildOptions: {
      define: {
        global: "globalThis",
      },
      plugins: [
        NodeModulesPolyfillPlugin(),
        {
          name: "fix-node-globals-polyfill",
          setup(build) {
            build.onResolve(
              { filter: /_virtual-process-polyfill_\.js/ },
              ({ path }) => ({ path })
            );
          },
        },
      ],
    },
  },
  worker: {
    format: "es",
  },
};
var vite_config_default = defineConfig(() => {
  process.env = {
    ...process.env,
    ...loadEnv(
      network === "ic"
        ? "production"
        : network === "staging"
        ? "staging"
        : "development",
      process.cwd()
    ),
    ...readCanisterIds({ prefix: "VITE_" }),
  };
  return {
    ...config,
    // Backwards compatibility for auto generated types of dfx that are meant for webpack and process.env
    define: {
      "process.env": {
        ...readCanisterIds({}),
        DFX_NETWORK: network,
      },
      VITE_APP_VERSION: JSON.stringify(version),
      VITE_DFX_NETWORK: JSON.stringify(network),
    },
  };
});
export { vite_config_default as default };
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsidml0ZS5jb25maWcudHMiXSwKICAic291cmNlc0NvbnRlbnQiOiBbImNvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9kaXJuYW1lID0gXCIvaG9tZS9qYW1lcy9PcGVuRlBMXCI7Y29uc3QgX192aXRlX2luamVjdGVkX29yaWdpbmFsX2ZpbGVuYW1lID0gXCIvaG9tZS9qYW1lcy9PcGVuRlBML3ZpdGUuY29uZmlnLnRzXCI7Y29uc3QgX192aXRlX2luamVjdGVkX29yaWdpbmFsX2ltcG9ydF9tZXRhX3VybCA9IFwiZmlsZTovLy9ob21lL2phbWVzL09wZW5GUEwvdml0ZS5jb25maWcudHNcIjtpbXBvcnQgeyBOb2RlTW9kdWxlc1BvbHlmaWxsUGx1Z2luIH0gZnJvbSBcIkBlc2J1aWxkLXBsdWdpbnMvbm9kZS1tb2R1bGVzLXBvbHlmaWxsXCI7XG5pbXBvcnQgaW5qZWN0IGZyb20gXCJAcm9sbHVwL3BsdWdpbi1pbmplY3RcIjtcbmltcG9ydCB7IHN2ZWx0ZWtpdCB9IGZyb20gXCJAc3ZlbHRlanMva2l0L3ZpdGVcIjtcbmltcG9ydCB7IHJlYWRGaWxlU3luYyB9IGZyb20gXCJmc1wiO1xuaW1wb3J0IHsgZGlybmFtZSwgam9pbiwgcmVzb2x2ZSB9IGZyb20gXCJwYXRoXCI7XG5pbXBvcnQgeyBmaWxlVVJMVG9QYXRoIH0gZnJvbSBcInVybFwiO1xuaW1wb3J0IHR5cGUgeyBVc2VyQ29uZmlnIH0gZnJvbSBcInZpdGVcIjtcbmltcG9ydCB7IGRlZmluZUNvbmZpZywgbG9hZEVudiB9IGZyb20gXCJ2aXRlXCI7XG5cbmNvbnN0IGZpbGUgPSBmaWxlVVJMVG9QYXRoKG5ldyBVUkwoXCJwYWNrYWdlLmpzb25cIiwgaW1wb3J0Lm1ldGEudXJsKSk7XG5jb25zdCBqc29uID0gcmVhZEZpbGVTeW5jKGZpbGUsIFwidXRmOFwiKTtcbmNvbnN0IHsgdmVyc2lvbiB9ID0gSlNPTi5wYXJzZShqc29uKTtcblxuLy8gbnBtIHJ1biBkZXYgPSBsb2NhbFxuLy8gbnBtIHJ1biBidWlsZCA9IGxvY2FsXG4vLyBkZnggZGVwbG95ID0gbG9jYWxcbi8vIGRmeCBkZXBsb3kgLS1uZXR3b3JrIGljID0gaWNcbi8vIGRmeCBkZXBsb3kgLS1uZXR3b3JrIHN0YWdpbmcgPSBzdGFnaW5nXG5jb25zdCBuZXR3b3JrID0gcHJvY2Vzcy5lbnYuREZYX05FVFdPUksgPz8gXCJsb2NhbFwiO1xuXG5jb25zdCByZWFkQ2FuaXN0ZXJJZHMgPSAoe1xuICBwcmVmaXgsXG59OiB7XG4gIHByZWZpeD86IHN0cmluZztcbn0pOiBSZWNvcmQ8c3RyaW5nLCBzdHJpbmc+ID0+IHtcbiAgY29uc3QgY2FuaXN0ZXJJZHNKc29uRmlsZSA9IFtcImljXCIsIFwic3RhZ2luZ1wiXS5pbmNsdWRlcyhuZXR3b3JrKVxuICAgID8gam9pbihwcm9jZXNzLmN3ZCgpLCBcImNhbmlzdGVyX2lkcy5qc29uXCIpXG4gICAgOiBqb2luKHByb2Nlc3MuY3dkKCksIFwiLmRmeFwiLCBcImxvY2FsXCIsIFwiY2FuaXN0ZXJfaWRzLmpzb25cIik7XG5cbiAgdHJ5IHtcbiAgICB0eXBlIERldGFpbHMgPSB7XG4gICAgICBpYz86IHN0cmluZztcbiAgICAgIHN0YWdpbmc/OiBzdHJpbmc7XG4gICAgICBsb2NhbD86IHN0cmluZztcbiAgICB9O1xuXG4gICAgY29uc3QgY29uZmlnOiBSZWNvcmQ8c3RyaW5nLCBEZXRhaWxzPiA9IEpTT04ucGFyc2UoXG4gICAgICByZWFkRmlsZVN5bmMoY2FuaXN0ZXJJZHNKc29uRmlsZSwgXCJ1dGYtOFwiKVxuICAgICk7XG5cbiAgICByZXR1cm4gT2JqZWN0LmVudHJpZXMoY29uZmlnKS5yZWR1Y2UoKGFjYywgY3VycmVudDogW3N0cmluZywgRGV0YWlsc10pID0+IHtcbiAgICAgIGNvbnN0IFtjYW5pc3Rlck5hbWUsIGNhbmlzdGVyRGV0YWlsc10gPSBjdXJyZW50O1xuXG4gICAgICByZXR1cm4ge1xuICAgICAgICAuLi5hY2MsXG4gICAgICAgIFtgJHtwcmVmaXggPz8gXCJcIn0ke2NhbmlzdGVyTmFtZS50b1VwcGVyQ2FzZSgpfV9DQU5JU1RFUl9JRGBdOlxuICAgICAgICAgIGNhbmlzdGVyRGV0YWlsc1tuZXR3b3JrIGFzIGtleW9mIERldGFpbHNdLFxuICAgICAgfTtcbiAgICB9LCB7fSk7XG4gIH0gY2F0Y2ggKGUpIHtcbiAgICBjb25zb2xlLndhcm4oYENvdWxkIG5vdCBnZXQgY2FuaXN0ZXIgSUQgZnJvbSAke2NhbmlzdGVySWRzSnNvbkZpbGV9OiAke2V9YCk7XG4gICAgcmV0dXJuIHt9O1xuICB9XG59O1xuXG5jb25zdCBjb25maWc6IFVzZXJDb25maWcgPSB7XG4gIHBsdWdpbnM6IFtzdmVsdGVraXQoKV0sXG4gIHJlc29sdmU6IHtcbiAgICBhbGlhczoge1xuICAgICAgJGRlY2xhcmF0aW9uczogcmVzb2x2ZShcIi4vc3JjL2RlY2xhcmF0aW9uc1wiKSxcbiAgICB9LFxuICB9LFxuICBjc3M6IHtcbiAgICBwcmVwcm9jZXNzb3JPcHRpb25zOiB7XG4gICAgICBzY3NzOiB7XG4gICAgICAgIGFkZGl0aW9uYWxEYXRhOiBgXG4gICAgICAgICAgQHVzZSBcIi4vbm9kZV9tb2R1bGVzL0BkZmluaXR5L2dpeC1jb21wb25lbnRzL2Rpc3Qvc3R5bGVzL21peGlucy9tZWRpYVwiO1xuICAgICAgICAgIEB1c2UgXCIuL25vZGVfbW9kdWxlcy9AZGZpbml0eS9naXgtY29tcG9uZW50cy9kaXN0L3N0eWxlcy9taXhpbnMvdGV4dFwiO1xuICAgICAgICBgLFxuICAgICAgfSxcbiAgICB9LFxuICB9LFxuICBidWlsZDoge1xuICAgIHRhcmdldDogXCJlczIwMjBcIixcbiAgICByb2xsdXBPcHRpb25zOiB7XG4gICAgICBvdXRwdXQ6IHtcbiAgICAgICAgbWFudWFsQ2h1bmtzOiAoaWQpID0+IHtcbiAgICAgICAgICBjb25zdCBmb2xkZXIgPSBkaXJuYW1lKGlkKTtcblxuICAgICAgICAgIGNvbnN0IGxhenkgPSBbXCJAZGZpbml0eS9ubnNcIiwgXCJAZGZpbml0eS9ubnMtcHJvdG9cIl07XG5cbiAgICAgICAgICBpZiAoXG4gICAgICAgICAgICBbXCJAc3ZlbHRlanNcIiwgXCJzdmVsdGVcIiwgXCJAZGZpbml0eS9naXgtY29tcG9uZW50c1wiLCAuLi5sYXp5XS5maW5kKFxuICAgICAgICAgICAgICAobGliKSA9PiBmb2xkZXIuaW5jbHVkZXMobGliKVxuICAgICAgICAgICAgKSA9PT0gdW5kZWZpbmVkICYmXG4gICAgICAgICAgICBmb2xkZXIuaW5jbHVkZXMoXCJub2RlX21vZHVsZXNcIilcbiAgICAgICAgICApIHtcbiAgICAgICAgICAgIHJldHVybiBcInZlbmRvclwiO1xuICAgICAgICAgIH1cblxuICAgICAgICAgIGlmIChcbiAgICAgICAgICAgIGxhenkuZmluZCgobGliKSA9PiBmb2xkZXIuaW5jbHVkZXMobGliKSkgIT09IHVuZGVmaW5lZCAmJlxuICAgICAgICAgICAgZm9sZGVyLmluY2x1ZGVzKFwibm9kZV9tb2R1bGVzXCIpXG4gICAgICAgICAgKSB7XG4gICAgICAgICAgICByZXR1cm4gXCJsYXp5XCI7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgcmV0dXJuIFwiaW5kZXhcIjtcbiAgICAgICAgfSxcbiAgICAgIH0sXG4gICAgICAvLyBQb2x5ZmlsbCBCdWZmZXIgZm9yIHByb2R1Y3Rpb24gYnVpbGRcbiAgICAgIHBsdWdpbnM6IFtcbiAgICAgICAgaW5qZWN0KHtcbiAgICAgICAgICBtb2R1bGVzOiB7IEJ1ZmZlcjogW1wiYnVmZmVyXCIsIFwiQnVmZmVyXCJdIH0sXG4gICAgICAgIH0pLFxuICAgICAgXSxcbiAgICB9LFxuICB9LFxuICAvLyBwcm94eSAvYXBpIHRvIHBvcnQgNDk0MyBkdXJpbmcgZGV2ZWxvcG1lbnRcbiAgc2VydmVyOiB7XG4gICAgcHJveHk6IHtcbiAgICAgIFwiL2FwaVwiOiBcImh0dHA6Ly9sb2NhbGhvc3Q6NDk0M1wiLFxuICAgIH0sXG4gIH0sXG4gIG9wdGltaXplRGVwczoge1xuICAgIGVzYnVpbGRPcHRpb25zOiB7XG4gICAgICBkZWZpbmU6IHtcbiAgICAgICAgZ2xvYmFsOiBcImdsb2JhbFRoaXNcIixcbiAgICAgIH0sXG4gICAgICBwbHVnaW5zOiBbXG4gICAgICAgIE5vZGVNb2R1bGVzUG9seWZpbGxQbHVnaW4oKSxcbiAgICAgICAge1xuICAgICAgICAgIG5hbWU6IFwiZml4LW5vZGUtZ2xvYmFscy1wb2x5ZmlsbFwiLFxuICAgICAgICAgIHNldHVwKGJ1aWxkKSB7XG4gICAgICAgICAgICBidWlsZC5vblJlc29sdmUoXG4gICAgICAgICAgICAgIHsgZmlsdGVyOiAvX3ZpcnR1YWwtcHJvY2Vzcy1wb2x5ZmlsbF9cXC5qcy8gfSxcbiAgICAgICAgICAgICAgKHsgcGF0aCB9KSA9PiAoeyBwYXRoIH0pXG4gICAgICAgICAgICApO1xuICAgICAgICAgIH0sXG4gICAgICAgIH0sXG4gICAgICBdLFxuICAgIH0sXG4gIH0sXG4gIHdvcmtlcjoge1xuICAgIGZvcm1hdDogXCJlc1wiLFxuICB9LFxufTtcblxuZXhwb3J0IGRlZmF1bHQgZGVmaW5lQ29uZmlnKCgpOiBVc2VyQ29uZmlnID0+IHtcbiAgLy8gRXhwYW5kIGVudmlyb25tZW50IC0gLmVudiBmaWxlcyAtIHdpdGggY2FuaXN0ZXIgSURzXG4gIHByb2Nlc3MuZW52ID0ge1xuICAgIC4uLnByb2Nlc3MuZW52LFxuICAgIC4uLmxvYWRFbnYoXG4gICAgICBuZXR3b3JrID09PSBcImljXCJcbiAgICAgICAgPyBcInByb2R1Y3Rpb25cIlxuICAgICAgICA6IG5ldHdvcmsgPT09IFwic3RhZ2luZ1wiXG4gICAgICAgID8gXCJzdGFnaW5nXCJcbiAgICAgICAgOiBcImRldmVsb3BtZW50XCIsXG4gICAgICBwcm9jZXNzLmN3ZCgpXG4gICAgKSxcbiAgICAuLi5yZWFkQ2FuaXN0ZXJJZHMoeyBwcmVmaXg6IFwiVklURV9cIiB9KSxcbiAgfTtcblxuICByZXR1cm4ge1xuICAgIC4uLmNvbmZpZyxcbiAgICAvLyBCYWNrd2FyZHMgY29tcGF0aWJpbGl0eSBmb3IgYXV0byBnZW5lcmF0ZWQgdHlwZXMgb2YgZGZ4IHRoYXQgYXJlIG1lYW50IGZvciB3ZWJwYWNrIGFuZCBwcm9jZXNzLmVudlxuICAgIGRlZmluZToge1xuICAgICAgXCJwcm9jZXNzLmVudlwiOiB7XG4gICAgICAgIC4uLnJlYWRDYW5pc3Rlcklkcyh7fSksXG4gICAgICAgIERGWF9ORVRXT1JLOiBuZXR3b3JrLFxuICAgICAgfSxcbiAgICAgIFZJVEVfQVBQX1ZFUlNJT046IEpTT04uc3RyaW5naWZ5KHZlcnNpb24pLFxuICAgICAgVklURV9ERlhfTkVUV09SSzogSlNPTi5zdHJpbmdpZnkobmV0d29yayksXG4gICAgfSxcbiAgfTtcbn0pO1xuIl0sCiAgIm1hcHBpbmdzIjogIjtBQUEyTyxTQUFTLGlDQUFpQztBQUNyUixPQUFPLFlBQVk7QUFDbkIsU0FBUyxpQkFBaUI7QUFDMUIsU0FBUyxvQkFBb0I7QUFDN0IsU0FBUyxTQUFTLE1BQU0sZUFBZTtBQUN2QyxTQUFTLHFCQUFxQjtBQUU5QixTQUFTLGNBQWMsZUFBZTtBQVB3RyxJQUFNLDJDQUEyQztBQVMvTCxJQUFNLE9BQU8sY0FBYyxJQUFJLElBQUksZ0JBQWdCLHdDQUFlLENBQUM7QUFDbkUsSUFBTSxPQUFPLGFBQWEsTUFBTSxNQUFNO0FBQ3RDLElBQU0sRUFBRSxRQUFRLElBQUksS0FBSyxNQUFNLElBQUk7QUFPbkMsSUFBTSxVQUFVLFFBQVEsSUFBSSxlQUFlO0FBRTNDLElBQU0sa0JBQWtCLENBQUM7QUFBQSxFQUN2QjtBQUNGLE1BRThCO0FBQzVCLFFBQU0sc0JBQXNCLENBQUMsTUFBTSxTQUFTLEVBQUUsU0FBUyxPQUFPLElBQzFELEtBQUssUUFBUSxJQUFJLEdBQUcsbUJBQW1CLElBQ3ZDLEtBQUssUUFBUSxJQUFJLEdBQUcsUUFBUSxTQUFTLG1CQUFtQjtBQUU1RCxNQUFJO0FBT0YsVUFBTUEsVUFBa0MsS0FBSztBQUFBLE1BQzNDLGFBQWEscUJBQXFCLE9BQU87QUFBQSxJQUMzQztBQUVBLFdBQU8sT0FBTyxRQUFRQSxPQUFNLEVBQUUsT0FB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
