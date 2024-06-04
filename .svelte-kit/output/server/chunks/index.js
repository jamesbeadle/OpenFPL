import { D as DEV } from "./vendor.js";
import * as devalue from "devalue";
import { Buffer } from "buffer";
import { parse, serialize } from "cookie";
import * as set_cookie_parser from "set-cookie-parser";
import { nonNullish, isNullish } from "@dfinity/utils";
import "dompurify";
import { AuthClient } from "@dfinity/auth-client";
import { SnsGovernanceCanister } from "@dfinity/sns";
import { HttpAgent, Actor } from "@dfinity/agent";
import "@dfinity/nns";
let base = "";
let assets = base;
const initial = { base, assets };
function override(paths) {
  base = paths.base;
  assets = paths.assets;
}
function reset() {
  base = initial.base;
  assets = initial.assets;
}
function set_assets(path) {
  assets = initial.assets = path;
}
const SVELTE_KIT_ASSETS = "/_svelte_kit_assets";
const ENDPOINT_METHODS = ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", "HEAD"];
const PAGE_METHODS = ["GET", "POST", "HEAD"];
function negotiate(accept, types) {
  const parts = [];
  accept.split(",").forEach((str, i) => {
    const match = /([^/]+)\/([^;]+)(?:;q=([0-9.]+))?/.exec(str);
    if (match) {
      const [, type, subtype, q = "1"] = match;
      parts.push({ type, subtype, q: +q, i });
    }
  });
  parts.sort((a, b) => {
    if (a.q !== b.q) {
      return b.q - a.q;
    }
    if (a.subtype === "*" !== (b.subtype === "*")) {
      return a.subtype === "*" ? 1 : -1;
    }
    if (a.type === "*" !== (b.type === "*")) {
      return a.type === "*" ? 1 : -1;
    }
    return a.i - b.i;
  });
  let accepted;
  let min_priority = Infinity;
  for (const mimetype of types) {
    const [type, subtype] = mimetype.split("/");
    const priority = parts.findIndex(
      (part) => (part.type === type || part.type === "*") && (part.subtype === subtype || part.subtype === "*")
    );
    if (priority !== -1 && priority < min_priority) {
      accepted = mimetype;
      min_priority = priority;
    }
  }
  return accepted;
}
function is_content_type(request, ...types) {
  const type = request.headers.get("content-type")?.split(";", 1)[0].trim() ?? "";
  return types.includes(type.toLowerCase());
}
function is_form_content_type(request) {
  return is_content_type(
    request,
    "application/x-www-form-urlencoded",
    "multipart/form-data",
    "text/plain"
  );
}
class HttpError {
  /**
   * @param {number} status
   * @param {{message: string} extends App.Error ? (App.Error | string | undefined) : App.Error} body
   */
  constructor(status, body2) {
    this.status = status;
    if (typeof body2 === "string") {
      this.body = { message: body2 };
    } else if (body2) {
      this.body = body2;
    } else {
      this.body = { message: `Error: ${status}` };
    }
  }
  toString() {
    return JSON.stringify(this.body);
  }
}
class Redirect {
  /**
   * @param {300 | 301 | 302 | 303 | 304 | 305 | 306 | 307 | 308} status
   * @param {string} location
   */
  constructor(status, location) {
    this.status = status;
    this.location = location;
  }
}
class SvelteKitError extends Error {
  /**
   * @param {number} status
   * @param {string} text
   * @param {string} message
   */
  constructor(status, text2, message) {
    super(message);
    this.status = status;
    this.text = text2;
  }
}
class ActionFailure {
  /**
   * @param {number} status
   * @param {T} data
   */
  constructor(status, data) {
    this.status = status;
    this.data = data;
  }
}
function json(data, init2) {
  const body2 = JSON.stringify(data);
  const headers2 = new Headers(init2?.headers);
  if (!headers2.has("content-length")) {
    headers2.set("content-length", encoder$3.encode(body2).byteLength.toString());
  }
  if (!headers2.has("content-type")) {
    headers2.set("content-type", "application/json");
  }
  return new Response(body2, {
    ...init2,
    headers: headers2
  });
}
const encoder$3 = new TextEncoder();
function text(body2, init2) {
  const headers2 = new Headers(init2?.headers);
  if (!headers2.has("content-length")) {
    const encoded = encoder$3.encode(body2);
    headers2.set("content-length", encoded.byteLength.toString());
    return new Response(encoded, {
      ...init2,
      headers: headers2
    });
  }
  return new Response(body2, {
    ...init2,
    headers: headers2
  });
}
function coalesce_to_error(err) {
  return err instanceof Error || err && /** @type {any} */
  err.name && /** @type {any} */
  err.message ? (
    /** @type {Error} */
    err
  ) : new Error(JSON.stringify(err));
}
function normalize_error(error) {
  return (
    /** @type {import('../runtime/control.js').Redirect | HttpError | SvelteKitError | Error} */
    error
  );
}
function get_status(error) {
  return error instanceof HttpError || error instanceof SvelteKitError ? error.status : 500;
}
function get_message(error) {
  return error instanceof SvelteKitError ? error.text : "Internal Error";
}
let public_env = {};
let safe_public_env = {};
function set_private_env(environment) {
}
function set_public_env(environment) {
  public_env = environment;
}
function set_safe_public_env(environment) {
  safe_public_env = environment;
}
function method_not_allowed(mod, method) {
  return text(`${method} method not allowed`, {
    status: 405,
    headers: {
      // https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/405
      // "The server must generate an Allow header field in a 405 status code response"
      allow: allowed_methods(mod).join(", ")
    }
  });
}
function allowed_methods(mod) {
  const allowed = ENDPOINT_METHODS.filter((method) => method in mod);
  if ("GET" in mod || "HEAD" in mod)
    allowed.push("HEAD");
  return allowed;
}
function static_error_page(options2, status, message) {
  let page2 = options2.templates.error({ status, message });
  return text(page2, {
    headers: { "content-type": "text/html; charset=utf-8" },
    status
  });
}
async function handle_fatal_error(event, options2, error) {
  error = error instanceof HttpError ? error : coalesce_to_error(error);
  const status = get_status(error);
  const body2 = await handle_error_and_jsonify(event, options2, error);
  const type = negotiate(event.request.headers.get("accept") || "text/html", [
    "application/json",
    "text/html"
  ]);
  if (event.isDataRequest || type === "application/json") {
    return json(body2, {
      status
    });
  }
  return static_error_page(options2, status, body2.message);
}
async function handle_error_and_jsonify(event, options2, error) {
  if (error instanceof HttpError) {
    return error.body;
  }
  const status = get_status(error);
  const message = get_message(error);
  return await options2.hooks.handleError({ error, event, status, message }) ?? { message };
}
function redirect_response(status, location) {
  const response = new Response(void 0, {
    status,
    headers: { location }
  });
  return response;
}
function clarify_devalue_error(event, error) {
  if (error.path) {
    return `Data returned from \`load\` while rendering ${event.route.id} is not serializable: ${error.message} (data${error.path})`;
  }
  if (error.path === "") {
    return `Data returned from \`load\` while rendering ${event.route.id} is not a plain object`;
  }
  return error.message;
}
function stringify_uses(node) {
  const uses = [];
  if (node.uses && node.uses.dependencies.size > 0) {
    uses.push(`"dependencies":${JSON.stringify(Array.from(node.uses.dependencies))}`);
  }
  if (node.uses && node.uses.search_params.size > 0) {
    uses.push(`"search_params":${JSON.stringify(Array.from(node.uses.search_params))}`);
  }
  if (node.uses && node.uses.params.size > 0) {
    uses.push(`"params":${JSON.stringify(Array.from(node.uses.params))}`);
  }
  if (node.uses?.parent)
    uses.push('"parent":1');
  if (node.uses?.route)
    uses.push('"route":1');
  if (node.uses?.url)
    uses.push('"url":1');
  return `"uses":{${uses.join(",")}}`;
}
async function render_endpoint(event, mod, state) {
  const method = (
    /** @type {import('types').HttpMethod} */
    event.request.method
  );
  let handler = mod[method] || mod.fallback;
  if (method === "HEAD" && mod.GET && !mod.HEAD) {
    handler = mod.GET;
  }
  if (!handler) {
    return method_not_allowed(mod, method);
  }
  const prerender = mod.prerender ?? state.prerender_default;
  if (prerender && (mod.POST || mod.PATCH || mod.PUT || mod.DELETE)) {
    throw new Error("Cannot prerender endpoints that have mutative methods");
  }
  if (state.prerendering && !prerender) {
    if (state.depth > 0) {
      throw new Error(`${event.route.id} is not prerenderable`);
    } else {
      return new Response(void 0, { status: 204 });
    }
  }
  try {
    let response = await handler(
      /** @type {import('@sveltejs/kit').RequestEvent<Record<string, any>>} */
      event
    );
    if (!(response instanceof Response)) {
      throw new Error(
        `Invalid response from route ${event.url.pathname}: handler should return a Response object`
      );
    }
    if (state.prerendering) {
      response = new Response(response.body, {
        status: response.status,
        statusText: response.statusText,
        headers: new Headers(response.headers)
      });
      response.headers.set("x-sveltekit-prerender", String(prerender));
    }
    return response;
  } catch (e) {
    if (e instanceof Redirect) {
      return new Response(void 0, {
        status: e.status,
        headers: { location: e.location }
      });
    }
    throw e;
  }
}
function is_endpoint_request(event) {
  const { method, headers: headers2 } = event.request;
  if (ENDPOINT_METHODS.includes(method) && !PAGE_METHODS.includes(method)) {
    return true;
  }
  if (method === "POST" && headers2.get("x-sveltekit-action") === "true")
    return false;
  const accept = event.request.headers.get("accept") ?? "*/*";
  return negotiate(accept, ["*", "text/html"]) !== "text/html";
}
function compact(arr) {
  return arr.filter(
    /** @returns {val is NonNullable<T>} */
    (val) => val != null
  );
}
const internal = new URL("sveltekit-internal://");
function resolve(base2, path) {
  if (path[0] === "/" && path[1] === "/")
    return path;
  let url = new URL(base2, internal);
  url = new URL(path, url);
  return url.protocol === internal.protocol ? url.pathname + url.search + url.hash : url.href;
}
function normalize_path(path, trailing_slash) {
  if (path === "/" || trailing_slash === "ignore")
    return path;
  if (trailing_slash === "never") {
    return path.endsWith("/") ? path.slice(0, -1) : path;
  } else if (trailing_slash === "always" && !path.endsWith("/")) {
    return path + "/";
  }
  return path;
}
function decode_pathname(pathname) {
  return pathname.split("%25").map(decodeURI).join("%25");
}
function decode_params(params) {
  for (const key2 in params) {
    params[key2] = decodeURIComponent(params[key2]);
  }
  return params;
}
const tracked_url_properties = (
  /** @type {const} */
  [
    "href",
    "pathname",
    "search",
    "toString",
    "toJSON"
  ]
);
function make_trackable(url, callback, search_params_callback) {
  const tracked = new URL(url);
  Object.defineProperty(tracked, "searchParams", {
    value: new Proxy(tracked.searchParams, {
      get(obj, key2) {
        if (key2 === "get" || key2 === "getAll" || key2 === "has") {
          return (param) => {
            search_params_callback(param);
            return obj[key2](param);
          };
        }
        callback();
        const value = Reflect.get(obj, key2);
        return typeof value === "function" ? value.bind(obj) : value;
      }
    }),
    enumerable: true,
    configurable: true
  });
  for (const property of tracked_url_properties) {
    Object.defineProperty(tracked, property, {
      get() {
        callback();
        return url[property];
      },
      enumerable: true,
      configurable: true
    });
  }
  {
    tracked[Symbol.for("nodejs.util.inspect.custom")] = (depth, opts, inspect) => {
      return inspect(url, opts);
    };
  }
  {
    disable_hash(tracked);
  }
  return tracked;
}
function disable_hash(url) {
  allow_nodejs_console_log(url);
  Object.defineProperty(url, "hash", {
    get() {
      throw new Error(
        "Cannot access event.url.hash. Consider using `$page.url.hash` inside a component instead"
      );
    }
  });
}
function disable_search(url) {
  allow_nodejs_console_log(url);
  for (const property of ["search", "searchParams"]) {
    Object.defineProperty(url, property, {
      get() {
        throw new Error(`Cannot access url.${property} on a page with prerendering enabled`);
      }
    });
  }
}
function allow_nodejs_console_log(url) {
  {
    url[Symbol.for("nodejs.util.inspect.custom")] = (depth, opts, inspect) => {
      return inspect(new URL(url), opts);
    };
  }
}
const DATA_SUFFIX = "/__data.json";
const HTML_DATA_SUFFIX = ".html__data.json";
function has_data_suffix(pathname) {
  return pathname.endsWith(DATA_SUFFIX) || pathname.endsWith(HTML_DATA_SUFFIX);
}
function add_data_suffix(pathname) {
  if (pathname.endsWith(".html"))
    return pathname.replace(/\.html$/, HTML_DATA_SUFFIX);
  return pathname.replace(/\/$/, "") + DATA_SUFFIX;
}
function strip_data_suffix(pathname) {
  if (pathname.endsWith(HTML_DATA_SUFFIX)) {
    return pathname.slice(0, -HTML_DATA_SUFFIX.length) + ".html";
  }
  return pathname.slice(0, -DATA_SUFFIX.length);
}
function is_action_json_request(event) {
  const accept = negotiate(event.request.headers.get("accept") ?? "*/*", [
    "application/json",
    "text/html"
  ]);
  return accept === "application/json" && event.request.method === "POST";
}
async function handle_action_json_request(event, options2, server) {
  const actions = server?.actions;
  if (!actions) {
    const no_actions_error = new SvelteKitError(
      405,
      "Method Not Allowed",
      "POST method not allowed. No actions exist for this page"
    );
    return action_json(
      {
        type: "error",
        error: await handle_error_and_jsonify(event, options2, no_actions_error)
      },
      {
        status: no_actions_error.status,
        headers: {
          // https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/405
          // "The server must generate an Allow header field in a 405 status code response"
          allow: "GET"
        }
      }
    );
  }
  check_named_default_separate(actions);
  try {
    const data = await call_action(event, actions);
    if (false)
      ;
    if (data instanceof ActionFailure) {
      return action_json({
        type: "failure",
        status: data.status,
        // @ts-expect-error we assign a string to what is supposed to be an object. That's ok
        // because we don't use the object outside, and this way we have better code navigation
        // through knowing where the related interface is used.
        data: stringify_action_response(
          data.data,
          /** @type {string} */
          event.route.id
        )
      });
    } else {
      return action_json({
        type: "success",
        status: data ? 200 : 204,
        // @ts-expect-error see comment above
        data: stringify_action_response(
          data,
          /** @type {string} */
          event.route.id
        )
      });
    }
  } catch (e) {
    const err = normalize_error(e);
    if (err instanceof Redirect) {
      return action_json_redirect(err);
    }
    return action_json(
      {
        type: "error",
        error: await handle_error_and_jsonify(event, options2, check_incorrect_fail_use(err))
      },
      {
        status: get_status(err)
      }
    );
  }
}
function check_incorrect_fail_use(error) {
  return error instanceof ActionFailure ? new Error('Cannot "throw fail()". Use "return fail()"') : error;
}
function action_json_redirect(redirect) {
  return action_json({
    type: "redirect",
    status: redirect.status,
    location: redirect.location
  });
}
function action_json(data, init2) {
  return json(data, init2);
}
function is_action_request(event) {
  return event.request.method === "POST";
}
async function handle_action_request(event, server) {
  const actions = server?.actions;
  if (!actions) {
    event.setHeaders({
      // https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/405
      // "The server must generate an Allow header field in a 405 status code response"
      allow: "GET"
    });
    return {
      type: "error",
      error: new SvelteKitError(
        405,
        "Method Not Allowed",
        "POST method not allowed. No actions exist for this page"
      )
    };
  }
  check_named_default_separate(actions);
  try {
    const data = await call_action(event, actions);
    if (false)
      ;
    if (data instanceof ActionFailure) {
      return {
        type: "failure",
        status: data.status,
        data: data.data
      };
    } else {
      return {
        type: "success",
        status: 200,
        // @ts-expect-error this will be removed upon serialization, so `undefined` is the same as omission
        data
      };
    }
  } catch (e) {
    const err = normalize_error(e);
    if (err instanceof Redirect) {
      return {
        type: "redirect",
        status: err.status,
        location: err.location
      };
    }
    return {
      type: "error",
      error: check_incorrect_fail_use(err)
    };
  }
}
function check_named_default_separate(actions) {
  if (actions.default && Object.keys(actions).length > 1) {
    throw new Error(
      "When using named actions, the default action cannot be used. See the docs for more info: https://kit.svelte.dev/docs/form-actions#named-actions"
    );
  }
}
async function call_action(event, actions) {
  const url = new URL(event.request.url);
  let name = "default";
  for (const param of url.searchParams) {
    if (param[0].startsWith("/")) {
      name = param[0].slice(1);
      if (name === "default") {
        throw new Error('Cannot use reserved action name "default"');
      }
      break;
    }
  }
  const action = actions[name];
  if (!action) {
    throw new SvelteKitError(404, "Not Found", `No action with name '${name}' found`);
  }
  if (!is_form_content_type(event.request)) {
    throw new SvelteKitError(
      415,
      "Unsupported Media Type",
      `Form actions expect form-encoded data — received ${event.request.headers.get(
        "content-type"
      )}`
    );
  }
  return action(event);
}
function validate_action_return(data) {
  if (data instanceof Redirect) {
    throw new Error("Cannot `return redirect(...)` — use `redirect(...)` instead");
  }
  if (data instanceof HttpError) {
    throw new Error("Cannot `return error(...)` — use `error(...)` or `return fail(...)` instead");
  }
}
function uneval_action_response(data, route_id) {
  return try_deserialize(data, devalue.uneval, route_id);
}
function stringify_action_response(data, route_id) {
  return try_deserialize(data, devalue.stringify, route_id);
}
function try_deserialize(data, fn, route_id) {
  try {
    return fn(data);
  } catch (e) {
    const error = (
      /** @type {any} */
      e
    );
    if ("path" in error) {
      let message = `Data returned from action inside ${route_id} is not serializable: ${error.message}`;
      if (error.path !== "")
        message += ` (data.${error.path})`;
      throw new Error(message);
    }
    throw error;
  }
}
const INVALIDATED_PARAM = "x-sveltekit-invalidated";
const TRAILING_SLASH_PARAM = "x-sveltekit-trailing-slash";
function b64_encode(buffer) {
  if (globalThis.Buffer) {
    return Buffer.from(buffer).toString("base64");
  }
  const little_endian = new Uint8Array(new Uint16Array([1]).buffer)[0] > 0;
  return btoa(
    new TextDecoder(little_endian ? "utf-16le" : "utf-16be").decode(
      new Uint16Array(new Uint8Array(buffer))
    )
  );
}
async function load_server_data({ event, state, node, parent }) {
  if (!node?.server)
    return null;
  let is_tracking = true;
  const uses = {
    dependencies: /* @__PURE__ */ new Set(),
    params: /* @__PURE__ */ new Set(),
    parent: false,
    route: false,
    url: false,
    search_params: /* @__PURE__ */ new Set()
  };
  const url = make_trackable(
    event.url,
    () => {
      if (is_tracking) {
        uses.url = true;
      }
    },
    (param) => {
      if (is_tracking) {
        uses.search_params.add(param);
      }
    }
  );
  if (state.prerendering) {
    disable_search(url);
  }
  const result = await node.server.load?.call(null, {
    ...event,
    fetch: (info, init2) => {
      new URL(info instanceof Request ? info.url : info, event.url);
      return event.fetch(info, init2);
    },
    /** @param {string[]} deps */
    depends: (...deps) => {
      for (const dep of deps) {
        const { href } = new URL(dep, event.url);
        uses.dependencies.add(href);
      }
    },
    params: new Proxy(event.params, {
      get: (target, key2) => {
        if (is_tracking) {
          uses.params.add(key2);
        }
        return target[
          /** @type {string} */
          key2
        ];
      }
    }),
    parent: async () => {
      if (is_tracking) {
        uses.parent = true;
      }
      return parent();
    },
    route: new Proxy(event.route, {
      get: (target, key2) => {
        if (is_tracking) {
          uses.route = true;
        }
        return target[
          /** @type {'id'} */
          key2
        ];
      }
    }),
    url,
    untrack(fn) {
      is_tracking = false;
      try {
        return fn();
      } finally {
        is_tracking = true;
      }
    }
  });
  return {
    type: "data",
    data: result ?? null,
    uses,
    slash: node.server.trailingSlash
  };
}
async function load_data({
  event,
  fetched,
  node,
  parent,
  server_data_promise,
  state,
  resolve_opts,
  csr
}) {
  const server_data_node = await server_data_promise;
  if (!node?.universal?.load) {
    return server_data_node?.data ?? null;
  }
  const result = await node.universal.load.call(null, {
    url: event.url,
    params: event.params,
    data: server_data_node?.data ?? null,
    route: event.route,
    fetch: create_universal_fetch(event, state, fetched, csr, resolve_opts),
    setHeaders: event.setHeaders,
    depends: () => {
    },
    parent,
    untrack: (fn) => fn()
  });
  return result ?? null;
}
function create_universal_fetch(event, state, fetched, csr, resolve_opts) {
  const universal_fetch = async (input, init2) => {
    const cloned_body = input instanceof Request && input.body ? input.clone().body : null;
    const cloned_headers = input instanceof Request && [...input.headers].length ? new Headers(input.headers) : init2?.headers;
    let response = await event.fetch(input, init2);
    const url = new URL(input instanceof Request ? input.url : input, event.url);
    const same_origin = url.origin === event.url.origin;
    let dependency;
    if (same_origin) {
      if (state.prerendering) {
        dependency = { response, body: null };
        state.prerendering.dependencies.set(url.pathname, dependency);
      }
    } else {
      const mode = input instanceof Request ? input.mode : init2?.mode ?? "cors";
      if (mode === "no-cors") {
        response = new Response("", {
          status: response.status,
          statusText: response.statusText,
          headers: response.headers
        });
      } else {
        const acao = response.headers.get("access-control-allow-origin");
        if (!acao || acao !== event.url.origin && acao !== "*") {
          throw new Error(
            `CORS error: ${acao ? "Incorrect" : "No"} 'Access-Control-Allow-Origin' header is present on the requested resource`
          );
        }
      }
    }
    const proxy = new Proxy(response, {
      get(response2, key2, _receiver) {
        async function push_fetched(body2, is_b64) {
          const status_number = Number(response2.status);
          if (isNaN(status_number)) {
            throw new Error(
              `response.status is not a number. value: "${response2.status}" type: ${typeof response2.status}`
            );
          }
          fetched.push({
            url: same_origin ? url.href.slice(event.url.origin.length) : url.href,
            method: event.request.method,
            request_body: (
              /** @type {string | ArrayBufferView | undefined} */
              input instanceof Request && cloned_body ? await stream_to_string(cloned_body) : init2?.body
            ),
            request_headers: cloned_headers,
            response_body: body2,
            response: response2,
            is_b64
          });
        }
        if (key2 === "arrayBuffer") {
          return async () => {
            const buffer = await response2.arrayBuffer();
            if (dependency) {
              dependency.body = new Uint8Array(buffer);
            }
            if (buffer instanceof ArrayBuffer) {
              await push_fetched(b64_encode(buffer), true);
            }
            return buffer;
          };
        }
        async function text2() {
          const body2 = await response2.text();
          if (!body2 || typeof body2 === "string") {
            await push_fetched(body2, false);
          }
          if (dependency) {
            dependency.body = body2;
          }
          return body2;
        }
        if (key2 === "text") {
          return text2;
        }
        if (key2 === "json") {
          return async () => {
            return JSON.parse(await text2());
          };
        }
        return Reflect.get(response2, key2, response2);
      }
    });
    if (csr) {
      const get2 = response.headers.get;
      response.headers.get = (key2) => {
        const lower = key2.toLowerCase();
        const value = get2.call(response.headers, lower);
        if (value && !lower.startsWith("x-sveltekit-")) {
          const included = resolve_opts.filterSerializedResponseHeaders(lower, value);
          if (!included) {
            throw new Error(
              `Failed to get response header "${lower}" — it must be included by the \`filterSerializedResponseHeaders\` option: https://kit.svelte.dev/docs/hooks#server-hooks-handle (at ${event.route.id})`
            );
          }
        }
        return value;
      };
    }
    return proxy;
  };
  return (input, init2) => {
    const response = universal_fetch(input, init2);
    response.catch(() => {
    });
    return response;
  };
}
async function stream_to_string(stream) {
  let result = "";
  const reader = stream.getReader();
  const decoder = new TextDecoder();
  while (true) {
    const { done, value } = await reader.read();
    if (done) {
      break;
    }
    result += decoder.decode(value);
  }
  return result;
}
function noop() {
}
function is_promise(value) {
  return !!value && (typeof value === "object" || typeof value === "function") && typeof /** @type {any} */
  value.then === "function";
}
function run(fn) {
  return fn();
}
function blank_object() {
  return /* @__PURE__ */ Object.create(null);
}
function run_all(fns) {
  fns.forEach(run);
}
function is_function(thing) {
  return typeof thing === "function";
}
function safe_not_equal(a, b) {
  return a != a ? b == b : a !== b || a && typeof a === "object" || typeof a === "function";
}
function subscribe(store, ...callbacks) {
  if (store == null) {
    for (const callback of callbacks) {
      callback(void 0);
    }
    return noop;
  }
  const unsub = store.subscribe(...callbacks);
  return unsub.unsubscribe ? () => unsub.unsubscribe() : unsub;
}
function compute_slots(slots) {
  const result = {};
  for (const key2 in slots) {
    result[key2] = true;
  }
  return result;
}
function null_to_empty(value) {
  return value == null ? "" : value;
}
function custom_event(type, detail, { bubbles = false, cancelable = false } = {}) {
  return new CustomEvent(type, { detail, bubbles, cancelable });
}
let current_component;
function set_current_component(component) {
  current_component = component;
}
function get_current_component() {
  if (!current_component)
    throw new Error("Function called outside component initialization");
  return current_component;
}
function onDestroy(fn) {
  get_current_component().$$.on_destroy.push(fn);
}
function createEventDispatcher() {
  const component = get_current_component();
  return (type, detail, { cancelable = false } = {}) => {
    const callbacks = component.$$.callbacks[type];
    if (callbacks) {
      const event = custom_event(
        /** @type {string} */
        type,
        detail,
        { cancelable }
      );
      callbacks.slice().forEach((fn) => {
        fn.call(component, event);
      });
      return !event.defaultPrevented;
    }
    return true;
  };
}
function setContext(key2, context) {
  get_current_component().$$.context.set(key2, context);
  return context;
}
function getContext(key2) {
  return get_current_component().$$.context.get(key2);
}
function ensure_array_like(array_like_or_iterator) {
  return array_like_or_iterator?.length !== void 0 ? array_like_or_iterator : Array.from(array_like_or_iterator);
}
const ATTR_REGEX = /[&"]/g;
const CONTENT_REGEX = /[&<]/g;
function escape(value, is_attr = false) {
  const str = String(value);
  const pattern2 = is_attr ? ATTR_REGEX : CONTENT_REGEX;
  pattern2.lastIndex = 0;
  let escaped = "";
  let last = 0;
  while (pattern2.test(str)) {
    const i = pattern2.lastIndex - 1;
    const ch = str[i];
    escaped += str.substring(last, i) + (ch === "&" ? "&amp;" : ch === '"' ? "&quot;" : "&lt;");
    last = i + 1;
  }
  return escaped + str.substring(last);
}
function each(items, fn) {
  items = ensure_array_like(items);
  let str = "";
  for (let i = 0; i < items.length; i += 1) {
    str += fn(items[i], i);
  }
  return str;
}
const missing_component = {
  $$render: () => ""
};
function validate_component(component, name) {
  if (!component || !component.$$render) {
    if (name === "svelte:component")
      name += " this={...}";
    throw new Error(
      `<${name}> is not a valid SSR component. You may need to review your build config to ensure that dependencies are compiled, rather than imported as pre-compiled modules. Otherwise you may need to fix a <${name}>.`
    );
  }
  return component;
}
let on_destroy;
function create_ssr_component(fn) {
  function $$render(result, props, bindings, slots, context) {
    const parent_component = current_component;
    const $$ = {
      on_destroy,
      context: new Map(context || (parent_component ? parent_component.$$.context : [])),
      // these will be immediately discarded
      on_mount: [],
      before_update: [],
      after_update: [],
      callbacks: blank_object()
    };
    set_current_component({ $$ });
    const html = fn(result, props, bindings, slots);
    set_current_component(parent_component);
    return html;
  }
  return {
    render: (props = {}, { $$slots = {}, context = /* @__PURE__ */ new Map() } = {}) => {
      on_destroy = [];
      const result = { title: "", head: "", css: /* @__PURE__ */ new Set() };
      const html = $$render(result, props, {}, $$slots, context);
      run_all(on_destroy);
      return {
        html,
        css: {
          code: Array.from(result.css).map((css2) => css2.code).join("\n"),
          map: null
          // TODO
        },
        head: result.title + result.head
      };
    },
    $$render
  };
}
function add_attribute(name, value, boolean) {
  if (value == null || boolean && !value)
    return "";
  const assignment = boolean && value === true ? "" : `="${escape(value, true)}"`;
  return ` ${name}${assignment}`;
}
const subscriber_queue = [];
function readable(value, start) {
  return {
    subscribe: writable(value, start).subscribe
  };
}
function writable(value, start = noop) {
  let stop;
  const subscribers = /* @__PURE__ */ new Set();
  function set(new_value) {
    if (safe_not_equal(value, new_value)) {
      value = new_value;
      if (stop) {
        const run_queue = !subscriber_queue.length;
        for (const subscriber of subscribers) {
          subscriber[1]();
          subscriber_queue.push(subscriber, value);
        }
        if (run_queue) {
          for (let i = 0; i < subscriber_queue.length; i += 2) {
            subscriber_queue[i][0](subscriber_queue[i + 1]);
          }
          subscriber_queue.length = 0;
        }
      }
    }
  }
  function update(fn) {
    set(fn(value));
  }
  function subscribe2(run2, invalidate = noop) {
    const subscriber = [run2, invalidate];
    subscribers.add(subscriber);
    if (subscribers.size === 1) {
      stop = start(set, update) || noop;
    }
    run2(value);
    return () => {
      subscribers.delete(subscriber);
      if (subscribers.size === 0 && stop) {
        stop();
        stop = null;
      }
    };
  }
  return { set, update, subscribe: subscribe2 };
}
function derived(stores, fn, initial_value) {
  const single = !Array.isArray(stores);
  const stores_array = single ? [stores] : stores;
  if (!stores_array.every(Boolean)) {
    throw new Error("derived() expects stores as input, got a falsy value");
  }
  const auto = fn.length < 2;
  return readable(initial_value, (set, update) => {
    let started = false;
    const values = [];
    let pending = 0;
    let cleanup = noop;
    const sync = () => {
      if (pending) {
        return;
      }
      cleanup();
      const result = fn(single ? values[0] : values, set, update);
      if (auto) {
        set(result);
      } else {
        cleanup = is_function(result) ? result : noop;
      }
    };
    const unsubscribers = stores_array.map(
      (store, i) => subscribe(
        store,
        (value) => {
          values[i] = value;
          pending &= ~(1 << i);
          if (started) {
            sync();
          }
        },
        () => {
          pending |= 1 << i;
        }
      )
    );
    started = true;
    sync();
    return function stop() {
      run_all(unsubscribers);
      cleanup();
      started = false;
    };
  });
}
function hash(...values) {
  let hash2 = 5381;
  for (const value of values) {
    if (typeof value === "string") {
      let i = value.length;
      while (i)
        hash2 = hash2 * 33 ^ value.charCodeAt(--i);
    } else if (ArrayBuffer.isView(value)) {
      const buffer = new Uint8Array(value.buffer, value.byteOffset, value.byteLength);
      let i = buffer.length;
      while (i)
        hash2 = hash2 * 33 ^ buffer[--i];
    } else {
      throw new TypeError("value must be a string or TypedArray");
    }
  }
  return (hash2 >>> 0).toString(36);
}
const escape_html_attr_dict = {
  "&": "&amp;",
  '"': "&quot;"
};
const escape_html_attr_regex = new RegExp(
  // special characters
  `[${Object.keys(escape_html_attr_dict).join("")}]|[\\ud800-\\udbff](?![\\udc00-\\udfff])|[\\ud800-\\udbff][\\udc00-\\udfff]|[\\udc00-\\udfff]`,
  "g"
);
function escape_html_attr(str) {
  const escaped_str = str.replace(escape_html_attr_regex, (match) => {
    if (match.length === 2) {
      return match;
    }
    return escape_html_attr_dict[match] ?? `&#${match.charCodeAt(0)};`;
  });
  return `"${escaped_str}"`;
}
const replacements = {
  "<": "\\u003C",
  "\u2028": "\\u2028",
  "\u2029": "\\u2029"
};
const pattern = new RegExp(`[${Object.keys(replacements).join("")}]`, "g");
function serialize_data(fetched, filter, prerendering2 = false) {
  const headers2 = {};
  let cache_control = null;
  let age = null;
  let varyAny = false;
  for (const [key2, value] of fetched.response.headers) {
    if (filter(key2, value)) {
      headers2[key2] = value;
    }
    if (key2 === "cache-control")
      cache_control = value;
    else if (key2 === "age")
      age = value;
    else if (key2 === "vary" && value.trim() === "*")
      varyAny = true;
  }
  const payload = {
    status: fetched.response.status,
    statusText: fetched.response.statusText,
    headers: headers2,
    body: fetched.response_body
  };
  const safe_payload = JSON.stringify(payload).replace(pattern, (match) => replacements[match]);
  const attrs = [
    'type="application/json"',
    "data-sveltekit-fetched",
    `data-url=${escape_html_attr(fetched.url)}`
  ];
  if (fetched.is_b64) {
    attrs.push("data-b64");
  }
  if (fetched.request_headers || fetched.request_body) {
    const values = [];
    if (fetched.request_headers) {
      values.push([...new Headers(fetched.request_headers)].join(","));
    }
    if (fetched.request_body) {
      values.push(fetched.request_body);
    }
    attrs.push(`data-hash="${hash(...values)}"`);
  }
  if (!prerendering2 && fetched.method === "GET" && cache_control && !varyAny) {
    const match = /s-maxage=(\d+)/g.exec(cache_control) ?? /max-age=(\d+)/g.exec(cache_control);
    if (match) {
      const ttl = +match[1] - +(age ?? "0");
      attrs.push(`data-ttl="${ttl}"`);
    }
  }
  return `<script ${attrs.join(" ")}>${safe_payload}<\/script>`;
}
const s = JSON.stringify;
const encoder$2 = new TextEncoder();
function sha256(data) {
  if (!key[0])
    precompute();
  const out = init.slice(0);
  const array2 = encode(data);
  for (let i = 0; i < array2.length; i += 16) {
    const w = array2.subarray(i, i + 16);
    let tmp;
    let a;
    let b;
    let out0 = out[0];
    let out1 = out[1];
    let out2 = out[2];
    let out3 = out[3];
    let out4 = out[4];
    let out5 = out[5];
    let out6 = out[6];
    let out7 = out[7];
    for (let i2 = 0; i2 < 64; i2++) {
      if (i2 < 16) {
        tmp = w[i2];
      } else {
        a = w[i2 + 1 & 15];
        b = w[i2 + 14 & 15];
        tmp = w[i2 & 15] = (a >>> 7 ^ a >>> 18 ^ a >>> 3 ^ a << 25 ^ a << 14) + (b >>> 17 ^ b >>> 19 ^ b >>> 10 ^ b << 15 ^ b << 13) + w[i2 & 15] + w[i2 + 9 & 15] | 0;
      }
      tmp = tmp + out7 + (out4 >>> 6 ^ out4 >>> 11 ^ out4 >>> 25 ^ out4 << 26 ^ out4 << 21 ^ out4 << 7) + (out6 ^ out4 & (out5 ^ out6)) + key[i2];
      out7 = out6;
      out6 = out5;
      out5 = out4;
      out4 = out3 + tmp | 0;
      out3 = out2;
      out2 = out1;
      out1 = out0;
      out0 = tmp + (out1 & out2 ^ out3 & (out1 ^ out2)) + (out1 >>> 2 ^ out1 >>> 13 ^ out1 >>> 22 ^ out1 << 30 ^ out1 << 19 ^ out1 << 10) | 0;
    }
    out[0] = out[0] + out0 | 0;
    out[1] = out[1] + out1 | 0;
    out[2] = out[2] + out2 | 0;
    out[3] = out[3] + out3 | 0;
    out[4] = out[4] + out4 | 0;
    out[5] = out[5] + out5 | 0;
    out[6] = out[6] + out6 | 0;
    out[7] = out[7] + out7 | 0;
  }
  const bytes = new Uint8Array(out.buffer);
  reverse_endianness(bytes);
  return base64(bytes);
}
const init = new Uint32Array(8);
const key = new Uint32Array(64);
function precompute() {
  function frac(x) {
    return (x - Math.floor(x)) * 4294967296;
  }
  let prime = 2;
  for (let i = 0; i < 64; prime++) {
    let is_prime = true;
    for (let factor = 2; factor * factor <= prime; factor++) {
      if (prime % factor === 0) {
        is_prime = false;
        break;
      }
    }
    if (is_prime) {
      if (i < 8) {
        init[i] = frac(prime ** (1 / 2));
      }
      key[i] = frac(prime ** (1 / 3));
      i++;
    }
  }
}
function reverse_endianness(bytes) {
  for (let i = 0; i < bytes.length; i += 4) {
    const a = bytes[i + 0];
    const b = bytes[i + 1];
    const c = bytes[i + 2];
    const d = bytes[i + 3];
    bytes[i + 0] = d;
    bytes[i + 1] = c;
    bytes[i + 2] = b;
    bytes[i + 3] = a;
  }
}
function encode(str) {
  const encoded = encoder$2.encode(str);
  const length = encoded.length * 8;
  const size = 512 * Math.ceil((length + 65) / 512);
  const bytes = new Uint8Array(size / 8);
  bytes.set(encoded);
  bytes[encoded.length] = 128;
  reverse_endianness(bytes);
  const words = new Uint32Array(bytes.buffer);
  words[words.length - 2] = Math.floor(length / 4294967296);
  words[words.length - 1] = length;
  return words;
}
const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".split("");
function base64(bytes) {
  const l = bytes.length;
  let result = "";
  let i;
  for (i = 2; i < l; i += 3) {
    result += chars[bytes[i - 2] >> 2];
    result += chars[(bytes[i - 2] & 3) << 4 | bytes[i - 1] >> 4];
    result += chars[(bytes[i - 1] & 15) << 2 | bytes[i] >> 6];
    result += chars[bytes[i] & 63];
  }
  if (i === l + 1) {
    result += chars[bytes[i - 2] >> 2];
    result += chars[(bytes[i - 2] & 3) << 4];
    result += "==";
  }
  if (i === l) {
    result += chars[bytes[i - 2] >> 2];
    result += chars[(bytes[i - 2] & 3) << 4 | bytes[i - 1] >> 4];
    result += chars[(bytes[i - 1] & 15) << 2];
    result += "=";
  }
  return result;
}
const array = new Uint8Array(16);
function generate_nonce() {
  crypto.getRandomValues(array);
  return base64(array);
}
const quoted = /* @__PURE__ */ new Set([
  "self",
  "unsafe-eval",
  "unsafe-hashes",
  "unsafe-inline",
  "none",
  "strict-dynamic",
  "report-sample",
  "wasm-unsafe-eval",
  "script"
]);
const crypto_pattern = /^(nonce|sha\d\d\d)-/;
class BaseProvider {
  /** @type {boolean} */
  #use_hashes;
  /** @type {boolean} */
  #script_needs_csp;
  /** @type {boolean} */
  #style_needs_csp;
  /** @type {import('types').CspDirectives} */
  #directives;
  /** @type {import('types').Csp.Source[]} */
  #script_src;
  /** @type {import('types').Csp.Source[]} */
  #script_src_elem;
  /** @type {import('types').Csp.Source[]} */
  #style_src;
  /** @type {import('types').Csp.Source[]} */
  #style_src_attr;
  /** @type {import('types').Csp.Source[]} */
  #style_src_elem;
  /** @type {string} */
  #nonce;
  /**
   * @param {boolean} use_hashes
   * @param {import('types').CspDirectives} directives
   * @param {string} nonce
   */
  constructor(use_hashes, directives, nonce) {
    this.#use_hashes = use_hashes;
    this.#directives = directives;
    const d = this.#directives;
    this.#script_src = [];
    this.#script_src_elem = [];
    this.#style_src = [];
    this.#style_src_attr = [];
    this.#style_src_elem = [];
    const effective_script_src = d["script-src"] || d["default-src"];
    const script_src_elem = d["script-src-elem"];
    const effective_style_src = d["style-src"] || d["default-src"];
    const style_src_attr = d["style-src-attr"];
    const style_src_elem = d["style-src-elem"];
    this.#script_needs_csp = !!effective_script_src && effective_script_src.filter((value) => value !== "unsafe-inline").length > 0 || !!script_src_elem && script_src_elem.filter((value) => value !== "unsafe-inline").length > 0;
    this.#style_needs_csp = !!effective_style_src && effective_style_src.filter((value) => value !== "unsafe-inline").length > 0 || !!style_src_attr && style_src_attr.filter((value) => value !== "unsafe-inline").length > 0 || !!style_src_elem && style_src_elem.filter((value) => value !== "unsafe-inline").length > 0;
    this.script_needs_nonce = this.#script_needs_csp && !this.#use_hashes;
    this.style_needs_nonce = this.#style_needs_csp && !this.#use_hashes;
    this.#nonce = nonce;
  }
  /** @param {string} content */
  add_script(content) {
    if (this.#script_needs_csp) {
      const d = this.#directives;
      if (this.#use_hashes) {
        const hash2 = sha256(content);
        this.#script_src.push(`sha256-${hash2}`);
        if (d["script-src-elem"]?.length) {
          this.#script_src_elem.push(`sha256-${hash2}`);
        }
      } else {
        if (this.#script_src.length === 0) {
          this.#script_src.push(`nonce-${this.#nonce}`);
        }
        if (d["script-src-elem"]?.length) {
          this.#script_src_elem.push(`nonce-${this.#nonce}`);
        }
      }
    }
  }
  /** @param {string} content */
  add_style(content) {
    if (this.#style_needs_csp) {
      const empty_comment_hash = "9OlNO0DNEeaVzHL4RZwCLsBHA8WBQ8toBp/4F5XV2nc=";
      const d = this.#directives;
      if (this.#use_hashes) {
        const hash2 = sha256(content);
        this.#style_src.push(`sha256-${hash2}`);
        if (d["style-src-attr"]?.length) {
          this.#style_src_attr.push(`sha256-${hash2}`);
        }
        if (d["style-src-elem"]?.length) {
          if (hash2 !== empty_comment_hash && !d["style-src-elem"].includes(`sha256-${empty_comment_hash}`)) {
            this.#style_src_elem.push(`sha256-${empty_comment_hash}`);
          }
          this.#style_src_elem.push(`sha256-${hash2}`);
        }
      } else {
        if (this.#style_src.length === 0 && !d["style-src"]?.includes("unsafe-inline")) {
          this.#style_src.push(`nonce-${this.#nonce}`);
        }
        if (d["style-src-attr"]?.length) {
          this.#style_src_attr.push(`nonce-${this.#nonce}`);
        }
        if (d["style-src-elem"]?.length) {
          if (!d["style-src-elem"].includes(`sha256-${empty_comment_hash}`)) {
            this.#style_src_elem.push(`sha256-${empty_comment_hash}`);
          }
          this.#style_src_elem.push(`nonce-${this.#nonce}`);
        }
      }
    }
  }
  /**
   * @param {boolean} [is_meta]
   */
  get_header(is_meta = false) {
    const header = [];
    const directives = { ...this.#directives };
    if (this.#style_src.length > 0) {
      directives["style-src"] = [
        ...directives["style-src"] || directives["default-src"] || [],
        ...this.#style_src
      ];
    }
    if (this.#style_src_attr.length > 0) {
      directives["style-src-attr"] = [
        ...directives["style-src-attr"] || [],
        ...this.#style_src_attr
      ];
    }
    if (this.#style_src_elem.length > 0) {
      directives["style-src-elem"] = [
        ...directives["style-src-elem"] || [],
        ...this.#style_src_elem
      ];
    }
    if (this.#script_src.length > 0) {
      directives["script-src"] = [
        ...directives["script-src"] || directives["default-src"] || [],
        ...this.#script_src
      ];
    }
    if (this.#script_src_elem.length > 0) {
      directives["script-src-elem"] = [
        ...directives["script-src-elem"] || [],
        ...this.#script_src_elem
      ];
    }
    for (const key2 in directives) {
      if (is_meta && (key2 === "frame-ancestors" || key2 === "report-uri" || key2 === "sandbox")) {
        continue;
      }
      const value = (
        /** @type {string[] | true} */
        directives[key2]
      );
      if (!value)
        continue;
      const directive = [key2];
      if (Array.isArray(value)) {
        value.forEach((value2) => {
          if (quoted.has(value2) || crypto_pattern.test(value2)) {
            directive.push(`'${value2}'`);
          } else {
            directive.push(value2);
          }
        });
      }
      header.push(directive.join(" "));
    }
    return header.join("; ");
  }
}
class CspProvider extends BaseProvider {
  get_meta() {
    const content = this.get_header(true);
    if (!content) {
      return;
    }
    return `<meta http-equiv="content-security-policy" content=${escape_html_attr(content)}>`;
  }
}
class CspReportOnlyProvider extends BaseProvider {
  /**
   * @param {boolean} use_hashes
   * @param {import('types').CspDirectives} directives
   * @param {string} nonce
   */
  constructor(use_hashes, directives, nonce) {
    super(use_hashes, directives, nonce);
    if (Object.values(directives).filter((v) => !!v).length > 0) {
      const has_report_to = directives["report-to"]?.length ?? 0 > 0;
      const has_report_uri = directives["report-uri"]?.length ?? 0 > 0;
      if (!has_report_to && !has_report_uri) {
        throw Error(
          "`content-security-policy-report-only` must be specified with either the `report-to` or `report-uri` directives, or both"
        );
      }
    }
  }
}
class Csp {
  /** @readonly */
  nonce = generate_nonce();
  /** @type {CspProvider} */
  csp_provider;
  /** @type {CspReportOnlyProvider} */
  report_only_provider;
  /**
   * @param {import('./types.js').CspConfig} config
   * @param {import('./types.js').CspOpts} opts
   */
  constructor({ mode, directives, reportOnly }, { prerender }) {
    const use_hashes = mode === "hash" || mode === "auto" && prerender;
    this.csp_provider = new CspProvider(use_hashes, directives, this.nonce);
    this.report_only_provider = new CspReportOnlyProvider(use_hashes, reportOnly, this.nonce);
  }
  get script_needs_nonce() {
    return this.csp_provider.script_needs_nonce || this.report_only_provider.script_needs_nonce;
  }
  get style_needs_nonce() {
    return this.csp_provider.style_needs_nonce || this.report_only_provider.style_needs_nonce;
  }
  /** @param {string} content */
  add_script(content) {
    this.csp_provider.add_script(content);
    this.report_only_provider.add_script(content);
  }
  /** @param {string} content */
  add_style(content) {
    this.csp_provider.add_style(content);
    this.report_only_provider.add_style(content);
  }
}
function defer() {
  let fulfil;
  let reject;
  const promise = new Promise((f, r) => {
    fulfil = f;
    reject = r;
  });
  return { promise, fulfil, reject };
}
function create_async_iterator() {
  const deferred = [defer()];
  return {
    iterator: {
      [Symbol.asyncIterator]() {
        return {
          next: async () => {
            const next = await deferred[0].promise;
            if (!next.done)
              deferred.shift();
            return next;
          }
        };
      }
    },
    push: (value) => {
      deferred[deferred.length - 1].fulfil({
        value,
        done: false
      });
      deferred.push(defer());
    },
    done: () => {
      deferred[deferred.length - 1].fulfil({ done: true });
    }
  };
}
const updated = {
  ...readable(false),
  check: () => false
};
const encoder$1 = new TextEncoder();
async function render_response({
  branch,
  fetched,
  options: options2,
  manifest,
  state,
  page_config,
  status,
  error = null,
  event,
  resolve_opts,
  action_result
}) {
  if (state.prerendering) {
    if (options2.csp.mode === "nonce") {
      throw new Error('Cannot use prerendering if config.kit.csp.mode === "nonce"');
    }
    if (options2.app_template_contains_nonce) {
      throw new Error("Cannot use prerendering if page template contains %sveltekit.nonce%");
    }
  }
  const { client } = manifest._;
  const modulepreloads = new Set(client.imports);
  const stylesheets = new Set(client.stylesheets);
  const fonts = new Set(client.fonts);
  const link_header_preloads = /* @__PURE__ */ new Set();
  const inline_styles = /* @__PURE__ */ new Map();
  let rendered;
  const form_value = action_result?.type === "success" || action_result?.type === "failure" ? action_result.data ?? null : null;
  let base$1 = base;
  let assets$1 = assets;
  let base_expression = s(base);
  if (!state.prerendering?.fallback) {
    const segments = event.url.pathname.slice(base.length).split("/").slice(2);
    base$1 = segments.map(() => "..").join("/") || ".";
    base_expression = `new URL(${s(base$1)}, location).pathname.slice(0, -1)`;
    if (!assets || assets[0] === "/" && assets !== SVELTE_KIT_ASSETS) {
      assets$1 = base$1;
    }
  }
  if (page_config.ssr) {
    const props = {
      stores: {
        page: writable(null),
        navigating: writable(null),
        updated
      },
      constructors: await Promise.all(branch.map(({ node }) => node.component())),
      form: form_value
    };
    let data2 = {};
    for (let i = 0; i < branch.length; i += 1) {
      data2 = { ...data2, ...branch[i].data };
      props[`data_${i}`] = data2;
    }
    props.page = {
      error,
      params: (
        /** @type {Record<string, any>} */
        event.params
      ),
      route: event.route,
      status,
      url: event.url,
      data: data2,
      form: form_value,
      state: {}
    };
    override({ base: base$1, assets: assets$1 });
    {
      try {
        rendered = options2.root.render(props);
      } finally {
        reset();
      }
    }
    for (const { node } of branch) {
      for (const url of node.imports)
        modulepreloads.add(url);
      for (const url of node.stylesheets)
        stylesheets.add(url);
      for (const url of node.fonts)
        fonts.add(url);
      if (node.inline_styles) {
        Object.entries(await node.inline_styles()).forEach(([k, v]) => inline_styles.set(k, v));
      }
    }
  } else {
    rendered = { head: "", html: "", css: { code: "", map: null } };
  }
  let head = "";
  let body2 = rendered.html;
  const csp = new Csp(options2.csp, {
    prerender: !!state.prerendering
  });
  const prefixed = (path) => {
    if (path.startsWith("/")) {
      return base + path;
    }
    return `${assets$1}/${path}`;
  };
  if (inline_styles.size > 0) {
    const content = Array.from(inline_styles.values()).join("\n");
    const attributes = [];
    if (csp.style_needs_nonce)
      attributes.push(` nonce="${csp.nonce}"`);
    csp.add_style(content);
    head += `
	<style${attributes.join("")}>${content}</style>`;
  }
  for (const dep of stylesheets) {
    const path = prefixed(dep);
    const attributes = ['rel="stylesheet"'];
    if (inline_styles.has(dep)) {
      attributes.push("disabled", 'media="(max-width: 0)"');
    } else {
      if (resolve_opts.preload({ type: "css", path })) {
        const preload_atts = ['rel="preload"', 'as="style"'];
        link_header_preloads.add(`<${encodeURI(path)}>; ${preload_atts.join(";")}; nopush`);
      }
    }
    head += `
		<link href="${path}" ${attributes.join(" ")}>`;
  }
  for (const dep of fonts) {
    const path = prefixed(dep);
    if (resolve_opts.preload({ type: "font", path })) {
      const ext = dep.slice(dep.lastIndexOf(".") + 1);
      const attributes = [
        'rel="preload"',
        'as="font"',
        `type="font/${ext}"`,
        `href="${path}"`,
        "crossorigin"
      ];
      head += `
		<link ${attributes.join(" ")}>`;
    }
  }
  const global = `__sveltekit_${options2.version_hash}`;
  const { data, chunks } = get_data(
    event,
    options2,
    branch.map((b) => b.server_data),
    global
  );
  if (page_config.ssr && page_config.csr) {
    body2 += `
			${fetched.map(
      (item) => serialize_data(item, resolve_opts.filterSerializedResponseHeaders, !!state.prerendering)
    ).join("\n			")}`;
  }
  if (page_config.csr) {
    if (client.uses_env_dynamic_public && state.prerendering) {
      modulepreloads.add(`${options2.app_dir}/env.js`);
    }
    const included_modulepreloads = Array.from(modulepreloads, (dep) => prefixed(dep)).filter(
      (path) => resolve_opts.preload({ type: "js", path })
    );
    for (const path of included_modulepreloads) {
      link_header_preloads.add(`<${encodeURI(path)}>; rel="modulepreload"; nopush`);
      if (options2.preload_strategy !== "modulepreload") {
        head += `
		<link rel="preload" as="script" crossorigin="anonymous" href="${path}">`;
      } else if (state.prerendering) {
        head += `
		<link rel="modulepreload" href="${path}">`;
      }
    }
    const blocks = [];
    const load_env_eagerly = client.uses_env_dynamic_public && state.prerendering;
    const properties = [`base: ${base_expression}`];
    if (assets) {
      properties.push(`assets: ${s(assets)}`);
    }
    if (client.uses_env_dynamic_public) {
      properties.push(`env: ${load_env_eagerly ? "null" : s(public_env)}`);
    }
    if (chunks) {
      blocks.push("const deferred = new Map();");
      properties.push(`defer: (id) => new Promise((fulfil, reject) => {
							deferred.set(id, { fulfil, reject });
						})`);
      properties.push(`resolve: ({ id, data, error }) => {
							const { fulfil, reject } = deferred.get(id);
							deferred.delete(id);

							if (error) reject(error);
							else fulfil(data);
						}`);
    }
    blocks.push(`${global} = {
						${properties.join(",\n						")}
					};`);
    const args = ["app", "element"];
    blocks.push("const element = document.currentScript.parentElement;");
    if (page_config.ssr) {
      const serialized = { form: "null", error: "null" };
      blocks.push(`const data = ${data};`);
      if (form_value) {
        serialized.form = uneval_action_response(
          form_value,
          /** @type {string} */
          event.route.id
        );
      }
      if (error) {
        serialized.error = devalue.uneval(error);
      }
      const hydrate = [
        `node_ids: [${branch.map(({ node }) => node.index).join(", ")}]`,
        "data",
        `form: ${serialized.form}`,
        `error: ${serialized.error}`
      ];
      if (status !== 200) {
        hydrate.push(`status: ${status}`);
      }
      if (options2.embedded) {
        hydrate.push(`params: ${devalue.uneval(event.params)}`, `route: ${s(event.route)}`);
      }
      const indent = "	".repeat(load_env_eagerly ? 7 : 6);
      args.push(`{
${indent}	${hydrate.join(`,
${indent}	`)}
${indent}}`);
    }
    if (load_env_eagerly) {
      blocks.push(`import(${s(`${base$1}/${options2.app_dir}/env.js`)}).then(({ env }) => {
						${global}.env = env;

						Promise.all([
							import(${s(prefixed(client.start))}),
							import(${s(prefixed(client.app))})
						]).then(([kit, app]) => {
							kit.start(${args.join(", ")});
						});
					});`);
    } else {
      blocks.push(`Promise.all([
						import(${s(prefixed(client.start))}),
						import(${s(prefixed(client.app))})
					]).then(([kit, app]) => {
						kit.start(${args.join(", ")});
					});`);
    }
    if (options2.service_worker) {
      const opts = "";
      blocks.push(`if ('serviceWorker' in navigator) {
						addEventListener('load', function () {
							navigator.serviceWorker.register('${prefixed("service-worker.js")}'${opts});
						});
					}`);
    }
    const init_app = `
				{
					${blocks.join("\n\n					")}
				}
			`;
    csp.add_script(init_app);
    body2 += `
			<script${csp.script_needs_nonce ? ` nonce="${csp.nonce}"` : ""}>${init_app}<\/script>
		`;
  }
  const headers2 = new Headers({
    "x-sveltekit-page": "true",
    "content-type": "text/html"
  });
  if (state.prerendering) {
    const http_equiv = [];
    const csp_headers = csp.csp_provider.get_meta();
    if (csp_headers) {
      http_equiv.push(csp_headers);
    }
    if (state.prerendering.cache) {
      http_equiv.push(`<meta http-equiv="cache-control" content="${state.prerendering.cache}">`);
    }
    if (http_equiv.length > 0) {
      head = http_equiv.join("\n") + head;
    }
  } else {
    const csp_header = csp.csp_provider.get_header();
    if (csp_header) {
      headers2.set("content-security-policy", csp_header);
    }
    const report_only_header = csp.report_only_provider.get_header();
    if (report_only_header) {
      headers2.set("content-security-policy-report-only", report_only_header);
    }
    if (link_header_preloads.size) {
      headers2.set("link", Array.from(link_header_preloads).join(", "));
    }
  }
  head += rendered.head;
  const html = options2.templates.app({
    head,
    body: body2,
    assets: assets$1,
    nonce: (
      /** @type {string} */
      csp.nonce
    ),
    env: safe_public_env
  });
  const transformed = await resolve_opts.transformPageChunk({
    html,
    done: true
  }) || "";
  if (!chunks) {
    headers2.set("etag", `"${hash(transformed)}"`);
  }
  return !chunks ? text(transformed, {
    status,
    headers: headers2
  }) : new Response(
    new ReadableStream({
      async start(controller) {
        controller.enqueue(encoder$1.encode(transformed + "\n"));
        for await (const chunk of chunks) {
          controller.enqueue(encoder$1.encode(chunk));
        }
        controller.close();
      },
      type: "bytes"
    }),
    {
      headers: {
        "content-type": "text/html"
      }
    }
  );
}
function get_data(event, options2, nodes, global) {
  let promise_id = 1;
  let count = 0;
  const { iterator, push, done } = create_async_iterator();
  function replacer2(thing) {
    if (typeof thing?.then === "function") {
      const id = promise_id++;
      count += 1;
      thing.then(
        /** @param {any} data */
        (data) => ({ data })
      ).catch(
        /** @param {any} error */
        async (error) => ({
          error: await handle_error_and_jsonify(event, options2, error)
        })
      ).then(
        /**
         * @param {{data: any; error: any}} result
         */
        async ({ data, error }) => {
          count -= 1;
          let str;
          try {
            str = devalue.uneval({ id, data, error }, replacer2);
          } catch (e) {
            error = await handle_error_and_jsonify(
              event,
              options2,
              new Error(`Failed to serialize promise while rendering ${event.route.id}`)
            );
            data = void 0;
            str = devalue.uneval({ id, data, error }, replacer2);
          }
          push(`<script>${global}.resolve(${str})<\/script>
`);
          if (count === 0)
            done();
        }
      );
      return `${global}.defer(${id})`;
    }
  }
  try {
    const strings = nodes.map((node) => {
      if (!node)
        return "null";
      return `{"type":"data","data":${devalue.uneval(node.data, replacer2)},${stringify_uses(node)}${node.slash ? `,"slash":${JSON.stringify(node.slash)}` : ""}}`;
    });
    return {
      data: `[${strings.join(",")}]`,
      chunks: count > 0 ? iterator : null
    };
  } catch (e) {
    throw new Error(clarify_devalue_error(
      event,
      /** @type {any} */
      e
    ));
  }
}
function get_option(nodes, option) {
  return nodes.reduce(
    (value, node) => {
      return (
        /** @type {Value} TypeScript's too dumb to understand this */
        node?.universal?.[option] ?? node?.server?.[option] ?? value
      );
    },
    /** @type {Value | undefined} */
    void 0
  );
}
async function respond_with_error({
  event,
  options: options2,
  manifest,
  state,
  status,
  error,
  resolve_opts
}) {
  if (event.request.headers.get("x-sveltekit-error")) {
    return static_error_page(
      options2,
      status,
      /** @type {Error} */
      error.message
    );
  }
  const fetched = [];
  try {
    const branch = [];
    const default_layout = await manifest._.nodes[0]();
    const ssr = get_option([default_layout], "ssr") ?? true;
    const csr = get_option([default_layout], "csr") ?? true;
    if (ssr) {
      state.error = true;
      const server_data_promise = load_server_data({
        event,
        state,
        node: default_layout,
        parent: async () => ({})
      });
      const server_data = await server_data_promise;
      const data = await load_data({
        event,
        fetched,
        node: default_layout,
        parent: async () => ({}),
        resolve_opts,
        server_data_promise,
        state,
        csr
      });
      branch.push(
        {
          node: default_layout,
          server_data,
          data
        },
        {
          node: await manifest._.nodes[1](),
          // 1 is always the root error
          data: null,
          server_data: null
        }
      );
    }
    return await render_response({
      options: options2,
      manifest,
      state,
      page_config: {
        ssr,
        csr
      },
      status,
      error: await handle_error_and_jsonify(event, options2, error),
      branch,
      fetched,
      event,
      resolve_opts
    });
  } catch (e) {
    if (e instanceof Redirect) {
      return redirect_response(e.status, e.location);
    }
    return static_error_page(
      options2,
      get_status(e),
      (await handle_error_and_jsonify(event, options2, e)).message
    );
  }
}
function once(fn) {
  let done = false;
  let result;
  return () => {
    if (done)
      return result;
    done = true;
    return result = fn();
  };
}
const encoder = new TextEncoder();
async function render_data(event, route, options2, manifest, state, invalidated_data_nodes, trailing_slash) {
  if (!route.page) {
    return new Response(void 0, {
      status: 404
    });
  }
  try {
    const node_ids = [...route.page.layouts, route.page.leaf];
    const invalidated = invalidated_data_nodes ?? node_ids.map(() => true);
    let aborted = false;
    const url = new URL(event.url);
    url.pathname = normalize_path(url.pathname, trailing_slash);
    const new_event = { ...event, url };
    const functions = node_ids.map((n, i) => {
      return once(async () => {
        try {
          if (aborted) {
            return (
              /** @type {import('types').ServerDataSkippedNode} */
              {
                type: "skip"
              }
            );
          }
          const node = n == void 0 ? n : await manifest._.nodes[n]();
          return load_server_data({
            event: new_event,
            state,
            node,
            parent: async () => {
              const data2 = {};
              for (let j = 0; j < i; j += 1) {
                const parent = (
                  /** @type {import('types').ServerDataNode | null} */
                  await functions[j]()
                );
                if (parent) {
                  Object.assign(data2, parent.data);
                }
              }
              return data2;
            }
          });
        } catch (e) {
          aborted = true;
          throw e;
        }
      });
    });
    const promises = functions.map(async (fn, i) => {
      if (!invalidated[i]) {
        return (
          /** @type {import('types').ServerDataSkippedNode} */
          {
            type: "skip"
          }
        );
      }
      return fn();
    });
    let length = promises.length;
    const nodes = await Promise.all(
      promises.map(
        (p, i) => p.catch(async (error) => {
          if (error instanceof Redirect) {
            throw error;
          }
          length = Math.min(length, i + 1);
          return (
            /** @type {import('types').ServerErrorNode} */
            {
              type: "error",
              error: await handle_error_and_jsonify(event, options2, error),
              status: error instanceof HttpError || error instanceof SvelteKitError ? error.status : void 0
            }
          );
        })
      )
    );
    const { data, chunks } = get_data_json(event, options2, nodes);
    if (!chunks) {
      return json_response(data);
    }
    return new Response(
      new ReadableStream({
        async start(controller) {
          controller.enqueue(encoder.encode(data));
          for await (const chunk of chunks) {
            controller.enqueue(encoder.encode(chunk));
          }
          controller.close();
        },
        type: "bytes"
      }),
      {
        headers: {
          // we use a proprietary content type to prevent buffering.
          // the `text` prefix makes it inspectable
          "content-type": "text/sveltekit-data",
          "cache-control": "private, no-store"
        }
      }
    );
  } catch (e) {
    const error = normalize_error(e);
    if (error instanceof Redirect) {
      return redirect_json_response(error);
    } else {
      return json_response(await handle_error_and_jsonify(event, options2, error), 500);
    }
  }
}
function json_response(json2, status = 200) {
  return text(typeof json2 === "string" ? json2 : JSON.stringify(json2), {
    status,
    headers: {
      "content-type": "application/json",
      "cache-control": "private, no-store"
    }
  });
}
function redirect_json_response(redirect) {
  return json_response({
    type: "redirect",
    location: redirect.location
  });
}
function get_data_json(event, options2, nodes) {
  let promise_id = 1;
  let count = 0;
  const { iterator, push, done } = create_async_iterator();
  const reducers = {
    /** @param {any} thing */
    Promise: (thing) => {
      if (typeof thing?.then === "function") {
        const id = promise_id++;
        count += 1;
        let key2 = "data";
        thing.catch(
          /** @param {any} e */
          async (e) => {
            key2 = "error";
            return handle_error_and_jsonify(
              event,
              options2,
              /** @type {any} */
              e
            );
          }
        ).then(
          /** @param {any} value */
          async (value) => {
            let str;
            try {
              str = devalue.stringify(value, reducers);
            } catch (e) {
              const error = await handle_error_and_jsonify(
                event,
                options2,
                new Error(`Failed to serialize promise while rendering ${event.route.id}`)
              );
              key2 = "error";
              str = devalue.stringify(error, reducers);
            }
            count -= 1;
            push(`{"type":"chunk","id":${id},"${key2}":${str}}
`);
            if (count === 0)
              done();
          }
        );
        return id;
      }
    }
  };
  try {
    const strings = nodes.map((node) => {
      if (!node)
        return "null";
      if (node.type === "error" || node.type === "skip") {
        return JSON.stringify(node);
      }
      return `{"type":"data","data":${devalue.stringify(node.data, reducers)},${stringify_uses(
        node
      )}${node.slash ? `,"slash":${JSON.stringify(node.slash)}` : ""}}`;
    });
    return {
      data: `{"type":"data","nodes":[${strings.join(",")}]}
`,
      chunks: count > 0 ? iterator : null
    };
  } catch (e) {
    throw new Error(clarify_devalue_error(
      event,
      /** @type {any} */
      e
    ));
  }
}
function load_page_nodes(page2, manifest) {
  return Promise.all([
    // we use == here rather than === because [undefined] serializes as "[null]"
    ...page2.layouts.map((n) => n == void 0 ? n : manifest._.nodes[n]()),
    manifest._.nodes[page2.leaf]()
  ]);
}
const MAX_DEPTH = 10;
async function render_page(event, page2, options2, manifest, state, resolve_opts) {
  if (state.depth > MAX_DEPTH) {
    return text(`Not found: ${event.url.pathname}`, {
      status: 404
      // TODO in some cases this should be 500. not sure how to differentiate
    });
  }
  if (is_action_json_request(event)) {
    const node = await manifest._.nodes[page2.leaf]();
    return handle_action_json_request(event, options2, node?.server);
  }
  try {
    const nodes = await load_page_nodes(page2, manifest);
    const leaf_node = (
      /** @type {import('types').SSRNode} */
      nodes.at(-1)
    );
    let status = 200;
    let action_result = void 0;
    if (is_action_request(event)) {
      action_result = await handle_action_request(event, leaf_node.server);
      if (action_result?.type === "redirect") {
        return redirect_response(action_result.status, action_result.location);
      }
      if (action_result?.type === "error") {
        status = get_status(action_result.error);
      }
      if (action_result?.type === "failure") {
        status = action_result.status;
      }
    }
    const should_prerender_data = nodes.some((node) => node?.server?.load);
    const data_pathname = add_data_suffix(event.url.pathname);
    const should_prerender = get_option(nodes, "prerender") ?? false;
    if (should_prerender) {
      const mod = leaf_node.server;
      if (mod?.actions) {
        throw new Error("Cannot prerender pages with actions");
      }
    } else if (state.prerendering) {
      return new Response(void 0, {
        status: 204
      });
    }
    state.prerender_default = should_prerender;
    const fetched = [];
    if (get_option(nodes, "ssr") === false && !(state.prerendering && should_prerender_data)) {
      return await render_response({
        branch: [],
        fetched,
        page_config: {
          ssr: false,
          csr: get_option(nodes, "csr") ?? true
        },
        status,
        error: null,
        event,
        options: options2,
        manifest,
        state,
        resolve_opts
      });
    }
    const branch = [];
    let load_error = null;
    const server_promises = nodes.map((node, i) => {
      if (load_error) {
        throw load_error;
      }
      return Promise.resolve().then(async () => {
        try {
          if (node === leaf_node && action_result?.type === "error") {
            throw action_result.error;
          }
          return await load_server_data({
            event,
            state,
            node,
            parent: async () => {
              const data = {};
              for (let j = 0; j < i; j += 1) {
                const parent = await server_promises[j];
                if (parent)
                  Object.assign(data, await parent.data);
              }
              return data;
            }
          });
        } catch (e) {
          load_error = /** @type {Error} */
          e;
          throw load_error;
        }
      });
    });
    const csr = get_option(nodes, "csr") ?? true;
    const load_promises = nodes.map((node, i) => {
      if (load_error)
        throw load_error;
      return Promise.resolve().then(async () => {
        try {
          return await load_data({
            event,
            fetched,
            node,
            parent: async () => {
              const data = {};
              for (let j = 0; j < i; j += 1) {
                Object.assign(data, await load_promises[j]);
              }
              return data;
            },
            resolve_opts,
            server_data_promise: server_promises[i],
            state,
            csr
          });
        } catch (e) {
          load_error = /** @type {Error} */
          e;
          throw load_error;
        }
      });
    });
    for (const p of server_promises)
      p.catch(() => {
      });
    for (const p of load_promises)
      p.catch(() => {
      });
    for (let i = 0; i < nodes.length; i += 1) {
      const node = nodes[i];
      if (node) {
        try {
          const server_data = await server_promises[i];
          const data = await load_promises[i];
          branch.push({ node, server_data, data });
        } catch (e) {
          const err = normalize_error(e);
          if (err instanceof Redirect) {
            if (state.prerendering && should_prerender_data) {
              const body2 = JSON.stringify({
                type: "redirect",
                location: err.location
              });
              state.prerendering.dependencies.set(data_pathname, {
                response: text(body2),
                body: body2
              });
            }
            return redirect_response(err.status, err.location);
          }
          const status2 = get_status(err);
          const error = await handle_error_and_jsonify(event, options2, err);
          while (i--) {
            if (page2.errors[i]) {
              const index = (
                /** @type {number} */
                page2.errors[i]
              );
              const node2 = await manifest._.nodes[index]();
              let j = i;
              while (!branch[j])
                j -= 1;
              return await render_response({
                event,
                options: options2,
                manifest,
                state,
                resolve_opts,
                page_config: { ssr: true, csr: true },
                status: status2,
                error,
                branch: compact(branch.slice(0, j + 1)).concat({
                  node: node2,
                  data: null,
                  server_data: null
                }),
                fetched
              });
            }
          }
          return static_error_page(options2, status2, error.message);
        }
      } else {
        branch.push(null);
      }
    }
    if (state.prerendering && should_prerender_data) {
      let { data, chunks } = get_data_json(
        event,
        options2,
        branch.map((node) => node?.server_data)
      );
      if (chunks) {
        for await (const chunk of chunks) {
          data += chunk;
        }
      }
      state.prerendering.dependencies.set(data_pathname, {
        response: text(data),
        body: data
      });
    }
    const ssr = get_option(nodes, "ssr") ?? true;
    return await render_response({
      event,
      options: options2,
      manifest,
      state,
      resolve_opts,
      page_config: {
        csr: get_option(nodes, "csr") ?? true,
        ssr
      },
      status,
      error: null,
      branch: ssr === false ? [] : compact(branch),
      action_result,
      fetched
    });
  } catch (e) {
    return await respond_with_error({
      event,
      options: options2,
      manifest,
      state,
      status: 500,
      error: e,
      resolve_opts
    });
  }
}
function exec(match, params, matchers) {
  const result = {};
  const values = match.slice(1);
  const values_needing_match = values.filter((value) => value !== void 0);
  let buffered = 0;
  for (let i = 0; i < params.length; i += 1) {
    const param = params[i];
    let value = values[i - buffered];
    if (param.chained && param.rest && buffered) {
      value = values.slice(i - buffered, i + 1).filter((s2) => s2).join("/");
      buffered = 0;
    }
    if (value === void 0) {
      if (param.rest)
        result[param.name] = "";
      continue;
    }
    if (!param.matcher || matchers[param.matcher](value)) {
      result[param.name] = value;
      const next_param = params[i + 1];
      const next_value = values[i + 1];
      if (next_param && !next_param.rest && next_param.optional && next_value && param.chained) {
        buffered = 0;
      }
      if (!next_param && !next_value && Object.keys(result).length === values_needing_match.length) {
        buffered = 0;
      }
      continue;
    }
    if (param.optional && param.chained) {
      buffered++;
      continue;
    }
    return;
  }
  if (buffered)
    return;
  return result;
}
function validate_options(options2) {
  if (options2?.path === void 0) {
    throw new Error("You must specify a `path` when setting, deleting or serializing cookies");
  }
}
function get_cookies(request, url, trailing_slash) {
  const header = request.headers.get("cookie") ?? "";
  const initial_cookies = parse(header, { decode: (value) => value });
  const normalized_url = normalize_path(url.pathname, trailing_slash);
  const new_cookies = {};
  const defaults = {
    httpOnly: true,
    sameSite: "lax",
    secure: url.hostname === "localhost" && url.protocol === "http:" ? false : true
  };
  const cookies = {
    // The JSDoc param annotations appearing below for get, set and delete
    // are necessary to expose the `cookie` library types to
    // typescript users. `@type {import('@sveltejs/kit').Cookies}` above is not
    // sufficient to do so.
    /**
     * @param {string} name
     * @param {import('cookie').CookieParseOptions} opts
     */
    get(name, opts) {
      const c = new_cookies[name];
      if (c && domain_matches(url.hostname, c.options.domain) && path_matches(url.pathname, c.options.path)) {
        return c.value;
      }
      const decoder = opts?.decode || decodeURIComponent;
      const req_cookies = parse(header, { decode: decoder });
      const cookie = req_cookies[name];
      return cookie;
    },
    /**
     * @param {import('cookie').CookieParseOptions} opts
     */
    getAll(opts) {
      const decoder = opts?.decode || decodeURIComponent;
      const cookies2 = parse(header, { decode: decoder });
      for (const c of Object.values(new_cookies)) {
        if (domain_matches(url.hostname, c.options.domain) && path_matches(url.pathname, c.options.path)) {
          cookies2[c.name] = c.value;
        }
      }
      return Object.entries(cookies2).map(([name, value]) => ({ name, value }));
    },
    /**
     * @param {string} name
     * @param {string} value
     * @param {import('./page/types.js').Cookie['options']} options
     */
    set(name, value, options2) {
      validate_options(options2);
      set_internal(name, value, { ...defaults, ...options2 });
    },
    /**
     * @param {string} name
     *  @param {import('./page/types.js').Cookie['options']} options
     */
    delete(name, options2) {
      validate_options(options2);
      cookies.set(name, "", { ...options2, maxAge: 0 });
    },
    /**
     * @param {string} name
     * @param {string} value
     *  @param {import('./page/types.js').Cookie['options']} options
     */
    serialize(name, value, options2) {
      validate_options(options2);
      let path = options2.path;
      if (!options2.domain || options2.domain === url.hostname) {
        path = resolve(normalized_url, path);
      }
      return serialize(name, value, { ...defaults, ...options2, path });
    }
  };
  function get_cookie_header(destination, header2) {
    const combined_cookies = {
      // cookies sent by the user agent have lowest precedence
      ...initial_cookies
    };
    for (const key2 in new_cookies) {
      const cookie = new_cookies[key2];
      if (!domain_matches(destination.hostname, cookie.options.domain))
        continue;
      if (!path_matches(destination.pathname, cookie.options.path))
        continue;
      const encoder2 = cookie.options.encode || encodeURIComponent;
      combined_cookies[cookie.name] = encoder2(cookie.value);
    }
    if (header2) {
      const parsed = parse(header2, { decode: (value) => value });
      for (const name in parsed) {
        combined_cookies[name] = parsed[name];
      }
    }
    return Object.entries(combined_cookies).map(([name, value]) => `${name}=${value}`).join("; ");
  }
  function set_internal(name, value, options2) {
    let path = options2.path;
    if (!options2.domain || options2.domain === url.hostname) {
      path = resolve(normalized_url, path);
    }
    new_cookies[name] = { name, value, options: { ...options2, path } };
  }
  return { cookies, new_cookies, get_cookie_header, set_internal };
}
function domain_matches(hostname, constraint) {
  if (!constraint)
    return true;
  const normalized = constraint[0] === "." ? constraint.slice(1) : constraint;
  if (hostname === normalized)
    return true;
  return hostname.endsWith("." + normalized);
}
function path_matches(path, constraint) {
  if (!constraint)
    return true;
  const normalized = constraint.endsWith("/") ? constraint.slice(0, -1) : constraint;
  if (path === normalized)
    return true;
  return path.startsWith(normalized + "/");
}
function add_cookies_to_headers(headers2, cookies) {
  for (const new_cookie of cookies) {
    const { name, value, options: options2 } = new_cookie;
    headers2.append("set-cookie", serialize(name, value, options2));
    if (options2.path.endsWith(".html")) {
      const path = add_data_suffix(options2.path);
      headers2.append("set-cookie", serialize(name, value, { ...options2, path }));
    }
  }
}
function create_fetch({ event, options: options2, manifest, state, get_cookie_header, set_internal }) {
  const server_fetch = async (info, init2) => {
    const original_request = normalize_fetch_input(info, init2, event.url);
    let mode = (info instanceof Request ? info.mode : init2?.mode) ?? "cors";
    let credentials = (info instanceof Request ? info.credentials : init2?.credentials) ?? "same-origin";
    return options2.hooks.handleFetch({
      event,
      request: original_request,
      fetch: async (info2, init3) => {
        const request = normalize_fetch_input(info2, init3, event.url);
        const url = new URL(request.url);
        if (!request.headers.has("origin")) {
          request.headers.set("origin", event.url.origin);
        }
        if (info2 !== original_request) {
          mode = (info2 instanceof Request ? info2.mode : init3?.mode) ?? "cors";
          credentials = (info2 instanceof Request ? info2.credentials : init3?.credentials) ?? "same-origin";
        }
        if ((request.method === "GET" || request.method === "HEAD") && (mode === "no-cors" && url.origin !== event.url.origin || url.origin === event.url.origin)) {
          request.headers.delete("origin");
        }
        if (url.origin !== event.url.origin) {
          if (`.${url.hostname}`.endsWith(`.${event.url.hostname}`) && credentials !== "omit") {
            const cookie = get_cookie_header(url, request.headers.get("cookie"));
            if (cookie)
              request.headers.set("cookie", cookie);
          }
          return fetch(request);
        }
        const prefix = assets || base;
        const decoded = decodeURIComponent(url.pathname);
        const filename = (decoded.startsWith(prefix) ? decoded.slice(prefix.length) : decoded).slice(1);
        const filename_html = `${filename}/index.html`;
        const is_asset = manifest.assets.has(filename);
        const is_asset_html = manifest.assets.has(filename_html);
        if (is_asset || is_asset_html) {
          const file = is_asset ? filename : filename_html;
          if (state.read) {
            const type = is_asset ? manifest.mimeTypes[filename.slice(filename.lastIndexOf("."))] : "text/html";
            return new Response(state.read(file), {
              headers: type ? { "content-type": type } : {}
            });
          }
          return await fetch(request);
        }
        if (credentials !== "omit") {
          const cookie = get_cookie_header(url, request.headers.get("cookie"));
          if (cookie) {
            request.headers.set("cookie", cookie);
          }
          const authorization = event.request.headers.get("authorization");
          if (authorization && !request.headers.has("authorization")) {
            request.headers.set("authorization", authorization);
          }
        }
        if (!request.headers.has("accept")) {
          request.headers.set("accept", "*/*");
        }
        if (!request.headers.has("accept-language")) {
          request.headers.set(
            "accept-language",
            /** @type {string} */
            event.request.headers.get("accept-language")
          );
        }
        const response = await respond(request, options2, manifest, {
          ...state,
          depth: state.depth + 1
        });
        const set_cookie = response.headers.get("set-cookie");
        if (set_cookie) {
          for (const str of set_cookie_parser.splitCookiesString(set_cookie)) {
            const { name, value, ...options3 } = set_cookie_parser.parseString(str);
            const path = options3.path ?? (url.pathname.split("/").slice(0, -1).join("/") || "/");
            set_internal(name, value, {
              path,
              .../** @type {import('cookie').CookieSerializeOptions} */
              options3
            });
          }
        }
        return response;
      }
    });
  };
  return (input, init2) => {
    const response = server_fetch(input, init2);
    response.catch(() => {
    });
    return response;
  };
}
function normalize_fetch_input(info, init2, url) {
  if (info instanceof Request) {
    return info;
  }
  return new Request(typeof info === "string" ? new URL(info, url) : info, init2);
}
function validator(expected) {
  function validate(module, file) {
    if (!module)
      return;
    for (const key2 in module) {
      if (key2[0] === "_" || expected.has(key2))
        continue;
      const values = [...expected.values()];
      const hint = hint_for_supported_files(key2, file?.slice(file.lastIndexOf("."))) ?? `valid exports are ${values.join(", ")}, or anything with a '_' prefix`;
      throw new Error(`Invalid export '${key2}'${file ? ` in ${file}` : ""} (${hint})`);
    }
  }
  return validate;
}
function hint_for_supported_files(key2, ext = ".js") {
  const supported_files = [];
  if (valid_layout_exports.has(key2)) {
    supported_files.push(`+layout${ext}`);
  }
  if (valid_page_exports.has(key2)) {
    supported_files.push(`+page${ext}`);
  }
  if (valid_layout_server_exports.has(key2)) {
    supported_files.push(`+layout.server${ext}`);
  }
  if (valid_page_server_exports.has(key2)) {
    supported_files.push(`+page.server${ext}`);
  }
  if (valid_server_exports.has(key2)) {
    supported_files.push(`+server${ext}`);
  }
  if (supported_files.length > 0) {
    return `'${key2}' is a valid export in ${supported_files.slice(0, -1).join(", ")}${supported_files.length > 1 ? " or " : ""}${supported_files.at(-1)}`;
  }
}
const valid_layout_exports = /* @__PURE__ */ new Set([
  "load",
  "prerender",
  "csr",
  "ssr",
  "trailingSlash",
  "config"
]);
const valid_page_exports = /* @__PURE__ */ new Set([...valid_layout_exports, "entries"]);
const valid_layout_server_exports = /* @__PURE__ */ new Set([...valid_layout_exports]);
const valid_page_server_exports = /* @__PURE__ */ new Set([...valid_layout_server_exports, "actions", "entries"]);
const valid_server_exports = /* @__PURE__ */ new Set([
  "GET",
  "POST",
  "PATCH",
  "PUT",
  "DELETE",
  "OPTIONS",
  "HEAD",
  "fallback",
  "prerender",
  "trailingSlash",
  "config",
  "entries"
]);
const validate_layout_exports = validator(valid_layout_exports);
const validate_page_exports = validator(valid_page_exports);
const validate_layout_server_exports = validator(valid_layout_server_exports);
const validate_page_server_exports = validator(valid_page_server_exports);
const validate_server_exports = validator(valid_server_exports);
let body;
let etag;
let headers;
function get_public_env(request) {
  body ??= `export const env=${JSON.stringify(public_env)}`;
  etag ??= `W/${Date.now()}`;
  headers ??= new Headers({
    "content-type": "application/javascript; charset=utf-8",
    etag
  });
  if (request.headers.get("if-none-match") === etag) {
    return new Response(void 0, { status: 304, headers });
  }
  return new Response(body, { headers });
}
function get_page_config(nodes) {
  let current = {};
  for (const node of nodes) {
    if (!node?.universal?.config && !node?.server?.config)
      continue;
    current = {
      ...current,
      ...node?.universal?.config,
      ...node?.server?.config
    };
  }
  return Object.keys(current).length ? current : void 0;
}
const default_transform = ({ html }) => html;
const default_filter = () => false;
const default_preload = ({ type }) => type === "js" || type === "css";
const page_methods = /* @__PURE__ */ new Set(["GET", "HEAD", "POST"]);
const allowed_page_methods = /* @__PURE__ */ new Set(["GET", "HEAD", "OPTIONS"]);
async function respond(request, options2, manifest, state) {
  const url = new URL(request.url);
  if (options2.csrf_check_origin) {
    const forbidden = is_form_content_type(request) && (request.method === "POST" || request.method === "PUT" || request.method === "PATCH" || request.method === "DELETE") && request.headers.get("origin") !== url.origin;
    if (forbidden) {
      const csrf_error = new HttpError(
        403,
        `Cross-site ${request.method} form submissions are forbidden`
      );
      if (request.headers.get("accept") === "application/json") {
        return json(csrf_error.body, { status: csrf_error.status });
      }
      return text(csrf_error.body.message, { status: csrf_error.status });
    }
  }
  let rerouted_path;
  try {
    rerouted_path = options2.hooks.reroute({ url: new URL(url) }) ?? url.pathname;
  } catch (e) {
    return text("Internal Server Error", {
      status: 500
    });
  }
  let decoded;
  try {
    decoded = decode_pathname(rerouted_path);
  } catch {
    return text("Malformed URI", { status: 400 });
  }
  let route = null;
  let params = {};
  if (base && !state.prerendering?.fallback) {
    if (!decoded.startsWith(base)) {
      return text("Not found", { status: 404 });
    }
    decoded = decoded.slice(base.length) || "/";
  }
  if (decoded === `/${options2.app_dir}/env.js`) {
    return get_public_env(request);
  }
  if (decoded.startsWith(`/${options2.app_dir}`)) {
    return text("Not found", { status: 404 });
  }
  const is_data_request = has_data_suffix(decoded);
  let invalidated_data_nodes;
  if (is_data_request) {
    decoded = strip_data_suffix(decoded) || "/";
    url.pathname = strip_data_suffix(url.pathname) + (url.searchParams.get(TRAILING_SLASH_PARAM) === "1" ? "/" : "") || "/";
    url.searchParams.delete(TRAILING_SLASH_PARAM);
    invalidated_data_nodes = url.searchParams.get(INVALIDATED_PARAM)?.split("").map((node) => node === "1");
    url.searchParams.delete(INVALIDATED_PARAM);
  }
  if (!state.prerendering?.fallback) {
    const matchers = await manifest._.matchers();
    for (const candidate of manifest._.routes) {
      const match = candidate.pattern.exec(decoded);
      if (!match)
        continue;
      const matched = exec(match, candidate.params, matchers);
      if (matched) {
        route = candidate;
        params = decode_params(matched);
        break;
      }
    }
  }
  let trailing_slash = void 0;
  const headers2 = {};
  let cookies_to_add = {};
  const event = {
    // @ts-expect-error `cookies` and `fetch` need to be created after the `event` itself
    cookies: null,
    // @ts-expect-error
    fetch: null,
    getClientAddress: state.getClientAddress || (() => {
      throw new Error(
        `${"@sveltejs/adapter-static"} does not specify getClientAddress. Please raise an issue`
      );
    }),
    locals: {},
    params,
    platform: state.platform,
    request,
    route: { id: route?.id ?? null },
    setHeaders: (new_headers) => {
      for (const key2 in new_headers) {
        const lower = key2.toLowerCase();
        const value = new_headers[key2];
        if (lower === "set-cookie") {
          throw new Error(
            "Use `event.cookies.set(name, value, options)` instead of `event.setHeaders` to set cookies"
          );
        } else if (lower in headers2) {
          throw new Error(`"${key2}" header is already set`);
        } else {
          headers2[lower] = value;
          if (state.prerendering && lower === "cache-control") {
            state.prerendering.cache = /** @type {string} */
            value;
          }
        }
      }
    },
    url,
    isDataRequest: is_data_request,
    isSubRequest: state.depth > 0
  };
  let resolve_opts = {
    transformPageChunk: default_transform,
    filterSerializedResponseHeaders: default_filter,
    preload: default_preload
  };
  try {
    if (route) {
      if (url.pathname === base || url.pathname === base + "/") {
        trailing_slash = "always";
      } else if (route.page) {
        const nodes = await load_page_nodes(route.page, manifest);
        if (DEV)
          ;
        trailing_slash = get_option(nodes, "trailingSlash");
      } else if (route.endpoint) {
        const node = await route.endpoint();
        trailing_slash = node.trailingSlash;
        if (DEV)
          ;
      }
      if (!is_data_request) {
        const normalized = normalize_path(url.pathname, trailing_slash ?? "never");
        if (normalized !== url.pathname && !state.prerendering?.fallback) {
          return new Response(void 0, {
            status: 308,
            headers: {
              "x-sveltekit-normalize": "1",
              location: (
                // ensure paths starting with '//' are not treated as protocol-relative
                (normalized.startsWith("//") ? url.origin + normalized : normalized) + (url.search === "?" ? "" : url.search)
              )
            }
          });
        }
      }
      if (state.before_handle || state.emulator?.platform) {
        let config = {};
        let prerender = false;
        if (route.endpoint) {
          const node = await route.endpoint();
          config = node.config ?? config;
          prerender = node.prerender ?? prerender;
        } else if (route.page) {
          const nodes = await load_page_nodes(route.page, manifest);
          config = get_page_config(nodes) ?? config;
          prerender = get_option(nodes, "prerender") ?? false;
        }
        if (state.before_handle) {
          state.before_handle(event, config, prerender);
        }
        if (state.emulator?.platform) {
          event.platform = await state.emulator.platform({ config, prerender });
        }
      }
    }
    const { cookies, new_cookies, get_cookie_header, set_internal } = get_cookies(
      request,
      url,
      trailing_slash ?? "never"
    );
    cookies_to_add = new_cookies;
    event.cookies = cookies;
    event.fetch = create_fetch({
      event,
      options: options2,
      manifest,
      state,
      get_cookie_header,
      set_internal
    });
    if (state.prerendering && !state.prerendering.fallback)
      disable_search(url);
    const response = await options2.hooks.handle({
      event,
      resolve: (event2, opts) => resolve2(event2, opts).then((response2) => {
        for (const key2 in headers2) {
          const value = headers2[key2];
          response2.headers.set(
            key2,
            /** @type {string} */
            value
          );
        }
        add_cookies_to_headers(response2.headers, Object.values(cookies_to_add));
        if (state.prerendering && event2.route.id !== null) {
          response2.headers.set("x-sveltekit-routeid", encodeURI(event2.route.id));
        }
        return response2;
      })
    });
    if (response.status === 200 && response.headers.has("etag")) {
      let if_none_match_value = request.headers.get("if-none-match");
      if (if_none_match_value?.startsWith('W/"')) {
        if_none_match_value = if_none_match_value.substring(2);
      }
      const etag2 = (
        /** @type {string} */
        response.headers.get("etag")
      );
      if (if_none_match_value === etag2) {
        const headers22 = new Headers({ etag: etag2 });
        for (const key2 of [
          "cache-control",
          "content-location",
          "date",
          "expires",
          "vary",
          "set-cookie"
        ]) {
          const value = response.headers.get(key2);
          if (value)
            headers22.set(key2, value);
        }
        return new Response(void 0, {
          status: 304,
          headers: headers22
        });
      }
    }
    if (is_data_request && response.status >= 300 && response.status <= 308) {
      const location = response.headers.get("location");
      if (location) {
        return redirect_json_response(new Redirect(
          /** @type {any} */
          response.status,
          location
        ));
      }
    }
    return response;
  } catch (e) {
    if (e instanceof Redirect) {
      const response = is_data_request ? redirect_json_response(e) : route?.page && is_action_json_request(event) ? action_json_redirect(e) : redirect_response(e.status, e.location);
      add_cookies_to_headers(response.headers, Object.values(cookies_to_add));
      return response;
    }
    return await handle_fatal_error(event, options2, e);
  }
  async function resolve2(event2, opts) {
    try {
      if (opts) {
        resolve_opts = {
          transformPageChunk: opts.transformPageChunk || default_transform,
          filterSerializedResponseHeaders: opts.filterSerializedResponseHeaders || default_filter,
          preload: opts.preload || default_preload
        };
      }
      if (state.prerendering?.fallback) {
        return await render_response({
          event: event2,
          options: options2,
          manifest,
          state,
          page_config: { ssr: false, csr: true },
          status: 200,
          error: null,
          branch: [],
          fetched: [],
          resolve_opts
        });
      }
      if (route) {
        const method = (
          /** @type {import('types').HttpMethod} */
          event2.request.method
        );
        let response;
        if (is_data_request) {
          response = await render_data(
            event2,
            route,
            options2,
            manifest,
            state,
            invalidated_data_nodes,
            trailing_slash ?? "never"
          );
        } else if (route.endpoint && (!route.page || is_endpoint_request(event2))) {
          response = await render_endpoint(event2, await route.endpoint(), state);
        } else if (route.page) {
          if (page_methods.has(method)) {
            response = await render_page(event2, route.page, options2, manifest, state, resolve_opts);
          } else {
            const allowed_methods2 = new Set(allowed_page_methods);
            const node = await manifest._.nodes[route.page.leaf]();
            if (node?.server?.actions) {
              allowed_methods2.add("POST");
            }
            if (method === "OPTIONS") {
              response = new Response(null, {
                status: 204,
                headers: {
                  allow: Array.from(allowed_methods2.values()).join(", ")
                }
              });
            } else {
              const mod = [...allowed_methods2].reduce(
                (acc, curr) => {
                  acc[curr] = true;
                  return acc;
                },
                /** @type {Record<string, any>} */
                {}
              );
              response = method_not_allowed(mod, method);
            }
          }
        } else {
          throw new Error("This should never happen");
        }
        if (request.method === "GET" && route.page && route.endpoint) {
          const vary = response.headers.get("vary")?.split(",")?.map((v) => v.trim().toLowerCase());
          if (!(vary?.includes("accept") || vary?.includes("*"))) {
            response = new Response(response.body, {
              status: response.status,
              statusText: response.statusText,
              headers: new Headers(response.headers)
            });
            response.headers.append("Vary", "Accept");
          }
        }
        return response;
      }
      if (state.error && event2.isSubRequest) {
        return await fetch(request, {
          headers: {
            "x-sveltekit-error": "true"
          }
        });
      }
      if (state.error) {
        return text("Internal Server Error", {
          status: 500
        });
      }
      if (state.depth === 0) {
        return await respond_with_error({
          event: event2,
          options: options2,
          manifest,
          state,
          status: 404,
          error: new SvelteKitError(404, "Not Found", `Not found: ${event2.url.pathname}`),
          resolve_opts
        });
      }
      if (state.prerendering) {
        return text("not found", { status: 404 });
      }
      return await fetch(request);
    } catch (e) {
      return await handle_fatal_error(event2, options2, e);
    } finally {
      event2.cookies.set = () => {
        throw new Error("Cannot use `cookies.set(...)` after the response has been generated");
      };
      event2.setHeaders = () => {
        throw new Error("Cannot use `setHeaders(...)` after the response has been generated");
      };
    }
  }
}
function afterUpdate() {
}
let prerendering = false;
function set_building() {
}
function set_prerendering() {
  prerendering = true;
}
const Root = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { stores } = $$props;
  let { page: page2 } = $$props;
  let { constructors } = $$props;
  let { components = [] } = $$props;
  let { form } = $$props;
  let { data_0 = null } = $$props;
  let { data_1 = null } = $$props;
  {
    setContext("__svelte__", stores);
  }
  afterUpdate(stores.page.notify);
  if ($$props.stores === void 0 && $$bindings.stores && stores !== void 0)
    $$bindings.stores(stores);
  if ($$props.page === void 0 && $$bindings.page && page2 !== void 0)
    $$bindings.page(page2);
  if ($$props.constructors === void 0 && $$bindings.constructors && constructors !== void 0)
    $$bindings.constructors(constructors);
  if ($$props.components === void 0 && $$bindings.components && components !== void 0)
    $$bindings.components(components);
  if ($$props.form === void 0 && $$bindings.form && form !== void 0)
    $$bindings.form(form);
  if ($$props.data_0 === void 0 && $$bindings.data_0 && data_0 !== void 0)
    $$bindings.data_0(data_0);
  if ($$props.data_1 === void 0 && $$bindings.data_1 && data_1 !== void 0)
    $$bindings.data_1(data_1);
  let $$settled;
  let $$rendered;
  let previous_head = $$result.head;
  do {
    $$settled = true;
    $$result.head = previous_head;
    {
      stores.page.set(page2);
    }
    $$rendered = `  ${constructors[1] ? `${validate_component(constructors[0] || missing_component, "svelte:component").$$render(
      $$result,
      { data: data_0, this: components[0] },
      {
        this: ($$value) => {
          components[0] = $$value;
          $$settled = false;
        }
      },
      {
        default: () => {
          return `${validate_component(constructors[1] || missing_component, "svelte:component").$$render(
            $$result,
            { data: data_1, form, this: components[1] },
            {
              this: ($$value) => {
                components[1] = $$value;
                $$settled = false;
              }
            },
            {}
          )}`;
        }
      }
    )}` : `${validate_component(constructors[0] || missing_component, "svelte:component").$$render(
      $$result,
      { data: data_0, form, this: components[0] },
      {
        this: ($$value) => {
          components[0] = $$value;
          $$settled = false;
        }
      },
      {}
    )}`} ${``}`;
  } while (!$$settled);
  return $$rendered;
});
function set_read_implementation(fn) {
}
function set_manifest(_) {
}
const options = {
  app_dir: "_app",
  app_template_contains_nonce: false,
  csp: { "mode": "auto", "directives": { "upgrade-insecure-requests": false, "block-all-mixed-content": false }, "reportOnly": { "upgrade-insecure-requests": false, "block-all-mixed-content": false } },
  csrf_check_origin: true,
  embedded: false,
  env_public_prefix: "PUBLIC_",
  env_private_prefix: "",
  hooks: null,
  // added lazily, via `get_hooks`
  preload_strategy: "modulepreload",
  root: Root,
  service_worker: false,
  templates: {
    app: ({ head, body: body2, assets: assets2, nonce, env }) => '<!doctype html>\n<html lang="en">\n  <head>\n    <meta charset="utf-8" />\n    <meta content="width=device-width, initial-scale=1" name="viewport" />\n\n    <title>OpenFPL</title>\n    <link href="https://openfpl.xyz" rel="canonical" />\n    <meta\n      content="OpenFPL is a decentralised fantasy football game on the Internet Computer blockchain."\n      name="description"\n    />\n    <meta content="OpenFPL" property="og:title" />\n    <meta\n      content="OpenFPL is a decentralised fantasy football game on the Internet Computer blockchain."\n      property="og:description"\n    />\n    <meta content="website" property="og:type" />\n    <meta content="https://openfpl.xyz" property="og:url" />\n    <meta content="https://openfpl.xyz/meta-share.jpg" property="og:image" />\n    <meta content="summary_large_image" name="twitter:card" />\n    <meta content="OpenFPL" name="twitter:title" />\n    <meta\n      content="OpenFPL is a decentralised fantasy football game on the Internet Computer blockchain."\n      name="twitter:description"\n    />\n    <meta content="https://openfpl.xyz/meta-share.jpg" name="twitter:image" />\n    <meta content="@beadle1989" name="twitter:creator" />\n\n    <link crossorigin="anonymous" href="/manifest.webmanifest" rel="manifest" />\n\n    <!-- Favicon -->\n    <link\n      rel="icon"\n      type="image/png"\n      sizes="32x32"\n      href="' + assets2 + '/favicons/favicon-32x32.png"\n    />\n    <link\n      rel="icon"\n      type="image/png"\n      sizes="16x16"\n      href="' + assets2 + '/favicons/favicon-16x16.png"\n    />\n    <link rel="shortcut icon" href="' + assets2 + '/favicons/favicon.ico" />\n\n    <!-- iOS meta tags & icons -->\n    <meta name="apple-mobile-web-app-capable" content="yes" />\n    <meta name="apple-mobile-web-app-status-bar-style" content="#2CE3A6" />\n    <meta name="apple-mobile-web-app-title" content="OpenFPL" />\n    <link\n      rel="apple-touch-icon"\n      href="' + assets2 + '/favicons/apple-touch-icon.png"\n    />\n    <link\n      rel="mask-icon"\n      href="' + assets2 + '/favicons/safari-pinned-tab.svg"\n      color="#2CE3A6"\n    />\n\n    <!-- MS -->\n    <meta name="msapplication-TileColor" content="#2CE3A6" />\n    <meta\n      name="msapplication-config"\n      content="' + assets2 + '/favicons/browserconfig.xml"\n    />\n\n    <meta content="#2CE3A6" name="theme-color" />\n    ' + head + '\n\n    <style>\n      html,\n      body {\n        height: 100%;\n        margin: 0;\n      }\n\n      @font-face {\n        font-display: swap;\n        font-family: "Poppins";\n        font-style: normal;\n        font-weight: 400;\n        src: url("' + assets2 + '/poppins-regular-webfont.woff2")\n          format("woff2");\n      }\n\n      @font-face {\n        font-display: swap;\n        font-family: "Manrope";\n        font-style: normal;\n        font-weight: 400;\n        src: url("' + assets2 + '/Manrope-Regular.woff2") format("woff2");\n      }\n      body {\n        font-family: "Poppins", sans-serif !important;\n        color: white !important;\n        background-color: #1a1a1d;\n        height: 100vh;\n        margin: 0;\n        background-image: url("' + assets2 + '/background.jpg");\n        background-size: cover;\n        background-position: center;\n        background-repeat: no-repeat;\n        background-attachment: fixed;\n      }\n\n      #app-spinner {\n        --spinner-size: 30px;\n\n        width: var(--spinner-size);\n        height: var(--spinner-size);\n\n        animation: app-spinner-linear-rotate 2000ms linear infinite;\n\n        position: absolute;\n        top: calc(50% - (var(--spinner-size) / 2));\n        left: calc(50% - (var(--spinner-size) / 2));\n\n        --radius: 45px;\n        --circumference: calc(3.14159265359 * var(--radius) * 2);\n\n        --start: calc((1 - 0.05) * var(--circumference));\n        --end: calc((1 - 0.8) * var(--circumference));\n      }\n\n      #app-spinner circle {\n        stroke-dasharray: var(--circumference);\n        stroke-width: 10%;\n        transform-origin: 50% 50% 0;\n\n        transition-property: stroke;\n\n        animation-name: app-spinner-stroke-rotate-100;\n        animation-duration: 4000ms;\n        animation-timing-function: cubic-bezier(0.35, 0, 0.25, 1);\n        animation-iteration-count: infinite;\n\n        fill: transparent;\n        stroke: currentColor;\n\n        transition: stroke-dashoffset 225ms linear;\n      }\n\n      @keyframes app-spinner-linear-rotate {\n        0% {\n          transform: rotate(0deg);\n        }\n        100% {\n          transform: rotate(360deg);\n        }\n      }\n\n      @keyframes app-spinner-stroke-rotate-100 {\n        0% {\n          stroke-dashoffset: var(--start);\n          transform: rotate(0);\n        }\n        12.5% {\n          stroke-dashoffset: var(--end);\n          transform: rotate(0);\n        }\n        12.5001% {\n          stroke-dashoffset: var(--end);\n          transform: rotateX(180deg) rotate(72.5deg);\n        }\n        25% {\n          stroke-dashoffset: var(--start);\n          transform: rotateX(180deg) rotate(72.5deg);\n        }\n\n        25.0001% {\n          stroke-dashoffset: var(--start);\n          transform: rotate(270deg);\n        }\n        37.5% {\n          stroke-dashoffset: var(--end);\n          transform: rotate(270deg);\n        }\n        37.5001% {\n          stroke-dashoffset: var(--end);\n          transform: rotateX(180deg) rotate(161.5deg);\n        }\n        50% {\n          stroke-dashoffset: var(--start);\n          transform: rotateX(180deg) rotate(161.5deg);\n        }\n\n        50.0001% {\n          stroke-dashoffset: var(--start);\n          transform: rotate(180deg);\n        }\n        62.5% {\n          stroke-dashoffset: var(--end);\n          transform: rotate(180deg);\n        }\n        62.5001% {\n          stroke-dashoffset: var(--end);\n          transform: rotateX(180deg) rotate(251.5deg);\n        }\n        75% {\n          stroke-dashoffset: var(--start);\n          transform: rotateX(180deg) rotate(251.5deg);\n        }\n\n        75.0001% {\n          stroke-dashoffset: var(--start);\n          transform: rotate(90deg);\n        }\n        87.5% {\n          stroke-dashoffset: var(--end);\n          transform: rotate(90deg);\n        }\n        87.5001% {\n          stroke-dashoffset: var(--end);\n          transform: rotateX(180deg) rotate(341.5deg);\n        }\n        100% {\n          stroke-dashoffset: var(--start);\n          transform: rotateX(180deg) rotate(341.5deg);\n        }\n      }\n    </style>\n  </head>\n  <body data-sveltekit-preload-data="hover">\n    <div style="display: contents">' + body2 + '</div>\n\n    <svg\n      id="app-spinner"\n      preserveAspectRatio="xMidYMid meet"\n      focusable="false"\n      aria-hidden="true"\n      data-tid="spinner"\n      viewBox="0 0 100 100"\n    >\n      <circle cx="50%" cy="50%" r="45" />\n    </svg>\n  </body>\n</html>\n',
    error: ({ status, message }) => '<!doctype html>\n<html lang="en">\n	<head>\n		<meta charset="utf-8" />\n		<title>' + message + `</title>

		<style>
			body {
				--bg: white;
				--fg: #222;
				--divider: #ccc;
				background: var(--bg);
				color: var(--fg);
				font-family:
					system-ui,
					-apple-system,
					BlinkMacSystemFont,
					'Segoe UI',
					Roboto,
					Oxygen,
					Ubuntu,
					Cantarell,
					'Open Sans',
					'Helvetica Neue',
					sans-serif;
				display: flex;
				align-items: center;
				justify-content: center;
				height: 100vh;
				margin: 0;
			}

			.error {
				display: flex;
				align-items: center;
				max-width: 32rem;
				margin: 0 1rem;
			}

			.status {
				font-weight: 200;
				font-size: 3rem;
				line-height: 1;
				position: relative;
				top: -0.05rem;
			}

			.message {
				border-left: 1px solid var(--divider);
				padding: 0 0 0 1rem;
				margin: 0 0 0 1rem;
				min-height: 2.5rem;
				display: flex;
				align-items: center;
			}

			.message h1 {
				font-weight: 400;
				font-size: 1em;
				margin: 0;
			}

			@media (prefers-color-scheme: dark) {
				body {
					--bg: #222;
					--fg: #ddd;
					--divider: #666;
				}
			}
		</style>
	</head>
	<body>
		<div class="error">
			<span class="status">` + status + '</span>\n			<div class="message">\n				<h1>' + message + "</h1>\n			</div>\n		</div>\n	</body>\n</html>\n"
  },
  version_hash: "1g3neil"
};
async function get_hooks() {
  return {};
}
function filter_private_env(env, { public_prefix, private_prefix }) {
  return Object.fromEntries(
    Object.entries(env).filter(
      ([k]) => k.startsWith(private_prefix) && (public_prefix === "" || !k.startsWith(public_prefix))
    )
  );
}
function filter_public_env(env, { public_prefix, private_prefix }) {
  return Object.fromEntries(
    Object.entries(env).filter(
      ([k]) => k.startsWith(public_prefix) && (private_prefix === "" || !k.startsWith(private_prefix))
    )
  );
}
const prerender_env_handler = {
  get({ type }, prop) {
    throw new Error(
      `Cannot read values from $env/dynamic/${type} while prerendering (attempted to read env.${prop.toString()}). Use $env/static/${type} instead`
    );
  }
};
class Server {
  /** @type {import('types').SSROptions} */
  #options;
  /** @type {import('@sveltejs/kit').SSRManifest} */
  #manifest;
  /** @param {import('@sveltejs/kit').SSRManifest} manifest */
  constructor(manifest) {
    this.#options = options;
    this.#manifest = manifest;
  }
  /**
   * @param {{
   *   env: Record<string, string>;
   *   read?: (file: string) => ReadableStream;
   * }} opts
   */
  async init({ env, read }) {
    const prefixes = {
      public_prefix: this.#options.env_public_prefix,
      private_prefix: this.#options.env_private_prefix
    };
    const private_env = filter_private_env(env, prefixes);
    const public_env2 = filter_public_env(env, prefixes);
    set_private_env(
      prerendering ? new Proxy({ type: "private" }, prerender_env_handler) : private_env
    );
    set_public_env(
      prerendering ? new Proxy({ type: "public" }, prerender_env_handler) : public_env2
    );
    set_safe_public_env(public_env2);
    if (!this.#options.hooks) {
      try {
        const module = await get_hooks();
        this.#options.hooks = {
          handle: module.handle || (({ event, resolve: resolve2 }) => resolve2(event)),
          handleError: module.handleError || (({ error }) => console.error(error)),
          handleFetch: module.handleFetch || (({ request, fetch: fetch2 }) => fetch2(request)),
          reroute: module.reroute || (() => {
          })
        };
      } catch (error) {
        {
          throw error;
        }
      }
    }
  }
  /**
   * @param {Request} request
   * @param {import('types').RequestOptions} options
   */
  async respond(request, options2) {
    return respond(request, this.#options, this.#manifest, {
      ...options2,
      error: false,
      depth: 0
    });
  }
}
const Layout$1 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${slots.default ? slots.default({}) : ``}`;
});
function get(key2, parse2 = JSON.parse) {
  try {
    return parse2(sessionStorage[key2]);
  } catch {
  }
}
const SNAPSHOT_KEY = "sveltekit:snapshot";
const SCROLL_KEY = "sveltekit:scroll";
get(SCROLL_KEY) ?? {};
get(SNAPSHOT_KEY) ?? {};
function goto(url, opts = {}) {
  {
    throw new Error("Cannot call goto(...) on the server");
  }
}
const getStores = () => {
  const stores = getContext("__svelte__");
  return {
    /** @type {typeof page} */
    page: {
      subscribe: stores.page.subscribe
    },
    /** @type {typeof navigating} */
    navigating: {
      subscribe: stores.navigating.subscribe
    },
    /** @type {typeof updated} */
    updated: stores.updated
  };
};
const page = {
  subscribe(fn) {
    const store = getStores().page;
    return store.subscribe(fn);
  }
};
const Error$1 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $page, $$unsubscribe_page;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  $$unsubscribe_page();
  return `<h1>${escape($page.status)}</h1> <p>${escape($page.error?.message)}</p>`;
});
const AUTH_MAX_TIME_TO_LIVE = BigInt(
  60 * 60 * 1e3 * 1e3 * 1e3 * 24 * 14
);
const AUTH_POPUP_WIDTH = 576;
const AUTH_POPUP_HEIGHT = 625;
const createAuthClient = () => AuthClient.create({
  idleOptions: {
    disableIdle: true,
    disableDefaultIdleCallback: true
  }
});
const popupCenter = ({
  width,
  height
}) => {
  {
    return void 0;
  }
};
let authClient;
const NNS_IC_ORG_ALTERNATIVE_ORIGIN = "https://openfpl.xyz";
const NNS_IC_APP_DERIVATION_ORIGIN = "https://bgpwv-eqaaa-aaaal-qb6eq-cai.icp0.io";
const isNnsAlternativeOrigin = () => {
  return window.location.origin === NNS_IC_ORG_ALTERNATIVE_ORIGIN;
};
const initAuthStore = () => {
  const { subscribe: subscribe2, set, update } = writable({
    identity: void 0
  });
  return {
    subscribe: subscribe2,
    sync: async () => {
      authClient = authClient ?? await createAuthClient();
      const isAuthenticated = await authClient.isAuthenticated();
      set({
        identity: isAuthenticated ? authClient.getIdentity() : null
      });
    },
    signIn: ({ domain }) => (
      // eslint-disable-next-line no-async-promise-executor
      new Promise(async (resolve2, reject) => {
        authClient = authClient ?? await createAuthClient();
        const identityProvider = domain;
        await authClient?.login({
          maxTimeToLive: AUTH_MAX_TIME_TO_LIVE,
          onSuccess: () => {
            update((state) => ({
              ...state,
              identity: authClient?.getIdentity()
            }));
            resolve2();
          },
          onError: reject,
          identityProvider,
          ...isNnsAlternativeOrigin() && {
            derivationOrigin: NNS_IC_APP_DERIVATION_ORIGIN
          },
          windowOpenerFeatures: popupCenter({
            width: AUTH_POPUP_WIDTH,
            height: AUTH_POPUP_HEIGHT
          })
        });
      })
    ),
    signOut: async () => {
      const client = authClient ?? await createAuthClient();
      await client.logout();
      authClient = null;
      update((state) => ({
        ...state,
        identity: null
      }));
      localStorage.removeItem("user_profile_data");
    }
  };
};
const authStore = initAuthStore();
const idlFactory = ({ IDL }) => {
  const CanisterId = IDL.Text;
  const Error2 = IDL.Variant({
    "DecodeError": IDL.Null,
    "NotAllowed": IDL.Null,
    "NotFound": IDL.Null,
    "NotAuthorized": IDL.Null,
    "InvalidData": IDL.Null,
    "SystemOnHold": IDL.Null,
    "AlreadyExists": IDL.Null,
    "CanisterCreateError": IDL.Null,
    "InvalidTeamError": IDL.Null
  });
  const Result = IDL.Variant({ "ok": IDL.Null, "err": Error2 });
  const TokenId = IDL.Nat16;
  const EntryRequirement = IDL.Variant({
    "InviteOnly": IDL.Null,
    "PaidEntry": IDL.Null,
    "PaidInviteEntry": IDL.Null,
    "FreeEntry": IDL.Null
  });
  const PaymentChoice = IDL.Variant({ "FPL": IDL.Null, "ICP": IDL.Null });
  const CreatePrivateLeagueDTO = IDL.Record({
    "tokenId": TokenId,
    "adminFee": IDL.Nat8,
    "name": IDL.Text,
    "banner": IDL.Opt(IDL.Vec(IDL.Nat8)),
    "entryRequirement": EntryRequirement,
    "entrants": IDL.Nat16,
    "photo": IDL.Opt(IDL.Vec(IDL.Nat8)),
    "entryFee": IDL.Nat,
    "paymentChoice": PaymentChoice,
    "termsAgreed": IDL.Bool
  });
  const SeasonId = IDL.Nat16;
  const FixtureStatusType = IDL.Variant({
    "Unplayed": IDL.Null,
    "Finalised": IDL.Null,
    "Active": IDL.Null,
    "Complete": IDL.Null
  });
  const ClubId = IDL.Nat16;
  const FixtureId = IDL.Nat32;
  const PlayerEventType = IDL.Variant({
    "PenaltyMissed": IDL.Null,
    "Goal": IDL.Null,
    "GoalConceded": IDL.Null,
    "Appearance": IDL.Null,
    "PenaltySaved": IDL.Null,
    "RedCard": IDL.Null,
    "KeeperSave": IDL.Null,
    "CleanSheet": IDL.Null,
    "YellowCard": IDL.Null,
    "GoalAssisted": IDL.Null,
    "OwnGoal": IDL.Null,
    "HighestScoringPlayer": IDL.Null
  });
  const PlayerEventData = IDL.Record({
    "fixtureId": FixtureId,
    "clubId": ClubId,
    "playerId": IDL.Nat16,
    "eventStartMinute": IDL.Nat8,
    "eventEndMinute": IDL.Nat8,
    "eventType": PlayerEventType
  });
  const GameweekNumber = IDL.Nat8;
  const FixtureDTO = IDL.Record({
    "id": IDL.Nat32,
    "status": FixtureStatusType,
    "highestScoringPlayerId": IDL.Nat16,
    "seasonId": SeasonId,
    "awayClubId": ClubId,
    "events": IDL.Vec(PlayerEventData),
    "homeClubId": ClubId,
    "kickOff": IDL.Int,
    "homeGoals": IDL.Nat8,
    "gameweek": GameweekNumber,
    "awayGoals": IDL.Nat8
  });
  const AddInitialFixturesDTO = IDL.Record({
    "seasonId": SeasonId,
    "seasonFixtures": IDL.Vec(FixtureDTO)
  });
  const NewTokenDTO = IDL.Record({
    "fee": IDL.Nat,
    "ticker": IDL.Text,
    "tokenImageURL": IDL.Text,
    "canisterId": CanisterId
  });
  const CountryId = IDL.Nat16;
  const PlayerPosition = IDL.Variant({
    "Goalkeeper": IDL.Null,
    "Midfielder": IDL.Null,
    "Forward": IDL.Null,
    "Defender": IDL.Null
  });
  const CreatePlayerDTO = IDL.Record({
    "clubId": ClubId,
    "valueQuarterMillions": IDL.Nat16,
    "dateOfBirth": IDL.Int,
    "nationality": CountryId,
    "shirtNumber": IDL.Nat8,
    "position": PlayerPosition,
    "lastName": IDL.Text,
    "firstName": IDL.Text
  });
  const PlayerId = IDL.Nat16;
  const LoanPlayerDTO = IDL.Record({
    "loanEndDate": IDL.Int,
    "playerId": PlayerId,
    "loanClubId": ClubId
  });
  const Spawn = IDL.Record({
    "percentage_to_spawn": IDL.Opt(IDL.Nat32),
    "new_controller": IDL.Opt(IDL.Principal),
    "nonce": IDL.Opt(IDL.Nat64)
  });
  const NeuronId = IDL.Record({ "id": IDL.Nat64 });
  const Follow = IDL.Record({
    "topic": IDL.Int32,
    "followees": IDL.Vec(NeuronId)
  });
  const ClaimOrRefreshNeuronFromAccount = IDL.Record({
    "controller": IDL.Opt(IDL.Principal),
    "memo": IDL.Nat64
  });
  const By = IDL.Variant({
    "NeuronIdOrSubaccount": IDL.Null,
    "MemoAndController": ClaimOrRefreshNeuronFromAccount,
    "Memo": IDL.Nat64
  });
  const ClaimOrRefresh = IDL.Record({ "by": IDL.Opt(By) });
  const ChangeAutoStakeMaturity = IDL.Record({
    "requested_setting_for_auto_stake_maturity": IDL.Bool
  });
  const IncreaseDissolveDelay = IDL.Record({
    "additional_dissolve_delay_seconds": IDL.Nat32
  });
  const SetDissolveTimestamp = IDL.Record({
    "dissolve_timestamp_seconds": IDL.Nat64
  });
  const Operation = IDL.Variant({
    "ChangeAutoStakeMaturity": ChangeAutoStakeMaturity,
    "StopDissolving": IDL.Null,
    "StartDissolving": IDL.Null,
    "IncreaseDissolveDelay": IncreaseDissolveDelay,
    "SetDissolveTimestamp": SetDissolveTimestamp
  });
  const Configure = IDL.Record({ "operation": IDL.Opt(Operation) });
  const StakeMaturityResponse = IDL.Record({
    "maturity_e8s": IDL.Nat64,
    "stake_maturity_e8s": IDL.Nat64
  });
  const AccountIdentifier = IDL.Record({ "hash": IDL.Vec(IDL.Nat8) });
  const Amount = IDL.Record({ "e8s": IDL.Nat64 });
  const Disburse = IDL.Record({
    "to_account": IDL.Opt(AccountIdentifier),
    "amount": IDL.Opt(Amount)
  });
  const Command = IDL.Variant({
    "Spawn": Spawn,
    "Follow": Follow,
    "ClaimOrRefresh": ClaimOrRefresh,
    "Configure": Configure,
    "StakeMaturity": StakeMaturityResponse,
    "Disburse": Disburse
  });
  const MoveFixtureDTO = IDL.Record({
    "fixtureId": FixtureId,
    "updatedFixtureGameweek": GameweekNumber,
    "updatedFixtureDate": IDL.Int
  });
  const PostponeFixtureDTO = IDL.Record({ "fixtureId": FixtureId });
  const PromoteFormerClubDTO = IDL.Record({ "clubId": ClubId });
  const ShirtType = IDL.Variant({ "Filled": IDL.Null, "Striped": IDL.Null });
  const PromoteNewClubDTO = IDL.Record({
    "secondaryColourHex": IDL.Text,
    "name": IDL.Text,
    "friendlyName": IDL.Text,
    "thirdColourHex": IDL.Text,
    "abbreviatedName": IDL.Text,
    "shirtType": ShirtType,
    "primaryColourHex": IDL.Text
  });
  const RecallPlayerDTO = IDL.Record({ "playerId": PlayerId });
  const RescheduleFixtureDTO = IDL.Record({
    "postponedFixtureId": FixtureId,
    "updatedFixtureGameweek": GameweekNumber,
    "updatedFixtureDate": IDL.Int
  });
  const RetirePlayerDTO = IDL.Record({
    "playerId": PlayerId,
    "retirementDate": IDL.Int
  });
  const RevaluePlayerDownDTO = IDL.Record({ "playerId": PlayerId });
  const RevaluePlayerUpDTO = IDL.Record({ "playerId": PlayerId });
  const SetPlayerInjuryDTO = IDL.Record({
    "playerId": PlayerId,
    "description": IDL.Text,
    "expectedEndDate": IDL.Int
  });
  const SubmitFixtureDataDTO = IDL.Record({
    "fixtureId": FixtureId,
    "seasonId": SeasonId,
    "gameweek": GameweekNumber,
    "playerEventData": IDL.Vec(PlayerEventData)
  });
  const TransferPlayerDTO = IDL.Record({
    "playerId": PlayerId,
    "newClubId": ClubId
  });
  const UnretirePlayerDTO = IDL.Record({ "playerId": PlayerId });
  const UpdateClubDTO = IDL.Record({
    "clubId": ClubId,
    "secondaryColourHex": IDL.Text,
    "name": IDL.Text,
    "friendlyName": IDL.Text,
    "thirdColourHex": IDL.Text,
    "abbreviatedName": IDL.Text,
    "shirtType": ShirtType,
    "primaryColourHex": IDL.Text
  });
  const UpdatePlayerDTO = IDL.Record({
    "dateOfBirth": IDL.Int,
    "playerId": PlayerId,
    "nationality": CountryId,
    "shirtNumber": IDL.Nat8,
    "position": PlayerPosition,
    "lastName": IDL.Text,
    "firstName": IDL.Text
  });
  const ClubDTO = IDL.Record({
    "id": ClubId,
    "secondaryColourHex": IDL.Text,
    "name": IDL.Text,
    "friendlyName": IDL.Text,
    "thirdColourHex": IDL.Text,
    "abbreviatedName": IDL.Text,
    "shirtType": ShirtType,
    "primaryColourHex": IDL.Text
  });
  const Result_20 = IDL.Variant({ "ok": IDL.Vec(ClubDTO), "err": Error2 });
  const CountryDTO = IDL.Record({
    "id": CountryId,
    "code": IDL.Text,
    "name": IDL.Text
  });
  const Result_23 = IDL.Variant({ "ok": IDL.Vec(CountryDTO), "err": Error2 });
  const PickTeamDTO = IDL.Record({
    "playerIds": IDL.Vec(PlayerId),
    "countrymenCountryId": CountryId,
    "username": IDL.Text,
    "goalGetterPlayerId": PlayerId,
    "hatTrickHeroGameweek": GameweekNumber,
    "transfersAvailable": IDL.Nat8,
    "teamBoostGameweek": GameweekNumber,
    "captainFantasticGameweek": GameweekNumber,
    "countrymenGameweek": GameweekNumber,
    "bankQuarterMillions": IDL.Nat16,
    "noEntryPlayerId": PlayerId,
    "safeHandsPlayerId": PlayerId,
    "braceBonusGameweek": GameweekNumber,
    "passMasterGameweek": GameweekNumber,
    "teamBoostClubId": ClubId,
    "goalGetterGameweek": GameweekNumber,
    "captainFantasticPlayerId": PlayerId,
    "transferWindowGameweek": GameweekNumber,
    "noEntryGameweek": GameweekNumber,
    "prospectsGameweek": GameweekNumber,
    "safeHandsGameweek": GameweekNumber,
    "principalId": IDL.Text,
    "passMasterPlayerId": PlayerId,
    "captainId": PlayerId,
    "monthlyBonusesAvailable": IDL.Nat8
  });
  const Result_22 = IDL.Variant({ "ok": PickTeamDTO, "err": Error2 });
  const DataCacheDTO = IDL.Record({ "hash": IDL.Text, "category": IDL.Text });
  const Result_21 = IDL.Variant({
    "ok": IDL.Vec(DataCacheDTO),
    "err": Error2
  });
  const GetFixturesDTO = IDL.Record({ "seasonId": SeasonId });
  const Result_14 = IDL.Variant({ "ok": IDL.Vec(FixtureDTO), "err": Error2 });
  const ClubFilterDTO = IDL.Record({ "clubId": ClubId });
  const PlayerStatus = IDL.Variant({
    "OnLoan": IDL.Null,
    "Former": IDL.Null,
    "Active": IDL.Null,
    "Retired": IDL.Null
  });
  const PlayerDTO = IDL.Record({
    "id": IDL.Nat16,
    "status": PlayerStatus,
    "clubId": ClubId,
    "valueQuarterMillions": IDL.Nat16,
    "dateOfBirth": IDL.Int,
    "nationality": CountryId,
    "shirtNumber": IDL.Nat8,
    "totalPoints": IDL.Int16,
    "position": PlayerPosition,
    "lastName": IDL.Text,
    "firstName": IDL.Text
  });
  const Result_9 = IDL.Variant({ "ok": IDL.Vec(PlayerDTO), "err": Error2 });
  const GetManagerDTO = IDL.Record({ "managerId": IDL.Text });
  const CalendarMonth = IDL.Nat8;
  const FantasyTeamSnapshot = IDL.Record({
    "playerIds": IDL.Vec(PlayerId),
    "month": CalendarMonth,
    "teamValueQuarterMillions": IDL.Nat16,
    "countrymenCountryId": CountryId,
    "username": IDL.Text,
    "goalGetterPlayerId": PlayerId,
    "hatTrickHeroGameweek": GameweekNumber,
    "transfersAvailable": IDL.Nat8,
    "teamBoostGameweek": GameweekNumber,
    "captainFantasticGameweek": GameweekNumber,
    "countrymenGameweek": GameweekNumber,
    "bankQuarterMillions": IDL.Nat16,
    "noEntryPlayerId": PlayerId,
    "monthlyPoints": IDL.Int16,
    "safeHandsPlayerId": PlayerId,
    "seasonId": SeasonId,
    "braceBonusGameweek": GameweekNumber,
    "favouriteClubId": ClubId,
    "passMasterGameweek": GameweekNumber,
    "teamBoostClubId": ClubId,
    "goalGetterGameweek": GameweekNumber,
    "captainFantasticPlayerId": PlayerId,
    "gameweek": GameweekNumber,
    "seasonPoints": IDL.Int16,
    "transferWindowGameweek": GameweekNumber,
    "noEntryGameweek": GameweekNumber,
    "prospectsGameweek": GameweekNumber,
    "safeHandsGameweek": GameweekNumber,
    "principalId": IDL.Text,
    "passMasterPlayerId": PlayerId,
    "captainId": PlayerId,
    "points": IDL.Int16,
    "monthlyBonusesAvailable": IDL.Nat8
  });
  const ManagerDTO = IDL.Record({
    "username": IDL.Text,
    "weeklyPosition": IDL.Int,
    "createDate": IDL.Int,
    "monthlyPoints": IDL.Int16,
    "weeklyPoints": IDL.Int16,
    "weeklyPositionText": IDL.Text,
    "gameweeks": IDL.Vec(FantasyTeamSnapshot),
    "favouriteClubId": ClubId,
    "monthlyPosition": IDL.Int,
    "seasonPosition": IDL.Int,
    "monthlyPositionText": IDL.Text,
    "privateLeagueMemberships": IDL.Vec(CanisterId),
    "profilePicture": IDL.Opt(IDL.Vec(IDL.Nat8)),
    "seasonPoints": IDL.Int16,
    "principalId": IDL.Text,
    "seasonPositionText": IDL.Text
  });
  const Result_1 = IDL.Variant({ "ok": ManagerDTO, "err": Error2 });
  const ManagerPrivateLeagueDTO = IDL.Record({
    "created": IDL.Int,
    "name": IDL.Text,
    "memberCount": IDL.Int,
    "seasonPosition": IDL.Nat,
    "seasonPositionText": IDL.Text,
    "canisterId": CanisterId
  });
  const ManagerPrivateLeaguesDTO = IDL.Record({
    "totalEntries": IDL.Nat,
    "entries": IDL.Vec(ManagerPrivateLeagueDTO)
  });
  const Result_19 = IDL.Variant({
    "ok": ManagerPrivateLeaguesDTO,
    "err": Error2
  });
  const GetMonthlyLeaderboardDTO = IDL.Record({
    "month": CalendarMonth,
    "clubId": ClubId,
    "offset": IDL.Nat,
    "seasonId": SeasonId,
    "limit": IDL.Nat,
    "searchTerm": IDL.Text
  });
  const LeaderboardEntry = IDL.Record({
    "username": IDL.Text,
    "positionText": IDL.Text,
    "position": IDL.Nat,
    "principalId": IDL.Text,
    "points": IDL.Int16
  });
  const MonthlyLeaderboardDTO = IDL.Record({
    "month": IDL.Nat8,
    "totalEntries": IDL.Nat,
    "seasonId": SeasonId,
    "entries": IDL.Vec(LeaderboardEntry)
  });
  const Result_11 = IDL.Variant({
    "ok": MonthlyLeaderboardDTO,
    "err": Error2
  });
  const GetMonthlyLeaderboardsDTO = IDL.Record({
    "month": CalendarMonth,
    "seasonId": SeasonId
  });
  const Result_18 = IDL.Variant({
    "ok": IDL.Vec(MonthlyLeaderboardDTO),
    "err": Error2
  });
  const GetPlayerDetailsDTO = IDL.Record({
    "playerId": PlayerId,
    "seasonId": SeasonId
  });
  const InjuryHistory = IDL.Record({
    "description": IDL.Text,
    "injuryStartDate": IDL.Int,
    "expectedEndDate": IDL.Int
  });
  const PlayerGameweekDTO = IDL.Record({
    "fixtureId": FixtureId,
    "events": IDL.Vec(PlayerEventData),
    "number": IDL.Nat8,
    "points": IDL.Int16
  });
  const ValueHistory = IDL.Record({
    "oldValue": IDL.Nat16,
    "newValue": IDL.Nat16,
    "seasonId": IDL.Nat16,
    "gameweek": IDL.Nat8
  });
  const PlayerDetailDTO = IDL.Record({
    "id": PlayerId,
    "status": PlayerStatus,
    "clubId": ClubId,
    "parentClubId": ClubId,
    "valueQuarterMillions": IDL.Nat16,
    "dateOfBirth": IDL.Int,
    "injuryHistory": IDL.Vec(InjuryHistory),
    "seasonId": SeasonId,
    "gameweeks": IDL.Vec(PlayerGameweekDTO),
    "nationality": CountryId,
    "retirementDate": IDL.Int,
    "valueHistory": IDL.Vec(ValueHistory),
    "latestInjuryEndDate": IDL.Int,
    "shirtNumber": IDL.Nat8,
    "position": PlayerPosition,
    "lastName": IDL.Text,
    "firstName": IDL.Text
  });
  const Result_17 = IDL.Variant({ "ok": PlayerDetailDTO, "err": Error2 });
  const GameweekFiltersDTO = IDL.Record({
    "seasonId": SeasonId,
    "gameweek": GameweekNumber
  });
  const PlayerPointsDTO = IDL.Record({
    "id": IDL.Nat16,
    "clubId": ClubId,
    "events": IDL.Vec(PlayerEventData),
    "position": PlayerPosition,
    "gameweek": GameweekNumber,
    "points": IDL.Int16
  });
  const Result_16 = IDL.Variant({
    "ok": IDL.Vec(PlayerPointsDTO),
    "err": Error2
  });
  const PlayerScoreDTO = IDL.Record({
    "id": IDL.Nat16,
    "clubId": ClubId,
    "assists": IDL.Int16,
    "dateOfBirth": IDL.Int,
    "nationality": CountryId,
    "goalsScored": IDL.Int16,
    "saves": IDL.Int16,
    "goalsConceded": IDL.Int16,
    "events": IDL.Vec(PlayerEventData),
    "position": PlayerPosition,
    "points": IDL.Int16
  });
  const Result_15 = IDL.Variant({
    "ok": IDL.Vec(IDL.Tuple(IDL.Nat16, PlayerScoreDTO)),
    "err": Error2
  });
  const Result_13 = IDL.Variant({
    "ok": ManagerPrivateLeagueDTO,
    "err": Error2
  });
  const GetLeagueMembersDTO = IDL.Record({
    "offset": IDL.Nat,
    "limit": IDL.Nat,
    "canisterId": CanisterId
  });
  const PrincipalId = IDL.Text;
  const LeagueMemberDTO = IDL.Record({
    "added": IDL.Int,
    "username": IDL.Text,
    "principalId": PrincipalId
  });
  const Result_12 = IDL.Variant({
    "ok": IDL.Vec(LeagueMemberDTO),
    "err": Error2
  });
  const GetPrivateLeagueMonthlyLeaderboard = IDL.Record({
    "month": CalendarMonth,
    "offset": IDL.Nat,
    "seasonId": SeasonId,
    "limit": IDL.Nat,
    "canisterId": CanisterId
  });
  const GetPrivateLeagueSeasonLeaderboard = IDL.Record({
    "offset": IDL.Nat,
    "seasonId": SeasonId,
    "limit": IDL.Nat,
    "canisterId": CanisterId
  });
  const SeasonLeaderboardDTO = IDL.Record({
    "totalEntries": IDL.Nat,
    "seasonId": SeasonId,
    "entries": IDL.Vec(LeaderboardEntry)
  });
  const Result_8 = IDL.Variant({ "ok": SeasonLeaderboardDTO, "err": Error2 });
  const GetPrivateLeagueWeeklyLeaderboard = IDL.Record({
    "offset": IDL.Nat,
    "seasonId": SeasonId,
    "limit": IDL.Nat,
    "gameweek": GameweekNumber,
    "canisterId": CanisterId
  });
  const WeeklyLeaderboardDTO = IDL.Record({
    "totalEntries": IDL.Nat,
    "seasonId": SeasonId,
    "entries": IDL.Vec(LeaderboardEntry),
    "gameweek": GameweekNumber
  });
  const Result_2 = IDL.Variant({ "ok": WeeklyLeaderboardDTO, "err": Error2 });
  const ProfileDTO = IDL.Record({
    "username": IDL.Text,
    "termsAccepted": IDL.Bool,
    "createDate": IDL.Int,
    "favouriteClubId": ClubId,
    "profilePicture": IDL.Opt(IDL.Vec(IDL.Nat8)),
    "profilePictureType": IDL.Text,
    "principalId": IDL.Text
  });
  const Result_10 = IDL.Variant({ "ok": ProfileDTO, "err": Error2 });
  const GetSeasonLeaderboardDTO = IDL.Record({
    "offset": IDL.Nat,
    "seasonId": SeasonId,
    "limit": IDL.Nat,
    "searchTerm": IDL.Text
  });
  const SeasonDTO = IDL.Record({
    "id": SeasonId,
    "name": IDL.Text,
    "year": IDL.Nat16
  });
  const Result_7 = IDL.Variant({ "ok": IDL.Vec(SeasonDTO), "err": Error2 });
  const EventLogEntryType = IDL.Variant({
    "SystemCheck": IDL.Null,
    "ManagerCanisterCreated": IDL.Null,
    "UnexpectedError": IDL.Null,
    "CanisterTopup": IDL.Null
  });
  const EventLogEntry = IDL.Record({
    "eventId": IDL.Nat,
    "eventTitle": IDL.Text,
    "eventDetail": IDL.Text,
    "eventTime": IDL.Int,
    "eventType": EventLogEntryType
  });
  const GetSystemLogDTO = IDL.Record({
    "dateEnd": IDL.Int,
    "totalEntries": IDL.Nat,
    "offset": IDL.Nat,
    "dateStart": IDL.Int,
    "limit": IDL.Nat,
    "entries": IDL.Vec(EventLogEntry),
    "eventType": IDL.Opt(EventLogEntryType)
  });
  const Result_6 = IDL.Variant({ "ok": GetSystemLogDTO, "err": Error2 });
  const SystemStateDTO = IDL.Record({
    "pickTeamSeasonId": SeasonId,
    "pickTeamSeasonName": IDL.Text,
    "calculationSeasonName": IDL.Text,
    "calculationGameweek": GameweekNumber,
    "transferWindowActive": IDL.Bool,
    "pickTeamGameweek": GameweekNumber,
    "calculationMonth": CalendarMonth,
    "calculationSeasonId": SeasonId,
    "onHold": IDL.Bool
  });
  const Result_5 = IDL.Variant({ "ok": SystemStateDTO, "err": Error2 });
  const TokenInfo = IDL.Record({
    "id": TokenId,
    "fee": IDL.Nat,
    "ticker": IDL.Text,
    "tokenImageURL": IDL.Text,
    "canisterId": CanisterId
  });
  const Result_4 = IDL.Variant({ "ok": IDL.Vec(TokenInfo), "err": Error2 });
  const Result_3 = IDL.Variant({ "ok": IDL.Nat, "err": Error2 });
  const AccountIdentifier__1 = IDL.Vec(IDL.Nat8);
  const GetWeeklyLeaderboardDTO = IDL.Record({
    "offset": IDL.Nat,
    "seasonId": SeasonId,
    "limit": IDL.Nat,
    "searchTerm": IDL.Text,
    "gameweek": GameweekNumber
  });
  const LeagueInviteDTO = IDL.Record({
    "managerId": PrincipalId,
    "canisterId": CanisterId
  });
  const UsernameFilterDTO = IDL.Record({ "username": IDL.Text });
  const PrivateLeagueRewardDTO = IDL.Record({
    "managerId": PrincipalId,
    "amount": IDL.Nat64
  });
  const UpdateTeamSelectionDTO = IDL.Record({
    "playerIds": IDL.Vec(PlayerId),
    "countrymenCountryId": CountryId,
    "username": IDL.Text,
    "goalGetterPlayerId": PlayerId,
    "hatTrickHeroGameweek": GameweekNumber,
    "teamBoostGameweek": GameweekNumber,
    "captainFantasticGameweek": GameweekNumber,
    "countrymenGameweek": GameweekNumber,
    "noEntryPlayerId": PlayerId,
    "safeHandsPlayerId": PlayerId,
    "braceBonusGameweek": GameweekNumber,
    "passMasterGameweek": GameweekNumber,
    "teamBoostClubId": ClubId,
    "goalGetterGameweek": GameweekNumber,
    "captainFantasticPlayerId": PlayerId,
    "transferWindowGameweek": GameweekNumber,
    "noEntryGameweek": GameweekNumber,
    "prospectsGameweek": GameweekNumber,
    "safeHandsGameweek": GameweekNumber,
    "passMasterPlayerId": PlayerId,
    "captainId": PlayerId
  });
  const UpdateFavouriteClubDTO = IDL.Record({ "favouriteClubId": ClubId });
  const UpdateLeagueBannerDTO = IDL.Record({
    "banner": IDL.Opt(IDL.Vec(IDL.Nat8)),
    "canisterId": CanisterId
  });
  const UpdateLeagueNameDTO = IDL.Record({
    "name": IDL.Text,
    "canisterId": CanisterId
  });
  const UpdateLeaguePictureDTO = IDL.Record({
    "picture": IDL.Opt(IDL.Vec(IDL.Nat8)),
    "canisterId": CanisterId
  });
  const UpdateProfilePictureDTO = IDL.Record({
    "profilePicture": IDL.Vec(IDL.Nat8),
    "extension": IDL.Text
  });
  const UpdateUsernameDTO = IDL.Record({ "username": IDL.Text });
  const RustResult = IDL.Variant({ "Ok": IDL.Text, "Err": IDL.Text });
  return IDL.Service({
    "acceptInviteAndPayFee": IDL.Func([CanisterId], [Result], []),
    "acceptLeagueInvite": IDL.Func([CanisterId], [Result], []),
    "createPrivateLeague": IDL.Func([CreatePrivateLeagueDTO], [Result], []),
    "enterLeague": IDL.Func([CanisterId], [Result], []),
    "enterLeagueWithFee": IDL.Func([CanisterId], [Result], []),
    "executeAddInitialFixtures": IDL.Func([AddInitialFixturesDTO], [], []),
    "executeAddNewToken": IDL.Func([NewTokenDTO], [], []),
    "executeCreatePlayer": IDL.Func([CreatePlayerDTO], [], []),
    "executeLoanPlayer": IDL.Func([LoanPlayerDTO], [], []),
    "executeManageDAONeuron": IDL.Func([Command], [], []),
    "executeMoveFixture": IDL.Func([MoveFixtureDTO], [], []),
    "executePostponeFixture": IDL.Func([PostponeFixtureDTO], [], []),
    "executePromoteFormerClub": IDL.Func([PromoteFormerClubDTO], [], []),
    "executePromoteNewClub": IDL.Func([PromoteNewClubDTO], [], []),
    "executeRecallPlayer": IDL.Func([RecallPlayerDTO], [], []),
    "executeRescheduleFixture": IDL.Func([RescheduleFixtureDTO], [], []),
    "executeRetirePlayer": IDL.Func([RetirePlayerDTO], [], []),
    "executeRevaluePlayerDown": IDL.Func([RevaluePlayerDownDTO], [], []),
    "executeRevaluePlayerUp": IDL.Func([RevaluePlayerUpDTO], [], []),
    "executeSetPlayerInjury": IDL.Func([SetPlayerInjuryDTO], [], []),
    "executeSubmitFixtureData": IDL.Func([SubmitFixtureDataDTO], [], []),
    "executeTransferPlayer": IDL.Func([TransferPlayerDTO], [], []),
    "executeUnretirePlayer": IDL.Func([UnretirePlayerDTO], [], []),
    "executeUpdateClub": IDL.Func([UpdateClubDTO], [], []),
    "executeUpdatePlayer": IDL.Func([UpdatePlayerDTO], [], []),
    "getCanisterCyclesAvailable": IDL.Func([], [IDL.Nat], []),
    "getCanisterCyclesBalance": IDL.Func([], [IDL.Nat], []),
    "getClubs": IDL.Func([], [Result_20], ["query"]),
    "getCountries": IDL.Func([], [Result_23], ["query"]),
    "getCurrentTeam": IDL.Func([], [Result_22], []),
    "getDataHashes": IDL.Func([], [Result_21], ["query"]),
    "getFixtures": IDL.Func([GetFixturesDTO], [Result_14], ["query"]),
    "getFormerClubs": IDL.Func([], [Result_20], ["query"]),
    "getLoanedPlayers": IDL.Func([ClubFilterDTO], [Result_9], ["query"]),
    "getManager": IDL.Func([GetManagerDTO], [Result_1], []),
    "getManagerPrivateLeagues": IDL.Func([], [Result_19], []),
    "getMonthlyLeaderboard": IDL.Func(
      [GetMonthlyLeaderboardDTO],
      [Result_11],
      []
    ),
    "getMonthlyLeaderboards": IDL.Func(
      [GetMonthlyLeaderboardsDTO],
      [Result_18],
      []
    ),
    "getNeuronId": IDL.Func([], [IDL.Nat64], []),
    "getPlayerDetails": IDL.Func(
      [GetPlayerDetailsDTO],
      [Result_17],
      ["query"]
    ),
    "getPlayerDetailsForGameweek": IDL.Func(
      [GameweekFiltersDTO],
      [Result_16],
      ["query"]
    ),
    "getPlayers": IDL.Func([], [Result_9], ["query"]),
    "getPlayersMap": IDL.Func([GameweekFiltersDTO], [Result_15], ["query"]),
    "getPostponedFixtures": IDL.Func([], [Result_14], ["query"]),
    "getPrivateLeague": IDL.Func([CanisterId], [Result_13], []),
    "getPrivateLeagueMembers": IDL.Func(
      [GetLeagueMembersDTO],
      [Result_12],
      []
    ),
    "getPrivateLeagueMonthlyLeaderboard": IDL.Func(
      [GetPrivateLeagueMonthlyLeaderboard],
      [Result_11],
      []
    ),
    "getPrivateLeagueSeasonLeaderboard": IDL.Func(
      [GetPrivateLeagueSeasonLeaderboard],
      [Result_8],
      []
    ),
    "getPrivateLeagueWeeklyLeaderboard": IDL.Func(
      [GetPrivateLeagueWeeklyLeaderboard],
      [Result_2],
      []
    ),
    "getProfile": IDL.Func([], [Result_10], []),
    "getRetiredPlayers": IDL.Func([ClubFilterDTO], [Result_9], ["query"]),
    "getSeasonLeaderboard": IDL.Func(
      [GetSeasonLeaderboardDTO],
      [Result_8],
      []
    ),
    "getSeasons": IDL.Func([], [Result_7], ["query"]),
    "getSystemLog": IDL.Func([GetSystemLogDTO], [Result_6], []),
    "getSystemState": IDL.Func([], [Result_5], ["query"]),
    "getTokenList": IDL.Func([], [Result_4], []),
    "getTotalManagers": IDL.Func([], [Result_3], ["query"]),
    "getTreasuryAccountPublic": IDL.Func([], [AccountIdentifier__1], []),
    "getWeeklyLeaderboard": IDL.Func(
      [GetWeeklyLeaderboardDTO],
      [Result_2],
      []
    ),
    "inviteUserToLeague": IDL.Func([LeagueInviteDTO], [Result], []),
    "isUsernameValid": IDL.Func([UsernameFilterDTO], [IDL.Bool], ["query"]),
    "payPrivateLeagueRewards": IDL.Func([PrivateLeagueRewardDTO], [], []),
    "requestCanisterTopup": IDL.Func([IDL.Nat], [], []),
    "saveFantasyTeam": IDL.Func([UpdateTeamSelectionDTO], [Result], []),
    "searchUsername": IDL.Func([UsernameFilterDTO], [Result_1], []),
    "setTimer": IDL.Func([IDL.Int, IDL.Text], [], []),
    "updateFavouriteClub": IDL.Func([UpdateFavouriteClubDTO], [Result], []),
    "updateLeagueBanner": IDL.Func([UpdateLeagueBannerDTO], [Result], []),
    "updateLeagueName": IDL.Func([UpdateLeagueNameDTO], [Result], []),
    "updateLeaguePicture": IDL.Func([UpdateLeaguePictureDTO], [Result], []),
    "updateProfilePicture": IDL.Func([UpdateProfilePictureDTO], [Result], []),
    "updateUsername": IDL.Func([UpdateUsernameDTO], [Result], []),
    "validateAddInitialFixtures": IDL.Func(
      [AddInitialFixturesDTO],
      [RustResult],
      ["query"]
    ),
    "validateAddNewToken": IDL.Func([NewTokenDTO], [RustResult], ["query"]),
    "validateCreatePlayer": IDL.Func(
      [CreatePlayerDTO],
      [RustResult],
      ["query"]
    ),
    "validateLoanPlayer": IDL.Func([LoanPlayerDTO], [RustResult], ["query"]),
    "validateManageDAONeuron": IDL.Func([Command], [RustResult], ["query"]),
    "validateMoveFixture": IDL.Func([MoveFixtureDTO], [RustResult], ["query"]),
    "validatePostponeFixture": IDL.Func(
      [PostponeFixtureDTO],
      [RustResult],
      ["query"]
    ),
    "validatePromoteFormerClub": IDL.Func(
      [PromoteFormerClubDTO],
      [RustResult],
      ["query"]
    ),
    "validatePromoteNewClub": IDL.Func(
      [PromoteNewClubDTO],
      [RustResult],
      ["query"]
    ),
    "validateRecallPlayer": IDL.Func(
      [RecallPlayerDTO],
      [RustResult],
      ["query"]
    ),
    "validateRescheduleFixture": IDL.Func(
      [RescheduleFixtureDTO],
      [RustResult],
      ["query"]
    ),
    "validateRetirePlayer": IDL.Func(
      [RetirePlayerDTO],
      [RustResult],
      ["query"]
    ),
    "validateRevaluePlayerDown": IDL.Func(
      [RevaluePlayerDownDTO],
      [RustResult],
      ["query"]
    ),
    "validateRevaluePlayerUp": IDL.Func(
      [RevaluePlayerUpDTO],
      [RustResult],
      ["query"]
    ),
    "validateSetPlayerInjury": IDL.Func(
      [SetPlayerInjuryDTO],
      [RustResult],
      ["query"]
    ),
    "validateSubmitFixtureData": IDL.Func(
      [SubmitFixtureDataDTO],
      [RustResult],
      ["query"]
    ),
    "validateTransferPlayer": IDL.Func(
      [TransferPlayerDTO],
      [RustResult],
      ["query"]
    ),
    "validateUnretirePlayer": IDL.Func(
      [UnretirePlayerDTO],
      [RustResult],
      ["query"]
    ),
    "validateUpdateClub": IDL.Func([UpdateClubDTO], [RustResult], ["query"]),
    "validateUpdatePlayer": IDL.Func(
      [UpdatePlayerDTO],
      [RustResult],
      ["query"]
    )
  });
};
var define_process_env_default$c = { OPENFPL_BACKEND_CANISTER_ID: "bd3sg-teaaa-aaaaa-qaaba-cai", OPENFPL_FRONTEND_CANISTER_ID: "be2us-64aaa-aaaaa-qaabq-cai", __CANDID_UI_CANISTER_ID: "bw4dl-smaaa-aaaaa-qaacq-cai", NEURON_CONTROLLER_CANISTER_ID: "br5f7-7uaaa-aaaaa-qaaca-cai", DFX_NETWORK: "local" };
const canisterId = define_process_env_default$c.CANISTER_ID_OPENFPL_BACKEND;
const createActor = (canisterId2, options2 = {}) => {
  const agent = options2.agent || new HttpAgent({ ...options2.agentOptions });
  if (options2.agent && options2.agentOptions) {
    console.warn(
      "Detected both agent and agentOptions passed to createActor. Ignoring agentOptions and proceeding with the provided agent."
    );
  }
  {
    agent.fetchRootKey().catch((err) => {
      console.warn(
        "Unable to fetch root key. Check to ensure that your local replica is running"
      );
      console.error(err);
    });
  }
  return Actor.createActor(idlFactory, {
    agent,
    canisterId: canisterId2,
    ...options2.actorOptions
  });
};
canisterId ? createActor(canisterId) : void 0;
class ActorFactory {
  static createActor(idlFactory2, canisterId2 = "", identity = null, options2 = null) {
    const hostOptions = {
      host: `http://localhost:8080/?canisterId=qhbym-qaaaa-aaaaa-aaafq-cai`,
      identity
    };
    if (!options2) {
      options2 = {
        agentOptions: hostOptions
      };
    } else if (!options2.agentOptions) {
      options2.agentOptions = hostOptions;
    } else {
      options2.agentOptions.host = hostOptions.host;
    }
    const agent = new HttpAgent({ ...options2.agentOptions });
    {
      agent.fetchRootKey().catch((err) => {
        console.warn(
          "Unable to fetch root key. Ensure your local replica is running"
        );
        console.error(err);
      });
    }
    return Actor.createActor(idlFactory2, {
      agent,
      canisterId: canisterId2,
      ...options2?.actorOptions
    });
  }
  static getAgent(canisterId2 = "", identity = null, options2 = null) {
    const hostOptions = {
      host: `http://localhost:8080/?canisterId=b77ix-eeaaa-aaaaa-qaada-cai`,
      identity
    };
    if (!options2) {
      options2 = {
        agentOptions: hostOptions
      };
    } else if (!options2.agentOptions) {
      options2.agentOptions = hostOptions;
    } else {
      options2.agentOptions.host = hostOptions.host;
    }
    return new HttpAgent({ ...options2.agentOptions });
  }
  static createIdentityActor(authStore2, canisterId2) {
    let unsubscribe;
    return new Promise((resolve2, reject) => {
      unsubscribe = authStore2.subscribe((store) => {
        if (store.identity) {
          resolve2(store.identity);
        }
      });
    }).then((identity) => {
      unsubscribe();
      return ActorFactory.createActor(idlFactory, canisterId2, identity);
    });
  }
  static createGovernanceAgent(authStore2, canisterId2) {
    let unsubscribe;
    return new Promise((resolve2, reject) => {
      unsubscribe = authStore2.subscribe((store) => {
        if (store.identity) {
          resolve2(store.identity);
        }
      });
    }).then((identity) => {
      unsubscribe();
      return ActorFactory.createActor(idlFactory, canisterId2, identity);
    });
  }
}
var FixtureStatus = /* @__PURE__ */ ((FixtureStatus2) => {
  FixtureStatus2[FixtureStatus2["UNPLAYED"] = 0] = "UNPLAYED";
  FixtureStatus2[FixtureStatus2["ACTIVE"] = 1] = "ACTIVE";
  FixtureStatus2[FixtureStatus2["COMPLETED"] = 2] = "COMPLETED";
  FixtureStatus2[FixtureStatus2["VERIFIED"] = 3] = "VERIFIED";
  return FixtureStatus2;
})(FixtureStatus || {});
var PlayerEvent = /* @__PURE__ */ ((PlayerEvent2) => {
  PlayerEvent2[PlayerEvent2["Appearance"] = 0] = "Appearance";
  PlayerEvent2[PlayerEvent2["Goal"] = 1] = "Goal";
  PlayerEvent2[PlayerEvent2["GoalAssisted"] = 2] = "GoalAssisted";
  PlayerEvent2[PlayerEvent2["GoalConceded"] = 3] = "GoalConceded";
  PlayerEvent2[PlayerEvent2["KeeperSave"] = 4] = "KeeperSave";
  PlayerEvent2[PlayerEvent2["CleanSheet"] = 5] = "CleanSheet";
  PlayerEvent2[PlayerEvent2["PenaltySaved"] = 6] = "PenaltySaved";
  PlayerEvent2[PlayerEvent2["PenaltyMissed"] = 7] = "PenaltyMissed";
  PlayerEvent2[PlayerEvent2["YellowCard"] = 8] = "YellowCard";
  PlayerEvent2[PlayerEvent2["RedCard"] = 9] = "RedCard";
  PlayerEvent2[PlayerEvent2["OwnGoal"] = 10] = "OwnGoal";
  PlayerEvent2[PlayerEvent2["HighestScoringPlayer"] = 11] = "HighestScoringPlayer";
  return PlayerEvent2;
})(PlayerEvent || {});
var Position = /* @__PURE__ */ ((Position2) => {
  Position2[Position2["GOALKEEPER"] = 0] = "GOALKEEPER";
  Position2[Position2["DEFENDER"] = 1] = "DEFENDER";
  Position2[Position2["MIDFIELDER"] = 2] = "MIDFIELDER";
  Position2[Position2["FORWARD"] = 3] = "FORWARD";
  return Position2;
})(Position || {});
function uint8ArrayToBase64(bytes) {
  const binary = Array.from(bytes).map((byte) => String.fromCharCode(byte)).join("");
  return btoa(binary);
}
function replacer(key2, value) {
  if (typeof value === "bigint") {
    return value.toString();
  } else {
    return value;
  }
}
function calculateAgeFromNanoseconds(nanoseconds) {
  const milliseconds = nanoseconds / 1e6;
  const birthDate = new Date(milliseconds);
  const today = /* @__PURE__ */ new Date();
  let age = today.getFullYear() - birthDate.getFullYear();
  const monthDifference = today.getMonth() - birthDate.getMonth();
  if (monthDifference < 0 || monthDifference === 0 && today.getDate() < birthDate.getDate()) {
    age--;
  }
  return age;
}
function updateTableData(fixtures, teams, selectedGameweek) {
  let tempTable = {};
  teams.forEach((team) => initTeamData(team.id, tempTable, teams));
  const relevantFixtures = fixtures.filter(
    (fixture) => convertFixtureStatus(fixture.fixture.status) === 3 && fixture.fixture.gameweek <= selectedGameweek
  );
  relevantFixtures.forEach(({ fixture, homeTeam, awayTeam }) => {
    if (!homeTeam || !awayTeam)
      return;
    initTeamData(homeTeam.id, tempTable, teams);
    initTeamData(awayTeam.id, tempTable, teams);
    const homeStats = tempTable[homeTeam.id];
    const awayStats = tempTable[awayTeam.id];
    homeStats.played++;
    awayStats.played++;
    homeStats.goalsFor += fixture.homeGoals;
    homeStats.goalsAgainst += fixture.awayGoals;
    awayStats.goalsFor += fixture.awayGoals;
    awayStats.goalsAgainst += fixture.homeGoals;
    if (fixture.homeGoals > fixture.awayGoals) {
      homeStats.wins++;
      homeStats.points += 3;
      awayStats.losses++;
    } else if (fixture.homeGoals === fixture.awayGoals) {
      homeStats.draws++;
      awayStats.draws++;
      homeStats.points += 1;
      awayStats.points += 1;
    } else {
      awayStats.wins++;
      awayStats.points += 3;
      homeStats.losses++;
    }
  });
  return Object.values(tempTable).sort((a, b) => {
    const goalDiffA = a.goalsFor - a.goalsAgainst;
    const goalDiffB = b.goalsFor - b.goalsAgainst;
    if (b.points !== a.points)
      return b.points - a.points;
    if (goalDiffB !== goalDiffA)
      return goalDiffB - goalDiffA;
    if (b.goalsFor !== a.goalsFor)
      return b.goalsFor - a.goalsFor;
    return a.goalsAgainst - b.goalsAgainst;
  });
}
function initTeamData(teamId, table, teams) {
  if (!table[teamId]) {
    const team = teams.find((t) => t.id === teamId);
    if (team) {
      table[teamId] = {
        ...team,
        played: 0,
        wins: 0,
        draws: 0,
        losses: 0,
        goalsFor: 0,
        goalsAgainst: 0,
        points: 0
      };
    }
  }
}
const allFormations = {
  "3-4-3": { positions: [0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3] },
  "3-5-2": { positions: [0, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3] },
  "4-3-3": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3] },
  "4-4-2": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3] },
  "4-5-1": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3] },
  "5-4-1": { positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3] },
  "5-3-2": { positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3] }
};
function getAvailableFormations(players, team) {
  const positionCounts = { 0: 0, 1: 0, 2: 0, 3: 0 };
  team.playerIds.forEach((id) => {
    const teamPlayer = players.find((p) => p.id === id);
    if (teamPlayer) {
      positionCounts[convertPlayerPosition(teamPlayer.position)]++;
    }
  });
  const formations = [
    "3-4-3",
    "3-5-2",
    "4-3-3",
    "4-4-2",
    "4-5-1",
    "5-4-1",
    "5-3-2"
  ];
  return formations.filter((formation) => {
    const [def, mid, fwd] = formation.split("-").map(Number);
    const minDef = Math.max(0, def - (positionCounts[1] || 0));
    const minMid = Math.max(0, mid - (positionCounts[2] || 0));
    const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
    const minGK = Math.max(0, 1 - (positionCounts[0] || 0));
    const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
    const totalPlayers = Object.values(positionCounts).reduce(
      (a, b) => a + b,
      0
    );
    return totalPlayers + additionalPlayersNeeded <= 11;
  });
}
function convertPlayerPosition(playerPosition) {
  if ("Goalkeeper" in playerPosition)
    return Position.GOALKEEPER;
  if ("Defender" in playerPosition)
    return Position.DEFENDER;
  if ("Midfielder" in playerPosition)
    return Position.MIDFIELDER;
  if ("Forward" in playerPosition)
    return Position.FORWARD;
  return Position.GOALKEEPER;
}
function convertEvent(playerEvent) {
  if ("Appearance" in playerEvent)
    return PlayerEvent.Appearance;
  if ("Goal" in playerEvent)
    return PlayerEvent.Goal;
  if ("GoalAssisted" in playerEvent)
    return PlayerEvent.GoalAssisted;
  if ("GoalConceded" in playerEvent)
    return PlayerEvent.GoalConceded;
  if ("KeeperSave" in playerEvent)
    return PlayerEvent.KeeperSave;
  if ("CleanSheet" in playerEvent)
    return PlayerEvent.CleanSheet;
  if ("PenaltySaved" in playerEvent)
    return PlayerEvent.PenaltySaved;
  if ("PenaltyMissed" in playerEvent)
    return PlayerEvent.PenaltyMissed;
  if ("YellowCard" in playerEvent)
    return PlayerEvent.YellowCard;
  if ("RedCard" in playerEvent)
    return PlayerEvent.RedCard;
  if ("OwnGoal" in playerEvent)
    return PlayerEvent.OwnGoal;
  if ("HighestScoringPlayer" in playerEvent)
    return PlayerEvent.HighestScoringPlayer;
  return PlayerEvent.Appearance;
}
function convertFixtureStatus(fixtureStatus) {
  if ("Goalkeeper" in fixtureStatus)
    return FixtureStatus.UNPLAYED;
  if ("Defender" in fixtureStatus)
    return FixtureStatus.ACTIVE;
  if ("Midfielder" in fixtureStatus)
    return FixtureStatus.COMPLETED;
  if ("Forward" in fixtureStatus)
    return FixtureStatus.VERIFIED;
  return FixtureStatus.UNPLAYED;
}
function isError(response) {
  return response && response.err !== void 0;
}
var define_process_env_default$b = { OPENFPL_BACKEND_CANISTER_ID: "bd3sg-teaaa-aaaaa-qaaba-cai", OPENFPL_FRONTEND_CANISTER_ID: "be2us-64aaa-aaaaa-qaabq-cai", __CANDID_UI_CANISTER_ID: "bw4dl-smaaa-aaaaa-qaacq-cai", NEURON_CONTROLLER_CANISTER_ID: "br5f7-7uaaa-aaaaa-qaaca-cai", DFX_NETWORK: "local" };
function createSystemStore() {
  const { subscribe: subscribe2, set } = writable(null);
  let actor = ActorFactory.createActor(
    idlFactory,
    define_process_env_default$b.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    await authStore.sync();
    let category = "system_state";
    const newHashValues = await actor.getDataHashes();
    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing system store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(`${category}_hash`);
    if (categoryHash?.hash != localHash) {
      let result = await actor.getSystemState();
      if (isError(result)) {
        console.error("Error syncing system store");
        return;
      }
      let updatedSystemStateData = result.ok;
      localStorage.setItem(
        category,
        JSON.stringify(updatedSystemStateData, replacer)
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedSystemStateData);
    } else {
      const cachedSystemStateData = localStorage.getItem(category);
      let cachedSystemState = null;
      try {
        cachedSystemState = JSON.parse(cachedSystemStateData || "{}");
      } catch (e) {
        cachedSystemState = null;
      }
      set(cachedSystemState);
    }
  }
  async function getSystemState() {
    let systemState;
    subscribe2((value) => {
      systemState = value;
    })();
    return systemState;
  }
  async function getSeasons() {
    try {
      let result = await actor.getSeasons();
      if (isError(result)) {
        console.error("Error fetching seasons:");
        return [];
      }
      return result.ok;
    } catch (error) {
      console.error("Error fetching seasons:", error);
      throw error;
    }
  }
  async function getLogs(dto) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default$b.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = await identityActor.getSystemLog(dto);
      if (isError(result)) {
        console.error("Error getting system logs:", result);
        return;
      }
      return result.ok;
    } catch (error) {
      console.error("Error getting system logs:", error);
      throw error;
    }
  }
  return {
    subscribe: subscribe2,
    sync,
    getSystemState,
    getSeasons,
    getLogs
  };
}
const systemStore = createSystemStore();
var define_process_env_default$a = { OPENFPL_BACKEND_CANISTER_ID: "bd3sg-teaaa-aaaaa-qaaba-cai", OPENFPL_FRONTEND_CANISTER_ID: "be2us-64aaa-aaaaa-qaabq-cai", __CANDID_UI_CANISTER_ID: "bw4dl-smaaa-aaaaa-qaacq-cai", NEURON_CONTROLLER_CANISTER_ID: "br5f7-7uaaa-aaaaa-qaaca-cai", DFX_NETWORK: "local" };
function createFixtureStore() {
  const { subscribe: subscribe2, set } = writable([]);
  let actor = ActorFactory.createActor(
    idlFactory,
    define_process_env_default$a.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync(seasonId) {
    const category = "fixtures";
    const newHashValues = await actor.getDataHashes();
    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing fixture store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(`${category}_hash`);
    if (categoryHash?.hash != localHash) {
      let dto = {
        seasonId
      };
      const result = await actor.getFixtures(dto);
      if (isError(result)) {
        console.error("error syncing fixture store");
        return;
      }
      let updatedFixturesData = result.ok;
      localStorage.setItem(
        category,
        JSON.stringify(updatedFixturesData, replacer)
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedFixturesData);
    } else {
      const cachedFixturesData = localStorage.getItem(category);
      let cachedFixtures = [];
      try {
        cachedFixtures = JSON.parse(cachedFixturesData || "[]");
      } catch (e) {
        cachedFixtures = [];
      }
      set(cachedFixtures);
    }
  }
  async function getNextFixture() {
    let fixtures = [];
    await subscribe2((value) => {
      fixtures = value;
    })();
    if (fixtures.length == 0) {
      return;
    }
    const now = /* @__PURE__ */ new Date();
    return fixtures.find(
      (fixture) => new Date(Number(fixture.kickOff) / 1e6) > now
    );
  }
  async function getPostponedFixtures() {
    try {
      let result = await actor.getPostponedFixtures();
      if (isError(result)) {
        console.error("Error getting postponed fixtures");
      }
      let fixtures = result.ok;
      return fixtures;
    } catch (error) {
      console.error("Error getting postponed fixtures:", error);
      throw error;
    }
  }
  return {
    subscribe: subscribe2,
    sync,
    getNextFixture,
    getPostponedFixtures
  };
}
const fixtureStore = createFixtureStore();
var define_process_env_default$9 = { OPENFPL_BACKEND_CANISTER_ID: "bd3sg-teaaa-aaaaa-qaaba-cai", OPENFPL_FRONTEND_CANISTER_ID: "be2us-64aaa-aaaaa-qaabq-cai", __CANDID_UI_CANISTER_ID: "bw4dl-smaaa-aaaaa-qaacq-cai", NEURON_CONTROLLER_CANISTER_ID: "br5f7-7uaaa-aaaaa-qaaca-cai", DFX_NETWORK: "local" };
function createTeamStore() {
  const { subscribe: subscribe2, set } = writable([]);
  let actor = ActorFactory.createActor(
    idlFactory,
    define_process_env_default$9.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    const category = "clubs";
    const newHashValues = await actor.getDataHashes();
    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing team store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(`${category}_hash`);
    if (categoryHash?.hash != localHash) {
      const updatedTeamsData = await actor.getClubs();
      if (isError(updatedTeamsData)) {
        return [];
      }
      localStorage.setItem(
        category,
        JSON.stringify(updatedTeamsData.ok, replacer)
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedTeamsData.ok);
    } else {
      const cachedTeamsData = localStorage.getItem(category);
      let cachedTeams = [];
      try {
        cachedTeams = JSON.parse(cachedTeamsData || "[]");
      } catch (e) {
        cachedTeams = [];
      }
      set(cachedTeams);
    }
  }
  async function getTeamById(id) {
    let teams = [];
    subscribe2((value) => {
      teams = value;
    })();
    return teams.find((team) => team.id === id);
  }
  async function getFormerClubs() {
    const formerClubsData = await actor.getFormerClubs();
    if (isError(formerClubsData)) {
      return [];
    }
    return formerClubsData.ok;
  }
  return {
    subscribe: subscribe2,
    sync,
    getTeamById,
    getFormerClubs
  };
}
const teamStore = createTeamStore();
const errorDetailToString = (err) => typeof err === "string" ? err : err instanceof Error ? err.message : "message" in err ? err.message : void 0;
const DEFAULT_ICON_SIZE = 20;
const core = {
  close: "Close",
  back: "Back",
  menu: "Open menu to access navigation options",
  collapse: "Collapse",
  expand: "Expand",
  copy: "Copy to clipboard"
};
const theme = {
  switch_theme: "Switch theme"
};
const progress = {
  completed: "Completed",
  in_progress: "In progress"
};
const en = {
  core,
  theme,
  progress
};
const i18n = readable({
  lang: "en",
  ...en
});
const css$c = {
  code: ".backdrop.svelte-whxjdd{position:absolute;top:0;right:0;bottom:0;left:0;background:var(--backdrop);color:var(--backdrop-contrast);-webkit-backdrop-filter:var(--backdrop-filter);backdrop-filter:var(--backdrop-filter);z-index:var(--backdrop-z-index);touch-action:manipulation;cursor:pointer}.backdrop.disablePointerEvents.svelte-whxjdd{cursor:inherit;pointer-events:none}",
  map: null
};
const Backdrop = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $i18n, $$unsubscribe_i18n;
  $$unsubscribe_i18n = subscribe(i18n, (value) => $i18n = value);
  let { disablePointerEvents = false } = $$props;
  createEventDispatcher();
  if ($$props.disablePointerEvents === void 0 && $$bindings.disablePointerEvents && disablePointerEvents !== void 0)
    $$bindings.disablePointerEvents(disablePointerEvents);
  $$result.css.add(css$c);
  $$unsubscribe_i18n();
  return `<div role="button" tabindex="-1"${add_attribute("aria-label", $i18n.core.close, 0)} class="${["backdrop svelte-whxjdd", disablePointerEvents ? "disablePointerEvents" : ""].join(" ").trim()}" data-tid="backdrop"></div>`;
});
const layoutBottomOffset = writable(0);
const initBusyStore = () => {
  const DEFAULT_STATE = [];
  const { subscribe: subscribe2, update, set } = writable(DEFAULT_STATE);
  return {
    subscribe: subscribe2,
    /**
     * Show the busy-screen if not visible
     */
    startBusy({ initiator: newInitiator, text: text2 }) {
      update((state) => [
        ...state.filter(({ initiator }) => newInitiator !== initiator),
        { initiator: newInitiator, text: text2 }
      ]);
    },
    /**
     * Hide the busy-screen if no other initiators are done
     */
    stopBusy(initiatorToRemove) {
      update((state) => state.filter(({ initiator }) => initiator !== initiatorToRemove));
    },
    resetForTesting() {
      set(DEFAULT_STATE);
    }
  };
};
const busyStore = initBusyStore();
const busy = derived(busyStore, ($busyStore) => $busyStore.length > 0);
const busyMessage = derived(busyStore, ($busyStore) => $busyStore.reverse().find(({ text: text2 }) => nonNullish(text2))?.text);
const css$b = {
  code: ".medium.svelte-85668t{--spinner-size:30px}.small.svelte-85668t{--spinner-size:calc(var(--line-height-standard) * 1rem)}.tiny.svelte-85668t{--spinner-size:calc(var(--line-height-standard) * 0.5rem)}svg.svelte-85668t{width:var(--spinner-size);height:var(--spinner-size);animation:spinner-linear-rotate 2000ms linear infinite;position:absolute;top:calc(50% - var(--spinner-size) / 2);left:calc(50% - var(--spinner-size) / 2);--radius:45px;--circumference:calc(3.1415926536 * var(--radius) * 2);--start:calc((1 - 0.05) * var(--circumference));--end:calc((1 - 0.8) * var(--circumference))}svg.inline.svelte-85668t{display:inline-block;position:relative}circle.svelte-85668t{stroke-dasharray:var(--circumference);stroke-width:10%;transform-origin:50% 50% 0;transition-property:stroke;animation-name:spinner-stroke-rotate-100;animation-duration:4000ms;animation-timing-function:cubic-bezier(0.35, 0, 0.25, 1);animation-iteration-count:infinite;fill:transparent;stroke:currentColor;transition:stroke-dashoffset 225ms linear}@keyframes spinner-linear-rotate{0%{transform:rotate(0deg)}100%{transform:rotate(360deg)}}@keyframes spinner-stroke-rotate-100{0%{stroke-dashoffset:var(--start);transform:rotate(0)}12.5%{stroke-dashoffset:var(--end);transform:rotate(0)}12.5001%{stroke-dashoffset:var(--end);transform:rotateX(180deg) rotate(72.5deg)}25%{stroke-dashoffset:var(--start);transform:rotateX(180deg) rotate(72.5deg)}25.0001%{stroke-dashoffset:var(--start);transform:rotate(270deg)}37.5%{stroke-dashoffset:var(--end);transform:rotate(270deg)}37.5001%{stroke-dashoffset:var(--end);transform:rotateX(180deg) rotate(161.5deg)}50%{stroke-dashoffset:var(--start);transform:rotateX(180deg) rotate(161.5deg)}50.0001%{stroke-dashoffset:var(--start);transform:rotate(180deg)}62.5%{stroke-dashoffset:var(--end);transform:rotate(180deg)}62.5001%{stroke-dashoffset:var(--end);transform:rotateX(180deg) rotate(251.5deg)}75%{stroke-dashoffset:var(--start);transform:rotateX(180deg) rotate(251.5deg)}75.0001%{stroke-dashoffset:var(--start);transform:rotate(90deg)}87.5%{stroke-dashoffset:var(--end);transform:rotate(90deg)}87.5001%{stroke-dashoffset:var(--end);transform:rotateX(180deg) rotate(341.5deg)}100%{stroke-dashoffset:var(--start);transform:rotateX(180deg) rotate(341.5deg)}}",
  map: null
};
const Spinner = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { inline = false } = $$props;
  let { size = "medium" } = $$props;
  if ($$props.inline === void 0 && $$bindings.inline && inline !== void 0)
    $$bindings.inline(inline);
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  $$result.css.add(css$b);
  return `  <svg class="${[escape(null_to_empty(size), true) + " svelte-85668t", inline ? "inline" : ""].join(" ").trim()}" preserveAspectRatio="xMidYMid meet" focusable="false" aria-hidden="true" data-tid="spinner" viewBox="0 0 100 100"><circle cx="50%" cy="50%" r="45" class="svelte-85668t"></circle></svg>`;
});
const css$a = {
  code: "div.svelte-14plyno{z-index:calc(var(--z-index) + 1000);position:fixed;top:0;right:0;bottom:0;left:0;background:var(--backdrop);color:var(--backdrop-contrast)}.content.svelte-14plyno{display:flex;flex-direction:column;justify-content:center;align-items:center}p.svelte-14plyno{padding-bottom:var(--padding);max-width:calc(var(--section-max-width) / 2)}",
  map: null
};
const BusyScreen = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $busy, $$unsubscribe_busy;
  let $busyMessage, $$unsubscribe_busyMessage;
  $$unsubscribe_busy = subscribe(busy, (value) => $busy = value);
  $$unsubscribe_busyMessage = subscribe(busyMessage, (value) => $busyMessage = value);
  $$result.css.add(css$a);
  $$unsubscribe_busy();
  $$unsubscribe_busyMessage();
  return ` ${$busy ? `<div data-tid="busy" class="svelte-14plyno"><div class="content svelte-14plyno">${nonNullish($busyMessage) ? `<p class="svelte-14plyno">${escape($busyMessage)}</p>` : ``} <span>${validate_component(Spinner, "Spinner").$$render($$result, { inline: true }, {}, {})}</span></div></div>` : ``}`;
});
const IconCheckCircle = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { size = `24px` } = $$props;
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  return `  <svg${add_attribute("width", size, 0)}${add_attribute("height", size, 0)} viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><rect x="1.25" y="1.25" width="21.5" height="21.5" rx="10.75" fill="var(--icon-check-circle-background, transparent)"></rect><path d="M7 11L11 15L17 9" stroke="var(--icon-check-circle-color, currentColor)" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><rect x="1.25" y="1.25" width="21.5" height="21.5" rx="10.75" stroke="var(--icon-check-circle-background, currentColor)" stroke-width="1.5"></rect></svg>`;
});
const IconClose = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { size = `${DEFAULT_ICON_SIZE}px` } = $$props;
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  return `  <svg${add_attribute("height", size, 0)}${add_attribute("width", size, 0)} viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><rect x="14.4194" y="4.52441" width="1.5" height="14" rx="0.75" transform="rotate(45 14.4194 4.52441)" fill="currentColor"></rect><rect x="4.5199" y="5.58496" width="1.5" height="14" rx="0.75" transform="rotate(-45 4.5199 5.58496)" fill="currentColor"></rect></svg>`;
});
const IconError = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { size = `${DEFAULT_ICON_SIZE}px` } = $$props;
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  return `  <svg xmlns="http://www.w3.org/2000/svg"${add_attribute("height", size, 0)} viewBox="0 0 24 24"${add_attribute("width", size, 0)} fill="currentColor"><path d="M0 0h24v24H0z" fill="none"></path><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"></path></svg>`;
});
const css$9 = {
  code: "svg.svelte-1lui9gh{vertical-align:middle}",
  map: null
};
const IconInfo = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { size = `${DEFAULT_ICON_SIZE}px` } = $$props;
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  $$result.css.add(css$9);
  return `  <svg${add_attribute("width", size, 0)}${add_attribute("height", size, 0)} viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" data-tid="icon-info" class="svelte-1lui9gh"><path d="M10.2222 17.5C14.3643 17.5 17.7222 14.1421 17.7222 10C17.7222 5.85786 14.3643 2.5 10.2222 2.5C6.08003 2.5 2.72217 5.85786 2.72217 10C2.72217 14.1421 6.08003 17.5 10.2222 17.5Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path d="M10.2222 13.3333V10" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path d="M10.2222 6.66699H10.2305" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path></svg>`;
});
const IconWarning = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { size = `${DEFAULT_ICON_SIZE}px` } = $$props;
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  return `  <svg xmlns="http://www.w3.org/2000/svg"${add_attribute("height", size, 0)} viewBox="0 0 24 24"${add_attribute("width", size, 0)} fill="currentColor"><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"></path></svg>`;
});
let elementsCounters = {};
const nextElementId = (prefix) => {
  elementsCounters = {
    ...elementsCounters,
    [prefix]: (elementsCounters[prefix] ?? 0) + 1
  };
  return `${prefix}${elementsCounters[prefix]}`;
};
const Html = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { text: text2 = void 0 } = $$props;
  if ($$props.text === void 0 && $$bindings.text && text2 !== void 0)
    $$bindings.text(text2);
  return `${``}`;
});
var Theme;
(function(Theme2) {
  Theme2["DARK"] = "dark";
  Theme2["LIGHT"] = "light";
})(Theme || (Theme = {}));
const isNode = () => typeof process !== "undefined" && process.versions != null && process.versions.node != null;
const enumFromStringExists = ({ obj, value }) => Object.values(obj).includes(value);
const THEME_ATTRIBUTE = "theme";
const LOCALSTORAGE_THEME_KEY = "nnsTheme";
const initTheme = () => {
  if (isNode()) {
    return void 0;
  }
  const theme2 = document.documentElement.getAttribute(THEME_ATTRIBUTE);
  const initialTheme = enumFromStringExists({
    obj: Theme,
    value: theme2
  }) ? theme2 : Theme.DARK;
  applyTheme({ theme: initialTheme, preserve: false });
  return initialTheme;
};
const applyTheme = ({ theme: theme2, preserve = true }) => {
  const { documentElement, head } = document;
  documentElement.setAttribute(THEME_ATTRIBUTE, theme2);
  const color = getComputedStyle(documentElement).getPropertyValue("--theme-color");
  head?.children?.namedItem("theme-color")?.setAttribute("content", color.trim());
  if (preserve) {
    localStorage.setItem(LOCALSTORAGE_THEME_KEY, JSON.stringify(theme2));
  }
};
initTheme();
var Menu;
(function(Menu2) {
  Menu2["COLLAPSED"] = "collapsed";
  Menu2["EXPANDED"] = "expanded";
})(Menu || (Menu = {}));
const MENU_ATTRIBUTE = "menu";
const LOCALSTORAGE_MENU_KEY = "nnsMenu";
const initMenu = () => {
  if (isNode()) {
    return void 0;
  }
  const menu = document.documentElement.getAttribute(MENU_ATTRIBUTE);
  const initialMenu2 = enumFromStringExists({
    obj: Menu,
    value: menu
  }) ? menu : Menu.EXPANDED;
  applyMenu({ menu: initialMenu2, preserve: false });
  return initialMenu2;
};
const applyMenu = ({ menu, preserve = true }) => {
  const { documentElement } = document;
  documentElement.setAttribute(MENU_ATTRIBUTE, menu);
  if (preserve) {
    localStorage.setItem(LOCALSTORAGE_MENU_KEY, JSON.stringify(menu));
  }
};
const initialMenu = initMenu();
const initMenuStore = () => {
  const { subscribe: subscribe2, update } = writable(initialMenu);
  return {
    subscribe: subscribe2,
    toggle: () => {
      update((state) => {
        const menu = state === Menu.EXPANDED ? Menu.COLLAPSED : Menu.EXPANDED;
        applyMenu({ menu, preserve: true });
        return menu;
      });
    }
  };
};
const menuStore = initMenuStore();
derived(menuStore, ($menuStore) => $menuStore === Menu.COLLAPSED);
const css$8 = {
  code: ".modal.svelte-1bbimtl.svelte-1bbimtl{position:fixed;top:0;right:0;bottom:0;left:0;z-index:var(--modal-z-index);touch-action:initial;cursor:initial}.wrapper.svelte-1bbimtl.svelte-1bbimtl{position:absolute;top:50%;left:50%;transform:translate(-50%, -50%);display:flex;flex-direction:column;background:var(--overlay-background);color:var(--overlay-background-contrast);--button-secondary-background:var(--focus-background);overflow:hidden;box-sizing:border-box;box-shadow:var(--overlay-box-shadow)}.wrapper.svelte-1bbimtl .container-wrapper.svelte-1bbimtl{margin:var(--padding-1_5x) var(--padding-2x) auto;display:flex;flex-direction:column;gap:var(--padding-1_5x);flex:1;overflow:hidden}.wrapper.alert.svelte-1bbimtl.svelte-1bbimtl{width:var(--alert-width);max-width:var(--alert-max-width);max-height:var(--alert-max-height);border-radius:var(--alert-border-radius)}.wrapper.alert.svelte-1bbimtl .header.svelte-1bbimtl{padding:var(--alert-padding-y) var(--alert-padding-x) var(--padding)}.wrapper.alert.svelte-1bbimtl .container-wrapper.svelte-1bbimtl{margin-bottom:calc(var(--alert-padding-y) * 2 / 3)}.wrapper.alert.svelte-1bbimtl .content.svelte-1bbimtl{margin:0 0 calc(var(--alert-padding-y) / 2);padding:calc(var(--alert-padding-y) / 2) calc(var(--alert-padding-x) / 2) 0}.wrapper.alert.svelte-1bbimtl .footer.svelte-1bbimtl{padding:0 var(--alert-padding-x) calc(var(--alert-padding-y) * 2 / 3)}@media(min-width: 576px){.wrapper.alert.svelte-1bbimtl .footer.svelte-1bbimtl{justify-content:flex-end}}.wrapper.dialog.svelte-1bbimtl.svelte-1bbimtl{width:var(--dialog-width);max-width:var(--dialog-max-width);min-height:var(--dialog-min-height);height:var(--dialog-height);max-height:var(--dialog-max-height, 100%);border-radius:var(--dialog-border-radius)}@supports (-webkit-touch-callout: none){.wrapper.dialog.svelte-1bbimtl.svelte-1bbimtl{max-height:-webkit-fill-available}@media(min-width: 768px){.wrapper.dialog.svelte-1bbimtl.svelte-1bbimtl{max-height:var(--dialog-max-height, 100%)}}}.wrapper.dialog.svelte-1bbimtl .header.svelte-1bbimtl{padding:var(--dialog-padding-y) var(--padding-3x) var(--padding)}.wrapper.dialog.svelte-1bbimtl .container-wrapper.svelte-1bbimtl{margin-bottom:var(--dialog-padding-y)}.wrapper.dialog.svelte-1bbimtl .content.svelte-1bbimtl{margin:0;padding:var(--dialog-padding-y) var(--dialog-padding-x)}.header.svelte-1bbimtl.svelte-1bbimtl{display:grid;grid-template-columns:1fr auto 1fr;gap:var(--padding);z-index:var(--z-index);position:relative}.header.svelte-1bbimtl h2.svelte-1bbimtl{white-space:var(--text-white-space, nowrap);overflow:hidden;text-overflow:ellipsis;grid-column-start:2;text-align:center}.header.svelte-1bbimtl button.svelte-1bbimtl{display:flex;justify-content:center;align-items:center;padding:0;justify-self:flex-end}.header.svelte-1bbimtl button.svelte-1bbimtl:active,.header.svelte-1bbimtl button.svelte-1bbimtl:focus,.header.svelte-1bbimtl button.svelte-1bbimtl:hover{background:var(--background-shade);border-radius:var(--border-radius)}.content.svelte-1bbimtl.svelte-1bbimtl{overflow-y:var(--modal-content-overflow-y, auto);overflow-x:hidden}.container.svelte-1bbimtl.svelte-1bbimtl{position:relative;display:flex;flex-direction:column;flex:1;overflow:hidden;border-radius:16px;background:var(--overlay-content-background);color:var(--overlay-content-background-contrast)}",
  map: null
};
const Modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $$slots = compute_slots(slots);
  let $i18n, $$unsubscribe_i18n;
  $$unsubscribe_i18n = subscribe(i18n, (value) => $i18n = value);
  let { visible = true } = $$props;
  let { role = "dialog" } = $$props;
  let { testId = void 0 } = $$props;
  let { disablePointerEvents = false } = $$props;
  let showHeader;
  let showFooterAlert;
  createEventDispatcher();
  const modalTitleId = nextElementId("modal-title-");
  const modalContentId = nextElementId("modal-content-");
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.role === void 0 && $$bindings.role && role !== void 0)
    $$bindings.role(role);
  if ($$props.testId === void 0 && $$bindings.testId && testId !== void 0)
    $$bindings.testId(testId);
  if ($$props.disablePointerEvents === void 0 && $$bindings.disablePointerEvents && disablePointerEvents !== void 0)
    $$bindings.disablePointerEvents(disablePointerEvents);
  $$result.css.add(css$8);
  showHeader = nonNullish($$slots.title);
  showFooterAlert = nonNullish($$slots.footer) && role === "alert";
  $$unsubscribe_i18n();
  return `${visible ? `<div class="modal svelte-1bbimtl"${add_attribute("role", role, 0)}${add_attribute("data-tid", testId, 0)}${add_attribute("aria-labelledby", showHeader ? modalTitleId : void 0, 0)}${add_attribute("aria-describedby", modalContentId, 0)}>${validate_component(Backdrop, "Backdrop").$$render($$result, { disablePointerEvents }, {}, {})} <div class="${escape(null_to_empty(`wrapper ${role}`), true) + " svelte-1bbimtl"}">${showHeader ? `<div class="header svelte-1bbimtl"><h2${add_attribute("id", modalTitleId, 0)} data-tid="modal-title" class="svelte-1bbimtl">${slots.title ? slots.title({}) : ``}</h2> ${!disablePointerEvents ? `<button data-tid="close-modal"${add_attribute("aria-label", $i18n.core.close, 0)} class="svelte-1bbimtl">${validate_component(IconClose, "IconClose").$$render($$result, { size: "24px" }, {}, {})}</button>` : ``}</div>` : ``} <div class="container-wrapper svelte-1bbimtl">${slots["sub-title"] ? slots["sub-title"]({}) : ``} <div class="container svelte-1bbimtl"><div class="${["content svelte-1bbimtl", role === "alert" ? "alert" : ""].join(" ").trim()}"${add_attribute("id", modalContentId, 0)}>${slots.default ? slots.default({}) : ``}</div></div></div> ${showFooterAlert ? `<div class="footer toolbar svelte-1bbimtl">${slots.footer ? slots.footer({}) : ``}</div>` : ``}</div></div>` : ``}`;
});
const initToastsStore = () => {
  const { subscribe: subscribe2, update, set } = writable([]);
  return {
    subscribe: subscribe2,
    show({ id, ...rest }) {
      const toastId = id ?? Symbol("toast");
      update((messages) => {
        return [...messages, { ...rest, id: toastId }];
      });
      return toastId;
    },
    hide(idToHide) {
      update((messages) => messages.filter(({ id }) => id !== idToHide));
    },
    update({ id, content }) {
      update((messages) => (
        // use map to preserve order
        messages.map((message) => {
          if (message.id !== id) {
            return message;
          }
          return {
            ...message,
            ...content
          };
        })
      ));
    },
    reset(levels) {
      if (nonNullish(levels) && levels.length > 0) {
        update((messages) => messages.filter(({ level }) => !levels.includes(level)));
        return;
      }
      set([]);
    }
  };
};
const toastsStore = initToastsStore();
const css$7 = {
  code: ".toast.svelte-w1j1kj.svelte-w1j1kj{display:flex;justify-content:space-between;align-items:center;gap:var(--padding-1_5x);background:var(--overlay-background);color:var(--overlay-background-contrast);--button-secondary-background:var(--focus-background);border-radius:var(--border-radius);box-shadow:var(--strong-shadow, 8px 8px 16px 0 rgba(0, 0, 0, 0.25));padding:var(--padding-1_5x);box-sizing:border-box}.toast.inverted.svelte-w1j1kj.svelte-w1j1kj{background:var(--toast-inverted-background);color:var(--toast-inverted-background-contrast)}.toast.svelte-w1j1kj .icon.svelte-w1j1kj{line-height:0}.toast.svelte-w1j1kj .icon.success.svelte-w1j1kj{color:var(--positive-emphasis)}.toast.svelte-w1j1kj .icon.info.svelte-w1j1kj{color:var(--primary)}.toast.svelte-w1j1kj .icon.warn.svelte-w1j1kj{color:var(--warning-emphasis-shade)}.toast.svelte-w1j1kj .icon.error.svelte-w1j1kj{color:var(--negative-emphasis)}.toast.svelte-w1j1kj .msg.svelte-w1j1kj{flex-grow:1;margin:0;word-break:break-word}.toast.svelte-w1j1kj .msg.scroll.svelte-w1j1kj{overflow-y:auto;max-height:calc(var(--font-size-standard) * 3 * 1.3);line-height:normal}.toast.svelte-w1j1kj .msg.truncate.svelte-w1j1kj{white-space:var(--text-white-space, nowrap);overflow:hidden;text-overflow:ellipsis}.toast.svelte-w1j1kj .msg.truncate .title.svelte-w1j1kj{white-space:var(--text-white-space, nowrap);overflow:hidden;text-overflow:ellipsis}.toast.svelte-w1j1kj .msg.clamp.svelte-w1j1kj{display:-webkit-box;-webkit-box-orient:vertical;-webkit-line-clamp:3;overflow:hidden}.toast.svelte-w1j1kj .msg.clamp .title.svelte-w1j1kj{display:-webkit-box;-webkit-box-orient:vertical;-webkit-line-clamp:2;overflow:hidden}.toast.svelte-w1j1kj .title.svelte-w1j1kj{display:block;font-size:var(--font-size-standard);line-height:var(--line-height-standard);font-weight:var(--font-weight-bold);line-height:normal}.toast.svelte-w1j1kj button.close.svelte-w1j1kj{padding:0;line-height:0;color:inherit}",
  map: null
};
const Toast = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $i18n, $$unsubscribe_i18n;
  $$unsubscribe_i18n = subscribe(i18n, (value) => $i18n = value);
  let { msg } = $$props;
  const iconMapper = (level2) => ({
    ["success"]: IconCheckCircle,
    ["warn"]: IconWarning,
    ["error"]: IconError,
    ["info"]: IconInfo,
    ["custom"]: void 0
  })[level2];
  let text2;
  let level;
  let spinner;
  let title;
  let overflow;
  let position;
  let icon;
  let theme2;
  let renderAsHtml;
  let scroll;
  let truncate;
  let clamp;
  let timeoutId = void 0;
  const cleanUpAutoHide = () => {
    if (isNullish(timeoutId)) {
      return;
    }
    clearTimeout(timeoutId);
  };
  const minHeightMessage = `min-height: ${DEFAULT_ICON_SIZE}px;`;
  onDestroy(cleanUpAutoHide);
  if ($$props.msg === void 0 && $$bindings.msg && msg !== void 0)
    $$bindings.msg(msg);
  $$result.css.add(css$7);
  ({ text: text2, level, spinner, title, overflow, position, icon, theme: theme2, renderAsHtml } = msg);
  scroll = overflow === void 0 || overflow === "scroll";
  truncate = overflow === "truncate";
  clamp = overflow === "clamp";
  $$unsubscribe_i18n();
  return `<div role="dialog" class="${escape(null_to_empty(`toast ${theme2 ?? "themed"}`), true) + " svelte-w1j1kj"}"><div class="${"icon " + escape(level, true) + " svelte-w1j1kj"}" aria-hidden="true">${spinner ? `${validate_component(Spinner, "Spinner").$$render($$result, { size: "small", inline: true }, {}, {})}` : `${nonNullish(icon) ? `${validate_component(icon || missing_component, "svelte:component").$$render($$result, {}, {}, {})}` : `${iconMapper(level) ? `${validate_component(iconMapper(level) || missing_component, "svelte:component").$$render($$result, { size: DEFAULT_ICON_SIZE }, {}, {})}` : ``}`}`}</div> <p class="${[
    "msg svelte-w1j1kj",
    (truncate ? "truncate" : "") + " " + (clamp ? "clamp" : "") + " " + (scroll ? "scroll" : "")
  ].join(" ").trim()}"${add_attribute("style", minHeightMessage, 0)}>${nonNullish(title) ? `<span class="title svelte-w1j1kj">${escape(title)}</span>` : ``} ${renderAsHtml ? `${validate_component(Html, "Html").$$render($$result, { text: text2 }, {}, {})}` : `${escape(text2)}`}</p> <button class="close svelte-w1j1kj"${add_attribute("aria-label", $i18n.core.close, 0)}>${validate_component(IconClose, "IconClose").$$render($$result, {}, {}, {})}</button> </div>`;
});
const css$6 = {
  code: ".wrapper.svelte-24m335{position:fixed;left:50%;transform:translate(-50%, 0);bottom:calc(var(--layout-bottom-offset, 0) + var(--padding-2x));width:calc(100% - var(--padding-8x) - var(--padding-0_5x));display:flex;flex-direction:column;gap:var(--padding);z-index:var(--toast-info-z-index)}.wrapper.error.svelte-24m335{z-index:var(--toast-error-z-index)}@media(min-width: 1024px){.wrapper.svelte-24m335{max-width:calc(var(--section-max-width) - var(--padding-2x))}}.top.svelte-24m335{top:calc(var(--header-height) + var(--padding-3x));bottom:unset;width:calc(100% - var(--padding-6x))}@media(min-width: 1024px){.top.svelte-24m335{right:var(--padding-2x);left:unset;transform:none;max-width:calc(var(--section-max-width) / 1.5 - var(--padding-2x))}}",
  map: null
};
const Toasts = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $toastsStore, $$unsubscribe_toastsStore;
  let $layoutBottomOffset, $$unsubscribe_layoutBottomOffset;
  $$unsubscribe_toastsStore = subscribe(toastsStore, (value) => $toastsStore = value);
  $$unsubscribe_layoutBottomOffset = subscribe(layoutBottomOffset, (value) => $layoutBottomOffset = value);
  let { position = "bottom" } = $$props;
  let toasts = [];
  let hasErrors;
  if ($$props.position === void 0 && $$bindings.position && position !== void 0)
    $$bindings.position(position);
  $$result.css.add(css$6);
  toasts = $toastsStore.filter(({ position: pos }) => (pos ?? "bottom") === position);
  hasErrors = toasts.find(({ level }) => ["error", "warn"].includes(level)) !== void 0;
  $$unsubscribe_toastsStore();
  $$unsubscribe_layoutBottomOffset();
  return `${toasts.length > 0 ? `<div class="${[
    escape(null_to_empty(`wrapper ${position}`), true) + " svelte-24m335",
    hasErrors ? "error" : ""
  ].join(" ").trim()}"${add_attribute("style", `--layout-bottom-offset: ${$layoutBottomOffset}px`, 0)}>${each(toasts, (msg) => {
    return `${validate_component(Toast, "Toast").$$render($$result, { msg }, {}, {})}`;
  })}</div>` : ``}`;
});
const css$5 = {
  code: "div.svelte-j8eaq1{width:100%}",
  map: null
};
const DEFAULT_OFFSET = 200;
const WizardTransition = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { transition = { diff: 0 } } = $$props;
  let absolutOffset = DEFAULT_OFFSET;
  if ($$props.transition === void 0 && $$bindings.transition && transition !== void 0)
    $$bindings.transition(transition);
  $$result.css.add(css$5);
  transition.diff === 0 ? 0 : transition.diff > 0 ? absolutOffset : -absolutOffset;
  return `<div class="svelte-j8eaq1">${slots.default ? slots.default({}) : ``}</div>`;
});
class WizardStepsState {
  currentStep;
  currentStepIndex = 0;
  previousStepIndex = 0;
  steps;
  constructor(steps) {
    this.steps = steps;
    this.currentStep = this.steps[0];
  }
  next() {
    if (this.currentStepIndex < this.steps.length - 1) {
      this.move(this.currentStepIndex + 1);
    }
    return this;
  }
  get diff() {
    return this.currentStepIndex - this.previousStepIndex;
  }
  back() {
    if (this.currentStepIndex > 0) {
      this.move(this.currentStepIndex - 1);
    }
    return this;
  }
  set(newStep) {
    this.move(newStep);
    return this;
  }
  move(nextStep) {
    this.previousStepIndex = this.currentStepIndex;
    this.currentStepIndex = nextStep;
    this.currentStep = this.steps[this.currentStepIndex];
  }
}
const WizardModal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { steps } = $$props;
  let { disablePointerEvents = false } = $$props;
  let { testId = void 0 } = $$props;
  let stepState;
  let { currentStep } = $$props;
  let transition;
  const next = () => stepState = stepState.next();
  const back = () => stepState = stepState.back();
  const set = (step) => stepState = stepState.set(step);
  createEventDispatcher();
  if ($$props.steps === void 0 && $$bindings.steps && steps !== void 0)
    $$bindings.steps(steps);
  if ($$props.disablePointerEvents === void 0 && $$bindings.disablePointerEvents && disablePointerEvents !== void 0)
    $$bindings.disablePointerEvents(disablePointerEvents);
  if ($$props.testId === void 0 && $$bindings.testId && testId !== void 0)
    $$bindings.testId(testId);
  if ($$props.currentStep === void 0 && $$bindings.currentStep && currentStep !== void 0)
    $$bindings.currentStep(currentStep);
  if ($$props.next === void 0 && $$bindings.next && next !== void 0)
    $$bindings.next(next);
  if ($$props.back === void 0 && $$bindings.back && back !== void 0)
    $$bindings.back(back);
  if ($$props.set === void 0 && $$bindings.set && set !== void 0)
    $$bindings.set(set);
  stepState = new WizardStepsState(steps);
  ({ currentStep } = stepState);
  transition = { diff: stepState.diff };
  return `${`${validate_component(Modal, "Modal").$$render($$result, { testId, disablePointerEvents }, {}, {
    title: () => {
      return `${slots.title ? slots.title({ slot: "title" }) : ``}`;
    },
    default: () => {
      return `${validate_component(WizardTransition, "WizardTransition").$$render($$result, { transition }, {}, {
        default: () => {
          return `${slots.default ? slots.default({}) : ``}`;
        }
      })}`;
    }
  })}`}`;
});
const toastsShow = (msg) => toastsStore.show(msg);
const toastsError = ({
  msg: { text: text2, ...rest },
  err
}) => {
  if (nonNullish(err)) {
    console.error(err);
  }
  return toastsStore.show({
    text: `${text2}${nonNullish(err) ? ` / ${errorDetailToString(err)}` : ""}`,
    ...rest,
    level: "error"
  });
};
var define_process_env_default$8 = { OPENFPL_BACKEND_CANISTER_ID: "bd3sg-teaaa-aaaaa-qaaba-cai", OPENFPL_FRONTEND_CANISTER_ID: "be2us-64aaa-aaaaa-qaabq-cai", __CANDID_UI_CANISTER_ID: "bw4dl-smaaa-aaaaa-qaacq-cai", NEURON_CONTROLLER_CANISTER_ID: "br5f7-7uaaa-aaaaa-qaaca-cai", DFX_NETWORK: "local" };
function createManagerStore() {
  const { subscribe: subscribe2, set } = writable(null);
  let systemState;
  systemStore.subscribe((value) => {
    systemState = value;
  });
  let actor = ActorFactory.createActor(
    idlFactory,
    define_process_env_default$8.OPENFPL_BACKEND_CANISTER_ID
  );
  let newManager = {
    playerIds: [],
    countrymenCountryId: 0,
    username: "",
    goalGetterPlayerId: 0,
    hatTrickHeroGameweek: 0,
    transfersAvailable: 0,
    termsAccepted: false,
    teamBoostGameweek: 0,
    captainFantasticGameweek: 0,
    createDate: 0n,
    countrymenGameweek: 0,
    bankQuarterMillions: 0,
    noEntryPlayerId: 0,
    safeHandsPlayerId: 0,
    history: [],
    braceBonusGameweek: 0,
    favouriteClubId: 0,
    passMasterGameweek: 0,
    teamBoostClubId: 0,
    goalGetterGameweek: 0,
    captainFantasticPlayerId: 0,
    profilePicture: [],
    transferWindowGameweek: 0,
    noEntryGameweek: 0,
    prospectsGameweek: 0,
    safeHandsGameweek: 0,
    principalId: "",
    passMasterPlayerId: 0,
    captainId: 0,
    monthlyBonusesAvailable: 0
  };
  async function getPublicProfile(principalId) {
    try {
      let dto = {
        managerId: principalId
      };
      let result = await actor.getManager(dto);
      if (isError(result)) {
        console.error("Error getting public profile");
      }
      let profile = result.ok;
      return profile;
    } catch (error) {
      console.error("Error fetching manager profile for gameweek:", error);
      throw error;
    }
  }
  async function getTotalManagers() {
    try {
      let result = await actor.getTotalManagers();
      if (isError(result)) {
        console.error("Error getting total managers");
      }
      const managerCountData = result.ok;
      return Number(managerCountData);
    } catch (error) {
      console.error("Error fetching total managers:", error);
      throw error;
    }
  }
  async function getFantasyTeamForGameweek(managerId, gameweek) {
    try {
      const category = "gameweek_points";
      const newHashValues = await actor.getDataHashes();
      let error = isError(newHashValues);
      if (error) {
        console.error("Error fetching hash values");
        return null;
      }
      let dataCacheValues = newHashValues.ok;
      let weelklyLeaderboardHash = dataCacheValues.find(
        (x) => x.category === "weekly_leaderboard_hash"
      ) ?? null;
      const localHash = localStorage.getItem(`${category}_hash`);
      if (weelklyLeaderboardHash != localHash) {
        let result = await actor.getManagerGameweek(
          managerId,
          systemState?.calculationGameweek,
          gameweek
        );
        if (isError(result)) {
          console.error("Error fetching fantasy team for gameweek:");
        }
        let snapshot = result.ok;
        localStorage.setItem(category, JSON.stringify(snapshot, replacer));
        localStorage.setItem(
          `${category}_hash`,
          weelklyLeaderboardHash?.hash ?? ""
        );
        const fantasyTeamData = result.ok;
        return fantasyTeamData;
      } else {
        const cachedSnapshot = localStorage.getItem(category);
        let snapshot = JSON.parse(cachedSnapshot || "undefined");
        return snapshot;
      }
    } catch (error) {
      console.error("Error fetching fantasy team for gameweek:", error);
      throw error;
    }
  }
  async function getCurrentTeam() {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default$8.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.getCurrentTeam();
      if (isError(result)) {
        return newManager;
      }
      let fantasyTeam = result.ok;
      return fantasyTeam;
    } catch (error) {
      console.error("Error fetching fantasy team:", error);
      throw error;
    }
  }
  async function saveFantasyTeam(userFantasyTeam, activeGameweek, bonusUsedInSession, transferWindowPlayedInSession) {
    try {
      let bonusPlayed = 0;
      let bonusPlayerId = 0;
      let bonusTeamId = 0;
      let bonusCountryId = 0;
      if (bonusUsedInSession) {
        bonusPlayerId = getBonusPlayerId(userFantasyTeam, activeGameweek);
        bonusTeamId = getBonusTeamId(userFantasyTeam, activeGameweek);
        bonusPlayed = getBonusPlayed(userFantasyTeam, activeGameweek);
        bonusCountryId = getBonusCountryId(userFantasyTeam, activeGameweek);
      }
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default$8.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let dto = {
        playerIds: userFantasyTeam.playerIds,
        captainId: userFantasyTeam.captainId,
        goalGetterGameweek: bonusPlayed == 1 ? activeGameweek : userFantasyTeam.goalGetterGameweek,
        goalGetterPlayerId: bonusPlayerId,
        passMasterGameweek: bonusPlayed == 2 ? activeGameweek : userFantasyTeam.passMasterGameweek,
        passMasterPlayerId: bonusPlayerId,
        noEntryGameweek: bonusPlayed == 3 ? activeGameweek : userFantasyTeam.noEntryGameweek,
        noEntryPlayerId: bonusPlayerId,
        teamBoostGameweek: bonusPlayed == 4 ? activeGameweek : userFantasyTeam.teamBoostGameweek,
        teamBoostClubId: bonusTeamId,
        safeHandsGameweek: bonusPlayed == 5 ? activeGameweek : userFantasyTeam.safeHandsGameweek,
        safeHandsPlayerId: bonusPlayerId,
        captainFantasticGameweek: bonusPlayed == 6 ? activeGameweek : userFantasyTeam.captainFantasticGameweek,
        captainFantasticPlayerId: bonusPlayerId,
        countrymenGameweek: bonusPlayed == 7 ? activeGameweek : userFantasyTeam.countrymenGameweek,
        countrymenCountryId: bonusCountryId,
        prospectsGameweek: bonusPlayed == 8 ? activeGameweek : userFantasyTeam.prospectsGameweek,
        braceBonusGameweek: bonusPlayed == 9 ? activeGameweek : userFantasyTeam.braceBonusGameweek,
        hatTrickHeroGameweek: bonusPlayed == 10 ? activeGameweek : userFantasyTeam.hatTrickHeroGameweek,
        transferWindowGameweek: transferWindowPlayedInSession ? activeGameweek : userFantasyTeam.transferWindowGameweek,
        username: userFantasyTeam.username
      };
      let result = await identityActor.saveFantasyTeam(dto);
      if (isError(result)) {
        console.error("Error saving fantasy team", result);
        return;
      }
      const fantasyTeam = result.ok;
      return fantasyTeam;
    } catch (error) {
      console.error("Error saving fantasy team:", error);
      throw error;
    }
  }
  function getBonusPlayed(userFantasyTeam, activeGameweek) {
    let bonusPlayed = 0;
    if (userFantasyTeam.goalGetterGameweek === activeGameweek) {
      bonusPlayed = 1;
    }
    if (userFantasyTeam.passMasterGameweek === activeGameweek) {
      bonusPlayed = 2;
    }
    if (userFantasyTeam.noEntryGameweek === activeGameweek) {
      bonusPlayed = 3;
    }
    if (userFantasyTeam.teamBoostGameweek === activeGameweek) {
      bonusPlayed = 4;
    }
    if (userFantasyTeam.safeHandsGameweek === activeGameweek) {
      bonusPlayed = 5;
    }
    if (userFantasyTeam.captainFantasticGameweek === activeGameweek) {
      bonusPlayed = 6;
    }
    if (userFantasyTeam.prospectsGameweek === activeGameweek) {
      bonusPlayed = 7;
    }
    if (userFantasyTeam.countrymenGameweek === activeGameweek) {
      bonusPlayed = 8;
    }
    if (userFantasyTeam.hatTrickHeroGameweek === activeGameweek) {
      bonusPlayed = 9;
    }
    if (userFantasyTeam.hatTrickHeroGameweek === activeGameweek) {
      bonusPlayed = 10;
    }
    return bonusPlayed;
  }
  function getBonusPlayerId(userFantasyTeam, activeGameweek) {
    let bonusPlayerId = 0;
    if (userFantasyTeam.goalGetterGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.goalGetterPlayerId;
    }
    if (userFantasyTeam.passMasterGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.passMasterPlayerId;
    }
    if (userFantasyTeam.noEntryGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.noEntryPlayerId;
    }
    if (userFantasyTeam.safeHandsGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.safeHandsPlayerId;
    }
    if (userFantasyTeam.captainFantasticGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.captainId;
    }
    return bonusPlayerId;
  }
  function getBonusTeamId(userFantasyTeam, activeGameweek) {
    let bonusTeamId = 0;
    if (userFantasyTeam.teamBoostGameweek === activeGameweek) {
      bonusTeamId = userFantasyTeam.teamBoostClubId;
    }
    return bonusTeamId;
  }
  function getBonusCountryId(userFantasyTeam, activeGameweek) {
    let bonusCountryId = 0;
    if (userFantasyTeam.countrymenGameweek === activeGameweek) {
      bonusCountryId = userFantasyTeam.countrymenCountryId;
    }
    return bonusCountryId;
  }
  async function snapshotFantasyTeams() {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default$8.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      await identityActor.snapshotFantasyTeams();
    } catch (error) {
      console.error("Error snapshotting fantasy teams:", error);
      throw error;
    }
  }
  return {
    subscribe: subscribe2,
    getTotalManagers,
    getFantasyTeamForGameweek,
    getCurrentTeam,
    saveFantasyTeam,
    snapshotFantasyTeams,
    getPublicProfile
  };
}
createManagerStore();
var define_process_env_default$7 = { OPENFPL_BACKEND_CANISTER_ID: "bd3sg-teaaa-aaaaa-qaaba-cai", OPENFPL_FRONTEND_CANISTER_ID: "be2us-64aaa-aaaaa-qaabq-cai", __CANDID_UI_CANISTER_ID: "bw4dl-smaaa-aaaaa-qaacq-cai", NEURON_CONTROLLER_CANISTER_ID: "br5f7-7uaaa-aaaaa-qaaca-cai", DFX_NETWORK: "local" };
function createCountriesStore() {
  const { subscribe: subscribe2, set } = writable([]);
  let actor = ActorFactory.createActor(
    idlFactory,
    define_process_env_default$7.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category = "countries";
    const newHashValues = await actor.getDataHashes();
    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing countries store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(`${category}_hash`);
    if (categoryHash?.hash != localHash) {
      let result = await actor.getCountries();
      if (isError(result)) {
        console.error("Error fetching countries");
      }
      let updatedCountriesData = result.ok;
      localStorage.setItem(
        category,
        JSON.stringify(updatedCountriesData, replacer)
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedCountriesData);
    } else {
      const cachedCountriesData = localStorage.getItem(category);
      let cachedCountries = [];
      try {
        cachedCountries = JSON.parse(cachedCountriesData || "[]");
      } catch (e) {
        cachedCountries = [];
      }
      set(cachedCountries);
    }
  }
  return {
    subscribe: subscribe2,
    sync
  };
}
const countriesStore = createCountriesStore();
var define_process_env_default$6 = { OPENFPL_BACKEND_CANISTER_ID: "bd3sg-teaaa-aaaaa-qaaba-cai", OPENFPL_FRONTEND_CANISTER_ID: "be2us-64aaa-aaaaa-qaabq-cai", __CANDID_UI_CANISTER_ID: "bw4dl-smaaa-aaaaa-qaacq-cai", NEURON_CONTROLLER_CANISTER_ID: "br5f7-7uaaa-aaaaa-qaaca-cai", DFX_NETWORK: "local" };
function createWeeklyLeaderboardStore() {
  const { subscribe: subscribe2, set } = writable(null);
  const itemsPerPage = 25;
  const category = "weekly_leaderboard";
  let actor = ActorFactory.createActor(
    idlFactory,
    define_process_env_default$6.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync(seasonId, gameweek) {
    const newHashValues = await actor.getDataHashes();
    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing leaderboard store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(`${category}_hash`);
    if (categoryHash?.hash != localHash) {
      let result = await actor.getWeeklyLeaderboard(
        seasonId,
        gameweek,
        100,
        0,
        ""
      );
      if (isError(result)) {
        let emptyLeaderboard = {
          entries: [],
          gameweek: 0,
          seasonId: 0,
          totalEntries: 0n
        };
        localStorage.setItem(
          category,
          JSON.stringify(emptyLeaderboard, replacer)
        );
        localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
        console.error("error fetching leaderboard store");
        return;
      }
      let updatedLeaderboardData = result.ok;
      localStorage.setItem(
        category,
        JSON.stringify(updatedLeaderboardData.ok, replacer)
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedLeaderboardData.ok);
    }
  }
  async function getWeeklyLeaderboard(seasonId, gameweek, currentPage, calculationGameweek, searchTerm) {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    if (currentPage <= 4 && gameweek == calculationGameweek) {
      const cachedData = localStorage.getItem(category);
      if (cachedData) {
        let cachedWeeklyLeaderboard;
        cachedWeeklyLeaderboard = JSON.parse(cachedData, replacer);
        if (cachedWeeklyLeaderboard) {
          return {
            ...cachedWeeklyLeaderboard,
            entries: cachedWeeklyLeaderboard.entries.slice(
              offset,
              offset + limit
            )
          };
        }
      }
    }
    let dto = {
      offset: BigInt(offset),
      seasonId,
      limit: BigInt(limit),
      searchTerm,
      gameweek
    };
    let leaderboardData = await actor.getWeeklyLeaderboard(dto);
    if (isError(leaderboardData)) {
      let emptyLeaderboard = {
        entries: [],
        gameweek: 0,
        seasonId: 0,
        totalEntries: 0n
      };
      localStorage.setItem(
        category,
        JSON.stringify(emptyLeaderboard, replacer)
      );
      return { entries: [], gameweek: 0, seasonId: 0, totalEntries: 0n };
    }
    localStorage.setItem(category, JSON.stringify(leaderboardData, replacer));
    return leaderboardData;
  }
  async function getLeadingWeeklyTeam(seasonId, gameweek) {
    let weeklyLeaderboard = await getWeeklyLeaderboard(
      seasonId,
      gameweek,
      1,
      0,
      ""
    );
    return weeklyLeaderboard.entries[0];
  }
  return {
    subscribe: subscribe2,
    sync,
    getWeeklyLeaderboard,
    getLeadingWeeklyTeam
  };
}
createWeeklyLeaderboardStore();
var define_process_env_default$5 = { OPENFPL_BACKEND_CANISTER_ID: "bd3sg-teaaa-aaaaa-qaaba-cai", OPENFPL_FRONTEND_CANISTER_ID: "be2us-64aaa-aaaaa-qaabq-cai", __CANDID_UI_CANISTER_ID: "bw4dl-smaaa-aaaaa-qaacq-cai", NEURON_CONTROLLER_CANISTER_ID: "br5f7-7uaaa-aaaaa-qaaca-cai", DFX_NETWORK: "local" };
function createPlayerStore() {
  const { subscribe: subscribe2, set } = writable([]);
  systemStore.subscribe((value) => {
  });
  fixtureStore.subscribe((value) => value);
  let actor = ActorFactory.createActor(
    idlFactory,
    define_process_env_default$5.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category = "players";
    const newHashValues = await actor.getDataHashes();
    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing player store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(`${category}_hash`);
    if (categoryHash?.hash != localHash) {
      let result = await actor.getPlayers();
      if (isError(result)) {
        console.error("Error fetching players data");
        return;
      }
      let updatedPlayersData = result.ok;
      localStorage.setItem(
        category,
        JSON.stringify(updatedPlayersData, replacer)
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedPlayersData);
    } else {
      const cachedPlayersData = localStorage.getItem(category);
      let cachedPlayers = [];
      try {
        cachedPlayers = JSON.parse(cachedPlayersData || "[]");
      } catch (e) {
        cachedPlayers = [];
      }
      set(cachedPlayers);
    }
  }
  async function getLoanedPlayers(clubId) {
    let dto = {
      clubId
    };
    let loanedPlayers = await actor.getLoanedPlayers(dto);
    if (isError(loanedPlayers)) {
      console.error("Error fetching loaned players");
      return [];
    }
    return loanedPlayers.ok;
  }
  async function getRetiredPlayers(clubId) {
    let dto = {
      clubId
    };
    let retiredPlayers = await actor.getRetiredPlayers(dto);
    if (isError(retiredPlayers)) {
      console.error("Error fetching retired players");
      return [];
    }
    return retiredPlayers.ok;
  }
  return {
    subscribe: subscribe2,
    sync,
    getLoanedPlayers,
    getRetiredPlayers
  };
}
const playerStore = createPlayerStore();
var define_process_env_default$4 = { OPENFPL_BACKEND_CANISTER_ID: "bd3sg-teaaa-aaaaa-qaaba-cai", OPENFPL_FRONTEND_CANISTER_ID: "be2us-64aaa-aaaaa-qaabq-cai", __CANDID_UI_CANISTER_ID: "bw4dl-smaaa-aaaaa-qaacq-cai", NEURON_CONTROLLER_CANISTER_ID: "br5f7-7uaaa-aaaaa-qaaca-cai", DFX_NETWORK: "local" };
function createPlayerEventsStore() {
  const { subscribe: subscribe2, set } = writable([]);
  let systemState;
  systemStore.subscribe((value) => {
    systemState = value;
  });
  let allFixtures;
  fixtureStore.subscribe((value) => allFixtures = value);
  let actor = ActorFactory.createActor(
    idlFactory,
    define_process_env_default$4.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category = "player_events";
    const newHashValues = await actor.getDataHashes();
    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing player events store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(`${category}_hash`);
    if (categoryHash?.hash != localHash) {
      let dto = {
        seasonId: systemState.calculationSeasonId,
        gameweek: systemState.calculationGameweek
      };
      let result = await actor.getPlayerDetailsForGameweek(dto);
      if (isError(result)) {
        console.error("Error fetching player details for gameweek");
        return;
      }
      let updatedPlayerEventsData = result.ok;
      localStorage.setItem(
        category,
        JSON.stringify(updatedPlayerEventsData, replacer)
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedPlayerEventsData);
    } else {
      const cachedPlayersData = localStorage.getItem(category);
      let cachedPlayerEvents = [];
      try {
        cachedPlayerEvents = JSON.parse(cachedPlayersData || "[]");
      } catch (e) {
        cachedPlayerEvents = [];
      }
      set(cachedPlayerEvents);
    }
  }
  async function getPlayerEvents() {
    const cachedPlayerEventsData = localStorage.getItem("player_events_data");
    let cachedPlayerEvents;
    try {
      cachedPlayerEvents = JSON.parse(cachedPlayerEventsData || "[]");
    } catch (e) {
      cachedPlayerEvents = [];
    }
    return cachedPlayerEvents;
  }
  async function getPlayerDetails(playerId, seasonId) {
    try {
      let dto = {
        playerId,
        seasonId
      };
      let result = await actor.getPlayerDetails(dto);
      if (isError(result)) {
        console.error("Error fetching player details");
      }
      return result.ok;
    } catch (error) {
      console.error("Error fetching player data:", error);
      throw error;
    }
  }
  async function getGameweekPlayers(fantasyTeam, gameweek) {
    await sync();
    let allPlayerEvents = [];
    if (systemState?.calculationGameweek === gameweek) {
      allPlayerEvents = await getPlayerEvents();
    } else {
      allPlayerEvents = await actor.getPlayersDetailsForGameweek(
        fantasyTeam.playerIds,
        systemState?.calculationSeasonId,
        gameweek
      );
    }
    let allPlayers = [];
    const unsubscribe = playerStore.subscribe((players) => {
      allPlayers = players.filter(
        (player) => fantasyTeam.playerIds.includes(player.id)
      );
    });
    unsubscribe();
    let gameweekData = await Promise.all(
      allPlayers.map(
        async (player) => await extractPlayerData(
          allPlayerEvents.find((x) => x.id == player.id),
          player
        )
      )
    );
    const playersWithPoints = gameweekData.map((entry) => {
      const score = calculatePlayerScore(entry, allFixtures);
      const bonusPoints = calculateBonusPoints(entry, fantasyTeam, score);
      const captainPoints = entry.player.id === fantasyTeam.captainId ? score + bonusPoints : 0;
      return {
        ...entry,
        points: score,
        bonusPoints,
        totalPoints: score + bonusPoints + captainPoints
      };
    });
    return await Promise.all(playersWithPoints);
  }
  async function extractPlayerData(playerPointsDTO, player) {
    let goals = 0, assists = 0, redCards = 0, yellowCards = 0, missedPenalties = 0, ownGoals = 0, saves = 0, cleanSheets = 0, penaltySaves = 0, goalsConceded = 0, appearance = 0, highestScoringPlayerId = 0;
    let goalPoints = 0, assistPoints = 0, goalsConcededPoints = 0, cleanSheetPoints = 0;
    playerPointsDTO.events.forEach((event) => {
      switch (convertEvent(event.eventType)) {
        case 0:
          appearance += 1;
          break;
        case 1:
          goals += 1;
          switch (convertPlayerPosition(playerPointsDTO.position)) {
            case 0:
            case 1:
              goalPoints += 20;
              break;
            case 2:
              goalPoints += 15;
              break;
            case 3:
              goalPoints += 10;
              break;
          }
          break;
        case 2:
          assists += 1;
          switch (convertPlayerPosition(playerPointsDTO.position)) {
            case 0:
            case 1:
              assistPoints += 15;
              break;
            case 2:
            case 3:
              assistPoints += 10;
              break;
          }
          break;
        case 3:
          goalsConceded += 1;
          if (convertPlayerPosition(playerPointsDTO.position) < 2 && goalsConceded % 2 === 0) {
            goalsConcededPoints += -15;
          }
          break;
        case 4:
          saves += 1;
          break;
        case 5:
          cleanSheets += 1;
          if (convertPlayerPosition(playerPointsDTO.position) < 2 && goalsConceded === 0) {
            cleanSheetPoints += 10;
          }
          break;
        case 6:
          penaltySaves += 1;
          break;
        case 7:
          missedPenalties += 1;
          break;
        case 8:
          yellowCards += 1;
          break;
        case 9:
          redCards += 1;
          break;
        case 10:
          ownGoals += 1;
          break;
        case 11:
          highestScoringPlayerId += 1;
          break;
      }
    });
    let playerGameweekDetails = {
      player,
      points: playerPointsDTO.points,
      appearance,
      goals,
      assists,
      goalsConceded,
      saves,
      cleanSheets,
      penaltySaves,
      missedPenalties,
      yellowCards,
      redCards,
      ownGoals,
      highestScoringPlayerId,
      goalPoints,
      assistPoints,
      goalsConcededPoints,
      cleanSheetPoints,
      gameweek: playerPointsDTO.gameweek,
      bonusPoints: 0,
      totalPoints: 0,
      isCaptain: false,
      nationalityId: player.nationality
    };
    return playerGameweekDetails;
  }
  function calculatePlayerScore(gameweekData, fixtures) {
    if (!gameweekData) {
      console.error("No gameweek data found:", gameweekData);
      return 0;
    }
    let score = 0;
    let pointsForAppearance = 5;
    let pointsFor3Saves = 5;
    let pointsForPenaltySave = 20;
    let pointsForHighestScore = 25;
    let pointsForRedCard = -20;
    let pointsForPenaltyMiss = -10;
    let pointsForEach2Conceded = -15;
    let pointsForOwnGoal = -10;
    let pointsForYellowCard = -5;
    let pointsForCleanSheet = 10;
    var pointsForGoal = 0;
    var pointsForAssist = 0;
    if (gameweekData.appearance > 0) {
      score += pointsForAppearance * gameweekData.appearance;
    }
    if (gameweekData.redCards > 0) {
      score += pointsForRedCard;
    }
    if (gameweekData.missedPenalties > 0) {
      score += pointsForPenaltyMiss * gameweekData.missedPenalties;
    }
    if (gameweekData.ownGoals > 0) {
      score += pointsForOwnGoal * gameweekData.ownGoals;
    }
    if (gameweekData.yellowCards > 0) {
      score += pointsForYellowCard * gameweekData.yellowCards;
    }
    switch (convertPlayerPosition(gameweekData.player.position)) {
      case 0:
        pointsForGoal = 20;
        pointsForAssist = 15;
        if (gameweekData.saves >= 3) {
          score += Math.floor(gameweekData.saves / 3) * pointsFor3Saves;
        }
        if (gameweekData.penaltySaves) {
          score += pointsForPenaltySave * gameweekData.penaltySaves;
        }
        if (gameweekData.cleanSheets > 0) {
          score += pointsForCleanSheet;
        }
        if (gameweekData.goalsConceded >= 2) {
          score += Math.floor(gameweekData.goalsConceded / 2) * pointsForEach2Conceded;
        }
        break;
      case 1:
        pointsForGoal = 20;
        pointsForAssist = 15;
        if (gameweekData.cleanSheets > 0) {
          score += pointsForCleanSheet;
        }
        if (gameweekData.goalsConceded >= 2) {
          score += Math.floor(gameweekData.goalsConceded / 2) * pointsForEach2Conceded;
        }
        break;
      case 2:
        pointsForGoal = 15;
        pointsForAssist = 10;
        break;
      case 3:
        pointsForGoal = 10;
        pointsForAssist = 10;
        break;
    }
    const gameweekFixtures = fixtures ? fixtures.filter((fixture) => fixture.gameweek === gameweekData.gameweek) : [];
    const playerFixtures = gameweekFixtures.filter(
      (fixture) => (fixture.homeClubId === gameweekData.player.clubId || fixture.awayClubId === gameweekData.player.clubId) && fixture.highestScoringPlayerId === gameweekData.player.id
    );
    if (playerFixtures && playerFixtures.length > 0) {
      score += pointsForHighestScore * playerFixtures.length;
    }
    score += gameweekData.goals * pointsForGoal;
    score += gameweekData.assists * pointsForAssist;
    return score;
  }
  function calculateBonusPoints(gameweekData, fantasyTeam, points) {
    if (!gameweekData) {
      console.error("No gameweek data found:", gameweekData);
      return 0;
    }
    let bonusPoints = 0;
    var pointsForGoal = 0;
    var pointsForAssist = 0;
    switch (convertPlayerPosition(gameweekData.player.position)) {
      case 0:
        pointsForGoal = 20;
        pointsForAssist = 15;
        break;
      case 1:
        pointsForGoal = 20;
        pointsForAssist = 15;
        break;
      case 2:
        pointsForGoal = 15;
        pointsForAssist = 10;
        break;
      case 3:
        pointsForGoal = 10;
        pointsForAssist = 10;
        break;
    }
    if (fantasyTeam.goalGetterGameweek === gameweekData.gameweek && fantasyTeam.goalGetterPlayerId === gameweekData.player.id) {
      bonusPoints = gameweekData.goals * pointsForGoal * 2;
    }
    if (fantasyTeam.passMasterGameweek === gameweekData.gameweek && fantasyTeam.passMasterPlayerId === gameweekData.player.id) {
      bonusPoints = gameweekData.assists * pointsForAssist * 2;
    }
    if (fantasyTeam.noEntryGameweek === gameweekData.gameweek && fantasyTeam.noEntryPlayerId === gameweekData.player.id && (convertPlayerPosition(gameweekData.player.position) === 0 || convertPlayerPosition(gameweekData.player.position) === 1) && gameweekData.cleanSheets) {
      bonusPoints = points * 2;
    }
    if (fantasyTeam.safeHandsGameweek === gameweekData.gameweek && convertPlayerPosition(gameweekData.player.position) === 0 && gameweekData.saves >= 5) {
      bonusPoints = points * 2;
    }
    if (fantasyTeam.captainFantasticGameweek === gameweekData.gameweek && fantasyTeam.captainId === gameweekData.player.id && gameweekData.goals > 0) {
      bonusPoints = points;
    }
    if (fantasyTeam.countrymenGameweek === gameweekData.gameweek && fantasyTeam.countrymenCountryId === gameweekData.player.nationality) {
      bonusPoints = points * 2;
    }
    if (fantasyTeam.prospectsGameweek === gameweekData.gameweek && calculateAgeFromNanoseconds(Number(gameweekData.player.dateOfBirth)) < 21) {
      bonusPoints = points * 2;
    }
    if (fantasyTeam.braceBonusGameweek === gameweekData.gameweek && gameweekData.goals >= 2) {
      bonusPoints = points;
    }
    if (fantasyTeam.hatTrickHeroGameweek === gameweekData.gameweek && gameweekData.goals >= 3) {
      bonusPoints = points * 2;
    }
    if (fantasyTeam.teamBoostGameweek === gameweekData.gameweek && gameweekData.player.clubId === fantasyTeam.teamBoostClubId) {
      bonusPoints = points;
    }
    return bonusPoints;
  }
  return {
    subscribe: subscribe2,
    sync,
    getPlayerDetails,
    getGameweekPlayers
  };
}
createPlayerEventsStore();
var define_process_env_default$3 = { OPENFPL_BACKEND_CANISTER_ID: "bd3sg-teaaa-aaaaa-qaaba-cai", OPENFPL_FRONTEND_CANISTER_ID: "be2us-64aaa-aaaaa-qaabq-cai", __CANDID_UI_CANISTER_ID: "bw4dl-smaaa-aaaaa-qaacq-cai", NEURON_CONTROLLER_CANISTER_ID: "br5f7-7uaaa-aaaaa-qaaca-cai", DFX_NETWORK: "local" };
function createUserStore() {
  const { subscribe: subscribe2, set } = writable(null);
  async function sync() {
    let localStorageString = localStorage.getItem("user_profile_data");
    if (localStorageString) {
      const localProfile = JSON.parse(localStorageString);
      set(localProfile);
      return;
    }
    try {
      await cacheProfile();
    } catch (error) {
      console.error("Error fetching user profile:", error);
      throw error;
    }
  }
  async function updateUsername(username) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default$3.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let dto = {
        username
      };
      const result = await identityActor.updateUsername(dto);
      if (isError(result)) {
        console.error("Error updating username");
        return;
      }
      await cacheProfile();
      return result;
    } catch (error) {
      console.error("Error updating username:", error);
      throw error;
    }
  }
  async function updateFavouriteTeam(favouriteTeamId) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default$3.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let dto = {
        clubId: favouriteTeamId
      };
      const result = await identityActor.updateFavouriteClub(dto);
      if (isError(result)) {
        console.error("Error updating favourite team");
        return;
      }
      await cacheProfile();
      return result;
    } catch (error) {
      console.error("Error updating favourite team:", error);
      throw error;
    }
  }
  async function updateProfilePicture(picture) {
    try {
      const maxPictureSize = 1e3;
      const extension = getFileExtensionFromFile(picture);
      if (picture.size > maxPictureSize * 1024) {
        return null;
      }
      const reader = new FileReader();
      reader.readAsArrayBuffer(picture);
      reader.onloadend = async () => {
        const arrayBuffer = reader.result;
        const uint8Array = new Uint8Array(arrayBuffer);
        try {
          const identityActor = await ActorFactory.createIdentityActor(
            authStore,
            define_process_env_default$3.OPENFPL_BACKEND_CANISTER_ID ?? ""
          );
          let dto = {
            profilePicture: uint8Array,
            extension
          };
          const result = await identityActor.updateProfilePicture(dto);
          if (isError(result)) {
            console.error("Error updating profile picture");
            return;
          }
          await cacheProfile();
          return result;
        } catch (error) {
          console.error(error);
        }
      };
    } catch (error) {
      console.error("Error updating username:", error);
      throw error;
    }
  }
  function getFileExtensionFromFile(file) {
    const filename = file.name;
    const lastIndex = filename.lastIndexOf(".");
    return lastIndex !== -1 ? filename.substring(lastIndex + 1) : "";
  }
  async function isUsernameAvailable(username) {
    const identityActor = await ActorFactory.createIdentityActor(
      authStore,
      define_process_env_default$3.OPENFPL_BACKEND_CANISTER_ID
    );
    let dto = {
      username
    };
    return await identityActor.isUsernameValid(dto);
  }
  async function cacheProfile() {
    const identityActor = await ActorFactory.createIdentityActor(
      authStore,
      define_process_env_default$3.OPENFPL_BACKEND_CANISTER_ID
    );
    let getProfileResponse = await identityActor.getProfile();
    let error = isError(getProfileResponse);
    if (error) {
      console.error("Error fetching user profile");
      return;
    }
    let profileData = getProfileResponse.ok;
    set(profileData);
  }
  return {
    subscribe: subscribe2,
    sync,
    updateUsername,
    updateFavouriteTeam,
    updateProfilePicture,
    isUsernameAvailable,
    cacheProfile
  };
}
const userStore = createUserStore();
const OpenFPLIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 137 188"><path d="M68.8457 0C43.0009 4.21054 19.8233 14.9859 0.331561 30.5217L0.264282 30.6627V129.685L68.7784 187.97L136.528 129.685L136.543 30.6204C117.335 15.7049 94.1282 4.14474 68.8457 0ZM82.388 145.014C82.388 145.503 82.0804 145.992 81.5806 146.114L68.7784 150.329C68.5285 150.39 68.2786 150.39 68.0287 150.329L55.2265 146.114C54.7267 145.931 54.4143 145.503 54.4143 145.014V140.738C54.4143 140.31 54.6642 139.883 55.039 139.7L67.8413 133.102C68.2161 132.919 68.591 132.919 68.9658 133.102L81.768 139.7C82.1429 139.883 82.388 140.31 82.388 140.738V145.014ZM106.464 97.9137C106.464 98.3414 106.214 98.769 105.777 98.9523L96.6607 103.534C96.036 103.84 95.8486 104.573 96.1609 105.122L105.027 121.189C105.277 121.678 105.215 122.228 104.84 122.594L89.7262 137.134C89.2889 137.561 88.6641 137.561 88.1644 137.256L70.9313 125.099C70.369 124.671 70.2441 123.877 70.7439 123.327L84.4208 108.421C85.2329 107.505 84.2958 106.161 83.1713 106.527L68.7447 111.109C68.4948 111.17 68.2449 111.17 67.9951 111.109L53.6358 106.527C52.4488 106.161 51.5742 107.566 52.3863 108.421L66.0584 123.327C66.5582 123.877 66.4332 124.671 65.871 125.099L48.6379 137.256C48.1381 137.561 47.5134 137.561 47.0761 137.134L31.9671 122.533C31.5923 122.167 31.5298 121.617 31.7797 121.128L40.6461 105.061C40.9585 104.45 40.7086 103.778 40.1463 103.473L31.03 98.8912C30.6552 98.7079 30.3428 98.2803 30.3428 97.8526V65.8413C30.3428 64.9249 31.4049 64.314 32.217 64.8639L39.709 69.8122C40.0214 70.0565 40.2088 70.362 40.2088 70.7896L40.2713 79.0368C40.2713 79.4034 40.4587 79.7699 40.7711 80.0143L51.7616 87.5284C52.5737 88.0782 53.6983 87.4673 53.6358 86.4898L52.9486 71.9503C52.9486 71.5838 52.7612 71.2173 52.4488 71.034L30.8426 56.5556C30.5302 56.3112 30.3428 55.9447 30.3428 55.5781V48.4305C30.3428 48.1862 30.4053 47.8807 30.5927 47.6975L38.3971 38.0452C38.7094 37.6176 39.2717 37.4954 39.7715 37.6786L67.9326 47.8807C68.1825 48.0029 68.4948 48.0029 68.7447 47.8807L96.9106 37.6786C97.4104 37.4954 97.9679 37.6786 98.2802 38.0452L106.089 47.6975C106.277 47.8807 106.339 48.1862 106.339 48.4305V55.5781C106.339 55.9447 106.152 56.3112 105.84 56.5556L84.2333 71.034C84.0459 71.2783 83.8585 71.6449 83.8585 72.0114L83.1713 86.5509C83.1088 87.5284 84.2333 88.1393 85.0455 87.5895L96.036 80.0753C96.3484 79.831 96.5358 79.5255 96.5358 79.0979L96.5983 70.8507C96.5983 70.4842 96.7857 70.1176 97.098 69.8733L104.59 64.9249C105.402 64.3751 106.464 64.9249 106.464 65.9024V97.9137Z" fill="#fffff"></path></svg>`;
});
const WalletIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 24 24"><path d="M12.136.326A1.5 1.5 0 0 1 14 1.78V3h.5A1.5 1.5 0 0 1 16 4.5v9a1.5 1.5 0 0 1-1.5 1.5h-13A1.5 1.5 0 0 1 0 13.5v-9a1.5 1.5 0 0 1 1.432-1.499L12.136.326zM5.562 3H13V1.78a.5.5 0 0 0-.621-.484L5.562 3zM1.5 4a.5.5 0 0 0-.5.5v9a.5.5 0 0 0 .5.5h13a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-13z"></path><path d="M15.5,6.5v3a1,1,0,0,1-1,1h-3.5v-5H14.5A1,1,0,0,1,15.5,6.5Z"></path><path d="M12,8a.5,.5 0,1,1,.001,0Z"></path></svg>`;
});
const authSignedInStore = derived(
  authStore,
  ({ identity }) => identity !== null && identity !== void 0
);
const userGetProfilePicture = derived(
  userStore,
  ($user) => {
    try {
      let byteArray;
      if ($user && $user.profilePicture) {
        if (Array.isArray($user.profilePicture) && $user.profilePicture[0] instanceof Uint8Array) {
          byteArray = $user.profilePicture[0];
          return `data:image/${$user.profilePictureType};base64,${uint8ArrayToBase64(byteArray)}`;
        } else if ($user.profilePicture instanceof Uint8Array) {
          return `data:${$user.profilePictureType};base64,${uint8ArrayToBase64(
            $user.profilePicture
          )}`;
        } else {
          if (typeof $user.profilePicture === "string") {
            if ($user.profilePicture.startsWith("data:image")) {
              return $user.profilePicture;
            } else {
              return `data:${$user.profilePictureType};base64,${$user.profilePicture}`;
            }
          }
        }
      }
      return "/profile_placeholder.png";
    } catch (error) {
      console.error(error);
      return "/profile_placeholder.png";
    }
  }
);
derived(
  userStore,
  (user) => user !== null && user !== void 0 ? user.favouriteTeamId : 0
);
const css$4 = {
  code: 'header.svelte-tlhn8x{background-color:rgba(36, 37, 41, 0.9)}.nav-underline.svelte-tlhn8x{position:relative;display:inline-block;color:white}.nav-underline.svelte-tlhn8x::after{content:"";position:absolute;width:100%;height:2px;background-color:#2ce3a6;bottom:0;left:0;transform:scaleX(0);transition:transform 0.3s ease-in-out;color:#2ce3a6}.nav-underline.svelte-tlhn8x:hover::after,.nav-underline.active.svelte-tlhn8x::after{transform:scaleX(1);color:#2ce3a6}.nav-underline.svelte-tlhn8x:hover::after{transform:scaleX(1);background-color:gray}.nav-button.svelte-tlhn8x{background-color:transparent}.nav-button.svelte-tlhn8x:hover{background-color:transparent;color:#2ce3a6;border:none}',
  map: null
};
const Header = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let currentClass;
  let currentBorder;
  let $page, $$unsubscribe_page;
  let $$unsubscribe_systemStore;
  let $$unsubscribe_fixtureStore;
  let $authSignedInStore, $$unsubscribe_authSignedInStore;
  let $userGetProfilePicture, $$unsubscribe_userGetProfilePicture;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  $$unsubscribe_systemStore = subscribe(systemStore, (value) => value);
  $$unsubscribe_fixtureStore = subscribe(fixtureStore, (value) => value);
  $$unsubscribe_authSignedInStore = subscribe(authSignedInStore, (value) => $authSignedInStore = value);
  $$unsubscribe_userGetProfilePicture = subscribe(userGetProfilePicture, (value) => $userGetProfilePicture = value);
  let showProfileDropdown = false;
  onDestroy(() => {
    if (typeof window !== "undefined") {
      document.removeEventListener("click", closeDropdownOnClickOutside);
    }
  });
  function closeDropdownOnClickOutside(event) {
    const target = event.target;
    if (target instanceof Element) {
      if (!target.closest(".profile-dropdown") && !target.closest(".profile-pic")) {
        showProfileDropdown = false;
      }
    }
  }
  $$result.css.add(css$4);
  currentClass = (route) => $page.url.pathname === route ? "text-blue-500 nav-underline active" : "nav-underline";
  currentBorder = (route) => $page.url.pathname === route ? "active-border" : "";
  $$unsubscribe_page();
  $$unsubscribe_systemStore();
  $$unsubscribe_fixtureStore();
  $$unsubscribe_authSignedInStore();
  $$unsubscribe_userGetProfilePicture();
  return `<header class="svelte-tlhn8x"><nav class="text-white"><div class="px-4 h-16 flex justify-between items-center w-full"><a href="/" class="hover:text-gray-400 flex items-center">${validate_component(OpenFPLIcon, "OpenFPLIcon").$$render($$result, { className: "h-8 w-auto" }, {}, {})}<b class="ml-2" data-svelte-h="svelte-6ko9z9">OpenFPL</b></a> <button class="menu-toggle md:hidden focus:outline-none" data-svelte-h="svelte-1xcvmve"><svg width="24" height="18" viewBox="0 0 24 18" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="24" height="2" rx="1" fill="currentColor"></rect><rect y="8" width="24" height="2" rx="1" fill="currentColor"></rect><rect y="16" width="24" height="2" rx="1" fill="currentColor"></rect></svg></button> ${$authSignedInStore ? `<ul class="hidden md:flex h-16"><li class="mx-2 flex items-center h-16"><a href="/" class="${"flex items-center h-full nav-underline hover:text-gray-400 $" + escape(currentClass("/"), true) + " svelte-tlhn8x"}"><span class="flex items-center h-full px-4" data-svelte-h="svelte-fx32ra">Home</span></a></li> <li class="mx-2 flex items-center h-16"><a href="/pick-team" class="${"flex items-center h-full nav-underline hover:text-gray-400 $" + escape(currentClass("/pick-team"), true) + " svelte-tlhn8x"}"><span class="flex items-center h-full px-4" data-svelte-h="svelte-1k6m4hl">Squad Selection</span></a></li> <li class="mx-2 flex items-center h-16"><a href="/governance" class="${"flex items-center h-full nav-underline hover:text-gray-400 $" + escape(currentClass("/governance"), true) + " svelte-tlhn8x"}"><span class="flex items-center h-full px-4" data-svelte-h="svelte-qfd2bh">Governance</span></a></li> <li class="flex flex-1 items-center"><div class="relative inline-block"><button class="${escape(null_to_empty(`h-full flex items-center rounded-sm ${currentBorder("/profile")}`), true) + " svelte-tlhn8x"}"><img${add_attribute("src", $userGetProfilePicture, 0)} alt="Profile" class="h-12 rounded-sm profile-pic" aria-label="Toggle Profile"></button> <div class="${escape(null_to_empty(`absolute right-0 top-full w-48 bg-black rounded-b-md rounded-l-md shadow-lg z-50 profile-dropdown ${showProfileDropdown ? "block" : "hidden"}`), true) + " svelte-tlhn8x"}"><ul class="text-gray-700"><li><a href="/profile" class="flex items-center h-full w-full nav-underline hover:text-gray-400 svelte-tlhn8x"><span class="flex items-center h-full w-full"><img${add_attribute("src", $userGetProfilePicture, 0)} alt="logo" class="h-8 my-2 ml-4 mr-2"> <p class="w-full min-w-[125px] max-w-[125px] truncate" data-svelte-h="svelte-1mjctb">Profile</p></span></a></li> <li><button class="flex items-center justify-center px-4 pb-2 pt-1 text-white rounded-md shadow focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-tlhn8x">Disconnect
                      ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul></div></div></li></ul> <div class="${escape(null_to_empty(`mobile-menu-panel absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${"hidden"} md:hidden`), true) + " svelte-tlhn8x"}"><ul class="flex flex-col"><li class="p-2"><a href="/" class="${escape(null_to_empty(`nav-underline hover:text-gray-400 ${currentClass("/")}`), true) + " svelte-tlhn8x"}">Home</a></li> <li class="p-2"><a href="/pick-team" class="${escape(null_to_empty(currentClass("/pick-team")), true) + " svelte-tlhn8x"}">Squad Selection</a></li> <li class="p-2"><a href="/governance" class="${escape(null_to_empty(currentClass("/governance")), true) + " svelte-tlhn8x"}">Governance</a></li> <li class="p-2"><a href="/profile" class="${"flex h-full w-full nav-underline hover:text-gray-400 w-full $" + escape(currentClass("/profile"), true) + " svelte-tlhn8x"}"><span class="flex items-center h-full w-full"><img${add_attribute("src", $userGetProfilePicture, 0)} alt="logo" class="w-8 h-8 rounded-sm"> <p class="w-full min-w-[100px] max-w-[100px] truncate p-2" data-svelte-h="svelte-f2gegq">Profile</p></span></a></li> <li class="px-2"><button class="flex h-full w-full hover:text-gray-400 w-full items-center">Disconnect
                ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul></div>` : `<ul class="hidden md:flex"><li class="mx-2 flex items-center h-16"><button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-tlhn8x">Connect
              ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul> <div class="${escape(null_to_empty(`mobile-menu-panel absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${"hidden"} md:hidden`), true) + " svelte-tlhn8x"}"><ul class="flex flex-col"><li class="p-2"><button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-tlhn8x">Connect
                ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul></div>`}</div></nav> </header>`;
});
const JunoIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 130 130"><g id="Layer_1-2"><g><path d="M91.99,64.798c0,-20.748 -16.845,-37.593 -37.593,-37.593l-0.003,-0c-20.749,-0 -37.594,16.845 -37.594,37.593l0,0.004c0,20.748 16.845,37.593 37.594,37.593l0.003,0c20.748,0 37.593,-16.845 37.593,-37.593l0,-0.004Z"></path><circle cx="87.153" cy="50.452" r="23.247" style="fill:#7888ff;"></circle></g></g></svg>`;
});
const Footer = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `<footer class="bg-gray-900 text-white py-3"><div class="container mx-1 xs:mx-2 md:mx-auto flex flex-col md:flex-row items-start md:items-center justify-between text-xs"><div class="flex-1" data-svelte-h="svelte-108debi"><div class="flex justify-start"><div class="flex flex-row pl-4"><a href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/?ref=zv6hh-xaaaa-aaaar-ac35q-cai" target="_blank" rel="noopener noreferrer"><img src="/openchat.png" class="h-4 w-auto mb-2 mr-2" alt="OpenChat"></a> <a href="https://github.com/jamesbeadle/OpenFPL" target="_blank" rel="noopener noreferrer"><img src="/github.png" class="h-4 w-auto mb-2" alt="GitHub"></a></div></div> <div class="flex justify-start"><div class="flex flex-col md:flex-row md:space-x-2 pl-4"><a href="/whitepaper" class="hover:text-gray-300">Whitepaper</a> <span class="hidden md:flex">|</span> <a href="/gameplay-rules" class="hover:text-gray-300 md:hidden lg:block">Gameplay Rules</a> <a href="/gameplay-rules" class="hover:text-gray-300 hidden md:block lg:hidden">Rules</a> <span class="hidden md:flex">|</span> <a href="/terms" class="hover:text-gray-300">Terms &amp; Conditions</a></div></div></div> <div class="flex-0"><a href="/"><b class="px-4 mt-2 md:mt-0 md:px-10 flex items-center">${validate_component(OpenFPLIcon, "OpenFplIcon").$$render($$result, { className: "h-6 w-auto mr-2" }, {}, {})}OpenFPL</b></a></div> <div class="flex-1"><div class="flex justify-end"><div class="text-right px-4 md:px-0 mt-1 md:mt-0 md:mr-4"><a href="https://juno.build" target="_blank" class="hover:text-gray-300 flex items-center">Sponsored By juno.build
            ${validate_component(JunoIcon, "JunoIcon").$$render($$result, { className: "h-8 w-auto ml-2" }, {}, {})}</a></div></div></div></div></footer>`;
});
const css$3 = {
  code: "main.svelte-cbh2q9{flex:1;display:flex;flex-direction:column}",
  map: null
};
const Layout = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $$unsubscribe_authStore;
  $$unsubscribe_authStore = subscribe(authStore, (value) => value);
  const init2 = async () => await Promise.all([syncAuthStore()]);
  const syncAuthStore = async () => {
    {
      return;
    }
  };
  $$result.css.add(css$3);
  $$unsubscribe_authStore();
  return ` ${function(__value) {
    if (is_promise(__value)) {
      __value.then(null, noop);
      return ` <div>${validate_component(Spinner, "Spinner").$$render($$result, {}, {}, {})}</div> `;
    }
    return function(_) {
      return ` <div class="flex flex-col h-screen justify-between default-text">${validate_component(Header, "Header").$$render($$result, {}, {}, {})} <main class="page-wrapper svelte-cbh2q9">${slots.default ? slots.default({}) : ``}</main> ${validate_component(Toasts, "Toasts").$$render($$result, {}, {}, {})} ${validate_component(Footer, "Footer").$$render($$result, {}, {}, {})}</div> `;
    }();
  }(init2())} ${validate_component(BusyScreen, "BusyScreen").$$render($$result, {}, {}, {})}`;
});
const BadgeIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  let { primaryColour = "" } = $$props;
  let { secondaryColour = "" } = $$props;
  let { thirdColour = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  if ($$props.primaryColour === void 0 && $$bindings.primaryColour && primaryColour !== void 0)
    $$bindings.primaryColour(primaryColour);
  if ($$props.secondaryColour === void 0 && $$bindings.secondaryColour && secondaryColour !== void 0)
    $$bindings.secondaryColour(secondaryColour);
  if ($$props.thirdColour === void 0 && $$bindings.thirdColour && thirdColour !== void 0)
    $$bindings.thirdColour(thirdColour);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 814 814"><path d="M407 33.9165C295.984 33.9165 135.667 118.708 135.667 118.708V508.75C135.667 508.75 141.044 561.82 152.625 593.541C194.871 709.259 407 780.083 407 780.083C407 780.083 619.129 709.259 661.375 593.541C672.956 561.82 678.333 508.75 678.333 508.75V118.708C678.333 118.708 518.016 33.9165 407 33.9165Z"${add_attribute("fill", primaryColour, 0)}></path><path d="M712.25 101.75V493.013C712.25 649.097 603.581 689.831 407 814C210.419 689.831 101.75 649.063 101.75 493.013V101.75C167.718 45.2448 282.729 0 407 0C531.271 0 646.282 45.2448 712.25 101.75ZM644.417 135.361C585.775 96.052 496.506 67.8333 407.237 67.8333C317.223 67.8333 228.124 96.1198 169.583 135.361V492.979C169.583 595.712 225.817 622.235 407 734.025C587.979 622.337 644.417 595.814 644.417 492.979V135.361Z"${add_attribute("fill", thirdColour, 0)}></path><path d="M407.237 135.667C464.862 135.667 527.811 150.42 576.583 174.467V493.012C576.583 547.347 562.542 558.539 407 654.422L407.237 135.667Z"${add_attribute("fill", secondaryColour, 0)}></path></svg>`;
});
const css$2 = {
  code: ".local-spinner.svelte-pvdm52{border:5px solid rgba(255, 255, 255, 0.3);border-top:5px solid white;border-radius:50%;width:50px;height:50px;position:absolute;top:50%;left:50%;transform:translate(-50%, -50%);animation:svelte-pvdm52-spin 1s linear infinite}@keyframes svelte-pvdm52-spin{0%{transform:translate(-50%, -50%) rotate(0deg)}100%{transform:translate(-50%, -50%) rotate(360deg)}}",
  map: null
};
const Local_spinner = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  $$result.css.add(css$2);
  return `<div class="local-spinner svelte-pvdm52"></div>`;
});
var define_process_env_default$2 = { OPENFPL_BACKEND_CANISTER_ID: "bd3sg-teaaa-aaaaa-qaaba-cai", OPENFPL_FRONTEND_CANISTER_ID: "be2us-64aaa-aaaaa-qaabq-cai", __CANDID_UI_CANISTER_ID: "bw4dl-smaaa-aaaaa-qaacq-cai", NEURON_CONTROLLER_CANISTER_ID: "br5f7-7uaaa-aaaaa-qaaca-cai", DFX_NETWORK: "local" };
function createMonthlyLeaderboardStore() {
  const { subscribe: subscribe2, set } = writable(null);
  const itemsPerPage = 25;
  const category = "monthly_leaderboard_data";
  let systemState;
  systemStore.subscribe((value) => {
    systemState = value;
  });
  let actor = ActorFactory.createActor(
    idlFactory,
    define_process_env_default$2.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category2 = "monthly_leaderboards";
    const newHashValues = await actor.getDataHashes();
    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing monthly leaderboard store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category2) ?? null;
    const localHash = localStorage.getItem(`${category2}_hash`);
    if (categoryHash?.hash != localHash) {
      let result = await actor.getMonthlyLeaderboards();
      if (isError(result)) {
        console.error("Error syncing monthly leaderboards");
        return;
      }
      let updatedLeaderboardData = result.ok;
      localStorage.setItem(
        category2,
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(`${category2}_hash`, categoryHash?.hash ?? "");
      set(updatedLeaderboardData);
    } else {
      const cachedMonthlyLeaderboardsData = localStorage.getItem(category2);
      let cachedMonthlyLeaderboards = [];
      try {
        cachedMonthlyLeaderboards = JSON.parse(
          cachedMonthlyLeaderboardsData || "[]"
        );
      } catch (e) {
        cachedMonthlyLeaderboards = [];
      }
      set(cachedMonthlyLeaderboards);
    }
  }
  async function getMonthlyLeaderboard(seasonId, clubId, month, currentPage, searchTerm) {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    if (currentPage <= 4 && month == systemState?.calculationMonth) {
      const cachedData = localStorage.getItem(category);
      if (cachedData) {
        let cachedLeaderboards = JSON.parse(cachedData);
        let clubLeaderboard2 = cachedLeaderboards.find(
          (x) => x.clubId === clubId
        );
        if (clubLeaderboard2) {
          return {
            ...clubLeaderboard2,
            entries: clubLeaderboard2.entries.slice(offset, offset + limit)
          };
        }
      }
    }
    let result = await actor.getClubLeaderboards(
      seasonId,
      month,
      clubId,
      limit,
      offset,
      searchTerm
    );
    let emptyReturn = {
      month: 0,
      clubId: 0,
      totalEntries: 0n,
      seasonId: 0,
      entries: []
    };
    if (isError(result)) {
      console.error("Error fetching monthly leaderboard");
      return emptyReturn;
    }
    let leaderboardData = result.ok;
    let clubLeaderboard = leaderboardData.find((x) => x.clubId === clubId);
    if (!clubLeaderboard) {
      return emptyReturn;
    }
    return {
      ...clubLeaderboard,
      entries: clubLeaderboard.entries.slice(offset, offset + limit)
    };
  }
  return {
    subscribe: subscribe2,
    sync,
    getMonthlyLeaderboard
  };
}
createMonthlyLeaderboardStore();
var define_process_env_default$1 = { OPENFPL_BACKEND_CANISTER_ID: "bd3sg-teaaa-aaaaa-qaaba-cai", OPENFPL_FRONTEND_CANISTER_ID: "be2us-64aaa-aaaaa-qaabq-cai", __CANDID_UI_CANISTER_ID: "bw4dl-smaaa-aaaaa-qaacq-cai", NEURON_CONTROLLER_CANISTER_ID: "br5f7-7uaaa-aaaaa-qaaca-cai", DFX_NETWORK: "local" };
function createSeasonLeaderboardStore() {
  const { subscribe: subscribe2, set } = writable(null);
  const itemsPerPage = 25;
  const category = "season_leaderboard";
  let systemState;
  systemStore.subscribe((value) => {
    systemState = value;
  });
  let actor = ActorFactory.createActor(
    idlFactory,
    define_process_env_default$1.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category2 = "season_leaderboard";
    const newHashValues = await actor.getDataHashes();
    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing season leaderboard store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category2) ?? null;
    const localHash = localStorage.getItem(`${category2}_hash`);
    if (categoryHash?.hash != localHash) {
      let result = await actor.getSeasonLeaderboard(
        systemState?.calculationSeasonId
      );
      if (isError(result)) {
        console.error("Error syncing season leaderboard.");
        return;
      }
      let updatedLeaderboardData = result.ok;
      localStorage.setItem(
        category2,
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(`${category2}_hash`, categoryHash?.hash ?? "");
      set(updatedLeaderboardData);
    } else {
      const cachedLeaderboardData = localStorage.getItem(category2);
      let cachedSeasonLeaderboard = {
        entries: [],
        seasonId: 0,
        totalEntries: 0n
      };
      try {
        cachedSeasonLeaderboard = JSON.parse(
          cachedLeaderboardData || "{entries: [], gameweek: 0, seasonId: 0, totalEntries: 0n }"
        );
      } catch (e) {
        cachedSeasonLeaderboard = {
          entries: [],
          seasonId: 0,
          totalEntries: 0n
        };
      }
      set(cachedSeasonLeaderboard);
    }
  }
  async function getSeasonLeaderboard(seasonId, currentPage, searchTerm) {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    if (currentPage <= 4 && seasonId == systemState?.calculationSeasonId) {
      const cachedData = localStorage.getItem(category);
      if (cachedData) {
        let cachedSeasonLeaderboard;
        cachedSeasonLeaderboard = JSON.parse(
          cachedData || "{entries: [], seasonId: 0, totalEntries: 0n }"
        );
        if (cachedSeasonLeaderboard) {
          return {
            ...cachedSeasonLeaderboard,
            entries: cachedSeasonLeaderboard.entries.slice(
              offset,
              offset + limit
            )
          };
        }
      }
    }
    let result = await actor.getSeasonLeaderboard(
      seasonId,
      limit,
      offset,
      searchTerm
    );
    if (isError(result)) {
      console.error("Error fetching season leaderboard");
    }
    let leaderboardData = result.ok;
    localStorage.setItem(category, JSON.stringify(leaderboardData, replacer));
    return leaderboardData;
  }
  return {
    subscribe: subscribe2,
    sync,
    getSeasonLeaderboard
  };
}
createSeasonLeaderboardStore();
const Page$g = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $$unsubscribe_systemStore;
  let $$unsubscribe_teamStore;
  let $$unsubscribe_fixtureStore;
  $$unsubscribe_systemStore = subscribe(systemStore, (value) => value);
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => value);
  $$unsubscribe_fixtureStore = subscribe(fixtureStore, (value) => value);
  $$unsubscribe_systemStore();
  $$unsubscribe_teamStore();
  $$unsubscribe_fixtureStore();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
var define_process_env_default = { OPENFPL_BACKEND_CANISTER_ID: "bd3sg-teaaa-aaaaa-qaaba-cai", OPENFPL_FRONTEND_CANISTER_ID: "be2us-64aaa-aaaaa-qaabq-cai", __CANDID_UI_CANISTER_ID: "bw4dl-smaaa-aaaaa-qaacq-cai", NEURON_CONTROLLER_CANISTER_ID: "br5f7-7uaaa-aaaaa-qaaca-cai", DFX_NETWORK: "local" };
function createGovernanceStore() {
  async function revaluePlayerUp(playerId) {
    try {
      await playerStore.sync();
      let allPlayers = [];
      const unsubscribe = playerStore.subscribe((players) => {
        allPlayers = players;
      });
      unsubscribe();
      var dto = {
        playerId
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 1000n,
          payload
        };
        let player = allPlayers.find((x) => x.id == playerId);
        if (player) {
          const command = {
            MakeProposal: {
              title: `Revalue ${player.lastName} value up.`,
              url: "openfpl.xyz/governance",
              summary: `Revalue ${player.lastName} value up from £${(player.valueQuarterMillions / 4).toFixed(2).toLocaleString()}m -> £${((player.valueQuarterMillions + 1) / 4).toFixed(2).toLocaleString()}m).`,
              action: [{ ExecuteGenericNervousSystemFunction: fn }]
            }
          };
          const neuronId = userNeurons[0].id[0];
          if (!neuronId) {
            return;
          }
          await governanceManageNeuron({
            subaccount: neuronId.id,
            command: [command]
          });
        }
      }
    } catch (error) {
      console.error("Error revaluing player up:", error);
      throw error;
    }
  }
  async function revaluePlayerDown(playerId) {
    try {
      await playerStore.sync();
      let allPlayers = [];
      const unsubscribe = playerStore.subscribe((players) => {
        allPlayers = players;
      });
      unsubscribe();
      var dto = {
        playerId
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 2000n,
          payload
        };
        let player = allPlayers.find((x) => x.id == playerId);
        if (player) {
          const command = {
            MakeProposal: {
              title: `Revalue ${player.lastName} value down.`,
              url: "openfpl.xyz/governance",
              summary: `Revalue ${player.lastName} value down from £${(player.valueQuarterMillions / 4).toFixed(2).toLocaleString()}m -> £${((player.valueQuarterMillions - 1) / 4).toFixed(2).toLocaleString()}m).`,
              action: [{ ExecuteGenericNervousSystemFunction: fn }]
            }
          };
          const neuronId = userNeurons[0].id[0];
          if (!neuronId) {
            return;
          }
          await governanceManageNeuron({
            subaccount: neuronId.id,
            command: [command]
          });
        }
      }
    } catch (error) {
      console.error("Error revaluing player down:", error);
      throw error;
    }
  }
  async function submitFixtureData(seasonId, gameweek, fixtureId, playerEventData) {
    try {
      await teamStore.sync();
      let clubs = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      await fixtureStore.sync(seasonId);
      let allFixtures = [];
      const unsubscribeFixtureStore = fixtureStore.subscribe((fixtures) => {
        allFixtures = fixtures;
      });
      unsubscribeFixtureStore();
      let dto = {
        seasonId,
        gameweek,
        fixtureId,
        playerEventData
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 3000n,
          payload
        };
        let fixture = allFixtures.find((x) => x.id == fixtureId);
        if (fixture) {
          let homeClub = clubs.find((x) => x.id == fixture?.homeClubId);
          let awayClub = clubs.find((x) => x.id == fixture?.awayClubId);
          if (!homeClub || !awayClub) {
            return;
          }
          const command = {
            MakeProposal: {
              title: `Fixture Data for ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`,
              url: "openfpl.xyz/governance",
              summary: `Fixture Data for ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`,
              action: [{ ExecuteGenericNervousSystemFunction: fn }]
            }
          };
          const neuronId = userNeurons[0].id[0];
          if (!neuronId) {
            return;
          }
          await governanceManageNeuron({
            subaccount: neuronId.id,
            command: [command]
          });
        }
      }
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }
  async function addInitialFixtures(seasonId, seasonFixtures) {
    try {
      await systemStore.sync();
      let seasonName = "";
      const unsubscribeSystemStore = systemStore.subscribe((systemState) => {
        if (systemState) {
          seasonName = systemState?.calculationSeasonName;
        }
      });
      unsubscribeSystemStore();
      let dto = {
        seasonId,
        seasonFixtures
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 4000n,
          payload
        };
        const command = {
          MakeProposal: {
            title: `Add initial fixtures for season ${seasonName}.`,
            url: "openfpl.xyz/governance",
            summary: `Add initial fixtures for season ${seasonName}.`,
            action: [{ ExecuteGenericNervousSystemFunction: fn }]
          }
        };
        const neuronId = userNeurons[0].id[0];
        if (!neuronId) {
          return;
        }
        await governanceManageNeuron({
          subaccount: neuronId.id,
          command: [command]
        });
      }
    } catch (error) {
      console.error("Error adding initial fixtures:", error);
      throw error;
    }
  }
  async function moveFixture(fixtureId, updatedFixtureGameweek, updatedFixtureDate) {
    try {
      await teamStore.sync();
      let clubs = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      let seasonId = 0;
      const unsubscribeSystemStore = systemStore.subscribe((systemState) => {
        if (systemState) {
          seasonId = systemState?.calculationSeasonId;
        }
      });
      unsubscribeSystemStore();
      await fixtureStore.sync(seasonId);
      let allFixtures = [];
      const unsubscribeFixtureStore = fixtureStore.subscribe((fixtures) => {
        allFixtures = fixtures;
      });
      unsubscribeFixtureStore();
      const dateObject = new Date(updatedFixtureDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1e6);
      let dto = {
        fixtureId,
        updatedFixtureGameweek,
        updatedFixtureDate: nanoseconds
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 5000n,
          payload
        };
        let fixture = allFixtures.find((x) => x.id == fixtureId);
        if (fixture) {
          let homeClub = clubs.find((x) => x.id == fixture?.homeClubId);
          let awayClub = clubs.find((x) => x.id == fixture?.awayClubId);
          if (!homeClub || !awayClub) {
            return;
          }
          const command = {
            MakeProposal: {
              title: `Move fixture ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`,
              url: "openfpl.xyz/governance",
              summary: `Fixture Data for ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`,
              action: [{ ExecuteGenericNervousSystemFunction: fn }]
            }
          };
          const neuronId = userNeurons[0].id[0];
          if (!neuronId) {
            return;
          }
          await governanceManageNeuron({
            subaccount: neuronId.id,
            command: [command]
          });
        }
      }
    } catch (error) {
      console.error("Error moving fixture:", error);
      throw error;
    }
  }
  async function postponeFixture(fixtureId) {
    try {
      await teamStore.sync();
      let clubs = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      let seasonId = 0;
      const unsubscribeSystemStore = systemStore.subscribe((systemState) => {
        if (systemState) {
          seasonId = systemState?.calculationSeasonId;
        }
      });
      unsubscribeSystemStore();
      await fixtureStore.sync(seasonId);
      let allFixtures = [];
      const unsubscribeFixtureStore = fixtureStore.subscribe((fixtures) => {
        allFixtures = fixtures;
      });
      unsubscribeFixtureStore();
      let dto = {
        fixtureId
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 6000n,
          payload
        };
        let fixture = allFixtures.find((x) => x.id == fixtureId);
        if (fixture) {
          let homeClub = clubs.find((x) => x.id == fixture?.homeClubId);
          let awayClub = clubs.find((x) => x.id == fixture?.awayClubId);
          if (!homeClub || !awayClub) {
            return;
          }
          const command = {
            MakeProposal: {
              title: `Postpone fixture ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`,
              url: "openfpl.xyz/governance",
              summary: `Fixture Data for ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`,
              action: [{ ExecuteGenericNervousSystemFunction: fn }]
            }
          };
          const neuronId = userNeurons[0].id[0];
          if (!neuronId) {
            return;
          }
          await governanceManageNeuron({
            subaccount: neuronId.id,
            command: [command]
          });
        }
      }
    } catch (error) {
      console.error("Error postponing fixture:", error);
      throw error;
    }
  }
  async function rescheduleFixture(fixtureId, updatedFixtureGameweek, updatedFixtureDate) {
    try {
      await teamStore.sync();
      let clubs = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      let seasonId = 0;
      const unsubscribeSystemStore = systemStore.subscribe((systemState) => {
        if (systemState) {
          seasonId = systemState?.calculationSeasonId;
        }
      });
      unsubscribeSystemStore();
      await fixtureStore.sync(seasonId);
      let allFixtures = [];
      const unsubscribeFixtureStore = fixtureStore.subscribe((fixtures) => {
        allFixtures = fixtures;
      });
      unsubscribeFixtureStore();
      const dateObject = new Date(updatedFixtureDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1e6);
      let dto = {
        fixtureId,
        updatedFixtureGameweek,
        updatedFixtureDate: nanoseconds
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 7000n,
          payload
        };
        let fixture = allFixtures.find((x) => x.id == fixtureId);
        if (fixture) {
          let homeClub = clubs.find((x) => x.id == fixture?.homeClubId);
          let awayClub = clubs.find((x) => x.id == fixture?.awayClubId);
          if (!homeClub || !awayClub) {
            return;
          }
          const command = {
            MakeProposal: {
              title: `Move fixture ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`,
              url: "openfpl.xyz/governance",
              summary: `Fixture Data for ${homeClub.friendlyName} v ${awayClub?.friendlyName}.`,
              action: [{ ExecuteGenericNervousSystemFunction: fn }]
            }
          };
          const neuronId = userNeurons[0].id[0];
          if (!neuronId) {
            return;
          }
          await governanceManageNeuron({
            subaccount: neuronId.id,
            command: [command]
          });
        }
      }
    } catch (error) {
      console.error("Error rescheduling fixture:", error);
      throw error;
    }
  }
  async function transferPlayer(playerId, newClubId) {
    try {
      await teamStore.sync();
      await playerStore.sync();
      let clubs = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      let allPlayers = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if (players) {
          allPlayers = players;
        }
      });
      unsubscribeTeamStore();
      let dto = {
        playerId,
        newClubId
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 8000n,
          payload
        };
        let player = allPlayers.find((x) => x.id == playerId);
        if (player) {
          let currentClub = clubs.find((x) => x.id == player?.clubId);
          let newClub = clubs.find((x) => x.id == newClubId);
          if (!currentClub) {
            return;
          }
          let title = "";
          if (newClubId == 0) {
            title = `Transfer ${player.firstName} ${player.lastName} outside of Premier League.`;
          }
          if (newClub) {
            title = `Transfer ${player.firstName} ${player.lastName} to ${newClub.friendlyName}`;
          }
          const command = {
            MakeProposal: {
              title,
              url: "openfpl.xyz/governance",
              summary: title,
              action: [{ ExecuteGenericNervousSystemFunction: fn }]
            }
          };
          const neuronId = userNeurons[0].id[0];
          if (!neuronId) {
            return;
          }
          await governanceManageNeuron({
            subaccount: neuronId.id,
            command: [command]
          });
        }
      }
    } catch (error) {
      console.error("Error transferring player:", error);
      throw error;
    }
  }
  async function loanPlayer(playerId, loanClubId, loanEndDate) {
    try {
      await teamStore.sync();
      await playerStore.sync();
      let clubs = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      let allPlayers = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if (players) {
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();
      const dateObject = new Date(loanEndDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1e6);
      let dto = {
        playerId,
        loanClubId,
        loanEndDate: nanoseconds
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 9000n,
          payload
        };
        let player = allPlayers.find((x) => x.id == playerId);
        if (player) {
          let club = clubs.find((x) => x.id == player?.clubId);
          if (!club) {
            return;
          }
          const command = {
            MakeProposal: {
              title: `Loan ${player.firstName} to ${club?.friendlyName}.`,
              url: "openfpl.xyz/governance",
              summary: `Loan ${player.firstName} to ${club?.friendlyName}.`,
              action: [{ ExecuteGenericNervousSystemFunction: fn }]
            }
          };
          const neuronId = userNeurons[0].id[0];
          if (!neuronId) {
            return;
          }
          await governanceManageNeuron({
            subaccount: neuronId.id,
            command: [command]
          });
        }
      }
    } catch (error) {
      console.error("Error loaning player:", error);
      throw error;
    }
  }
  async function recallPlayer(playerId) {
    try {
      await teamStore.sync();
      await playerStore.sync();
      let clubs = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      let allPlayers = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if (players) {
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();
      let dto = {
        playerId
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 10000n,
          payload
        };
        let player = allPlayers.find((x) => x.id == playerId);
        if (player) {
          let club = clubs.find((x) => x.id == player?.clubId);
          if (!club) {
            return;
          }
          const command = {
            MakeProposal: {
              title: `Recall ${player.firstName} ${player?.lastName} loan.`,
              url: "openfpl.xyz/governance",
              summary: `Recall ${player.firstName} ${player?.lastName} loan.`,
              action: [{ ExecuteGenericNervousSystemFunction: fn }]
            }
          };
          const neuronId = userNeurons[0].id[0];
          if (!neuronId) {
            return;
          }
          await governanceManageNeuron({
            subaccount: neuronId.id,
            command: [command]
          });
        }
      }
    } catch (error) {
      console.error("Error recalling player loan:", error);
      throw error;
    }
  }
  async function createPlayer(clubId, position, firstName, lastName, shirtNumber, valueQuarterMillions, dateOfBirth, nationality) {
    try {
      await teamStore.sync();
      await playerStore.sync();
      let clubs = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      const dateObject = new Date(dateOfBirth);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1e6);
      let dto = {
        clubId,
        position,
        firstName,
        lastName,
        shirtNumber,
        valueQuarterMillions,
        dateOfBirth: nanoseconds,
        nationality
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 11000n,
          payload
        };
        let club = clubs.find((x) => x.id == clubId);
        if (!club) {
          return;
        }
        const command = {
          MakeProposal: {
            title: `Create New Player: ${firstName} v ${lastName}.`,
            url: "openfpl.xyz/governance",
            summary: `Create New Player: ${firstName} v ${lastName}.`,
            action: [{ ExecuteGenericNervousSystemFunction: fn }]
          }
        };
        const neuronId = userNeurons[0].id[0];
        if (!neuronId) {
          return;
        }
        await governanceManageNeuron({
          subaccount: neuronId.id,
          command: [command]
        });
      }
    } catch (error) {
      console.error("Error creating player:", error);
      throw error;
    }
  }
  async function updatePlayer(playerId, position, firstName, lastName, shirtNumber, dateOfBirth, nationality) {
    try {
      await teamStore.sync();
      await playerStore.sync();
      let clubs = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      let allPlayers = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if (players) {
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();
      let dto = {
        playerId,
        position,
        firstName,
        lastName,
        shirtNumber,
        dateOfBirth: BigInt(dateOfBirth),
        nationality
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 12000n,
          payload
        };
        let player = allPlayers.find((x) => x.id == playerId);
        if (player) {
          let club = clubs.find((x) => x.id == player?.clubId);
          if (!club) {
            return;
          }
          const command = {
            MakeProposal: {
              title: `Update ${player.firstName} ${player.lastName} details.`,
              url: "openfpl.xyz/governance",
              summary: `Update ${player.firstName} ${player.lastName} details.`,
              action: [{ ExecuteGenericNervousSystemFunction: fn }]
            }
          };
          const neuronId = userNeurons[0].id[0];
          if (!neuronId) {
            return;
          }
          await governanceManageNeuron({
            subaccount: neuronId.id,
            command: [command]
          });
        }
      }
    } catch (error) {
      console.error("Error updating player:", error);
      throw error;
    }
  }
  async function setPlayerInjury(playerId, description, expectedEndDate) {
    try {
      await teamStore.sync();
      await playerStore.sync();
      let clubs = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      let allPlayers = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if (players) {
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();
      const dateObject = new Date(expectedEndDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1e6);
      let dto = {
        playerId,
        description,
        expectedEndDate: nanoseconds
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 13000n,
          payload
        };
        let player = allPlayers.find((x) => x.id == playerId);
        if (player) {
          let club = clubs.find((x) => x.id == player?.clubId);
          if (!club) {
            return;
          }
          const command = {
            MakeProposal: {
              title: `Set Player Injury for ${player.firstName} ${player.lastName}.`,
              url: "openfpl.xyz/governance",
              summary: `Set Player Injury for ${player.firstName} ${player.lastName}.`,
              action: [{ ExecuteGenericNervousSystemFunction: fn }]
            }
          };
          const neuronId = userNeurons[0].id[0];
          if (!neuronId) {
            return;
          }
          await governanceManageNeuron({
            subaccount: neuronId.id,
            command: [command]
          });
        }
      }
    } catch (error) {
      console.error("Error setting player injury:", error);
      throw error;
    }
  }
  async function retirePlayer(playerId, retirementDate) {
    try {
      await teamStore.sync();
      await playerStore.sync();
      let clubs = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      let allPlayers = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if (players) {
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();
      const dateObject = new Date(retirementDate);
      const timestampMilliseconds = dateObject.getTime();
      let nanoseconds = BigInt(timestampMilliseconds) * BigInt(1e6);
      let dto = {
        playerId,
        retirementDate: nanoseconds
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 14000n,
          payload
        };
        let player = allPlayers.find((x) => x.id == playerId);
        if (player) {
          let club = clubs.find((x) => x.id == player?.clubId);
          if (!club) {
            return;
          }
          const command = {
            MakeProposal: {
              title: `Retire ${player.firstName} ${player.lastName}.`,
              url: "openfpl.xyz/governance",
              summary: `Retire ${player.firstName} ${player.lastName}.`,
              action: [{ ExecuteGenericNervousSystemFunction: fn }]
            }
          };
          const neuronId = userNeurons[0].id[0];
          if (!neuronId) {
            return;
          }
          await governanceManageNeuron({
            subaccount: neuronId.id,
            command: [command]
          });
        }
      }
    } catch (error) {
      console.error("Error retiring player:", error);
      throw error;
    }
  }
  async function unretirePlayer(playerId) {
    try {
      await teamStore.sync();
      await playerStore.sync();
      let clubs = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      let allPlayers = [];
      const unsubscribePlayerStore = playerStore.subscribe((players) => {
        if (players) {
          allPlayers = players;
        }
      });
      unsubscribePlayerStore();
      let dto = {
        playerId
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 15000n,
          payload
        };
        let player = allPlayers.find((x) => x.id == playerId);
        if (player) {
          let club = clubs.find((x) => x.id == player?.clubId);
          if (!club) {
            return;
          }
          const command = {
            MakeProposal: {
              title: `Unretire ${player.firstName} ${player.lastName}.`,
              url: "openfpl.xyz/governance",
              summary: `Unretire ${player.firstName} ${player.lastName}.`,
              action: [{ ExecuteGenericNervousSystemFunction: fn }]
            }
          };
          const neuronId = userNeurons[0].id[0];
          if (!neuronId) {
            return;
          }
          await governanceManageNeuron({
            subaccount: neuronId.id,
            command: [command]
          });
        }
      }
    } catch (error) {
      console.error("Error unretiring player:", error);
      throw error;
    }
  }
  async function promoteFormerClub(clubId) {
    try {
      await teamStore.sync();
      let clubs = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      let seasonId = 0;
      const unsubscribeSystemStore = systemStore.subscribe((systemState) => {
        if (systemState) {
          seasonId = systemState?.calculationSeasonId;
        }
      });
      unsubscribeSystemStore();
      let dto = {
        clubId
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 16000n,
          payload
        };
        let club = clubs.find((x) => x.id == clubId);
        if (!club) {
          return;
        }
        const command = {
          MakeProposal: {
            title: `Promote ${club.friendlyName}.`,
            url: "openfpl.xyz/governance",
            summary: `Promote ${club.friendlyName}.`,
            action: [{ ExecuteGenericNervousSystemFunction: fn }]
          }
        };
        const neuronId = userNeurons[0].id[0];
        if (!neuronId) {
          return;
        }
        await governanceManageNeuron({
          subaccount: neuronId.id,
          command: [command]
        });
      }
    } catch (error) {
      console.error("Error promoting former club:", error);
      throw error;
    }
  }
  async function promoteNewClub(name, friendlyName, primaryColourHex, secondaryColourHex, thirdColourHex, abbreviatedName, shirtType) {
    try {
      let dto = {
        name,
        friendlyName,
        primaryColourHex,
        secondaryColourHex,
        thirdColourHex,
        abbreviatedName,
        shirtType
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 17000n,
          payload
        };
        const command = {
          MakeProposal: {
            title: `Promote ${friendlyName}.`,
            url: "openfpl.xyz/governance",
            summary: `Promote ${friendlyName}.`,
            action: [{ ExecuteGenericNervousSystemFunction: fn }]
          }
        };
        const neuronId = userNeurons[0].id[0];
        if (!neuronId) {
          return;
        }
        await governanceManageNeuron({
          subaccount: neuronId.id,
          command: [command]
        });
      }
    } catch (error) {
      console.error("Error promoting new club:", error);
      throw error;
    }
  }
  async function updateClub(clubId, name, friendlyName, primaryColourHex, secondaryColourHex, thirdColourHex, abbreviatedName, shirtType) {
    try {
      await teamStore.sync();
      let clubs = [];
      const unsubscribeTeamStore = teamStore.subscribe((teams) => {
        if (teams) {
          clubs = teams;
        }
      });
      unsubscribeTeamStore();
      let seasonId = 0;
      const unsubscribeSystemStore = systemStore.subscribe((systemState) => {
        if (systemState) {
          seasonId = systemState?.calculationSeasonId;
        }
      });
      unsubscribeSystemStore();
      await fixtureStore.sync(seasonId);
      let allFixtures = [];
      const unsubscribeFixtureStore = fixtureStore.subscribe((fixtures) => {
        allFixtures = fixtures;
      });
      unsubscribeFixtureStore();
      let dto = {
        clubId,
        name,
        friendlyName,
        primaryColourHex,
        secondaryColourHex,
        thirdColourHex,
        abbreviatedName,
        shirtType
      };
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE ?? ""
      );
      const governanceAgent = ActorFactory.getAgent(
        define_process_env_default.CANISTER_ID_SNS_GOVERNANCE,
        identityActor,
        null
      );
      const {
        manageNeuron: governanceManageNeuron,
        listNeurons: governanceListNeurons
      } = SnsGovernanceCanister.create({
        agent: governanceAgent,
        canisterId: identityActor
      });
      const userNeurons = await governanceListNeurons({
        principal: identityActor.principal,
        limit: 10,
        beforeNeuronId: { id: [] }
      });
      if (userNeurons.length > 0) {
        const jsonString = JSON.stringify(dto);
        const encoder2 = new TextEncoder();
        const payload = encoder2.encode(jsonString);
        const fn = {
          function_id: 18000n,
          payload
        };
        let club = clubs.find((x) => x.id == clubId);
        if (!club) {
          return;
        }
        const command = {
          MakeProposal: {
            title: `Update ${club.friendlyName} club details.`,
            url: "openfpl.xyz/governance",
            summary: `Update ${club.friendlyName} club details.`,
            action: [{ ExecuteGenericNervousSystemFunction: fn }]
          }
        };
        const neuronId = userNeurons[0].id[0];
        if (!neuronId) {
          return;
        }
        await governanceManageNeuron({
          subaccount: neuronId.id,
          command: [command]
        });
      }
    } catch (error) {
      console.error("Error updating club:", error);
      throw error;
    }
  }
  return {
    revaluePlayerUp,
    revaluePlayerDown,
    submitFixtureData,
    addInitialFixtures,
    moveFixture,
    postponeFixture,
    rescheduleFixture,
    loanPlayer,
    transferPlayer,
    recallPlayer,
    createPlayer,
    updatePlayer,
    setPlayerInjury,
    retirePlayer,
    unretirePlayer,
    promoteFormerClub,
    promoteNewClub,
    updateClub
  };
}
const governanceStore = createGovernanceStore();
const Confirm_fixture_data_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { visible = false } = $$props;
  let { onConfirm } = $$props;
  let { closeModal } = $$props;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.onConfirm === void 0 && $$bindings.onConfirm && onConfirm !== void 0)
    $$bindings.onConfirm(onConfirm);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h4 data-svelte-h="svelte-1yevh2p">Confirm Fixture Data</h4> <button class="text-black" data-svelte-h="svelte-naxdfo">✕</button></div> <div class="my-5" data-svelte-h="svelte-1kpybyt"><h1>Please confirm your fixture data.</h1> <p class="text-gray-600">You will not be able to edit your submission and entries that differ
        from the accepted consensus data will not receive $FPL rewards. If
        consensus has already been reached for the fixture your submission will
        also not be counted.</p></div> <div class="flex justify-end gap-3"><button class="default-button fpl-cancel-btn" type="button" data-svelte-h="svelte-1n52tb1">Cancel</button> <button class="default-button fpl-button" data-svelte-h="svelte-1pog147">Confirm</button></div></div>`;
    }
  })}`;
});
const Clear_draft_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { visible = false } = $$props;
  let { onConfirm } = $$props;
  let { closeModal } = $$props;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.onConfirm === void 0 && $$bindings.onConfirm && onConfirm !== void 0)
    $$bindings.onConfirm(onConfirm);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-rcqdii">Clear Draft</h3> <button class="times-button" data-svelte-h="svelte-2aq7vi">×</button></div> <p data-svelte-h="svelte-idipww">Please confirm you want to clear the draft from your cache.</p> <div class="items-center py-3 flex space-x-4"><button class="default-button fpl-cancel-btn" type="button" data-svelte-h="svelte-1husm0b">Cancel</button> <button class="default-button fpl-button" data-svelte-h="svelte-zv2dtu">Clear</button></div></div>`;
    }
  })}`;
});
const Page$f = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let fixtureId;
  let $playerEventData, $$unsubscribe_playerEventData = noop, $$subscribe_playerEventData = () => ($$unsubscribe_playerEventData(), $$unsubscribe_playerEventData = subscribe(playerEventData, ($$value) => $playerEventData = $$value), playerEventData);
  let $systemStore, $$unsubscribe_systemStore;
  let $$unsubscribe_teamStore;
  let $selectedPlayers, $$unsubscribe_selectedPlayers;
  let $page, $$unsubscribe_page;
  $$unsubscribe_systemStore = subscribe(systemStore, (value) => $systemStore = value);
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => value);
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let showClearDraftModal = false;
  let showConfirmDataModal = false;
  let selectedPlayers = writable([]);
  $$unsubscribe_selectedPlayers = subscribe(selectedPlayers, (value) => $selectedPlayers = value);
  let playerEventData = writable([]);
  $$subscribe_playerEventData();
  async function confirmFixtureData() {
    busyStore.startBusy({
      initiator: "confirm-data",
      text: "Saving fixture data..."
    });
    try {
      await governanceStore.submitFixtureData($systemStore?.calculationSeasonId ?? 0, $systemStore?.calculationGameweek ?? 0, fixtureId, $playerEventData);
      localStorage.removeItem(`fixtureDraft_${fixtureId}`);
      toastsShow({
        text: "Fixture data saved.",
        level: "success",
        duration: 2e3
      });
      goto("/fixture-validation");
    } catch (error) {
      toastsError({
        msg: { text: "Error saving fixture data." },
        err: error
      });
      console.error("Error saving fixture data: ", error);
    } finally {
      showConfirmDataModal = false;
      busyStore.stopBusy("confirm-data");
    }
  }
  function clearDraft() {
    $$subscribe_playerEventData(playerEventData = writable([]));
    localStorage.removeItem(`fixtureDraft_${fixtureId}`);
    toastsShow({
      text: "Draft cleared.",
      level: "success",
      duration: 2e3
    });
    closeConfirmClearDraftModal();
  }
  function closeConfirmClearDraftModal() {
    showClearDraftModal = false;
  }
  function closeConfirmDataModal() {
    showConfirmDataModal = false;
  }
  fixtureId = Number($page.url.searchParams.get("id"));
  $playerEventData.length == 0 || $playerEventData.filter((x) => convertEvent(x.eventType) == 0).length != $selectedPlayers.length;
  $$unsubscribe_playerEventData();
  $$unsubscribe_systemStore();
  $$unsubscribe_teamStore();
  $$unsubscribe_selectedPlayers();
  $$unsubscribe_page();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(Spinner, "Spinner").$$render($$result, {}, {}, {})}`}`;
    }
  })} ${``} ${``} ${validate_component(Confirm_fixture_data_modal, "ConfirmFixtureDataModal").$$render(
    $$result,
    {
      visible: showConfirmDataModal,
      onConfirm: confirmFixtureData,
      closeModal: closeConfirmDataModal
    },
    {},
    {}
  )} ${validate_component(Clear_draft_modal, "ClearDraftModal").$$render(
    $$result,
    {
      closeModal: closeConfirmClearDraftModal,
      visible: showClearDraftModal,
      onConfirm: clearDraft
    },
    {},
    {}
  )}`;
});
const Add_initial_fixtures = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $$unsubscribe_systemStore;
  $$unsubscribe_systemStore = subscribe(systemStore, (value) => value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let fixtureData = [];
  let showConfirm = false;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = fixtureData.length == 0;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_systemStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-cmilh7">Add Initial Fixtures</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><div class="flex-col space-y-2"><p data-svelte-h="svelte-1kjbtbb">Please select a file to upload:</p> <input class="my-4" type="file" accept=".csv"></div> <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${``}</div>`;
    }
  })}`;
});
const Revalue_player_up = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $$unsubscribe_playerStore;
  let $teamStore, $$unsubscribe_teamStore;
  $$unsubscribe_playerStore = subscribe(playerStore, (value) => value);
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let selectedPlayerId = 0;
  let showConfirm = false;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = selectedPlayerId <= 0;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_playerStore();
  $$unsubscribe_teamStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-15yd750">Revalue Player Up</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><div class="flex-col space-y-2"><p data-svelte-h="svelte-1tp620s">Select the player&#39;s club:</p> <select class="p-2 fpl-dropdown min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-gooey4">Select Club</option>${each($teamStore, (club) => {
        return `<option${add_attribute("value", club.id, 0)}>${escape(club.friendlyName)}</option>`;
      })}</select></div> ${``} ${``} <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${``}</div>`;
    }
  })}`;
});
const Revalue_player_down = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $$unsubscribe_playerStore;
  let $teamStore, $$unsubscribe_teamStore;
  $$unsubscribe_playerStore = subscribe(playerStore, (value) => value);
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let selectedPlayerId = 0;
  let showConfirm = false;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = selectedPlayerId <= 0;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_playerStore();
  $$unsubscribe_teamStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-itffcx">Revalue Player Down</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><div class="flex-col space-y-2"><p data-svelte-h="svelte-1tp620s">Select the player&#39;s club:</p> <select class="p-2 fpl-dropdown min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-gooey4">Select Club</option>${each($teamStore, (club) => {
        return `<option${add_attribute("value", club.id, 0)}>${escape(club.friendlyName)}</option>`;
      })}</select></div> ${``} ${``} <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
              px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${``}</div>`;
    }
  })}`;
});
const Move_fixture = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $teamStore, $$unsubscribe_teamStore;
  let $$unsubscribe_systemStore;
  let $$unsubscribe_fixtureStore;
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  $$unsubscribe_systemStore = subscribe(systemStore, (value) => value);
  $$unsubscribe_fixtureStore = subscribe(fixtureStore, (value) => value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  let selectedFixtureId = 0;
  let gameweekFixtures = [];
  let date = "";
  let time = "";
  let showConfirm = false;
  function getTeamById(teamId) {
    return $teamStore.find((x) => x.id === teamId);
  }
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = !selectedFixtureId;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_teamStore();
  $$unsubscribe_systemStore();
  $$unsubscribe_fixtureStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-kmrp2y">Move Fixture</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><div class="flex-col space-y-2"><p data-svelte-h="svelte-1hdxidk">Select Gameweek:</p> <select class="p-2 fpl-dropdown my-4 min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-1qi0ln6">Select Gameweek</option>${each(gameweeks, (gameweek) => {
        return `<option${add_attribute("value", gameweek, 0)}>Gameweek ${escape(gameweek)}</option>`;
      })}</select></div> <div class="flex-col space-y-2"><p data-svelte-h="svelte-1mcsvml">Select Fixture:</p> <select class="p-2 fpl-dropdown my-4 min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-1xsaz9j">Select Fixture</option>${each(gameweekFixtures, (fixture) => {
        let homeTeam = getTeamById(fixture.homeClubId), awayTeam = getTeamById(fixture.awayClubId);
        return `  <option${add_attribute("value", fixture.id, 0)}>${escape(homeTeam.friendlyName)} v ${escape(awayTeam.friendlyName)}</option>`;
      })}</select></div> <div class="border-b border-gray-200 my-4"></div> <p class="mr-2 my-2" data-svelte-h="svelte-1ct6cbi">Set new date:</p> <div class="flex flex-row my-2"><p class="mr-2" data-svelte-h="svelte-1gu3l1z">Select Date:</p> <input type="date" class="input input-bordered"${add_attribute("value", date, 0)}></div> <div class="flex flex-row my-2"><p class="mr-2" data-svelte-h="svelte-y26t78">Select Time:</p> <input type="time" class="input input-bordered"${add_attribute("value", time, 0)}></div> <div class="flex flex-row my-2 items-center"><p class="mr-2" data-svelte-h="svelte-1ullkw5">Select Gameweek:</p> <select class="p-2 fpl-dropdown my-4 min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-1kvgm78">Select New Gameweek</option>${each(gameweeks, (gameweek) => {
        return `<option${add_attribute("value", gameweek, 0)}>Gameweek ${escape(gameweek)}</option>`;
      })}</select></div> <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
const Postpone_fixture = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $teamStore, $$unsubscribe_teamStore;
  let $$unsubscribe_systemStore;
  let $$unsubscribe_fixtureStore;
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  $$unsubscribe_systemStore = subscribe(systemStore, (value) => value);
  $$unsubscribe_fixtureStore = subscribe(fixtureStore, (value) => value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  let selectedFixtureId = 0;
  let gameweekFixtures = [];
  let showConfirm = false;
  function getTeamById(teamId) {
    return $teamStore.find((x) => x.id === teamId);
  }
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = !selectedFixtureId;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_teamStore();
  $$unsubscribe_systemStore();
  $$unsubscribe_fixtureStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-p6nm2f">Postpone Fixture</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><div class="flex-col space-y-2"><p data-svelte-h="svelte-1hdxidk">Select Gameweek:</p> <select class="p-2 fpl-dropdown my-4 min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-1qi0ln6">Select Gameweek</option>${each(gameweeks, (gameweek) => {
        return `<option${add_attribute("value", gameweek, 0)}>Gameweek ${escape(gameweek)}</option>`;
      })}</select></div> <div class="flex-col space-y-2"><p data-svelte-h="svelte-1mcsvml">Select Fixture:</p> <select class="p-2 fpl-dropdown my-4 min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-1xsaz9j">Select Fixture</option>${each(gameweekFixtures, (fixture) => {
        let homeTeam = getTeamById(fixture.homeClubId), awayTeam = getTeamById(fixture.awayClubId);
        return `  <option${add_attribute("value", fixture.id, 0)}>${escape(homeTeam.friendlyName)} v ${escape(awayTeam.friendlyName)}</option>`;
      })}</select></div> <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
const Reschedule_fixture = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $teamStore, $$unsubscribe_teamStore;
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  let selectedFixtureId = 0;
  let postponedFixtures = [];
  let date = "";
  let time = "";
  let showConfirm = false;
  function getTeamById(teamId) {
    return $teamStore.find((x) => x.id === teamId);
  }
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = !selectedFixtureId;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_teamStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-q68hh1">Reschedule Fixture</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><div class="flex-col space-y-2"><p data-svelte-h="svelte-ywwbfb">Select Postponed Fixture:</p> <select class="p-2 fpl-dropdown my-4 min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-1xsaz9j">Select Fixture</option>${each(postponedFixtures, (fixture) => {
        let homeTeam = getTeamById(fixture.homeClubId), awayTeam = getTeamById(fixture.awayClubId);
        return `  <option${add_attribute("value", fixture.id, 0)}>${escape(homeTeam.friendlyName)} v ${escape(awayTeam.friendlyName)}</option>`;
      })}</select></div> <div class="border-b border-gray-200"></div> <p class="mr-2 my-2" data-svelte-h="svelte-1ct6cbi">Set new date:</p> <div class="flex flex-row my-2"><p class="mr-2" data-svelte-h="svelte-1gu3l1z">Select Date:</p> <input type="date" class="input input-bordered"${add_attribute("value", date, 0)}></div> <div class="flex flex-row my-2"><p class="mr-2" data-svelte-h="svelte-y26t78">Select Time:</p> <input type="time" class="input input-bordered"${add_attribute("value", time, 0)}></div> <div class="flex flex-row my-2 items-center"><p class="mr-2" data-svelte-h="svelte-1ullkw5">Select Gameweek:</p> <select class="p-2 fpl-dropdown min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-1kvgm78">Select New Gameweek</option>${each(gameweeks, (gameweek) => {
        return `<option${add_attribute("value", gameweek, 0)}>Gameweek ${escape(gameweek)}</option>`;
      })}</select></div> <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
const Loan_player = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $$unsubscribe_playerStore;
  let $teamStore, $$unsubscribe_teamStore;
  $$unsubscribe_playerStore = subscribe(playerStore, (value) => value);
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let selectedPlayerId = 0;
  let showConfirm = false;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = selectedPlayerId <= 0;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_playerStore();
  $$unsubscribe_teamStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-yv1guj">Loan Player</h3> <button class="times-button" data-svelte-h="svelte-2aq7vi">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><div class="flex-col space-y-2"><p data-svelte-h="svelte-1tp620s">Select the player&#39;s club:</p> <select class="p-2 fpl-dropdown min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-gooey4">Select Club</option>${each($teamStore, (club) => {
        return `<option${add_attribute("value", club.id, 0)}>${escape(club.friendlyName)}</option>`;
      })}</select></div> ${``} <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${``}</div>`;
    }
  })}`;
});
const Transfer_player = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $$unsubscribe_playerStore;
  let $teamStore, $$unsubscribe_teamStore;
  $$unsubscribe_playerStore = subscribe(playerStore, (value) => value);
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let selectedPlayerId = 0;
  let showConfirm = false;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = selectedPlayerId <= 0;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_playerStore();
  $$unsubscribe_teamStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-eogsmc">Transfer Player</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><p data-svelte-h="svelte-1tp620s">Select the player&#39;s club:</p> <select class="p-2 fpl-dropdown min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-gooey4">Select Club</option>${each($teamStore, (club) => {
        return `<option${add_attribute("value", club.id, 0)}>${escape(club.friendlyName)}</option>`;
      })}</select> ${``} <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${``}</div>`;
    }
  })}`;
});
const Recall_player = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $teamStore, $$unsubscribe_teamStore;
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let selectedPlayerId = 0;
  let showConfirm = false;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = selectedPlayerId <= 0;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_teamStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-awztf2">Recall Player</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><div class="flex-col space-y-2"><p data-svelte-h="svelte-1tp620s">Select the player&#39;s club:</p> <select class="p-2 fpl-dropdown min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-gooey4">Select Club</option>${each($teamStore, (club) => {
        return `<option${add_attribute("value", club.id, 0)}>${escape(club.friendlyName)}</option>`;
      })}</select></div> ${``} <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
const Create_player = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $teamStore, $$unsubscribe_teamStore;
  let $countriesStore, $$unsubscribe_countriesStore;
  $$unsubscribe_teamStore = subscribe(teamStore, (value2) => $teamStore = value2);
  $$unsubscribe_countriesStore = subscribe(countriesStore, (value2) => $countriesStore = value2);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let selectedClubId = 0;
  let firstName = "";
  let lastName = "";
  let dateOfBirth = "";
  let shirtNumber = 0;
  let value = 0;
  let showConfirm = false;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = selectedClubId <= 0;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_teamStore();
  $$unsubscribe_countriesStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-9uabtx">Create Player</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><div class="flex-col space-y-2"><p data-svelte-h="svelte-zed03u">Select Club:</p> <select class="p-2 fpl-dropdown min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-gooey4">Select Club</option>${each($teamStore, (club) => {
        return `<option${add_attribute("value", club.id, 0)}>${escape(club.friendlyName)}</option>`;
      })}</select></div> <div class="flex-col space-y-2"><p data-svelte-h="svelte-12rrly1">Select Position:</p> <select class="p-2 fpl-dropdown my-4 min-w-[100px]"><option${add_attribute("value", { Goalkeeper: null }, 0)} data-svelte-h="svelte-1p5crkn">Goalkeeper</option><option${add_attribute("value", { Defender: null }, 0)} data-svelte-h="svelte-9nrckf">Defender</option><option${add_attribute("value", { Midfielder: null }, 0)} data-svelte-h="svelte-egyywf">Midfielder</option><option${add_attribute("value", { Forward: null }, 0)} data-svelte-h="svelte-dhqeof">Forward</option></select></div> <div class="flex-col space-y-2"><p class="py-2" data-svelte-h="svelte-tfgbay">First Name:</p> <input type="text" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black" placeholder="First Name"${add_attribute("value", firstName, 0)}></div> <div class="flex-col space-y-2"><p class="py-2" data-svelte-h="svelte-1odo0oq">Last Name:</p> <input type="text" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black" placeholder="First Name"${add_attribute("value", lastName, 0)}></div> <div class="flex-col space-y-2"><p class="py-2" data-svelte-h="svelte-17jft0i">Shirt Number:</p> <input type="number" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black" placeholder="Shirt Number" min="1" max="99" step="1"${add_attribute("value", shirtNumber, 0)}></div> <div class="flex-col space-y-2"><p class="py-2" data-svelte-h="svelte-p1i34b">Value (£m):</p> <input type="number" step="0.25" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black" placeholder="Value"${add_attribute("value", value, 0)}></div> <div class="flex-col space-y-2"><p class="py-2" data-svelte-h="svelte-x5j7yv">Date of Birth:</p> <input type="date" class="input input-bordered"${add_attribute("value", dateOfBirth, 0)}></div> <div class="flex-col space-y-2"><p class="py-2" data-svelte-h="svelte-jmi6x5">Nationality:</p> <select class="p-2 fpl-dropdown min-w-[100px] mb-2"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-e3ccus">Select Nationality</option>${each($countriesStore, (country) => {
        return `<option${add_attribute("value", country.id, 0)}>${escape(country.name)}</option>`;
      })}</select></div> <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
const Update_player = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $$unsubscribe_playerStore;
  let $teamStore, $$unsubscribe_teamStore;
  let $$unsubscribe_countriesStore;
  $$unsubscribe_playerStore = subscribe(playerStore, (value) => value);
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  $$unsubscribe_countriesStore = subscribe(countriesStore, (value) => value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let firstName = "";
  let lastName = "";
  let shirtNumber;
  let nationalityId;
  let displayDOB = "";
  let showConfirm = false;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = firstName.length > 50 || lastName.length == 0 || lastName.length > 50 || shirtNumber <= 0 || shirtNumber > 99 || displayDOB == "" || nationalityId <= 0;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_playerStore();
  $$unsubscribe_teamStore();
  $$unsubscribe_countriesStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-111jmmy">Update Player</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><div class="flex-col space-y-2"><p data-svelte-h="svelte-1tp620s">Select the player&#39;s club:</p> <select class="p-2 fpl-dropdown min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-gooey4">Select Club</option>${each($teamStore, (club) => {
        return `<option${add_attribute("value", club.id, 0)}>${escape(club.friendlyName)}</option>`;
      })}</select></div> ${``} <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
const Set_player_injury = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $$unsubscribe_playerStore;
  let $teamStore, $$unsubscribe_teamStore;
  $$unsubscribe_playerStore = subscribe(playerStore, (value) => value);
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let selectedPlayerId = 0;
  let showConfirm = false;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = selectedPlayerId <= 0;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_playerStore();
  $$unsubscribe_teamStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-1epdx5w">Set Player Injury</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><p data-svelte-h="svelte-1tp620s">Select the player&#39;s club:</p> <select class="p-2 fpl-dropdown min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-gooey4">Select Club</option>${each($teamStore, (club) => {
        return `<option${add_attribute("value", club.id, 0)}>${escape(club.friendlyName)}</option>`;
      })}</select> ${``} <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
const Retire_player = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $$unsubscribe_playerStore;
  let $teamStore, $$unsubscribe_teamStore;
  $$unsubscribe_playerStore = subscribe(playerStore, (value) => value);
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let selectedPlayerId = 0;
  let showConfirm = false;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = selectedPlayerId <= 0;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_playerStore();
  $$unsubscribe_teamStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-181rwt8">Retire Player</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><p data-svelte-h="svelte-1tp620s">Select the player&#39;s club:</p> <select class="p-2 fpl-dropdown min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-gooey4">Select Club</option>${each($teamStore, (club) => {
        return `<option${add_attribute("value", club.id, 0)}>${escape(club.friendlyName)}</option>`;
      })}</select> ${``} <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${``}</div>`;
    }
  })}`;
});
const Unretire_player = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $teamStore, $$unsubscribe_teamStore;
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let selectedPlayerId = 0;
  let showConfirm = false;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = selectedPlayerId <= 0;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_teamStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-1s9cm8h">Unretire Player</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><div class="flex-col space-y-2"><p data-svelte-h="svelte-1tp620s">Select the player&#39;s club:</p> <select class="p-2 fpl-dropdown min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-gooey4">Select Club</option>${each($teamStore, (club) => {
        return `<option${add_attribute("value", club.id, 0)}>${escape(club.friendlyName)}</option>`;
      })}</select></div> ${``} <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
const Promote_former_club = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let { visible } = $$props;
  let { closeModal } = $$props;
  let formerClubs = [];
  let selectedClubId = 0;
  let showConfirm = false;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = selectedClubId <= 0;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-1tlchoz">Promote Former Club</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><div class="flex-col space-y-2"><select class="p-2 fpl-dropdown min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-gooey4">Select Club</option>${each(formerClubs, (club) => {
        return `<option${add_attribute("value", club.id, 0)}>${escape(club.friendlyName)}</option>`;
      })}</select></div> <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
const Promote_new_club = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let { visible } = $$props;
  let { closeModal } = $$props;
  let name = "";
  let friendlyName = "";
  let abbreviatedName = "";
  let primaryColourHex = "";
  let secondaryColourHex = "";
  let thirdColourHex = "";
  let showConfirm = false;
  let shirtTypes = [{ Filled: null }, { Striped: null }];
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = name.length <= 0 || name.length > 100 || friendlyName.length <= 0 || friendlyName.length > 50 || abbreviatedName.length != 3;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-6c6oto">Promote New Club</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><input type="text" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black" placeholder="Club Full Name"${add_attribute("value", name, 0)}> <input type="text" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black" placeholder="Club Friendly Name"${add_attribute("value", name, 0)}> <input type="text" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black" placeholder="Abbreviated Name"${add_attribute("value", abbreviatedName, 0)}> <input type="color" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"${add_attribute("value", primaryColourHex, 0)}> <input type="color" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"${add_attribute("value", secondaryColourHex, 0)}> <input type="color" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"${add_attribute("value", thirdColourHex, 0)}> <select class="p-2 fpl-dropdown my-4 min-w-[100px]">${each(shirtTypes, (shirt) => {
        return `<option${add_attribute("value", shirt, 0)}>${escape(shirt)}</option>`;
      })}</select> <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${``}</div>`;
    }
  })}`;
});
const Update_club = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $teamStore, $$unsubscribe_teamStore;
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let selectedClubId = 0;
  let showConfirm = false;
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = selectedClubId <= 0;
  {
    if (isSubmitDisabled && showConfirm) {
      showConfirm = false;
    }
  }
  $$unsubscribe_teamStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-1p20ean">Update Club</h3> <button class="times-button" data-svelte-h="svelte-jkt426">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><select class="p-2 fpl-dropdown min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-gooey4">Select Club</option>${each($teamStore, (club) => {
        return `<option${add_attribute("value", club.id, 0)}>${escape(club.friendlyName)}</option>`;
      })}</select> ${``} <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-19jfrwv">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Raise Proposal</button></div> ${showConfirm ? `<div class="items-center flex" data-svelte-h="svelte-6fi0oe"><p class="text-orange-400">Failed proposals will cost the proposer 10 $FPL tokens.</p></div> <div class="items-center flex"><button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Confirm Submit Proposal</button></div>` : ``}</div></div> ${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
const Add_fixture_data = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let $teamStore, $$unsubscribe_teamStore;
  let $$unsubscribe_systemStore;
  let $$unsubscribe_fixtureStore;
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  $$unsubscribe_systemStore = subscribe(systemStore, (value) => value);
  $$unsubscribe_fixtureStore = subscribe(fixtureStore, (value) => value);
  let { visible } = $$props;
  let { closeModal } = $$props;
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  let selectedFixtureId;
  let gameweekFixtures = [];
  function getTeamById(teamId) {
    return $teamStore.find((x) => x.id === teamId);
  }
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  isSubmitDisabled = !selectedFixtureId;
  $$unsubscribe_teamStore();
  $$unsubscribe_systemStore();
  $$unsubscribe_fixtureStore();
  return `${validate_component(Modal, "Modal").$$render($$result, { visible }, {}, {
    default: () => {
      return `<div class="mx-4 p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-5slgzo">Add Fixture Data</h3> <button class="times-button" data-svelte-h="svelte-2aq7vi">×</button></div> <div class="flex justify-start items-center w-full"><div class="w-full flex-col space-y-4 mb-2"><div class="flex-col space-y-2"><p data-svelte-h="svelte-1hdxidk">Select Gameweek:</p> <select class="p-2 fpl-dropdown my-4 min-w-[100px]">${each(gameweeks, (gameweek) => {
        return `<option${add_attribute("value", gameweek, 0)}>Gameweek ${escape(gameweek)}</option>`;
      })}</select></div> <div class="flex-col space-y-2"><p data-svelte-h="svelte-1mcsvml">Select Fixture:</p> <select class="p-2 fpl-dropdown my-4 min-w-[100px]">${each(gameweekFixtures, (fixture) => {
        let homeTeam = getTeamById(fixture.homeClubId), awayTeam = getTeamById(fixture.awayClubId);
        return `  <option${add_attribute("value", fixture.id, 0)}>${escape(homeTeam.friendlyName)} v ${escape(awayTeam.friendlyName)}</option>`;
      })}</select></div> <div class="border-b border-gray-200"></div> <div class="items-center flex space-x-4"><button class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]" type="button" data-svelte-h="svelte-1cdq9j1">Cancel</button> <button${add_attribute(
        "class",
        `${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`,
        0
      )} ${isSubmitDisabled ? "disabled" : ""}>Add Fixture Data</button></div></div></div> ${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
const Page$e = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let showRevaluePlayerUpModal = false;
  let showRevaluePlayerDownModal = false;
  let showAddInitialFixturesModal = false;
  let showMoveFixtureModal = false;
  let showPostponeFixtureModal = false;
  let showRescheduleFixtureModal = false;
  let showLoanPlayerModal = false;
  let showTransferPlayerModal = false;
  let showRecallPlayerModal = false;
  let showCreatePlayerModal = false;
  let showUpdatePlayerModal = false;
  let showSetPlayerInjuryModal = false;
  let showRetirePlayerModal = false;
  let showUnretirePlayerModal = false;
  let showPromoteFormerClubModal = false;
  let showPromoteNewClubModal = false;
  let showUpdateClubModal = false;
  let showAddFixtureDataModal = false;
  function hideRevaluePlayerUpModal() {
    showRevaluePlayerUpModal = false;
  }
  function hideRevaluePlayerDownModal() {
    showRevaluePlayerDownModal = false;
  }
  function hideAddInitialFixturesModal() {
    showAddInitialFixturesModal = false;
  }
  function hideMoveFixturesModal() {
    showMoveFixtureModal = false;
  }
  function hidePostponeFixturesModal() {
    showPostponeFixtureModal = false;
  }
  function hideRescehduleFixturesModal() {
    showRescheduleFixtureModal = false;
  }
  function hideLoanPlayerModal() {
    showLoanPlayerModal = false;
  }
  function hideTransferPlayerModal() {
    showTransferPlayerModal = false;
  }
  function hideRecallPlayerModal() {
    showRecallPlayerModal = false;
  }
  function hideCreatePlayerModal() {
    showCreatePlayerModal = false;
  }
  function hideUpdatePlayerModal() {
    showUpdatePlayerModal = false;
  }
  function hideSetPlayerInjuryModal() {
    showSetPlayerInjuryModal = false;
  }
  function hideRetirePlayerModal() {
    showRetirePlayerModal = false;
  }
  function hideUnretirePlayerModal() {
    showUnretirePlayerModal = false;
  }
  function hidePromoteFormerClubModal() {
    showPromoteFormerClubModal = false;
  }
  function hidePromoteNewClubModal() {
    showPromoteNewClubModal = false;
  }
  function hideUpdateClubModal() {
    showUpdateClubModal = false;
  }
  function hideAddFixtureDataModal() {
    showAddFixtureDataModal = false;
  }
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${validate_component(Revalue_player_up, "RevaluePlayerUp").$$render(
        $$result,
        {
          visible: showRevaluePlayerUpModal,
          closeModal: hideRevaluePlayerUpModal
        },
        {},
        {}
      )} ${validate_component(Revalue_player_down, "RevaluePlayerDown").$$render(
        $$result,
        {
          visible: showRevaluePlayerDownModal,
          closeModal: hideRevaluePlayerDownModal
        },
        {},
        {}
      )} ${validate_component(Add_initial_fixtures, "AddInitialFixtures").$$render(
        $$result,
        {
          visible: showAddInitialFixturesModal,
          closeModal: hideAddInitialFixturesModal
        },
        {},
        {}
      )} ${validate_component(Move_fixture, "MoveFixture").$$render(
        $$result,
        {
          visible: showMoveFixtureModal,
          closeModal: hideMoveFixturesModal
        },
        {},
        {}
      )} ${validate_component(Postpone_fixture, "PostponeFixture").$$render(
        $$result,
        {
          visible: showPostponeFixtureModal,
          closeModal: hidePostponeFixturesModal
        },
        {},
        {}
      )} ${validate_component(Reschedule_fixture, "RescheduleFixture").$$render(
        $$result,
        {
          visible: showRescheduleFixtureModal,
          closeModal: hideRescehduleFixturesModal
        },
        {},
        {}
      )} ${validate_component(Loan_player, "LoanPlayer").$$render(
        $$result,
        {
          visible: showLoanPlayerModal,
          closeModal: hideLoanPlayerModal
        },
        {},
        {}
      )} ${validate_component(Transfer_player, "TransferPlayer").$$render(
        $$result,
        {
          visible: showTransferPlayerModal,
          closeModal: hideTransferPlayerModal
        },
        {},
        {}
      )} ${validate_component(Recall_player, "RecallPlayer").$$render(
        $$result,
        {
          visible: showRecallPlayerModal,
          closeModal: hideRecallPlayerModal
        },
        {},
        {}
      )} ${validate_component(Create_player, "CreatePlayer").$$render(
        $$result,
        {
          visible: showCreatePlayerModal,
          closeModal: hideCreatePlayerModal
        },
        {},
        {}
      )} ${validate_component(Update_player, "UpdatePlayer").$$render(
        $$result,
        {
          visible: showUpdatePlayerModal,
          closeModal: hideUpdatePlayerModal
        },
        {},
        {}
      )} ${validate_component(Set_player_injury, "SetPlayerInjury").$$render(
        $$result,
        {
          visible: showSetPlayerInjuryModal,
          closeModal: hideSetPlayerInjuryModal
        },
        {},
        {}
      )} ${validate_component(Retire_player, "RetirePlayer").$$render(
        $$result,
        {
          visible: showRetirePlayerModal,
          closeModal: hideRetirePlayerModal
        },
        {},
        {}
      )} ${validate_component(Unretire_player, "UnretirePlayer").$$render(
        $$result,
        {
          visible: showUnretirePlayerModal,
          closeModal: hideUnretirePlayerModal
        },
        {},
        {}
      )} ${validate_component(Promote_former_club, "PromoteFormerClub").$$render(
        $$result,
        {
          visible: showPromoteFormerClubModal,
          closeModal: hidePromoteFormerClubModal
        },
        {},
        {}
      )} ${validate_component(Promote_new_club, "PromoteNewClub").$$render(
        $$result,
        {
          visible: showPromoteNewClubModal,
          closeModal: hidePromoteNewClubModal
        },
        {},
        {}
      )} ${validate_component(Update_club, "UpdateClub").$$render(
        $$result,
        {
          visible: showUpdateClubModal,
          closeModal: hideUpdateClubModal
        },
        {},
        {}
      )} ${validate_component(Add_fixture_data, "AddFixtureData").$$render(
        $$result,
        {
          visible: showAddFixtureDataModal,
          closeModal: hideAddFixtureDataModal
        },
        {},
        {}
      )} <div class="m-4"><div class="bg-panel rounded-md"><ul class="flex rounded-t-lg bg-light-gray border-b border-gray-700 px-4 pt-2" data-svelte-h="svelte-18bk998"><li class="mr-4 active-tab"><button class="text-white">Raise Proposal</button></li></ul> <p class="m-4" data-svelte-h="svelte-fij59x">Player proposals</p> <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mt-4 mx-4"><div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-72lk56">Revalue Player Up</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-1rxmlhe">Revalue Player Down</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-zwn9vo">Loan Player</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-17ctatm">Transfer Player</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-muicqu">Recall Player</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-1k130gg">Create Player</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-104xva">Update Player</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-1k3k226">Set Player Injury</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-5hhgma">Retire Player</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-1gkx6yc">Unretire Player</button></div></div></div> <p class="m-4" data-svelte-h="svelte-11opyhx">Fixture proposals</p> <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mt-4 mx-4"><div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-15xq52m">Add Fixture Data</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-1v20vcq">Add Initial Fixtures</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-1tbcn66">Move Fixture</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-1ln289y">Postpone Fixture</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-ybpkhm">Reschedule Fixture</button></div></div></div> <p class="m-4" data-svelte-h="svelte-ujx3lm">Club proposals</p> <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mt-4 mx-4 mb-4"><div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-tgkj3u">Promote Former Club</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-5oqelw">Promote New Club</button></div></div> <div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full"><button class="rounded fpl-button px-3 sm:px-2 px-3 py-1 mr-1 my-1 w-full" data-svelte-h="svelte-1bkfns6">Update Club</button></div></div></div></div></div>`;
    }
  })}`;
});
const Page$d = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $teamStore, $$unsubscribe_teamStore;
  let $$unsubscribe_playerStore;
  let $$unsubscribe_fixtureStore;
  let $$unsubscribe_systemStore;
  let $page, $$unsubscribe_page;
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  $$unsubscribe_playerStore = subscribe(playerStore, (value) => value);
  $$unsubscribe_fixtureStore = subscribe(fixtureStore, (value) => value);
  $$unsubscribe_systemStore = subscribe(systemStore, (value) => value);
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let fixturesWithTeams = [];
  let selectedGameweek;
  Number($page.url.searchParams.get("id"));
  {
    if (fixturesWithTeams.length > 0 && $teamStore.length > 0) {
      updateTableData(fixturesWithTeams, $teamStore, selectedGameweek);
    }
  }
  $$unsubscribe_teamStore();
  $$unsubscribe_playerStore();
  $$unsubscribe_fixtureStore();
  $$unsubscribe_systemStore();
  $$unsubscribe_page();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(Spinner, "Spinner").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
const Page$c = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $teamStore, $$unsubscribe_teamStore;
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  $$unsubscribe_teamStore();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="page-header-wrapper flex w-full"><div class="content-panel w-full"><div class="w-full grid grid-cols-1 md:grid-cols-4 gap-4 mt-4"><p class="col-span-1 md:col-span-4 text-center w-full mb-4" data-svelte-h="svelte-gufabx">Premier League Clubs</p> ${each($teamStore.sort((a, b) => a.id - b.id), (team) => {
        return `<div class="flex flex-col items-center bg-gray-700 rounded shadow p-4 w-full"><div class="flex items-center space-x-4 w-full">${validate_component(BadgeIcon, "BadgeIcon").$$render(
          $$result,
          {
            primaryColour: team.primaryColourHex,
            secondaryColour: team.secondaryColourHex,
            thirdColour: team.thirdColourHex,
            className: "w-8"
          },
          {},
          {}
        )} <p class="flex-grow text-lg md:text-sm">${escape(team.friendlyName)}</p> <a class="mt-auto self-end"${add_attribute("href", `/club?id=${team.id}`, 0)}><button class="fpl-button text-white font-bold py-2 px-4 rounded self-end" data-svelte-h="svelte-1bk95qn">View</button> </a></div> </div>`;
      })}</div></div></div>`;
    }
  })}`;
});
const Default_canisters = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return ``;
});
const Page$b = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="bg-panel rounded-md mt-4"><h1 class="default-header p-4" data-svelte-h="svelte-30ik2c">OpenFPL Cycle Management</h1> <ul class="flex bg-light-gray px-1 md:px-4 pt-2 contained-text border-b border-gray-700 mb-4"><li${add_attribute("class", `mr-1 md:mr-4 ${"active-tab"}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-white"}`,
        0
      )}>Default Canisters</button></li> <li${add_attribute(
        "class",
        `mr-1 md:mr-4 ${""}`,
        0
      )}><button${add_attribute(
        "class",
        `p-2 ${"text-gray-400"}`,
        0
      )}>Automatically Generated Canisters</button></li> <li${add_attribute("class", `mr-1 md:mr-4 ${""}`, 0)}><button${add_attribute("class", `p-2 ${"text-gray-400"}`, 0)}>Topups</button></li> <li${add_attribute("class", `mr-1 md:mr-4 ${""}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-gray-400"}`,
        0
      )}>Cycles Minted</button></li></ul> ${`${validate_component(Default_canisters, "DefaultCanisters").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
const css$1 = {
  code: ".striped.svelte-a09ql9 tr.svelte-a09ql9:nth-child(odd){background-color:rgba(46, 50, 58, 0.6)}",
  map: null
};
const Page$a = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  $$result.css.add(css$1);
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="bg-panel rounded-md p-4 mt-4" data-svelte-h="svelte-1akb89f"><h1 class="default-header">OpenFPL Gameplay Rules</h1> <div><p class="my-2">Please see the below OpenFPL fantasy football gameplay rules.</p> <p class="my-2">Each user begins with £300m to purchase players for their team. The
        value of a player can go up or down depending on how the player is rated
        in the DAO. Provided a certain voting threshold is reached for either a
        £0.25m increase or decrease, the player&#39;s value will change in that
        gameweek. A players value can only change when the season is active 
        (the first game has kicked off and the final game has not finished).</p> <p class="my-2">Each team has 11 players, with no more than 2 selected from any single
        team. The team must be in a valid formation, with 1 goalkeeper, 3-5
        defenders, 3-5 midfielders and 1-3 strikers.</p> <p class="my-2">Users will setup their team before the gameweek deadline each week. When
        playing OpenFPL, users have the chance to win FPL tokens depending on
        how well the players in their team perform.</p> <p class="my-2">In January, a user can change their entire team once.</p> <p class="my-2">A user is allowed to make 3 transfers per week which are never carried
        over.</p> <p class="my-2">Each week a user can select a star player. This player will receive
        double points for the gameweek. If one is not set by the start of the
        gameweek it will automatically be set to the most valuable player in
        your team.</p> <h2 class="default-sub-header">Points</h2> <p class="my-2">The user can get the following points during a gameweek for their team:</p> <table class="w-full border-collapse striped mb-8 mt-4 svelte-a09ql9"><tr class="svelte-a09ql9"><th class="text-left px-4 py-2">For</th> <th class="text-left">Points</th></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Appearing in the game.</td> <td>5</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Every 3 saves a goalkeeper makes.</td> <td>5</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Goalkeeper or defender cleansheet.</td> <td>10</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Forward scores a goal.</td> <td>10</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Midfielder or Forward assists a goal.</td> <td>10</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Midfielder scores a goal.</td> <td>15</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Goalkeeper or defender assists a goal.</td> <td>15</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Goalkeeper or defender scores a goal.</td> <td>20</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Goalkeeper saves a penalty.</td> <td>20</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Player is highest scoring player in match.</td> <td>25</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Player receives a red card.</td> <td>-20</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Player misses a penalty.</td> <td>-15</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Each time a goalkeeper or defender concedes 2 goals.</td> <td>-15</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">A player scores an own goal.</td> <td>-10</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">A player receives a yellow card.</td> <td>-5</td></tr></table> <h2 class="default-sub-header">Bonuses</h2> <p class="my-2">A user can play 1 bonus per gameweek. Each season a user starts with the
        following 8 bonuses:</p> <table class="w-full border-collapse striped mb-8 mt-4 svelte-a09ql9"><tr class="svelte-a09ql9"><th class="text-left px-4 py-2">Bonus</th> <th class="text-left">Description</th></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Goal Getter</td> <td>Select a player you think will score in a game to receive a X3
            mulitplier for each goal scored.</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Pass Master</td> <td>Select a player you think will assist in a game to receive a X3
            mulitplier for each assist.</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">No Entry</td> <td>Select a goalkeeper or defender you think will keep a clean sheet
            to receive a X3 multipler on their total score.</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Team Boost</td> <td>Receive a X2 multiplier from all players from a single club that
            are in your team.</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Safe Hands</td> <td>Receive a X3 multiplier on your goalkeeper if they make 5 saves in
            a match.</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Captain Fantastic</td> <td>Receive a X2 multiplier on your team captain&#39;s score if they score
            a goal in a match.</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Countrymen</td> <td>Receive a X2 multiplier for players of a selected nationality.</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Prospects</td> <td>Receive a X2 multiplier for players under the age of 21.</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Brace Bonus</td> <td>Receive a X2 multiplier on a player&#39;s score if they score 2 or more
            goals in a game. Applies to every player who scores a brace.</td></tr> <tr class="svelte-a09ql9"><td class="text-left px-4 py-2">Hat Trick Hero</td> <td>Receive a X3 multiplier on a player&#39;s score if they score 3 or more
            goals in a game. Applies to every player who scores a hat-trick.</td></tr></table></div></div>`;
    }
  })}`;
});
const Page$9 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let activeProposals = [];
  const proposalStatuses = [
    { id: 1, description: "Open" },
    { id: 2, description: "Rejected" },
    { id: 3, description: "Accepted" },
    { id: 4, description: "Executed" },
    { id: 5, description: "Failed" }
  ];
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="m-4"><div class="bg-panel rounded-md"><ul class="flex rounded-t-lg bg-light-gray border-b border-gray-700 px-4 pt-2"><li${add_attribute("class", `mr-4 ${"active-tab"}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-white"}`,
        0
      )}>Proposals</button></li></ul> ${`<div class="flex justify-between items-center mx-4 mt-4"><select class="fpl-dropdown min-w-[100px]">${each(proposalStatuses, (proposalType) => {
        return `<option${add_attribute("value", proposalType.id, 0)}>${escape(proposalType.description)}</option>`;
      })}</select> <a href="/add-proposal" data-svelte-h="svelte-rozslz"><button class="p-2 fpl-button text-white rounded-md">Raise Proposal</button></a></div> <div class="flex flex-col space-y-4 mt-4"><div class="overflow-x-auto flex-1"><div class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray" data-svelte-h="svelte-1hkhhiw"><div class="w-2/12">Id</div> <div class="w-2/12">Proposal Type</div> <div class="w-4/12">Details</div> <div class="w-4/12">Voting</div></div> ${each(activeProposals, (proposal) => {
        return `<div class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer"><div class="w-2/12">${escape(proposal.id)}</div> <div class="w-2/12">${escape(proposal.topic)}</div> <div class="w-4/12">${escape(proposal.proposal?.title)}</div> <div class="w-4/12">${escape(proposal.latestTally?.yes)}</div> <div class="w-4/12">${escape(proposal.latestTally?.no)}</div> <div class="w-4/12" data-svelte-h="svelte-1e9yq30"><button>Vote</button></div> </div>`;
      })}</div></div>`}</div></div>`;
    }
  })}`;
});
const Page$8 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `  `;
});
function formatEventType(type) {
  return type.replace(/([a-z])([A-Z])/g, "$1 $2");
}
const Page$7 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let startDate = "";
  let endDate = "";
  let eventTypes = [
    { "SystemCheck": null },
    { "CyclesBalanceCheck": null },
    { "UnexpectedError": null },
    { "NewManagerCanisterCreated": null },
    { "TopupSent": null }
  ];
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="bg-panel rounded-md mt-4"><h1 class="default-header p-4" data-svelte-h="svelte-1n1vmrq">OpenFPL System Log</h1> <div class="p-4 flex flex-col sm:flex-row gap-4"><div><label for="start-date" class="block text-sm font-medium" data-svelte-h="svelte-1k71rm2">Start Date</label> <input type="date" id="start-date" class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"${add_attribute("value", startDate, 0)}></div> <div><label for="end-date" class="block text-sm font-medium" data-svelte-h="svelte-1e3dopu">End Date</label> <input type="date" id="end-date" class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"${add_attribute("value", endDate, 0)}></div> <div><label for="event-type" class="block text-sm font-medium" data-svelte-h="svelte-1801z4i">Event Type</label> <select id="event-type" class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm bg-light-gray"><option${add_attribute("value", null, 0)} data-svelte-h="svelte-ao4nde">Select an event type</option>${each(eventTypes, (type) => {
        return `<option${add_attribute("value", type, 0)}>${escape(formatEventType(Object.keys(type)[0]))}</option>`;
      })}</select></div> <div class="flex items-end"><button class="fpl-button default-button" data-svelte-h="svelte-zv974x">Filter</button></div></div> ${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
const Page$6 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $$unsubscribe_selectedGameweek;
  let $$unsubscribe_loadingGameweekDetail;
  let $$unsubscribe_teamStore;
  let $page, $$unsubscribe_page;
  let $$unsubscribe_fantasyTeam;
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => value);
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let fantasyTeam = writable(null);
  $$unsubscribe_fantasyTeam = subscribe(fantasyTeam, (value) => value);
  let selectedGameweek = writable(Number($page.url.searchParams.get("gw")) ?? 1);
  $$unsubscribe_selectedGameweek = subscribe(selectedGameweek, (value) => value);
  let loadingGameweekDetail = writable(false);
  $$unsubscribe_loadingGameweekDetail = subscribe(loadingGameweekDetail, (value) => value);
  $page.url.searchParams.get("id");
  $$unsubscribe_selectedGameweek();
  $$unsubscribe_loadingGameweekDetail();
  $$unsubscribe_teamStore();
  $$unsubscribe_page();
  $$unsubscribe_fantasyTeam();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
const League_details_form = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let leagueName = "";
  let maxEntrants = 1e3;
  let leaguePictureName = "No file chosen";
  let { privateLeague = writable({
    adminFee: 0,
    name: "",
    entryRequirement: { FreeEntry: null },
    entrants: 0,
    termsAgreed: false,
    tokenId: 0,
    banner: [],
    photo: [],
    entryFee: 0n,
    paymentChoice: { ICP: null }
  }) } = $$props;
  if ($$props.privateLeague === void 0 && $$bindings.privateLeague && privateLeague !== void 0)
    $$bindings.privateLeague(privateLeague);
  {
    {
      privateLeague.update((current) => {
        return { ...current, entrants: maxEntrants };
      });
    }
  }
  return `<div class="container mx-auto px-4 pt-4"><div class="mb-4"><label class="block text-sm mb-2" for="league-name" data-svelte-h="svelte-1na500r">League Name:</label> <input type="text" class="shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline" id="league-name"${add_attribute("value", leagueName, 0)}></div> <div class="file-upload-wrapper mb-4"><label class="block text-sm mb-2">League Photo:
        <div class="text-xs"><span>${escape(leaguePictureName)}</span></div> <input type="file" id="profile-image" accept="image/*" class="file-input"></label></div> <div class="mb-4"><label class="block text-sm mb-2" for="max-entrants" data-svelte-h="svelte-kubq9b">Max Entrants:</label> <input type="number" min="2" max="1000" class="shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline" id="max-entrants"${add_attribute("value", maxEntrants, 0)}></div> <div><label class="block text-sm font-bold" for="entry-token" data-svelte-h="svelte-1hu93vt">League Token:</label> <select id="entry-token" class="p-2 fpl-dropdown min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-dflbn6">FPL</option><option${add_attribute("value", 1, 0)} data-svelte-h="svelte-1fymy1v">ICP</option><option${add_attribute("value", 2, 0)} data-svelte-h="svelte-12fiheu">CHAT</option><option${add_attribute("value", 3, 0)} data-svelte-h="svelte-usaqyl">Dragginz</option></select></div></div>`;
});
let accountBalance = 1e3;
const Entry_requirements = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let creatorPrizePool = 0;
  let { privateLeague = writable(null) } = $$props;
  if ($$props.privateLeague === void 0 && $$bindings.privateLeague && privateLeague !== void 0)
    $$bindings.privateLeague(privateLeague);
  return `<div class="container mx-auto p-4"><p class="text-xl mb-2" data-svelte-h="svelte-18wtvzv">Entry Requirements</p> <div class="mb-4"><label class="block text-sm font-bold mb-2" for="entry-type" data-svelte-h="svelte-1bktuog">Entry Type:</label> <select id="entry-type" class="p-2 fpl-dropdown my-4 min-w-[100px]"><option${add_attribute("value", 0, 0)} data-svelte-h="svelte-10ug6uw">Free Entry</option><option${add_attribute("value", 1, 0)} data-svelte-h="svelte-1tymnkz">Paid Entry</option><option${add_attribute("value", 2, 0)} data-svelte-h="svelte-1e921rp">Invite Entry</option><option${add_attribute("value", 3, 0)} data-svelte-h="svelte-1mvuv80">Paid Invite Entry</option></select></div> ${``} <div class="mb-4"><label class="block text-sm font-bold mb-2" for="creator-prize-pool" data-svelte-h="svelte-9btatd">Creator Prize Pool:</label> <input type="number" step="1" min="0" class="shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline" id="creator-prize-pool"${add_attribute("value", creatorPrizePool, 0)}></div> <div class="mb-4"><label class="block text-sm font-bold mb-2" data-svelte-h="svelte-6tssxn">Your Account Balance:</label> <p>${escape(accountBalance)} ICP</p></div></div>`;
});
const Prize_setup = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $numberOfWinners, $$unsubscribe_numberOfWinners;
  let $percentages, $$unsubscribe_percentages;
  let numberOfWinners = writable(10);
  $$unsubscribe_numberOfWinners = subscribe(numberOfWinners, (value) => $numberOfWinners = value);
  let percentages = derived(numberOfWinners, ($numberOfWinners2) => {
    let shares = [];
    let harmonicSum = 0;
    for (let i = 1; i <= $numberOfWinners2; i++) {
      harmonicSum += 1 / i;
    }
    for (let i = 1; i <= $numberOfWinners2; i++) {
      shares.push(1 / i / harmonicSum);
    }
    let percentages2 = shares.map((x) => x * 100);
    let total = percentages2.reduce((acc, curr) => acc + curr, 0);
    percentages2[percentages2.length - 1] += 100 - total;
    return percentages2;
  });
  $$unsubscribe_percentages = subscribe(percentages, (value) => $percentages = value);
  let { privateLeague = writable(null) } = $$props;
  if ($$props.privateLeague === void 0 && $$bindings.privateLeague && privateLeague !== void 0)
    $$bindings.privateLeague(privateLeague);
  $$unsubscribe_numberOfWinners();
  $$unsubscribe_percentages();
  return `<div class="container mx-auto p-4"><p class="text-xl mb-2" data-svelte-h="svelte-gkgwk">Prize Setup</p> <div class="mb-4"><label class="block text-sm font-bold mb-2" for="league-name" data-svelte-h="svelte-1btdpww">Number of Winners:</label> <input type="number" step="1" min="1" max="1000" class="shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline" id="max-entrants"${add_attribute("value", $numberOfWinners, 0)}></div> <div class="mb-4"><p class="block text-sm font-bold mb-2" data-svelte-h="svelte-1g71c53">Percentage Split:</p> ${each($percentages, (percent, index) => {
    return `<div class="mb-2"><input type="number" min="0" max="100" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"${add_attribute("id", `winner-${index}`, 0)}${add_attribute("value", $percentages[index], 0)}> </div>`;
  })} ${$percentages.reduce((total, curr) => total + curr, 0) !== 100 ? `<p class="text-red-500 text-xs italic" data-svelte-h="svelte-9qw4x2">Total percentage must equal 100%.</p>` : ``}</div></div>`;
});
const Agree_terms = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { privateLeague = writable(null) } = $$props;
  if ($$props.privateLeague === void 0 && $$bindings.privateLeague && privateLeague !== void 0)
    $$bindings.privateLeague(privateLeague);
  return `<div class="container mx-auto px-4 py-8" data-svelte-h="svelte-15akzys"><h1 class="text-3xl font-bold text-center mb-6">OpenFPL Private League Terms &amp; Conditions</h1> <div class="space-y-4 text-sm"><p>These Terms and Conditions govern your use of the private league features provided by OpenFPL. 
            By participating in any private league, you agree to these terms.</p> <p>Private leagues on OpenFPL are funded using ICRC-1 tokens. 
            Participants may be required to contribute a predetermined number of tokens to join a private league. 
            The distribution of tokens and any potential winnings are subject to the specific rules set forth by the league&#39;s creator.</p> <ul class="list-disc list-inside"><li>Entry requirements and fees.</li> <li>Distribution of winnings.</li> <li>Setting the league admin fee.</li></ul> <p>It is your responsibility to clearly communicate these rules to all participants before the start of the league. 
            OpenFPL is not responsible for the enforcement of individual league rules and operates only as a platform provider.</p> <p>You are responsible for ensuring that your participation in private leagues complies with all applicable laws and regulations 
            in your jurisdiction. OpenFPL disclaims all liability for any illegal use of the platform by its users.</p> <p>OpenFPL provides the platform for private leagues &quot;as is&quot; and &quot;as available,&quot; without any warranties of any kind. 
            We do not guarantee the continuous, uninterrupted or error-free operation of the platform, 
            nor do we guarantee the outcomes of any games or leagues conducted on our platform.</p> <p>To the fullest extent permitted by law, OpenFPL shall not be liable for any indirect, incidental, special, consequential, or punitive damages, 
            or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, 
            or other intangible losses resulting from:</p> <ul class="list-disc list-inside ml-4"><li>Your access to, use of, or inability to access or use the services;</li> <li>Any conduct or content of any third party on the services;</li> <li>Unauthorized access, use, or alteration of your transmissions or content.</li></ul> <p>If you have any questions about these Terms and Conditions, please contact us at 
            <a href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/?ref=zv6hh-xaaaa-aaaar-ac35q-cai" class="text-blue-600 hover:text-blue-800">OpenFPL Community Support
            </a>.</p> <div class="mt-6 flex items-center"><input type="checkbox" id="agreeTerms" name="agreeTerms" class="w-4 h-4 border-gray-300 rounded focus:ring-blue-500"> <label for="agreeTerms" class="ml-2 block text-sm">I agree to the OpenFPL Private League Terms &amp; Conditions</label></div></div></div>`;
});
const Payment = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let fplBalance;
  let icpBalance;
  let { privateLeague = writable(null) } = $$props;
  if ($$props.privateLeague === void 0 && $$bindings.privateLeague && privateLeague !== void 0)
    $$bindings.privateLeague(privateLeague);
  return `<div class="container mx-auto px-4 py-8"><p class="text-xl mb-2" data-svelte-h="svelte-4k0p">Payment</p> <div class="mb-4"><p>FPL Balance: ${escape(fplBalance)}</p> <p>ICP Balance: ${escape(icpBalance)}</p></div> <div class="grid grid-cols-2 gap-4"><button class="fpl-button px-4 py-2 rounded-md" data-svelte-h="svelte-1x3bu33">Purchase with 250 FPL</button> <button class="fpl-button px-4 py-2 rounded-md" data-svelte-h="svelte-1nlxozb">Purchase with 1 ICP</button></div> <div class="text-sm mt-4" data-svelte-h="svelte-54tdyj"><p>* Purchasing in FPL will burn the tokens and reduce the token supply.</p> <p>* Purchasing in ICP will add funds to the DAO&#39;s treasury.</p></div></div>`;
});
const css = {
  code: ".pips-container.svelte-wusr0z{display:flex;justify-content:left}.pip.svelte-wusr0z{width:10px;height:10px;border-radius:50%;background-color:lightgrey;margin:0 5px}.pip.active.svelte-wusr0z{background-color:#2ce3a6}",
  map: null
};
const Create_private_league = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let backButtonVisible;
  let nextButtonVisible;
  let $privateLeague, $$unsubscribe_privateLeague;
  let $currentStepIndex, $$unsubscribe_currentStepIndex;
  let $visible, $$unsubscribe_visible;
  let $pips, $$unsubscribe_pips;
  let { visible = writable(false) } = $$props;
  $$unsubscribe_visible = subscribe(visible, (value) => $visible = value);
  let currentStepIndex = writable(0);
  $$unsubscribe_currentStepIndex = subscribe(currentStepIndex, (value) => $currentStepIndex = value);
  let { closeModal } = $$props;
  let { handleCreateLeague } = $$props;
  let { privateLeague = writable({
    adminFee: 0,
    name: "",
    entryRequirement: { FreeEntry: null },
    entrants: 0,
    termsAgreed: false,
    tokenId: 0,
    banner: [],
    photo: [],
    entryFee: 0n,
    paymentChoice: { "FPL": null }
  }) } = $$props;
  $$unsubscribe_privateLeague = subscribe(privateLeague, (value) => $privateLeague = value);
  let currentStep = {
    name: "LeagueDetails",
    title: "Enter your league details:"
  };
  let modal;
  const steps = [
    {
      name: "LeagueDetails",
      title: "Enter your league details:"
    },
    {
      name: "EntryRequirements",
      title: "Setup your league entry requirements:"
    },
    {
      name: "PrizeDistribution",
      title: "Setup your league prize distribution:"
    },
    {
      name: "Terms",
      title: "Agree OpenFPL private league terms and conditions:"
    },
    {
      name: "Payment",
      title: "Purchase your private league:"
    }
  ];
  let pips = derived(currentStepIndex, ($currentStepIndex2) => steps.map((_, index) => index <= $currentStepIndex2));
  $$unsubscribe_pips = subscribe(pips, (value) => $pips = value);
  if ($$props.visible === void 0 && $$bindings.visible && visible !== void 0)
    $$bindings.visible(visible);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  if ($$props.handleCreateLeague === void 0 && $$bindings.handleCreateLeague && handleCreateLeague !== void 0)
    $$bindings.handleCreateLeague(handleCreateLeague);
  if ($$props.privateLeague === void 0 && $$bindings.privateLeague && privateLeague !== void 0)
    $$bindings.privateLeague(privateLeague);
  $$result.css.add(css);
  let $$settled;
  let $$rendered;
  let previous_head = $$result.head;
  do {
    $$settled = true;
    $$result.head = previous_head;
    backButtonVisible = $currentStepIndex > 0;
    nextButtonVisible = $currentStepIndex === 0 && ($privateLeague && $privateLeague.name && $privateLeague.name.length > 2) && ($privateLeague.entrants > 1 && $privateLeague.entrants <= 1e3);
    $$rendered = `      ${$visible ? `${validate_component(WizardModal, "WizardModal").$$render(
      $$result,
      { steps, currentStep, this: modal },
      {
        currentStep: ($$value) => {
          currentStep = $$value;
          $$settled = false;
        },
        this: ($$value) => {
          modal = $$value;
          $$settled = false;
        }
      },
      {
        default: () => {
          return `<div class="p-4"><div class="flex justify-between items-center"><p class="text-xl mt-2" data-svelte-h="svelte-1sfhxr1">Create Private League</p> ${validate_component(OpenFPLIcon, "OpenFplIcon").$$render($$result, { className: "w-6 mr-2" }, {}, {})}</div> ${currentStep?.name === "LeagueDetails" ? `${validate_component(League_details_form, "LeagueDetailsForm").$$render($$result, { privateLeague }, {}, {})}` : ``} ${currentStep?.name === "EntryRequirements" ? `${validate_component(Entry_requirements, "EntryRequirements").$$render($$result, { privateLeague }, {}, {})}` : ``} ${currentStep?.name === "PrizeDistribution" ? `${validate_component(Prize_setup, "PrizeSetup").$$render($$result, { privateLeague }, {}, {})}` : ``} ${currentStep?.name === "Terms" ? `${validate_component(Agree_terms, "AgreeTerms").$$render($$result, { privateLeague }, {}, {})}` : ``} ${currentStep?.name === "Payment" ? `${validate_component(Payment, "Payment").$$render($$result, { privateLeague }, {}, {})}` : ``} <div class="horizontal-divider my-2"></div> <div class="flex flex-row m-4 items-center"><div class="pips-container w-1/2 svelte-wusr0z">${each($pips, (pip, index) => {
            return `<div class="${"pip " + escape(pip ? "active" : "", true) + " svelte-wusr0z"}"></div>`;
          })}</div> <div class="flex justify-end space-x-2 mr-4 w-1/2">${backButtonVisible ? `<button class="fpl-button px-4 py-2 rounded-sm" data-svelte-h="svelte-qkcshm">Back</button>` : `<button class="bg-gray-800 px-4 py-2 rounded-sm text-gray-400" data-svelte-h="svelte-1xngkp">Back</button>`} ${nextButtonVisible ? `<button class="fpl-button px-4 py-2 rounded-sm" data-svelte-h="svelte-umtn6t">Next</button>` : `<button class="bg-gray-800 px-4 py-2 rounded-sm text-gray-400" data-svelte-h="svelte-1w83lu7">Next</button>`}</div></div></div>`;
        }
      }
    )}` : ``}`;
  } while (!$$settled);
  $$unsubscribe_privateLeague();
  $$unsubscribe_currentStepIndex();
  $$unsubscribe_visible();
  $$unsubscribe_pips();
  return $$rendered;
});
const pageSize = 10;
const Page$5 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $leagues, $$unsubscribe_leagues;
  const leagues = writable(null);
  $$unsubscribe_leagues = subscribe(leagues, (value) => $leagues = value);
  const showCreateLeagueModal = writable(false);
  let currentPage = 1;
  function fetchLeagues() {
    const dummyLeagues = [
      {
        canisterId: "1",
        name: "OpenFPL Team",
        memberCount: 10n,
        seasonPosition: 1n,
        created: BigInt(Date.now())
      },
      {
        canisterId: "2",
        name: "OpenChat",
        memberCount: 10000n,
        seasonPosition: 3n,
        created: BigInt(Date.now())
      },
      {
        canisterId: "3",
        name: "Dragginz",
        memberCount: 5000n,
        seasonPosition: 2n,
        created: BigInt(Date.now())
      }
    ];
    leagues.set({ entries: dummyLeagues, totalEntries: 2n });
  }
  function handleCreateLeague() {
    fetchLeagues();
  }
  $$unsubscribe_leagues();
  return `${showCreateLeagueModal ? `${validate_component(Create_private_league, "CreateLeagueModal").$$render(
    $$result,
    {
      visible: showCreateLeagueModal,
      handleCreateLeague,
      closeModal: () => showCreateLeagueModal.set(false)
    },
    {},
    {}
  )}` : ``} ${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="m-4"><div class="bg-panel rounded-md"><div class="py-4"><div class="flex justify-between items-center p-4"><div data-svelte-h="svelte-caz7ur">Private Leagues</div> <button class="fpl-button text-white rounded-md p-2" data-svelte-h="svelte-1u65rpy">Create New League</button></div> <div class="overflow-x-auto flex-1"><div class="flex justify-between border border-gray-700 py-2 bg-light-gray border-b border-gray-700 p-4" data-svelte-h="svelte-e3dkh2"><div class="w-3/6">League Name</div> <div class="w-1/6">Members</div> <div class="w-1/6">Season Position</div> <div class="w-1/6"></div></div> ${$leagues ? `${each($leagues.entries, (league) => {
        return `<div class="flex items-center justify-between border-b border-gray-700 cursor-pointer p-4"><div class="w-3/6">${escape(league.name)}</div> <div class="w-1/6">${escape(league.memberCount)}</div> <div class="w-1/6">${escape(league.seasonPosition)}</div> <div class="w-1/6 flex justify-center items-center" data-svelte-h="svelte-li25cb"><button class="rounded fpl-button flex items-center px-4 py-2">View
                    </button></div> </div>`;
      })} <div class="justify-center mt-4 overflow-x-auto px-4"><div class="flex space-x-1 min-w-max">${each(Array(Math.ceil(Number($leagues.totalEntries) / pageSize)), (_, index) => {
        return `<button${add_attribute("class", `px-4 py-2 rounded-md ${index + 1 === currentPage ? "fpl-button" : ""}`, 0)}>${escape(index + 1)} </button>`;
      })}</div></div>` : `<p data-svelte-h="svelte-1hecc6e">You are not a member of any leagues.</p>`}</div></div></div></div>`;
    }
  })}`;
});
function getGridSetup(formation) {
  const formationSplits = formation.split("-").map(Number);
  const setups = [[1], ...formationSplits.map((s2) => Array(s2).fill(0).map((_, i) => i + 1))];
  return setups;
}
const Page$4 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $$unsubscribe_newCaptainId;
  let $playerStore, $$unsubscribe_playerStore;
  let $fantasyTeam, $$unsubscribe_fantasyTeam;
  let $$unsubscribe_transfersAvailable;
  let $$unsubscribe_bankBalance;
  let $$unsubscribe_systemStore;
  $$unsubscribe_playerStore = subscribe(playerStore, (value) => $playerStore = value);
  $$unsubscribe_systemStore = subscribe(systemStore, (value) => value);
  let selectedFormation = "4-4-2";
  const fantasyTeam = writable({
    playerIds: [],
    countrymenCountryId: 0,
    username: "",
    goalGetterPlayerId: 0,
    hatTrickHeroGameweek: 0,
    transfersAvailable: 0,
    teamBoostGameweek: 0,
    captainFantasticGameweek: 0,
    countrymenGameweek: 0,
    bankQuarterMillions: 0,
    noEntryPlayerId: 0,
    safeHandsPlayerId: 0,
    braceBonusGameweek: 0,
    passMasterGameweek: 0,
    teamBoostClubId: 0,
    goalGetterGameweek: 0,
    captainFantasticPlayerId: 0,
    transferWindowGameweek: 0,
    noEntryGameweek: 0,
    prospectsGameweek: 0,
    safeHandsGameweek: 0,
    principalId: "",
    passMasterPlayerId: 0,
    captainId: 0,
    monthlyBonusesAvailable: 0
  });
  $$unsubscribe_fantasyTeam = subscribe(fantasyTeam, (value) => $fantasyTeam = value);
  const transfersAvailable = writable(Infinity);
  $$unsubscribe_transfersAvailable = subscribe(transfersAvailable, (value) => value);
  const bankBalance = writable(1200);
  $$unsubscribe_bankBalance = subscribe(bankBalance, (value) => value);
  const availableFormations = writable(["3-4-3", "3-5-2", "4-3-3", "4-4-2", "4-5-1", "5-4-1", "5-3-2"]);
  const newCaptainId = writable(0);
  $$unsubscribe_newCaptainId = subscribe(newCaptainId, (value) => value);
  function getTeamFormation(team) {
    const positionCounts = { 0: 0, 1: 0, 2: 0, 3: 0 };
    team.playerIds.forEach((id) => {
      const teamPlayer = $playerStore.find((p) => p.id === id);
      if (teamPlayer) {
        positionCounts[convertPlayerPosition(teamPlayer.position)]++;
      }
    });
    for (const formation of Object.keys(allFormations)) {
      const formationPositions = allFormations[formation].positions;
      let isMatch = true;
      const formationCount = formationPositions.reduce(
        (acc, pos) => {
          acc[pos] = (acc[pos] || 0) + 1;
          return acc;
        },
        {}
      );
      for (const pos in formationCount) {
        if (formationCount[pos] !== positionCounts[pos]) {
          isMatch = false;
          break;
        }
      }
      if (isMatch) {
        return formation;
      }
    }
    console.error("No valid formation found for the team");
    return selectedFormation;
  }
  function disableInvalidFormations() {
    if (!$fantasyTeam || !$fantasyTeam.playerIds) {
      return;
    }
    const formations = getAvailableFormations($playerStore, $fantasyTeam);
    availableFormations.set(formations);
  }
  {
    if ($fantasyTeam && $playerStore.length > 0) {
      disableInvalidFormations();
    }
  }
  {
    {
      if ($fantasyTeam) {
        getGridSetup(selectedFormation);
        if ($fantasyTeam.playerIds.filter((x) => x > 0).length == 11) {
          const newFormation = getTeamFormation($fantasyTeam);
          selectedFormation = newFormation;
        }
      }
    }
  }
  $$unsubscribe_newCaptainId();
  $$unsubscribe_playerStore();
  $$unsubscribe_fantasyTeam();
  $$unsubscribe_transfersAvailable();
  $$unsubscribe_bankBalance();
  $$unsubscribe_systemStore();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(Spinner, "Spinner").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
const Page$3 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $teamStore, $$unsubscribe_teamStore;
  let $fixtureStore, $$unsubscribe_fixtureStore;
  let $$unsubscribe_playerStore;
  let $systemStore, $$unsubscribe_systemStore;
  let $page, $$unsubscribe_page;
  let $$unsubscribe_countriesStore;
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  $$unsubscribe_fixtureStore = subscribe(fixtureStore, (value) => $fixtureStore = value);
  $$unsubscribe_playerStore = subscribe(playerStore, (value) => value);
  $$unsubscribe_systemStore = subscribe(systemStore, (value) => $systemStore = value);
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  $$unsubscribe_countriesStore = subscribe(countriesStore, (value) => value);
  let selectedGameweek = $systemStore?.pickTeamGameweek ?? 1;
  let fixturesWithTeams = [];
  Number($page.url.searchParams.get("id"));
  {
    if ($fixtureStore.length > 0 && $teamStore.length > 0) {
      updateTableData(fixturesWithTeams, $teamStore, selectedGameweek);
    }
  }
  $$unsubscribe_teamStore();
  $$unsubscribe_fixtureStore();
  $$unsubscribe_playerStore();
  $$unsubscribe_systemStore();
  $$unsubscribe_page();
  $$unsubscribe_countriesStore();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
const Page$2 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(Local_spinner, "LocalSpinner").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
const Page$1 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="bg-panel rounded-md p-4 mt-4" data-svelte-h="svelte-p7ybpc"><h1 class="default-header">OpenFPL DAO Terms &amp; Conditions</h1> <div><p class="my-2 text-xs">Last Updated: 13th October 2023</p> <p class="my-4">By accessing the OpenFPL website (&quot;Site&quot;) and participating in the
        OpenFPL Fantasy Football DAO (&quot;Service&quot;), you agree to comply with and
        be bound by the following Terms and Conditions.</p> <h2 class="default-sub-header">Acceptance of Terms</h2> <p class="my-4">You acknowledge that you have read, understood, and agree to be bound by
        these Terms. These Terms are subject to change by a DAO proposal and
        vote.</p> <h2 class="default-sub-header">Decentralised Structure</h2> <p class="my-4">OpenFPL operates as a decentralised autonomous organisation (DAO). As
        such, traditional legal and liability structures may not apply. Members
        and users are responsible for their own actions within the DAO
        framework.</p> <h2 class="default-sub-header">Eligibility</h2> <p class="my-4">The Service is open to users of all ages.</p> <h2 class="default-sub-header">User Conduct</h2> <p class="my-4">No Automation or Bots: You agree not to use bots, automated methods, or
        other non-human ways of interacting with the site.</p> <h2 class="default-sub-header">Username Policy</h2> <p class="my-4">You agree not to use usernames that are offensive, vulgar, or infringe
        on the rights of others.</p> <h2 class="default-sub-header">Changes to Terms</h2> <p class="my-4">These Terms and Conditions are subject to change. Amendments will be
        effective upon DAO members&#39; approval via proposal and vote.</p></div></div>`;
    }
  })}`;
});
const Vision = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `<div class="m-4" data-svelte-h="svelte-nvmvhm"><h1 class="default-header">Our Vision</h1> <p class="my-4">OpenFPL was created as our answer to the question:</p> <p class="my-2"><i>&quot;How do you introduce the most new users to the Internet Computer
      Blockchain?&quot;</i>.</p> <p class="my-4">Football is the most popular sport in the world, with billions of fans, the
    leading fantasy football game engages over 10 million players a season.
    OpenFPL is a better, more equitable, decentralised fantasy football platform
    for football fans worldwide. We have used our football knowledge to create a
    more engaging game, coupled with token distribution to ensure users are more
    equitably rewarded for their successful pariticipation.</p> <p class="my-4 default-header">Why The Internet Computer?</p> <p>The Internet Computer (IC) is the only computer system in the world that
    allows users of an online service to truly own that service. The IC&#39;s unique
    architecture allows the interface the user engages with to be stored on the
    network, bypassing the big tech companies who do not have an interest in
    providing decentralised services. The IC not only has the capabilities to
    shift power structures in the tech world, it is built with its own
    decentralised service creation infrastructure that allow services like
    OpenFPL to become Decentralised Autonomous Organisations (DAOs). OpenFPL
    will transform fantasy Premier League football using this DAO architecture
    into a decentralised service that is more engaging for its users, rewarding
    football fans for their insight and participation in football.</p> <p class="my-4">OpenFPL is more than a decentralised service, it is a brand that has
    multiple viable revenue streams. The ICPFA will distribute this value to
    token holders through inflation resistant tokenomics. Through a
    mechanisation of purchasing &amp; burning exchange $FPL, we aim to keep the
    total supply at 100 million, while building up a healthy treasury for the
    DAO to utilise as it wishes.</p> <p class="my-4">OpenFPL will create a platform Premier League fans feel at home using, with
    their input shaping the service. Our features are designed to enhance user
    engagement on the platform. These include more detailed and varied gameplay,
    community-based player valuations, customisable private leagues, and
    collaborations with football content creators. As we attract more users,
    engagement within the OpenFPL ecosystem will grow, which should contribute
    to the growth and value of the $FPL governance token.</p> <p class="my-4">Our vision for OpenFPL encompasses a commitment to societal impact,
    specifically through our organisation, the ICPFA. The ICPFA will be focused
    on supporting grassroots football initiatives, demonstrating our belief in
    OpenFPL&#39;s ability to bring about positive change in the football community
    using the IC.</p> <p class="my-4 mb-4">In essence OpenFPL will be the world&#39;s game on the world&#39;s computer. A truly
    decentralised service, the fans home for Premier League football.</p></div>`;
});
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="bg-panel mt-4"><h1 class="p-4 mx-1 default-header" data-svelte-h="svelte-pit84d">OpenFPL Whitepaper</h1> <ul class="flex flex-nowrap overflow-x-auto bg-light-gray border-b border-gray-700 px-4 pt-2"><li${add_attribute("class", `mr-4 ${"active-tab"}`, 0)}><button${add_attribute("class", `p-2 ${"text-white"}`, 0)}>Vision</button></li> <li${add_attribute("class", `mr-4 ${""}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-gray-400"}`,
        0
      )}>Gameplay</button></li> <li${add_attribute("class", `mr-4 ${""}`, 0)}><button${add_attribute("class", `p-2 ${"text-gray-400"}`, 0)}>DAO</button></li> <li${add_attribute("class", `mr-4 ${""}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-gray-400"}`,
        0
      )}>Tokenomics</button></li> <li${add_attribute("class", `mr-4 ${""}`, 0)}><button${add_attribute("class", `p-2 ${"text-gray-400"}`, 0)}>Revenue</button></li> <li${add_attribute("class", `mr-4 ${""}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-gray-400"}`,
        0
      )}>Marketing</button></li> <li${add_attribute("class", `mr-4 ${""}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-gray-400"}`,
        0
      )}>Architecture</button></li> <li${add_attribute("class", `mr-4 ${""}`, 0)}><button${add_attribute("class", `p-2 ${"text-gray-400"}`, 0)}>Roadmap</button></li></ul> ${`${validate_component(Vision, "Vision").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
export {
  Error$1 as E,
  Layout$1 as L,
  Page$g as P,
  Server as S,
  set_building as a,
  set_manifest as b,
  set_prerendering as c,
  set_private_env as d,
  set_public_env as e,
  set_read_implementation as f,
  get_hooks as g,
  set_safe_public_env as h,
  Page$f as i,
  Page$e as j,
  Page$d as k,
  Page$c as l,
  Page$b as m,
  Page$a as n,
  options as o,
  Page$9 as p,
  Page$8 as q,
  Page$7 as r,
  set_assets as s,
  Page$6 as t,
  Page$5 as u,
  Page$4 as v,
  Page$3 as w,
  Page$2 as x,
  Page$1 as y,
  Page as z
};
