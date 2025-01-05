import { B as BROWSER } from "./vendor.js";
import * as devalue from "devalue";
import { Buffer } from "buffer";
import { parse, serialize } from "cookie";
import * as set_cookie_parser from "set-cookie-parser";
import { AuthClient } from "@dfinity/auth-client";
import { createAgent } from "@dfinity/utils";
import { HttpAgent, Actor } from "@dfinity/agent";
import { Text as Text$1 } from "@dfinity/candid/lib/cjs/idl.js";
import { IcrcLedgerCanister } from "@dfinity/ledger-icrc";
import { Principal } from "@dfinity/principal";
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
    const match = /([^/ \t]+)\/([^; \t]+)[ \t]*(?:;[ \t]*q=([0-9.]+))?/.exec(str);
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
const escape_html_attr_dict = {
  "&": "&amp;",
  '"': "&quot;"
  // Svelte also escapes < because the escape function could be called inside a `noscript` there
  // https://github.com/sveltejs/svelte/security/advisories/GHSA-8266-84wp-wv5c
  // However, that doesn't apply in SvelteKit
};
const escape_html_dict = {
  "&": "&amp;",
  "<": "&lt;"
};
const surrogates = (
  // high surrogate without paired low surrogate
  "[\\ud800-\\udbff](?![\\udc00-\\udfff])|[\\ud800-\\udbff][\\udc00-\\udfff]|[\\udc00-\\udfff]"
);
const escape_html_attr_regex = new RegExp(
  `[${Object.keys(escape_html_attr_dict).join("")}]|` + surrogates,
  "g"
);
const escape_html_regex = new RegExp(
  `[${Object.keys(escape_html_dict).join("")}]|` + surrogates,
  "g"
);
function escape_html$1(str, is_attr) {
  const dict = is_attr ? escape_html_attr_dict : escape_html_dict;
  const escaped_str = str.replace(is_attr ? escape_html_attr_regex : escape_html_regex, (match) => {
    if (match.length === 2) {
      return match;
    }
    return dict[match] ?? `&#${match.charCodeAt(0)};`;
  });
  return escaped_str;
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
  if ("GET" in mod || "HEAD" in mod) allowed.push("HEAD");
  return allowed;
}
function static_error_page(options2, status, message) {
  let page2 = options2.templates.error({ status, message: escape_html$1(message) });
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
  if (node.uses?.parent) uses.push('"parent":1');
  if (node.uses?.route) uses.push('"route":1');
  if (node.uses?.url) uses.push('"url":1');
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
  if (method === "POST" && headers2.get("x-sveltekit-action") === "true") return false;
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
  if (path[0] === "/" && path[1] === "/") return path;
  let url = new URL(base2, internal);
  url = new URL(path, url);
  return url.protocol === internal.protocol ? url.pathname + url.search + url.hash : url.href;
}
function normalize_path(path, trailing_slash) {
  if (path === "/" || trailing_slash === "ignore") return path;
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
function make_trackable(url, callback, search_params_callback, allow_hash = false) {
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
  const tracked_url_properties = ["href", "pathname", "search", "toString", "toJSON"];
  if (allow_hash) tracked_url_properties.push("hash");
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
    tracked.searchParams[Symbol.for("nodejs.util.inspect.custom")] = (depth, opts, inspect) => {
      return inspect(url.searchParams, opts);
    };
  }
  if (!allow_hash) {
    disable_hash(tracked);
  }
  return tracked;
}
function disable_hash(url) {
  allow_nodejs_console_log(url);
  Object.defineProperty(url, "hash", {
    get() {
      throw new Error(
        "Cannot access event.url.hash. Consider using `page.url.hash` inside a component instead"
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
  if (pathname.endsWith(".html")) return pathname.replace(/\.html$/, HTML_DATA_SUFFIX);
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
      `POST method not allowed. No form actions exist for ${"this page"}`
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
    if (false) ;
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
          event.route.id,
          options2.hooks.transport
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
          event.route.id,
          options2.hooks.transport
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
        `POST method not allowed. No form actions exist for ${"this page"}`
      )
    };
  }
  check_named_default_separate(actions);
  try {
    const data = await call_action(event, actions);
    if (false) ;
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
      "When using named actions, the default action cannot be used. See the docs for more info: https://svelte.dev/docs/kit/form-actions#named-actions"
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
function uneval_action_response(data, route_id, transport) {
  const replacer2 = (thing) => {
    for (const key2 in transport) {
      const encoded = transport[key2].encode(thing);
      if (encoded) {
        return `app.decode('${key2}', ${devalue.uneval(encoded, replacer2)})`;
      }
    }
  };
  return try_serialize(data, (value) => devalue.uneval(value, replacer2), route_id);
}
function stringify_action_response(data, route_id, transport) {
  const encoders = Object.fromEntries(
    Object.entries(transport).map(([key2, value]) => [key2, value.encode])
  );
  return try_serialize(data, (value) => devalue.stringify(value, encoders), route_id);
}
function try_serialize(data, fn, route_id) {
  try {
    return fn(data);
  } catch (e) {
    const error = (
      /** @type {any} */
      e
    );
    if (data instanceof Response) {
      throw new Error(
        `Data returned from action inside ${route_id} is not serializable. Form actions need to return plain objects or fail(). E.g. return { success: true } or return fail(400, { message: "invalid" });`
      );
    }
    if ("path" in error) {
      let message = `Data returned from action inside ${route_id} is not serializable: ${error.message}`;
      if (error.path !== "") message += ` (data.${error.path})`;
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
  if (!node?.server) return null;
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
              `Failed to get response header "${lower}" — it must be included by the \`filterSerializedResponseHeaders\` option: https://svelte.dev/docs/kit/hooks#Server-hooks-handle (at ${event.route.id})`
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
var is_array = Array.isArray;
var array_from = Array.from;
var define_property = Object.defineProperty;
var get_descriptor = Object.getOwnPropertyDescriptor;
const noop = () => {
};
function is_promise(value) {
  return typeof value?.then === "function";
}
function run_all(arr) {
  for (var i = 0; i < arr.length; i++) {
    arr[i]();
  }
}
function fallback(value, fallback2, lazy = false) {
  return value === void 0 ? lazy ? (
    /** @type {() => V} */
    fallback2()
  ) : (
    /** @type {V} */
    fallback2
  ) : value;
}
function equals(value) {
  return value === this.v;
}
function safe_not_equal(a, b) {
  return a != a ? b == b : a !== b || a !== null && typeof a === "object" || typeof a === "function";
}
function safe_equals(value) {
  return !safe_not_equal(value, this.v);
}
const DERIVED = 1 << 1;
const EFFECT = 1 << 2;
const RENDER_EFFECT = 1 << 3;
const BLOCK_EFFECT = 1 << 4;
const BRANCH_EFFECT = 1 << 5;
const ROOT_EFFECT = 1 << 6;
const BOUNDARY_EFFECT = 1 << 7;
const UNOWNED = 1 << 8;
const DISCONNECTED = 1 << 9;
const CLEAN = 1 << 10;
const DIRTY = 1 << 11;
const MAYBE_DIRTY = 1 << 12;
const INERT = 1 << 13;
const DESTROYED = 1 << 14;
const EFFECT_RAN = 1 << 15;
const EFFECT_TRANSPARENT = 1 << 16;
const HEAD_EFFECT = 1 << 19;
const EFFECT_HAS_DERIVED = 1 << 20;
const LEGACY_PROPS = Symbol("legacy props");
function effect_update_depth_exceeded() {
  {
    throw new Error(`https://svelte.dev/e/effect_update_depth_exceeded`);
  }
}
function hydration_failed() {
  {
    throw new Error(`https://svelte.dev/e/hydration_failed`);
  }
}
function state_unsafe_local_read() {
  {
    throw new Error(`https://svelte.dev/e/state_unsafe_local_read`);
  }
}
function state_unsafe_mutation() {
  {
    throw new Error(`https://svelte.dev/e/state_unsafe_mutation`);
  }
}
let legacy_mode_flag = false;
const HYDRATION_START = "[";
const HYDRATION_END = "]";
const HYDRATION_ERROR = {};
function source(v, stack) {
  var signal = {
    f: 0,
    // TODO ideally we could skip this altogether, but it causes type errors
    v,
    reactions: null,
    equals,
    version: 0
  };
  return signal;
}
// @__NO_SIDE_EFFECTS__
function mutable_source(initial_value, immutable = false) {
  const s2 = source(initial_value);
  if (!immutable) {
    s2.equals = safe_equals;
  }
  return s2;
}
function set(source2, value) {
  if (active_reaction !== null && is_runes() && (active_reaction.f & (DERIVED | BLOCK_EFFECT)) !== 0 && // If the source was created locally within the current derived, then
  // we allow the mutation.
  (derived_sources === null || !derived_sources.includes(source2))) {
    state_unsafe_mutation();
  }
  return internal_set(source2, value);
}
function internal_set(source2, value) {
  if (!source2.equals(value)) {
    source2.v = value;
    source2.version = increment_version();
    mark_reactions(source2, DIRTY);
    if (active_effect !== null && (active_effect.f & CLEAN) !== 0 && (active_effect.f & BRANCH_EFFECT) === 0) {
      if (new_deps !== null && new_deps.includes(source2)) {
        set_signal_status(active_effect, DIRTY);
        schedule_effect(active_effect);
      } else {
        if (untracked_writes === null) {
          set_untracked_writes([source2]);
        } else {
          untracked_writes.push(source2);
        }
      }
    }
  }
  return value;
}
function mark_reactions(signal, status) {
  var reactions = signal.reactions;
  if (reactions === null) return;
  var length = reactions.length;
  for (var i = 0; i < length; i++) {
    var reaction = reactions[i];
    var flags = reaction.f;
    if ((flags & DIRTY) !== 0) continue;
    set_signal_status(reaction, status);
    if ((flags & (CLEAN | UNOWNED)) !== 0) {
      if ((flags & DERIVED) !== 0) {
        mark_reactions(
          /** @type {Derived} */
          reaction,
          MAYBE_DIRTY
        );
      } else {
        schedule_effect(
          /** @type {Effect} */
          reaction
        );
      }
    }
  }
}
function hydration_mismatch(location) {
  {
    console.warn(`https://svelte.dev/e/hydration_mismatch`);
  }
}
let hydrating = false;
function set_hydrating(value) {
  hydrating = value;
}
let hydrate_node;
function set_hydrate_node(node) {
  if (node === null) {
    hydration_mismatch();
    throw HYDRATION_ERROR;
  }
  return hydrate_node = node;
}
function hydrate_next() {
  return set_hydrate_node(
    /** @type {TemplateNode} */
    /* @__PURE__ */ get_next_sibling(hydrate_node)
  );
}
var $window;
var first_child_getter;
var next_sibling_getter;
function init_operations() {
  if ($window !== void 0) {
    return;
  }
  $window = window;
  var element_prototype = Element.prototype;
  var node_prototype = Node.prototype;
  first_child_getter = get_descriptor(node_prototype, "firstChild").get;
  next_sibling_getter = get_descriptor(node_prototype, "nextSibling").get;
  element_prototype.__click = void 0;
  element_prototype.__className = "";
  element_prototype.__attributes = null;
  element_prototype.__styles = null;
  element_prototype.__e = void 0;
  Text.prototype.__t = void 0;
}
function create_text(value = "") {
  return document.createTextNode(value);
}
// @__NO_SIDE_EFFECTS__
function get_first_child(node) {
  return first_child_getter.call(node);
}
// @__NO_SIDE_EFFECTS__
function get_next_sibling(node) {
  return next_sibling_getter.call(node);
}
function clear_text_content(node) {
  node.textContent = "";
}
function destroy_derived_children(derived2) {
  var children = derived2.children;
  if (children !== null) {
    derived2.children = null;
    for (var i = 0; i < children.length; i += 1) {
      var child = children[i];
      if ((child.f & DERIVED) !== 0) {
        destroy_derived(
          /** @type {Derived} */
          child
        );
      } else {
        destroy_effect(
          /** @type {Effect} */
          child
        );
      }
    }
  }
}
function get_derived_parent_effect(derived2) {
  var parent = derived2.parent;
  while (parent !== null) {
    if ((parent.f & DERIVED) === 0) {
      return (
        /** @type {Effect} */
        parent
      );
    }
    parent = parent.parent;
  }
  return null;
}
function execute_derived(derived2) {
  var value;
  var prev_active_effect = active_effect;
  set_active_effect(get_derived_parent_effect(derived2));
  {
    try {
      destroy_derived_children(derived2);
      value = update_reaction(derived2);
    } finally {
      set_active_effect(prev_active_effect);
    }
  }
  return value;
}
function update_derived(derived2) {
  var value = execute_derived(derived2);
  var status = (skip_reaction || (derived2.f & UNOWNED) !== 0) && derived2.deps !== null ? MAYBE_DIRTY : CLEAN;
  set_signal_status(derived2, status);
  if (!derived2.equals(value)) {
    derived2.v = value;
    derived2.version = increment_version();
  }
}
function destroy_derived(derived2) {
  destroy_derived_children(derived2);
  remove_reactions(derived2, 0);
  set_signal_status(derived2, DESTROYED);
  derived2.v = derived2.children = derived2.deps = derived2.ctx = derived2.reactions = null;
}
function push_effect(effect2, parent_effect) {
  var parent_last = parent_effect.last;
  if (parent_last === null) {
    parent_effect.last = parent_effect.first = effect2;
  } else {
    parent_last.next = effect2;
    effect2.prev = parent_last;
    parent_effect.last = effect2;
  }
}
function create_effect(type, fn, sync, push2 = true) {
  var is_root = (type & ROOT_EFFECT) !== 0;
  var parent_effect = active_effect;
  var effect2 = {
    ctx: component_context,
    deps: null,
    deriveds: null,
    nodes_start: null,
    nodes_end: null,
    f: type | DIRTY,
    first: null,
    fn,
    last: null,
    next: null,
    parent: is_root ? null : parent_effect,
    prev: null,
    teardown: null,
    transitions: null,
    version: 0
  };
  if (sync) {
    var previously_flushing_effect = is_flushing_effect;
    try {
      set_is_flushing_effect(true);
      update_effect(effect2);
      effect2.f |= EFFECT_RAN;
    } catch (e) {
      destroy_effect(effect2);
      throw e;
    } finally {
      set_is_flushing_effect(previously_flushing_effect);
    }
  } else if (fn !== null) {
    schedule_effect(effect2);
  }
  var inert = sync && effect2.deps === null && effect2.first === null && effect2.nodes_start === null && effect2.teardown === null && (effect2.f & EFFECT_HAS_DERIVED) === 0;
  if (!inert && !is_root && push2) {
    if (parent_effect !== null) {
      push_effect(effect2, parent_effect);
    }
    if (active_reaction !== null && (active_reaction.f & DERIVED) !== 0) {
      var derived2 = (
        /** @type {Derived} */
        active_reaction
      );
      (derived2.children ??= []).push(effect2);
    }
  }
  return effect2;
}
function component_root(fn) {
  const effect2 = create_effect(ROOT_EFFECT, fn, true);
  return (options2 = {}) => {
    return new Promise((fulfil) => {
      if (options2.outro) {
        pause_effect(effect2, () => {
          destroy_effect(effect2);
          fulfil(void 0);
        });
      } else {
        destroy_effect(effect2);
        fulfil(void 0);
      }
    });
  };
}
function effect(fn) {
  return create_effect(EFFECT, fn, false);
}
function branch(fn, push2 = true) {
  return create_effect(RENDER_EFFECT | BRANCH_EFFECT, fn, true, push2);
}
function execute_effect_teardown(effect2) {
  var teardown = effect2.teardown;
  if (teardown !== null) {
    const previous_reaction = active_reaction;
    set_active_reaction(null);
    try {
      teardown.call(null);
    } finally {
      set_active_reaction(previous_reaction);
    }
  }
}
function destroy_effect_deriveds(signal) {
  var deriveds = signal.deriveds;
  if (deriveds !== null) {
    signal.deriveds = null;
    for (var i = 0; i < deriveds.length; i += 1) {
      destroy_derived(deriveds[i]);
    }
  }
}
function destroy_effect_children(signal, remove_dom = false) {
  var effect2 = signal.first;
  signal.first = signal.last = null;
  while (effect2 !== null) {
    var next = effect2.next;
    destroy_effect(effect2, remove_dom);
    effect2 = next;
  }
}
function destroy_block_effect_children(signal) {
  var effect2 = signal.first;
  while (effect2 !== null) {
    var next = effect2.next;
    if ((effect2.f & BRANCH_EFFECT) === 0) {
      destroy_effect(effect2);
    }
    effect2 = next;
  }
}
function destroy_effect(effect2, remove_dom = true) {
  var removed = false;
  if ((remove_dom || (effect2.f & HEAD_EFFECT) !== 0) && effect2.nodes_start !== null) {
    var node = effect2.nodes_start;
    var end = effect2.nodes_end;
    while (node !== null) {
      var next = node === end ? null : (
        /** @type {TemplateNode} */
        /* @__PURE__ */ get_next_sibling(node)
      );
      node.remove();
      node = next;
    }
    removed = true;
  }
  destroy_effect_children(effect2, remove_dom && !removed);
  destroy_effect_deriveds(effect2);
  remove_reactions(effect2, 0);
  set_signal_status(effect2, DESTROYED);
  var transitions = effect2.transitions;
  if (transitions !== null) {
    for (const transition of transitions) {
      transition.stop();
    }
  }
  execute_effect_teardown(effect2);
  var parent = effect2.parent;
  if (parent !== null && parent.first !== null) {
    unlink_effect(effect2);
  }
  effect2.next = effect2.prev = effect2.teardown = effect2.ctx = effect2.deps = effect2.fn = effect2.nodes_start = effect2.nodes_end = null;
}
function unlink_effect(effect2) {
  var parent = effect2.parent;
  var prev = effect2.prev;
  var next = effect2.next;
  if (prev !== null) prev.next = next;
  if (next !== null) next.prev = prev;
  if (parent !== null) {
    if (parent.first === effect2) parent.first = next;
    if (parent.last === effect2) parent.last = prev;
  }
}
function pause_effect(effect2, callback) {
  var transitions = [];
  pause_children(effect2, transitions, true);
  run_out_transitions(transitions, () => {
    destroy_effect(effect2);
    callback();
  });
}
function run_out_transitions(transitions, fn) {
  var remaining = transitions.length;
  if (remaining > 0) {
    var check = () => --remaining || fn();
    for (var transition of transitions) {
      transition.out(check);
    }
  } else {
    fn();
  }
}
function pause_children(effect2, transitions, local) {
  if ((effect2.f & INERT) !== 0) return;
  effect2.f ^= INERT;
  if (effect2.transitions !== null) {
    for (const transition of effect2.transitions) {
      if (transition.is_global || local) {
        transitions.push(transition);
      }
    }
  }
  var child = effect2.first;
  while (child !== null) {
    var sibling = child.next;
    var transparent = (child.f & EFFECT_TRANSPARENT) !== 0 || (child.f & BRANCH_EFFECT) !== 0;
    pause_children(child, transitions, transparent ? local : false);
    child = sibling;
  }
}
function flush_tasks() {
}
function lifecycle_outside_component(name) {
  {
    throw new Error(`https://svelte.dev/e/lifecycle_outside_component`);
  }
}
const FLUSH_MICROTASK = 0;
const FLUSH_SYNC = 1;
let is_throwing_error = false;
let scheduler_mode = FLUSH_MICROTASK;
let is_micro_task_queued = false;
let last_scheduled_effect = null;
let is_flushing_effect = false;
function set_is_flushing_effect(value) {
  is_flushing_effect = value;
}
let queued_root_effects = [];
let flush_count = 0;
let dev_effect_stack = [];
let active_reaction = null;
function set_active_reaction(reaction) {
  active_reaction = reaction;
}
let active_effect = null;
function set_active_effect(effect2) {
  active_effect = effect2;
}
let derived_sources = null;
let new_deps = null;
let skipped_deps = 0;
let untracked_writes = null;
function set_untracked_writes(value) {
  untracked_writes = value;
}
let current_version = 1;
let skip_reaction = false;
let component_context = null;
function increment_version() {
  return ++current_version;
}
function is_runes() {
  return !legacy_mode_flag;
}
function check_dirtiness(reaction) {
  var flags = reaction.f;
  if ((flags & DIRTY) !== 0) {
    return true;
  }
  if ((flags & MAYBE_DIRTY) !== 0) {
    var dependencies = reaction.deps;
    var is_unowned = (flags & UNOWNED) !== 0;
    if (dependencies !== null) {
      var i;
      if ((flags & DISCONNECTED) !== 0) {
        for (i = 0; i < dependencies.length; i++) {
          (dependencies[i].reactions ??= []).push(reaction);
        }
        reaction.f ^= DISCONNECTED;
      }
      for (i = 0; i < dependencies.length; i++) {
        var dependency = dependencies[i];
        if (check_dirtiness(
          /** @type {Derived} */
          dependency
        )) {
          update_derived(
            /** @type {Derived} */
            dependency
          );
        }
        if (is_unowned && active_effect !== null && !skip_reaction && !dependency?.reactions?.includes(reaction)) {
          (dependency.reactions ??= []).push(reaction);
        }
        if (dependency.version > reaction.version) {
          return true;
        }
      }
    }
    if (!is_unowned || active_effect !== null && !skip_reaction) {
      set_signal_status(reaction, CLEAN);
    }
  }
  return false;
}
function propagate_error(error, effect2) {
  var current = effect2;
  while (current !== null) {
    if ((current.f & BOUNDARY_EFFECT) !== 0) {
      try {
        current.fn(error);
        return;
      } catch {
        current.f ^= BOUNDARY_EFFECT;
      }
    }
    current = current.parent;
  }
  is_throwing_error = false;
  throw error;
}
function should_rethrow_error(effect2) {
  return (effect2.f & DESTROYED) === 0 && (effect2.parent === null || (effect2.parent.f & BOUNDARY_EFFECT) === 0);
}
function handle_error(error, effect2, previous_effect, component_context2) {
  if (is_throwing_error) {
    if (previous_effect === null) {
      is_throwing_error = false;
    }
    if (should_rethrow_error(effect2)) {
      throw error;
    }
    return;
  }
  if (previous_effect !== null) {
    is_throwing_error = true;
  }
  {
    propagate_error(error, effect2);
    return;
  }
}
function update_reaction(reaction) {
  var previous_deps = new_deps;
  var previous_skipped_deps = skipped_deps;
  var previous_untracked_writes = untracked_writes;
  var previous_reaction = active_reaction;
  var previous_skip_reaction = skip_reaction;
  var prev_derived_sources = derived_sources;
  var previous_component_context = component_context;
  var flags = reaction.f;
  new_deps = /** @type {null | Value[]} */
  null;
  skipped_deps = 0;
  untracked_writes = null;
  active_reaction = (flags & (BRANCH_EFFECT | ROOT_EFFECT)) === 0 ? reaction : null;
  skip_reaction = !is_flushing_effect && (flags & UNOWNED) !== 0;
  derived_sources = null;
  component_context = reaction.ctx;
  try {
    var result = (
      /** @type {Function} */
      (0, reaction.fn)()
    );
    var deps = reaction.deps;
    if (new_deps !== null) {
      var i;
      remove_reactions(reaction, skipped_deps);
      if (deps !== null && skipped_deps > 0) {
        deps.length = skipped_deps + new_deps.length;
        for (i = 0; i < new_deps.length; i++) {
          deps[skipped_deps + i] = new_deps[i];
        }
      } else {
        reaction.deps = deps = new_deps;
      }
      if (!skip_reaction) {
        for (i = skipped_deps; i < deps.length; i++) {
          (deps[i].reactions ??= []).push(reaction);
        }
      }
    } else if (deps !== null && skipped_deps < deps.length) {
      remove_reactions(reaction, skipped_deps);
      deps.length = skipped_deps;
    }
    return result;
  } finally {
    new_deps = previous_deps;
    skipped_deps = previous_skipped_deps;
    untracked_writes = previous_untracked_writes;
    active_reaction = previous_reaction;
    skip_reaction = previous_skip_reaction;
    derived_sources = prev_derived_sources;
    component_context = previous_component_context;
  }
}
function remove_reaction(signal, dependency) {
  let reactions = dependency.reactions;
  if (reactions !== null) {
    var index = reactions.indexOf(signal);
    if (index !== -1) {
      var new_length = reactions.length - 1;
      if (new_length === 0) {
        reactions = dependency.reactions = null;
      } else {
        reactions[index] = reactions[new_length];
        reactions.pop();
      }
    }
  }
  if (reactions === null && (dependency.f & DERIVED) !== 0 && // Destroying a child effect while updating a parent effect can cause a dependency to appear
  // to be unused, when in fact it is used by the currently-updating parent. Checking `new_deps`
  // allows us to skip the expensive work of disconnecting and immediately reconnecting it
  (new_deps === null || !new_deps.includes(dependency))) {
    set_signal_status(dependency, MAYBE_DIRTY);
    if ((dependency.f & (UNOWNED | DISCONNECTED)) === 0) {
      dependency.f ^= DISCONNECTED;
    }
    remove_reactions(
      /** @type {Derived} **/
      dependency,
      0
    );
  }
}
function remove_reactions(signal, start_index) {
  var dependencies = signal.deps;
  if (dependencies === null) return;
  for (var i = start_index; i < dependencies.length; i++) {
    remove_reaction(signal, dependencies[i]);
  }
}
function update_effect(effect2) {
  var flags = effect2.f;
  if ((flags & DESTROYED) !== 0) {
    return;
  }
  set_signal_status(effect2, CLEAN);
  var previous_effect = active_effect;
  var previous_component_context = component_context;
  active_effect = effect2;
  try {
    if ((flags & BLOCK_EFFECT) !== 0) {
      destroy_block_effect_children(effect2);
    } else {
      destroy_effect_children(effect2);
    }
    destroy_effect_deriveds(effect2);
    execute_effect_teardown(effect2);
    var teardown = update_reaction(effect2);
    effect2.teardown = typeof teardown === "function" ? teardown : null;
    effect2.version = current_version;
    if (BROWSER) ;
  } catch (error) {
    handle_error(error, effect2, previous_effect, previous_component_context || effect2.ctx);
  } finally {
    active_effect = previous_effect;
  }
}
function infinite_loop_guard() {
  if (flush_count > 1e3) {
    flush_count = 0;
    try {
      effect_update_depth_exceeded();
    } catch (error) {
      if (last_scheduled_effect !== null) {
        {
          handle_error(error, last_scheduled_effect, null);
        }
      } else {
        throw error;
      }
    }
  }
  flush_count++;
}
function flush_queued_root_effects(root_effects) {
  var length = root_effects.length;
  if (length === 0) {
    return;
  }
  infinite_loop_guard();
  var previously_flushing_effect = is_flushing_effect;
  is_flushing_effect = true;
  try {
    for (var i = 0; i < length; i++) {
      var effect2 = root_effects[i];
      if ((effect2.f & CLEAN) === 0) {
        effect2.f ^= CLEAN;
      }
      var collected_effects = [];
      process_effects(effect2, collected_effects);
      flush_queued_effects(collected_effects);
    }
  } finally {
    is_flushing_effect = previously_flushing_effect;
  }
}
function flush_queued_effects(effects) {
  var length = effects.length;
  if (length === 0) return;
  for (var i = 0; i < length; i++) {
    var effect2 = effects[i];
    if ((effect2.f & (DESTROYED | INERT)) === 0) {
      try {
        if (check_dirtiness(effect2)) {
          update_effect(effect2);
          if (effect2.deps === null && effect2.first === null && effect2.nodes_start === null) {
            if (effect2.teardown === null) {
              unlink_effect(effect2);
            } else {
              effect2.fn = null;
            }
          }
        }
      } catch (error) {
        handle_error(error, effect2, null, effect2.ctx);
      }
    }
  }
}
function process_deferred() {
  is_micro_task_queued = false;
  if (flush_count > 1001) {
    return;
  }
  const previous_queued_root_effects = queued_root_effects;
  queued_root_effects = [];
  flush_queued_root_effects(previous_queued_root_effects);
  if (!is_micro_task_queued) {
    flush_count = 0;
    last_scheduled_effect = null;
  }
}
function schedule_effect(signal) {
  if (scheduler_mode === FLUSH_MICROTASK) {
    if (!is_micro_task_queued) {
      is_micro_task_queued = true;
      queueMicrotask(process_deferred);
    }
  }
  last_scheduled_effect = signal;
  var effect2 = signal;
  while (effect2.parent !== null) {
    effect2 = effect2.parent;
    var flags = effect2.f;
    if ((flags & (ROOT_EFFECT | BRANCH_EFFECT)) !== 0) {
      if ((flags & CLEAN) === 0) return;
      effect2.f ^= CLEAN;
    }
  }
  queued_root_effects.push(effect2);
}
function process_effects(effect2, collected_effects) {
  var current_effect = effect2.first;
  var effects = [];
  main_loop: while (current_effect !== null) {
    var flags = current_effect.f;
    var is_branch = (flags & BRANCH_EFFECT) !== 0;
    var is_skippable_branch = is_branch && (flags & CLEAN) !== 0;
    var sibling = current_effect.next;
    if (!is_skippable_branch && (flags & INERT) === 0) {
      if ((flags & RENDER_EFFECT) !== 0) {
        if (is_branch) {
          current_effect.f ^= CLEAN;
        } else {
          try {
            if (check_dirtiness(current_effect)) {
              update_effect(current_effect);
            }
          } catch (error) {
            handle_error(error, current_effect, null, current_effect.ctx);
          }
        }
        var child = current_effect.first;
        if (child !== null) {
          current_effect = child;
          continue;
        }
      } else if ((flags & EFFECT) !== 0) {
        effects.push(current_effect);
      }
    }
    if (sibling === null) {
      let parent = current_effect.parent;
      while (parent !== null) {
        if (effect2 === parent) {
          break main_loop;
        }
        var parent_sibling = parent.next;
        if (parent_sibling !== null) {
          current_effect = parent_sibling;
          continue main_loop;
        }
        parent = parent.parent;
      }
    }
    current_effect = sibling;
  }
  for (var i = 0; i < effects.length; i++) {
    child = effects[i];
    collected_effects.push(child);
    process_effects(child, collected_effects);
  }
}
function flush_sync(fn) {
  var previous_scheduler_mode = scheduler_mode;
  var previous_queued_root_effects = queued_root_effects;
  try {
    infinite_loop_guard();
    const root_effects = [];
    scheduler_mode = FLUSH_SYNC;
    queued_root_effects = root_effects;
    is_micro_task_queued = false;
    flush_queued_root_effects(previous_queued_root_effects);
    var result = fn?.();
    flush_tasks();
    if (queued_root_effects.length > 0 || root_effects.length > 0) {
      flush_sync();
    }
    flush_count = 0;
    last_scheduled_effect = null;
    if (BROWSER) ;
    return result;
  } finally {
    scheduler_mode = previous_scheduler_mode;
    queued_root_effects = previous_queued_root_effects;
  }
}
function get$1(signal) {
  var flags = signal.f;
  var is_derived = (flags & DERIVED) !== 0;
  if (is_derived && (flags & DESTROYED) !== 0) {
    var value = execute_derived(
      /** @type {Derived} */
      signal
    );
    destroy_derived(
      /** @type {Derived} */
      signal
    );
    return value;
  }
  if (active_reaction !== null) {
    if (derived_sources !== null && derived_sources.includes(signal)) {
      state_unsafe_local_read();
    }
    var deps = active_reaction.deps;
    if (new_deps === null && deps !== null && deps[skipped_deps] === signal) {
      skipped_deps++;
    } else if (new_deps === null) {
      new_deps = [signal];
    } else {
      new_deps.push(signal);
    }
    if (untracked_writes !== null && active_effect !== null && (active_effect.f & CLEAN) !== 0 && (active_effect.f & BRANCH_EFFECT) === 0 && untracked_writes.includes(signal)) {
      set_signal_status(active_effect, DIRTY);
      schedule_effect(active_effect);
    }
  } else if (is_derived && /** @type {Derived} */
  signal.deps === null) {
    var derived2 = (
      /** @type {Derived} */
      signal
    );
    var parent = derived2.parent;
    var target = derived2;
    while (parent !== null) {
      if ((parent.f & DERIVED) !== 0) {
        var parent_derived = (
          /** @type {Derived} */
          parent
        );
        target = parent_derived;
        parent = parent_derived.parent;
      } else {
        var parent_effect = (
          /** @type {Effect} */
          parent
        );
        if (!parent_effect.deriveds?.includes(target)) {
          (parent_effect.deriveds ??= []).push(target);
        }
        break;
      }
    }
  }
  if (is_derived) {
    derived2 = /** @type {Derived} */
    signal;
    if (check_dirtiness(derived2)) {
      update_derived(derived2);
    }
  }
  return signal.v;
}
function untrack(fn) {
  const previous_reaction = active_reaction;
  try {
    active_reaction = null;
    return fn();
  } finally {
    active_reaction = previous_reaction;
  }
}
const STATUS_MASK = ~(DIRTY | MAYBE_DIRTY | CLEAN);
function set_signal_status(signal, status) {
  signal.f = signal.f & STATUS_MASK | status;
}
function push$1(props, runes = false, fn) {
  component_context = {
    p: component_context,
    c: null,
    e: null,
    m: false,
    s: props,
    x: null,
    l: null
  };
}
function pop$1(component) {
  const context_stack_item = component_context;
  if (context_stack_item !== null) {
    const component_effects = context_stack_item.e;
    if (component_effects !== null) {
      var previous_effect = active_effect;
      var previous_reaction = active_reaction;
      context_stack_item.e = null;
      try {
        for (var i = 0; i < component_effects.length; i++) {
          var component_effect = component_effects[i];
          set_active_effect(component_effect.effect);
          set_active_reaction(component_effect.reaction);
          effect(component_effect.fn);
        }
      } finally {
        set_active_effect(previous_effect);
        set_active_reaction(previous_reaction);
      }
    }
    component_context = context_stack_item.p;
    context_stack_item.m = true;
  }
  return (
    /** @type {T} */
    {}
  );
}
const PASSIVE_EVENTS = ["touchstart", "touchmove"];
function is_passive_event(name) {
  return PASSIVE_EVENTS.includes(name);
}
const all_registered_events = /* @__PURE__ */ new Set();
const root_event_handles = /* @__PURE__ */ new Set();
function handle_event_propagation(event) {
  var handler_element = this;
  var owner_document = (
    /** @type {Node} */
    handler_element.ownerDocument
  );
  var event_name = event.type;
  var path = event.composedPath?.() || [];
  var current_target = (
    /** @type {null | Element} */
    path[0] || event.target
  );
  var path_idx = 0;
  var handled_at = event.__root;
  if (handled_at) {
    var at_idx = path.indexOf(handled_at);
    if (at_idx !== -1 && (handler_element === document || handler_element === /** @type {any} */
    window)) {
      event.__root = handler_element;
      return;
    }
    var handler_idx = path.indexOf(handler_element);
    if (handler_idx === -1) {
      return;
    }
    if (at_idx <= handler_idx) {
      path_idx = at_idx;
    }
  }
  current_target = /** @type {Element} */
  path[path_idx] || event.target;
  if (current_target === handler_element) return;
  define_property(event, "currentTarget", {
    configurable: true,
    get() {
      return current_target || owner_document;
    }
  });
  var previous_reaction = active_reaction;
  var previous_effect = active_effect;
  set_active_reaction(null);
  set_active_effect(null);
  try {
    var throw_error;
    var other_errors = [];
    while (current_target !== null) {
      var parent_element = current_target.assignedSlot || current_target.parentNode || /** @type {any} */
      current_target.host || null;
      try {
        var delegated = current_target["__" + event_name];
        if (delegated !== void 0 && !/** @type {any} */
        current_target.disabled) {
          if (is_array(delegated)) {
            var [fn, ...data] = delegated;
            fn.apply(current_target, [event, ...data]);
          } else {
            delegated.call(current_target, event);
          }
        }
      } catch (error) {
        if (throw_error) {
          other_errors.push(error);
        } else {
          throw_error = error;
        }
      }
      if (event.cancelBubble || parent_element === handler_element || parent_element === null) {
        break;
      }
      current_target = parent_element;
    }
    if (throw_error) {
      for (let error of other_errors) {
        queueMicrotask(() => {
          throw error;
        });
      }
      throw throw_error;
    }
  } finally {
    event.__root = handler_element;
    delete event.currentTarget;
    set_active_reaction(previous_reaction);
    set_active_effect(previous_effect);
  }
}
function assign_nodes(start, end) {
  var effect2 = (
    /** @type {Effect} */
    active_effect
  );
  if (effect2.nodes_start === null) {
    effect2.nodes_start = start;
    effect2.nodes_end = end;
  }
}
function mount(component, options2) {
  return _mount(component, options2);
}
function hydrate(component, options2) {
  init_operations();
  options2.intro = options2.intro ?? false;
  const target = options2.target;
  const was_hydrating = hydrating;
  const previous_hydrate_node = hydrate_node;
  try {
    var anchor = (
      /** @type {TemplateNode} */
      /* @__PURE__ */ get_first_child(target)
    );
    while (anchor && (anchor.nodeType !== 8 || /** @type {Comment} */
    anchor.data !== HYDRATION_START)) {
      anchor = /** @type {TemplateNode} */
      /* @__PURE__ */ get_next_sibling(anchor);
    }
    if (!anchor) {
      throw HYDRATION_ERROR;
    }
    set_hydrating(true);
    set_hydrate_node(
      /** @type {Comment} */
      anchor
    );
    hydrate_next();
    const instance = _mount(component, { ...options2, anchor });
    if (hydrate_node === null || hydrate_node.nodeType !== 8 || /** @type {Comment} */
    hydrate_node.data !== HYDRATION_END) {
      hydration_mismatch();
      throw HYDRATION_ERROR;
    }
    set_hydrating(false);
    return (
      /**  @type {Exports} */
      instance
    );
  } catch (error) {
    if (error === HYDRATION_ERROR) {
      if (options2.recover === false) {
        hydration_failed();
      }
      init_operations();
      clear_text_content(target);
      set_hydrating(false);
      return mount(component, options2);
    }
    throw error;
  } finally {
    set_hydrating(was_hydrating);
    set_hydrate_node(previous_hydrate_node);
  }
}
const document_listeners = /* @__PURE__ */ new Map();
function _mount(Component, { target, anchor, props = {}, events, context: context2, intro = true }) {
  init_operations();
  var registered_events = /* @__PURE__ */ new Set();
  var event_handle = (events2) => {
    for (var i = 0; i < events2.length; i++) {
      var event_name = events2[i];
      if (registered_events.has(event_name)) continue;
      registered_events.add(event_name);
      var passive = is_passive_event(event_name);
      target.addEventListener(event_name, handle_event_propagation, { passive });
      var n = document_listeners.get(event_name);
      if (n === void 0) {
        document.addEventListener(event_name, handle_event_propagation, { passive });
        document_listeners.set(event_name, 1);
      } else {
        document_listeners.set(event_name, n + 1);
      }
    }
  };
  event_handle(array_from(all_registered_events));
  root_event_handles.add(event_handle);
  var component = void 0;
  var unmount2 = component_root(() => {
    var anchor_node = anchor ?? target.appendChild(create_text());
    branch(() => {
      if (context2) {
        push$1({});
        var ctx = (
          /** @type {ComponentContext} */
          component_context
        );
        ctx.c = context2;
      }
      if (events) {
        props.$$events = events;
      }
      if (hydrating) {
        assign_nodes(
          /** @type {TemplateNode} */
          anchor_node,
          null
        );
      }
      component = Component(anchor_node, props) || {};
      if (hydrating) {
        active_effect.nodes_end = hydrate_node;
      }
      if (context2) {
        pop$1();
      }
    });
    return () => {
      for (var event_name of registered_events) {
        target.removeEventListener(event_name, handle_event_propagation);
        var n = (
          /** @type {number} */
          document_listeners.get(event_name)
        );
        if (--n === 0) {
          document.removeEventListener(event_name, handle_event_propagation);
          document_listeners.delete(event_name);
        } else {
          document_listeners.set(event_name, n);
        }
      }
      root_event_handles.delete(event_handle);
      if (anchor_node !== anchor) {
        anchor_node.parentNode?.removeChild(anchor_node);
      }
    };
  });
  mounted_components.set(component, unmount2);
  return component;
}
let mounted_components = /* @__PURE__ */ new WeakMap();
function unmount(component, options2) {
  const fn = mounted_components.get(component);
  if (fn) {
    mounted_components.delete(component);
    return fn(options2);
  }
  return Promise.resolve();
}
function asClassComponent$1(component) {
  return class extends Svelte4Component {
    /** @param {any} options */
    constructor(options2) {
      super({
        component,
        ...options2
      });
    }
  };
}
class Svelte4Component {
  /** @type {any} */
  #events;
  /** @type {Record<string, any>} */
  #instance;
  /**
   * @param {ComponentConstructorOptions & {
   *  component: any;
   * }} options
   */
  constructor(options2) {
    var sources = /* @__PURE__ */ new Map();
    var add_source = (key2, value) => {
      var s2 = /* @__PURE__ */ mutable_source(value);
      sources.set(key2, s2);
      return s2;
    };
    const props = new Proxy(
      { ...options2.props || {}, $$events: {} },
      {
        get(target, prop) {
          return get$1(sources.get(prop) ?? add_source(prop, Reflect.get(target, prop)));
        },
        has(target, prop) {
          if (prop === LEGACY_PROPS) return true;
          get$1(sources.get(prop) ?? add_source(prop, Reflect.get(target, prop)));
          return Reflect.has(target, prop);
        },
        set(target, prop, value) {
          set(sources.get(prop) ?? add_source(prop, value), value);
          return Reflect.set(target, prop, value);
        }
      }
    );
    this.#instance = (options2.hydrate ? hydrate : mount)(options2.component, {
      target: options2.target,
      anchor: options2.anchor,
      props,
      context: options2.context,
      intro: options2.intro ?? false,
      recover: options2.recover
    });
    if (!options2?.props?.$$host || options2.sync === false) {
      flush_sync();
    }
    this.#events = props.$$events;
    for (const key2 of Object.keys(this.#instance)) {
      if (key2 === "$set" || key2 === "$destroy" || key2 === "$on") continue;
      define_property(this, key2, {
        get() {
          return this.#instance[key2];
        },
        /** @param {any} value */
        set(value) {
          this.#instance[key2] = value;
        },
        enumerable: true
      });
    }
    this.#instance.$set = /** @param {Record<string, any>} next */
    (next) => {
      Object.assign(props, next);
    };
    this.#instance.$destroy = () => {
      unmount(this.#instance);
    };
  }
  /** @param {Record<string, any>} props */
  $set(props) {
    this.#instance.$set(props);
  }
  /**
   * @param {string} event
   * @param {(...args: any[]) => any} callback
   * @returns {any}
   */
  $on(event, callback) {
    this.#events[event] = this.#events[event] || [];
    const cb = (...args) => callback.call(this, ...args);
    this.#events[event].push(cb);
    return () => {
      this.#events[event] = this.#events[event].filter(
        /** @param {any} fn */
        (fn) => fn !== cb
      );
    };
  }
  $destroy() {
    this.#instance.$destroy();
  }
}
const ATTR_REGEX = /[&"<]/g;
const CONTENT_REGEX = /[&<]/g;
function escape_html(value, is_attr) {
  const str = String(value ?? "");
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
const replacements$1 = {
  translate: /* @__PURE__ */ new Map([
    [true, "yes"],
    [false, "no"]
  ])
};
function attr(name, value, is_boolean = false) {
  if (value == null || !value && is_boolean || value === "" && name === "class") return "";
  const normalized = name in replacements$1 && replacements$1[name].get(value) || value;
  const assignment = is_boolean ? "" : `="${escape_html(normalized, true)}"`;
  return ` ${name}${assignment}`;
}
function subscribe_to_store(store, run, invalidate) {
  if (store == null) {
    run(void 0);
    if (invalidate) invalidate(void 0);
    return noop;
  }
  const unsub = untrack(
    () => store.subscribe(
      run,
      // @ts-expect-error
      invalidate
    )
  );
  return unsub.unsubscribe ? () => unsub.unsubscribe() : unsub;
}
const subscriber_queue = [];
function readable(value, start) {
  return {
    subscribe: writable(value, start).subscribe
  };
}
function writable(value, start = noop) {
  let stop = null;
  const subscribers = /* @__PURE__ */ new Set();
  function set2(new_value) {
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
    set2(fn(
      /** @type {T} */
      value
    ));
  }
  function subscribe(run, invalidate = noop) {
    const subscriber = [run, invalidate];
    subscribers.add(subscriber);
    if (subscribers.size === 1) {
      stop = start(set2, update) || noop;
    }
    run(
      /** @type {T} */
      value
    );
    return () => {
      subscribers.delete(subscriber);
      if (subscribers.size === 0 && stop) {
        stop();
        stop = null;
      }
    };
  }
  return { set: set2, update, subscribe };
}
function derived(stores2, fn, initial_value) {
  const single = !Array.isArray(stores2);
  const stores_array = single ? [stores2] : stores2;
  if (!stores_array.every(Boolean)) {
    throw new Error("derived() expects stores as input, got a falsy value");
  }
  const auto = fn.length < 2;
  return readable(initial_value, (set2, update) => {
    let started = false;
    const values = [];
    let pending = 0;
    let cleanup = noop;
    const sync = () => {
      if (pending) {
        return;
      }
      cleanup();
      const result = fn(single ? values[0] : values, set2, update);
      if (auto) {
        set2(result);
      } else {
        cleanup = typeof result === "function" ? result : noop;
      }
    };
    const unsubscribers = stores_array.map(
      (store, i) => subscribe_to_store(
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
      while (i) hash2 = hash2 * 33 ^ value.charCodeAt(--i);
    } else if (ArrayBuffer.isView(value)) {
      const buffer = new Uint8Array(value.buffer, value.byteOffset, value.byteLength);
      let i = buffer.length;
      while (i) hash2 = hash2 * 33 ^ buffer[--i];
    } else {
      throw new TypeError("value must be a string or TypedArray");
    }
  }
  return (hash2 >>> 0).toString(36);
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
    if (key2 === "cache-control") cache_control = value;
    else if (key2 === "age") age = value;
    else if (key2 === "vary" && value.trim() === "*") varyAny = true;
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
    `data-url="${escape_html$1(fetched.url, true)}"`
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
  if (!key[0]) precompute();
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
  #script_src_needs_csp;
  /** @type {boolean} */
  #script_src_elem_needs_csp;
  /** @type {boolean} */
  #style_needs_csp;
  /** @type {boolean} */
  #style_src_needs_csp;
  /** @type {boolean} */
  #style_src_attr_needs_csp;
  /** @type {boolean} */
  #style_src_elem_needs_csp;
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
    const needs_csp = (directive) => !!directive && !directive.some((value) => value === "unsafe-inline");
    this.#script_src_needs_csp = needs_csp(effective_script_src);
    this.#script_src_elem_needs_csp = needs_csp(script_src_elem);
    this.#style_src_needs_csp = needs_csp(effective_style_src);
    this.#style_src_attr_needs_csp = needs_csp(style_src_attr);
    this.#style_src_elem_needs_csp = needs_csp(style_src_elem);
    this.#script_needs_csp = this.#script_src_needs_csp || this.#script_src_elem_needs_csp;
    this.#style_needs_csp = this.#style_src_needs_csp || this.#style_src_attr_needs_csp || this.#style_src_elem_needs_csp;
    this.script_needs_nonce = this.#script_needs_csp && !this.#use_hashes;
    this.style_needs_nonce = this.#style_needs_csp && !this.#use_hashes;
    this.#nonce = nonce;
  }
  /** @param {string} content */
  add_script(content) {
    if (!this.#script_needs_csp) return;
    const source2 = this.#use_hashes ? `sha256-${sha256(content)}` : `nonce-${this.#nonce}`;
    if (this.#script_src_needs_csp) {
      this.#script_src.push(source2);
    }
    if (this.#script_src_elem_needs_csp) {
      this.#script_src_elem.push(source2);
    }
  }
  /** @param {string} content */
  add_style(content) {
    if (!this.#style_needs_csp) return;
    const source2 = this.#use_hashes ? `sha256-${sha256(content)}` : `nonce-${this.#nonce}`;
    if (this.#style_src_needs_csp) {
      this.#style_src.push(source2);
    }
    if (this.#style_src_needs_csp) {
      this.#style_src.push(source2);
    }
    if (this.#style_src_attr_needs_csp) {
      this.#style_src_attr.push(source2);
    }
    if (this.#style_src_elem_needs_csp) {
      const sha256_empty_comment_hash = "sha256-9OlNO0DNEeaVzHL4RZwCLsBHA8WBQ8toBp/4F5XV2nc=";
      const d = this.#directives;
      if (d["style-src-elem"] && !d["style-src-elem"].includes(sha256_empty_comment_hash) && !this.#style_src_elem.includes(sha256_empty_comment_hash)) {
        this.#style_src_elem.push(sha256_empty_comment_hash);
      }
      if (source2 !== sha256_empty_comment_hash) {
        this.#style_src_elem.push(source2);
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
      if (!value) continue;
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
    return `<meta http-equiv="content-security-policy" content="${escape_html$1(content, true)}">`;
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
            if (!next.done) deferred.shift();
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
const updated$1 = {
  ...readable(false),
  check: () => false
};
const encoder$1 = new TextEncoder();
async function render_response({
  branch: branch2,
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
  {
    if (!state.prerendering?.fallback) {
      const segments = event.url.pathname.slice(base.length).split("/").slice(2);
      base$1 = segments.map(() => "..").join("/") || ".";
      base_expression = `new URL(${s(base$1)}, location).pathname.slice(0, -1)`;
      if (!assets || assets[0] === "/" && assets !== SVELTE_KIT_ASSETS) {
        assets$1 = base$1;
      }
    } else if (options2.hash_routing) {
      base_expression = "new URL('.', location).pathname.slice(0, -1)";
    }
  }
  if (page_config.ssr) {
    const props = {
      stores: {
        page: writable(null),
        navigating: writable(null),
        updated: updated$1
      },
      constructors: await Promise.all(branch2.map(({ node }) => node.component())),
      form: form_value
    };
    let data2 = {};
    for (let i = 0; i < branch2.length; i += 1) {
      data2 = { ...data2, ...branch2[i].data };
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
    const render_opts = {
      context: /* @__PURE__ */ new Map([
        [
          "__request__",
          {
            page: props.page
          }
        ]
      ])
    };
    {
      try {
        rendered = options2.root.render(props, render_opts);
      } finally {
        reset();
      }
    }
    for (const { node } of branch2) {
      for (const url of node.imports) modulepreloads.add(url);
      for (const url of node.stylesheets) stylesheets.add(url);
      for (const url of node.fonts) fonts.add(url);
      if (node.inline_styles && !client.inline) {
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
  if (client.inline?.style) {
    head += `
	<style>${client.inline.style}</style>`;
  }
  if (inline_styles.size > 0) {
    const content = Array.from(inline_styles.values()).join("\n");
    const attributes = [];
    if (csp.style_needs_nonce) attributes.push(` nonce="${csp.nonce}"`);
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
    branch2.map((b) => b.server_data),
    csp,
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
    if (!client.inline) {
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
							const try_to_resolve = () => {
								if (!deferred.has(id)) {
									setTimeout(try_to_resolve, 0);
									return;
								}
								const { fulfil, reject } = deferred.get(id);
								deferred.delete(id);
								if (error) reject(error);
								else fulfil(data);
							}
							try_to_resolve();
						}`);
    }
    blocks.push(`${global} = {
						${properties.join(",\n						")}
					};`);
    const args = ["element"];
    blocks.push("const element = document.currentScript.parentElement;");
    if (page_config.ssr) {
      const serialized = { form: "null", error: "null" };
      if (form_value) {
        serialized.form = uneval_action_response(
          form_value,
          /** @type {string} */
          event.route.id,
          options2.hooks.transport
        );
      }
      if (error) {
        serialized.error = devalue.uneval(error);
      }
      const hydrate2 = [
        `node_ids: [${branch2.map(({ node }) => node.index).join(", ")}]`,
        `data: ${data}`,
        `form: ${serialized.form}`,
        `error: ${serialized.error}`
      ];
      if (status !== 200) {
        hydrate2.push(`status: ${status}`);
      }
      if (options2.embedded) {
        hydrate2.push(`params: ${devalue.uneval(event.params)}`, `route: ${s(event.route)}`);
      }
      const indent = "	".repeat(load_env_eagerly ? 7 : 6);
      args.push(`{
${indent}	${hydrate2.join(`,
${indent}	`)}
${indent}}`);
    }
    const boot = client.inline ? `${client.inline.script}

					__sveltekit_${options2.version_hash}.app.start(${args.join(", ")});` : client.app ? `Promise.all([
						import(${s(prefixed(client.start))}),
						import(${s(prefixed(client.app))})
					]).then(([kit, app]) => {
						kit.start(app, ${args.join(", ")});
					});` : `import(${s(prefixed(client.start))}).then((app) => {
						app.start(${args.join(", ")})
					});`;
    if (load_env_eagerly) {
      blocks.push(`import(${s(`${base$1}/${options2.app_dir}/env.js`)}).then(({ env }) => {
						${global}.env = env;

						${boot.replace(/\n/g, "\n	")}
					});`);
    } else {
      blocks.push(boot);
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
      headers: headers2
    }
  );
}
function get_data(event, options2, nodes, csp, global) {
  let promise_id = 1;
  let count = 0;
  const { iterator, push: push2, done } = create_async_iterator();
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
          } catch {
            error = await handle_error_and_jsonify(
              event,
              options2,
              new Error(`Failed to serialize promise while rendering ${event.route.id}`)
            );
            data = void 0;
            str = devalue.uneval({ id, data, error }, replacer2);
          }
          const nonce = csp.script_needs_nonce ? ` nonce="${csp.nonce}"` : "";
          push2(`<script${nonce}>${global}.resolve(${str})<\/script>
`);
          if (count === 0) done();
        }
      );
      return `${global}.defer(${id})`;
    } else {
      for (const key2 in options2.hooks.transport) {
        const encoded = options2.hooks.transport[key2].encode(thing);
        if (encoded) {
          return `app.decode('${key2}', ${devalue.uneval(encoded, replacer2)})`;
        }
      }
    }
  }
  try {
    const strings = nodes.map((node) => {
      if (!node) return "null";
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
    const branch2 = [];
    const default_layout = await manifest._.nodes[0]();
    const ssr = get_option([default_layout], "ssr") ?? true;
    const csr = get_option([default_layout], "csr") ?? true;
    if (ssr) {
      state.error = true;
      const server_data_promise = load_server_data({
        event,
        state,
        node: default_layout,
        // eslint-disable-next-line @typescript-eslint/require-await
        parent: async () => ({})
      });
      const server_data = await server_data_promise;
      const data = await load_data({
        event,
        fetched,
        node: default_layout,
        // eslint-disable-next-line @typescript-eslint/require-await
        parent: async () => ({}),
        resolve_opts,
        server_data_promise,
        state,
        csr
      });
      branch2.push(
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
      branch: branch2,
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
    if (done) return result;
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
  const { iterator, push: push2, done } = create_async_iterator();
  const reducers = {
    ...Object.fromEntries(
      Object.entries(options2.hooks.transport).map(([key2, value]) => [key2, value.encode])
    ),
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
            } catch {
              const error = await handle_error_and_jsonify(
                event,
                options2,
                new Error(`Failed to serialize promise while rendering ${event.route.id}`)
              );
              key2 = "error";
              str = devalue.stringify(error, reducers);
            }
            count -= 1;
            push2(`{"type":"chunk","id":${id},"${key2}":${str}}
`);
            if (count === 0) done();
          }
        );
        return id;
      }
    }
  };
  try {
    const strings = nodes.map((node) => {
      if (!node) return "null";
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
      if (BROWSER && action_result && !event.request.headers.has("x-sveltekit-action")) ;
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
    const branch2 = [];
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
                if (parent) Object.assign(data, parent.data);
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
      if (load_error) throw load_error;
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
    for (const p of server_promises) p.catch(() => {
    });
    for (const p of load_promises) p.catch(() => {
    });
    for (let i = 0; i < nodes.length; i += 1) {
      const node = nodes[i];
      if (node) {
        try {
          const server_data = await server_promises[i];
          const data = await load_promises[i];
          branch2.push({ node, server_data, data });
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
              while (!branch2[j]) j -= 1;
              return await render_response({
                event,
                options: options2,
                manifest,
                state,
                resolve_opts,
                page_config: { ssr: true, csr: true },
                status: status2,
                error,
                branch: compact(branch2.slice(0, j + 1)).concat({
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
        branch2.push(null);
      }
    }
    if (state.prerendering && should_prerender_data) {
      let { data, chunks } = get_data_json(
        event,
        options2,
        branch2.map((node) => node?.server_data)
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
      branch: ssr === false ? [] : compact(branch2),
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
      if (param.rest) result[param.name] = "";
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
  if (buffered) return;
  return result;
}
const INVALID_COOKIE_CHARACTER_REGEX = /[\x00-\x1F\x7F()<>@,;:"/[\]?={} \t]/;
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
      const req_cookies = parse(header, { decode: opts?.decode });
      const cookie = req_cookies[name];
      return cookie;
    },
    /**
     * @param {import('cookie').CookieParseOptions} opts
     */
    getAll(opts) {
      const cookies2 = parse(header, { decode: opts?.decode });
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
      const illegal_characters = name.match(INVALID_COOKIE_CHARACTER_REGEX);
      if (illegal_characters) {
        console.warn(
          `The cookie name "${name}" will be invalid in SvelteKit 3.0 as it contains ${illegal_characters.join(
            " and "
          )}. See RFC 2616 for more details https://datatracker.ietf.org/doc/html/rfc2616#section-2.2`
        );
      }
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
      if (!domain_matches(destination.hostname, cookie.options.domain)) continue;
      if (!path_matches(destination.pathname, cookie.options.path)) continue;
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
  if (!constraint) return true;
  const normalized = constraint[0] === "." ? constraint.slice(1) : constraint;
  if (hostname === normalized) return true;
  return hostname.endsWith("." + normalized);
}
function path_matches(path, constraint) {
  if (!constraint) return true;
  const normalized = constraint.endsWith("/") ? constraint.slice(0, -1) : constraint;
  if (path === normalized) return true;
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
let read_implementation = null;
function set_read_implementation(fn) {
  read_implementation = fn;
}
function set_manifest(_) {
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
            if (cookie) request.headers.set("cookie", cookie);
          }
          return fetch(request);
        }
        const prefix = assets || base;
        const decoded = decodeURIComponent(url.pathname);
        const filename = (decoded.startsWith(prefix) ? decoded.slice(prefix.length) : decoded).slice(1);
        const filename_html = `${filename}/index.html`;
        const is_asset = manifest.assets.has(filename) || filename in manifest._.server_assets;
        const is_asset_html = manifest.assets.has(filename_html) || filename_html in manifest._.server_assets;
        if (is_asset || is_asset_html) {
          const file = is_asset ? filename : filename_html;
          if (state.read) {
            const type = is_asset ? manifest.mimeTypes[filename.slice(filename.lastIndexOf("."))] : "text/html";
            return new Response(state.read(file), {
              headers: type ? { "content-type": type } : {}
            });
          } else if (read_implementation && file in manifest._.server_assets) {
            const length = manifest._.server_assets[file];
            const type = manifest.mimeTypes[file.slice(file.lastIndexOf("."))];
            return new Response(read_implementation(file), {
              headers: {
                "Content-Length": "" + length,
                "Content-Type": type
              }
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
            const { name, value, ...options3 } = set_cookie_parser.parseString(str, {
              decodeValues: false
            });
            const path = options3.path ?? (url.pathname.split("/").slice(0, -1).join("/") || "/");
            set_internal(name, value, {
              path,
              encode: (value2) => value2,
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
    if (!module) return;
    for (const key2 in module) {
      if (key2[0] === "_" || expected.has(key2)) continue;
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
    if (!node?.universal?.config && !node?.server?.config) continue;
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
  if (options2.hash_routing && url.pathname !== base + "/" && url.pathname !== "/[fallback]") {
    return text("Not found", { status: 404 });
  }
  let rerouted_path;
  try {
    rerouted_path = options2.hooks.reroute({ url: new URL(url) }) ?? url.pathname;
  } catch {
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
    const headers22 = new Headers();
    headers22.set("cache-control", "public, max-age=0, must-revalidate");
    return text("Not found", { status: 404, headers: headers22 });
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
      if (!match) continue;
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
        if (BROWSER) ;
        trailing_slash = get_option(nodes, "trailingSlash");
      } else if (route.endpoint) {
        const node = await route.endpoint();
        trailing_slash = node.trailingSlash;
        if (BROWSER) ;
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
    } else if (state.emulator?.platform) {
      event.platform = await state.emulator.platform({
        config: {},
        prerender: !!state.prerendering?.fallback
      });
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
    if (state.prerendering && !state.prerendering.fallback) disable_search(url);
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
          if (value) headers22.set(key2, value);
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
      if (options2.hash_routing || state.prerendering?.fallback) {
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
var current_component = null;
function getContext(key2) {
  const context_map = get_or_init_context_map();
  const result = (
    /** @type {T} */
    context_map.get(key2)
  );
  return result;
}
function setContext(key2, context2) {
  get_or_init_context_map().set(key2, context2);
  return context2;
}
function get_or_init_context_map(name) {
  if (current_component === null) {
    lifecycle_outside_component();
  }
  return current_component.c ??= new Map(get_parent_context(current_component) || void 0);
}
function push(fn) {
  current_component = { p: current_component, c: null, d: null };
}
function pop() {
  var component = (
    /** @type {Component} */
    current_component
  );
  var ondestroy = component.d;
  if (ondestroy) {
    on_destroy.push(...ondestroy);
  }
  current_component = component.p;
}
function get_parent_context(component_context2) {
  let parent = component_context2.p;
  while (parent !== null) {
    const context_map = parent.c;
    if (context_map !== null) {
      return context_map;
    }
    parent = parent.p;
  }
  return null;
}
const BLOCK_OPEN = `<!--${HYDRATION_START}-->`;
const BLOCK_CLOSE = `<!--${HYDRATION_END}-->`;
let on_destroy = [];
function render(component, options2 = {}) {
  const payload = { out: "", css: /* @__PURE__ */ new Set(), head: { title: "", out: "" } };
  const prev_on_destroy = on_destroy;
  on_destroy = [];
  payload.out += BLOCK_OPEN;
  if (options2.context) {
    push();
    current_component.c = options2.context;
  }
  component(payload, options2.props ?? {}, {}, {});
  if (options2.context) {
    pop();
  }
  payload.out += BLOCK_CLOSE;
  for (const cleanup of on_destroy) cleanup();
  on_destroy = prev_on_destroy;
  let head = payload.head.out + payload.head.title;
  for (const { hash: hash2, code } of payload.css) {
    head += `<style id="${hash2}">${code}</style>`;
  }
  return {
    head,
    html: payload.out,
    body: payload.out
  };
}
function stringify(value) {
  return typeof value === "string" ? value : value == null ? "" : value + "";
}
function store_get(store_values, store_name, store) {
  if (store_name in store_values && store_values[store_name][0] === store) {
    return store_values[store_name][2];
  }
  store_values[store_name]?.[1]();
  store_values[store_name] = [store, null, void 0];
  const unsub = subscribe_to_store(
    store,
    /** @param {any} v */
    (v) => store_values[store_name][2] = v
  );
  store_values[store_name][1] = unsub;
  return store_values[store_name][2];
}
function unsubscribe_stores(store_values) {
  for (const store_name in store_values) {
    store_values[store_name][1]();
  }
}
function slot(payload, $$props, name, slot_props, fallback_fn) {
  var slot_fn = $$props.$$slots?.[name];
  if (slot_fn === true) {
    slot_fn = $$props["children"];
  }
  if (slot_fn !== void 0) {
    slot_fn(payload, slot_props);
  }
}
function bind_props(props_parent, props_now) {
  for (const key2 in props_now) {
    const initial_value = props_parent[key2];
    const value = props_now[key2];
    if (initial_value === void 0 && value !== void 0 && Object.getOwnPropertyDescriptor(props_parent, key2)?.set) {
      props_parent[key2] = value;
    }
  }
}
function await_block(promise, pending_fn, then_fn) {
  if (is_promise(promise)) {
    promise.then(null, noop);
    if (pending_fn !== null) {
      pending_fn();
    }
  } else if (then_fn !== null) {
    then_fn(promise);
  }
}
function ensure_array_like(array_like_or_iterator) {
  if (array_like_or_iterator) {
    return array_like_or_iterator.length !== void 0 ? array_like_or_iterator : Array.from(array_like_or_iterator);
  }
  return [];
}
function asClassComponent(component) {
  const component_constructor = asClassComponent$1(component);
  const _render = (props, { context: context2 } = {}) => {
    const result = render(component, { props, context: context2 });
    return {
      css: { code: "", map: null },
      head: result.head,
      html: result.body
    };
  };
  component_constructor.render = _render;
  return component_constructor;
}
function onDestroy(fn) {
  var context2 = (
    /** @type {Component} */
    current_component
  );
  (context2.d ??= []).push(fn);
}
let prerendering = false;
function set_building() {
}
function set_prerendering() {
  prerendering = true;
}
function Root($$payload, $$props) {
  push();
  let {
    stores: stores2,
    page: page2,
    constructors,
    components = [],
    form,
    data_0 = null,
    data_1 = null
  } = $$props;
  {
    setContext("__svelte__", stores2);
  }
  {
    stores2.page.set(page2);
  }
  const Pyramid_1 = constructors[1];
  if (constructors[1]) {
    $$payload.out += "<!--[-->";
    const Pyramid_0 = constructors[0];
    $$payload.out += `<!---->`;
    Pyramid_0($$payload, {
      data: data_0,
      form,
      children: ($$payload2) => {
        $$payload2.out += `<!---->`;
        Pyramid_1($$payload2, { data: data_1, form });
        $$payload2.out += `<!---->`;
      },
      $$slots: { default: true }
    });
    $$payload.out += `<!---->`;
  } else {
    $$payload.out += "<!--[!-->";
    const Pyramid_0 = constructors[0];
    $$payload.out += `<!---->`;
    Pyramid_0($$payload, { data: data_0, form });
    $$payload.out += `<!---->`;
  }
  $$payload.out += `<!--]--> `;
  {
    $$payload.out += "<!--[!-->";
  }
  $$payload.out += `<!--]-->`;
  pop();
}
const root = asClassComponent(Root);
const options = {
  app_dir: "_app",
  app_template_contains_nonce: false,
  csp: { "mode": "auto", "directives": { "upgrade-insecure-requests": false, "block-all-mixed-content": false }, "reportOnly": { "upgrade-insecure-requests": false, "block-all-mixed-content": false } },
  csrf_check_origin: true,
  embedded: false,
  env_public_prefix: "PUBLIC_",
  env_private_prefix: "",
  hash_routing: false,
  hooks: null,
  // added lazily, via `get_hooks`
  preload_strategy: "modulepreload",
  root,
  service_worker: false,
  templates: {
    app: ({ head, body: body2, assets: assets2, nonce, env }) => '<!doctype html>\n<html lang="en">\n  <head>\n    <meta charset="utf-8" />\n    <meta content="width=device-width, initial-scale=1" name="viewport" />\n\n    <title>OpenFPL</title>\n    <link href="https://openfpl.xyz" rel="canonical" />\n    <meta\n      content="OpenFPL is a decentralised fantasy football game on the Internet Computer blockchain."\n      name="description"\n    />\n    <meta content="OpenFPL" property="og:title" />\n    <meta\n      content="OpenFPL is a decentralised fantasy football game on the Internet Computer blockchain."\n      property="og:description"\n    />\n    <meta content="website" property="og:type" />\n    <meta content="https://openfpl.xyz" property="og:url" />\n    <meta content="https://openfpl.xyz/meta-share.jpg" property="og:image" />\n    <meta content="summary_large_image" name="twitter:card" />\n    <meta content="OpenFPL" name="twitter:title" />\n    <meta\n      content="OpenFPL is a decentralised fantasy football platform on the Internet Computer blockchain."\n      name="twitter:description"\n    />\n    <meta content="https://openfpl.xyz/meta-share.jpg" name="twitter:image" />\n    <meta content="@beadle1989" name="twitter:creator" />\n\n    <link crossorigin="anonymous" href="/manifest.webmanifest" rel="manifest" />\n\n    <link rel="preload" href="/adopt_filled.png" as="image" />\n    <link rel="preload" href="/adopt.png" as="image" />\n    <link rel="preload" href="/background.jpg" as="image" />\n    <link rel="preload" href="/board.png" as="image" />\n    <link rel="preload" href="/brace-bonus.png" as="image" />\n    <link rel="preload" href="/ckBTCCoin.png" as="image" />\n    <link rel="preload" href="/ckETHCoin.png" as="image" />\n    <link rel="preload" href="/one-nation.png" as="image" />\n    <link rel="preload" href="/discord.png" as="image" />\n    <link rel="preload" href="/FPLCoin.png" as="image" />\n    <link rel="preload" href="/github.png" as="image" />\n    <link rel="preload" href="/hat-trick-hero.png" as="image" />\n    <link rel="preload" href="/ICPCoin.png" as="image" />\n    <link rel="preload" href="/no-entry.png" as="image" />\n    <link rel="preload" href="/openchat.png" as="image" />\n    <link rel="preload" href="/pass-master.png" as="image" />\n    <link rel="preload" href="/pitch.png" as="image" />\n    <link rel="preload" href="/profile_placeholder.png" as="image" />\n    <link rel="preload" href="/prospects.png" as="image" />\n    <link rel="preload" href="/reject.png" as="image" />\n    <link rel="preload" href="/reject_filled.png" as="image" />\n    <link rel="preload" href="/safe-hands.png" as="image" />\n    <link rel="preload" href="/team-boost.png" as="image" />\n    <link rel="preload" href="/twitter.png" as="image" />\n\n    <!-- Favicon -->\n    <link\n      rel="icon"\n      type="image/png"\n      sizes="32x32"\n      href="' + assets2 + '/favicons/favicon-32x32.png"\n    />\n    <link\n      rel="icon"\n      type="image/png"\n      sizes="16x16"\n      href="' + assets2 + '/favicons/favicon-16x16.png"\n    />\n    <link rel="shortcut icon" href="' + assets2 + '/favicons/favicon.ico" />\n\n    <!-- iOS meta tags & icons -->\n    <meta name="apple-mobile-web-app-capable" content="yes" />\n    <meta name="apple-mobile-web-app-status-bar-style" content="#2CE3A6" />\n    <meta name="apple-mobile-web-app-title" content="OpenFPL" />\n    <link\n      rel="apple-touch-icon"\n      href="' + assets2 + '/favicons/apple-touch-icon.png"\n    />\n    <link\n      rel="mask-icon"\n      href="' + assets2 + '/favicons/safari-pinned-tab.svg"\n      color="#2CE3A6"\n    />\n\n    <!-- MS -->\n    <meta name="msapplication-TileColor" content="#2CE3A6" />\n    <meta\n      name="msapplication-config"\n      content="' + assets2 + '/favicons/browserconfig.xml"\n    />\n\n    <meta content="#2CE3A6" name="theme-color" />\n    ' + head + '\n\n    <style>\n      html,\n      body {\n        height: 100%;\n        margin: 0;\n      }\n\n      @font-face {\n        font-display: swap;\n        font-family: "Poppins";\n        font-style: normal;\n        font-weight: 400;\n        src: url("' + assets2 + '/poppins-regular-webfont.woff2")\n          format("woff2");\n      }\n\n      @font-face {\n        font-display: swap;\n        font-family: "Manrope";\n        font-style: normal;\n        font-weight: 400;\n        src: url("' + assets2 + '/Manrope-Regular.woff2") format("woff2");\n      }\n      body {\n        font-family: "Poppins", sans-serif !important;\n        color: white !important;\n        background-color: #1a1a1d;\n        height: 100vh;\n        margin: 0;\n        background-image: url("' + assets2 + '/background.jpg");\n        background-size: cover;\n        background-position: center;\n        background-repeat: no-repeat;\n        background-attachment: fixed;\n      }\n\n      #app-spinner {\n        --spinner-size: 30px;\n\n        width: var(--spinner-size);\n        height: var(--spinner-size);\n\n        animation: app-spinner-linear-rotate 2000ms linear infinite;\n\n        position: absolute;\n        top: calc(50% - (var(--spinner-size) / 2));\n        left: calc(50% - (var(--spinner-size) / 2));\n\n        --radius: 45px;\n        --circumference: calc(3.14159265359 * var(--radius) * 2);\n\n        --start: calc((1 - 0.05) * var(--circumference));\n        --end: calc((1 - 0.8) * var(--circumference));\n      }\n\n      #app-spinner circle {\n        stroke-dasharray: var(--circumference);\n        stroke-width: 10%;\n        transform-origin: 50% 50% 0;\n\n        transition-property: stroke;\n\n        animation-name: app-spinner-stroke-rotate-100;\n        animation-duration: 4000ms;\n        animation-timing-function: cubic-bezier(0.35, 0, 0.25, 1);\n        animation-iteration-count: infinite;\n\n        fill: transparent;\n        stroke: currentColor;\n\n        transition: stroke-dashoffset 225ms linear;\n      }\n\n      @keyframes app-spinner-linear-rotate {\n        0% {\n          transform: rotate(0deg);\n        }\n        100% {\n          transform: rotate(360deg);\n        }\n      }\n\n      @keyframes app-spinner-stroke-rotate-100 {\n        0% {\n          stroke-dashoffset: var(--start);\n          transform: rotate(0);\n        }\n        12.5% {\n          stroke-dashoffset: var(--end);\n          transform: rotate(0);\n        }\n        12.5001% {\n          stroke-dashoffset: var(--end);\n          transform: rotateX(180deg) rotate(72.5deg);\n        }\n        25% {\n          stroke-dashoffset: var(--start);\n          transform: rotateX(180deg) rotate(72.5deg);\n        }\n\n        25.0001% {\n          stroke-dashoffset: var(--start);\n          transform: rotate(270deg);\n        }\n        37.5% {\n          stroke-dashoffset: var(--end);\n          transform: rotate(270deg);\n        }\n        37.5001% {\n          stroke-dashoffset: var(--end);\n          transform: rotateX(180deg) rotate(161.5deg);\n        }\n        50% {\n          stroke-dashoffset: var(--start);\n          transform: rotateX(180deg) rotate(161.5deg);\n        }\n\n        50.0001% {\n          stroke-dashoffset: var(--start);\n          transform: rotate(180deg);\n        }\n        62.5% {\n          stroke-dashoffset: var(--end);\n          transform: rotate(180deg);\n        }\n        62.5001% {\n          stroke-dashoffset: var(--end);\n          transform: rotateX(180deg) rotate(251.5deg);\n        }\n        75% {\n          stroke-dashoffset: var(--start);\n          transform: rotateX(180deg) rotate(251.5deg);\n        }\n\n        75.0001% {\n          stroke-dashoffset: var(--start);\n          transform: rotate(90deg);\n        }\n        87.5% {\n          stroke-dashoffset: var(--end);\n          transform: rotate(90deg);\n        }\n        87.5001% {\n          stroke-dashoffset: var(--end);\n          transform: rotateX(180deg) rotate(341.5deg);\n        }\n        100% {\n          stroke-dashoffset: var(--start);\n          transform: rotateX(180deg) rotate(341.5deg);\n        }\n      }\n    </style>\n  </head>\n  <body data-sveltekit-preload-data="hover">\n    <div style="display: contents">' + body2 + '</div>\n\n    <svg\n      id="app-spinner"\n      preserveAspectRatio="xMidYMid meet"\n      focusable="false"\n      aria-hidden="true"\n      data-tid="spinner"\n      viewBox="0 0 100 100"\n    >\n      <circle cx="50%" cy="50%" r="45" />\n    </svg>\n  </body>\n</html>\n',
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
  version_hash: "1xz9o6"
};
async function get_hooks() {
  let handle;
  let handleFetch;
  let handleError;
  let init2;
  let reroute;
  let transport;
  return {
    handle,
    handleFetch,
    handleError,
    init: init2,
    reroute,
    transport
  };
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
let init_promise;
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
    if (read) {
      set_read_implementation(read);
    }
    await (init_promise ??= (async () => {
      try {
        const module = await get_hooks();
        this.#options.hooks = {
          handle: module.handle || (({ event, resolve: resolve2 }) => resolve2(event)),
          handleError: module.handleError || (({ error }) => console.error(error)),
          handleFetch: module.handleFetch || (({ request, fetch: fetch2 }) => fetch2(request)),
          reroute: module.reroute || (() => {
          }),
          transport: module.transport || {}
        };
        if (module.init) {
          await module.init();
        }
      } catch (error) {
        {
          throw error;
        }
      }
    })());
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
function Layout$1($$payload, $$props) {
  push();
  let { children } = $$props;
  children($$payload);
  $$payload.out += `<!---->`;
  pop();
}
const SNAPSHOT_KEY = "sveltekit:snapshot";
const SCROLL_KEY = "sveltekit:scroll";
function notifiable_store(value) {
  const store = writable(value);
  let ready = true;
  function notify() {
    ready = true;
    store.update((val) => val);
  }
  function set2(new_value) {
    ready = false;
    store.set(new_value);
  }
  function subscribe(run) {
    let old_value;
    return store.subscribe((new_value) => {
      if (old_value === void 0 || ready && new_value !== old_value) {
        run(old_value = new_value);
      }
    });
  }
  return { notify, set: set2, subscribe };
}
function create_updated_store() {
  const { set: set2, subscribe } = writable(false);
  {
    return {
      subscribe,
      // eslint-disable-next-line @typescript-eslint/require-await
      check: async () => false
    };
  }
}
let updated;
const is_legacy = noop.toString().includes("$$") || /function \w+\(\) \{\}/.test(noop.toString());
if (is_legacy) {
  ({
    data: {},
    form: null,
    error: null,
    params: {},
    route: { id: null },
    state: {},
    status: -1,
    url: new URL("https://example.com")
  });
  updated = { current: false };
} else {
  updated = new class Updated {
    current = false;
  }();
}
function get(key2, parse2 = JSON.parse) {
  try {
    return parse2(sessionStorage[key2]);
  } catch {
  }
}
get(SCROLL_KEY) ?? {};
get(SNAPSHOT_KEY) ?? {};
const stores = {
  url: /* @__PURE__ */ notifiable_store({}),
  page: /* @__PURE__ */ notifiable_store({}),
  navigating: /* @__PURE__ */ writable(
    /** @type {import('@sveltejs/kit').Navigation | null} */
    null
  ),
  updated: /* @__PURE__ */ create_updated_store()
};
({
  get current() {
    return updated.current;
  },
  check: stores.updated.check
});
function context() {
  return getContext("__request__");
}
const page$1 = {
  get data() {
    return context().page.data;
  },
  get error() {
    return context().page.error;
  },
  get form() {
    return context().page.form;
  },
  get params() {
    return context().page.params;
  },
  get route() {
    return context().page.route;
  },
  get state() {
    return context().page.state;
  },
  get status() {
    return context().page.status;
  },
  get url() {
    return context().page.url;
  }
};
const page = page$1;
function Error$1($$payload, $$props) {
  push();
  $$payload.out += `<h1>${escape_html(page.status)}</h1> <p>${escape_html(page.error?.message)}</p>`;
  pop();
}
function createCountryStore() {
  const { subscribe, set: set2 } = writable([]);
  return {
    subscribe,
    setCountries: (countries) => set2(countries)
  };
}
const countryStore = createCountryStore();
function createSeasonStore() {
  const { subscribe, set: set2 } = writable([]);
  async function getSeasonName(seasonId) {
    let seasons = [];
    await subscribe((value) => {
      seasons = value;
    })();
    if (seasons.length == 0) {
      return;
    }
    let season = seasons.find((x) => x.id == seasonId);
    if (season == null) {
      return;
    }
    return season.name;
  }
  return {
    subscribe,
    setSeasons: (seasons) => set2(seasons),
    getSeasonName
  };
}
const seasonStore = createSeasonStore();
function createClubStore() {
  const { subscribe, set: set2 } = writable([]);
  return {
    subscribe,
    setClubs: (clubs) => set2(clubs.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName)))
  };
}
const clubStore = createClubStore();
const idlFactory = ({ IDL }) => {
  const List = IDL.Rec();
  const GameweekNumber = IDL.Nat8;
  const Error2 = IDL.Variant({
    "MoreThan2PlayersFromClub": IDL.Null,
    "DecodeError": IDL.Null,
    "NotAllowed": IDL.Null,
    "DuplicatePlayerInTeam": IDL.Null,
    "InvalidBonuses": IDL.Null,
    "TooManyTransfers": IDL.Null,
    "NotFound": IDL.Null,
    "NumberPerPositionError": IDL.Null,
    "TeamOverspend": IDL.Null,
    "NotAuthorized": IDL.Null,
    "SelectedCaptainNotInTeam": IDL.Null,
    "InvalidData": IDL.Null,
    "SystemOnHold": IDL.Null,
    "AlreadyExists": IDL.Null,
    "CanisterCreateError": IDL.Null,
    "Not11Players": IDL.Null
  });
  const Result = IDL.Variant({ "ok": IDL.Null, "err": Error2 });
  const Result_26 = IDL.Variant({ "ok": IDL.Text, "err": Error2 });
  const AppStatusDTO__1 = IDL.Record({
    "version": IDL.Text,
    "onHold": IDL.Bool
  });
  const Result_25 = IDL.Variant({ "ok": AppStatusDTO__1, "err": Error2 });
  const CanisterType = IDL.Variant({
    "SNS": IDL.Null,
    "Leaderboard": IDL.Null,
    "Dapp": IDL.Null,
    "Archive": IDL.Null,
    "Manager": IDL.Null
  });
  const GetCanistersDTO = IDL.Record({ "canisterType": CanisterType });
  const CanisterId = IDL.Text;
  const CanisterTopup = IDL.Record({
    "topupTime": IDL.Int,
    "canisterId": CanisterId,
    "cyclesAmount": IDL.Nat
  });
  const CanisterDTO = IDL.Record({
    "cycles": IDL.Nat,
    "topups": IDL.Vec(CanisterTopup),
    "computeAllocation": IDL.Nat,
    "canisterId": CanisterId
  });
  const Result_24 = IDL.Variant({ "ok": IDL.Vec(CanisterDTO), "err": Error2 });
  const ClubId = IDL.Nat16;
  const ShirtType = IDL.Variant({ "Filled": IDL.Null, "Striped": IDL.Null });
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
  const Result_23 = IDL.Variant({ "ok": IDL.Vec(ClubDTO), "err": Error2 });
  const CountryId = IDL.Nat16;
  const CountryDTO = IDL.Record({
    "id": CountryId,
    "code": IDL.Text,
    "name": IDL.Text
  });
  const Result_22 = IDL.Variant({ "ok": IDL.Vec(CountryDTO), "err": Error2 });
  const PickTeamDTO = IDL.Record({
    "playerIds": IDL.Vec(ClubId),
    "username": IDL.Text,
    "goalGetterPlayerId": ClubId,
    "oneNationCountryId": CountryId,
    "hatTrickHeroGameweek": GameweekNumber,
    "transfersAvailable": IDL.Nat8,
    "oneNationGameweek": GameweekNumber,
    "teamBoostGameweek": GameweekNumber,
    "captainFantasticGameweek": GameweekNumber,
    "bankQuarterMillions": IDL.Nat16,
    "noEntryPlayerId": ClubId,
    "safeHandsPlayerId": ClubId,
    "braceBonusGameweek": GameweekNumber,
    "passMasterGameweek": GameweekNumber,
    "teamBoostClubId": ClubId,
    "goalGetterGameweek": GameweekNumber,
    "firstGameweek": IDL.Bool,
    "captainFantasticPlayerId": ClubId,
    "transferWindowGameweek": GameweekNumber,
    "noEntryGameweek": GameweekNumber,
    "prospectsGameweek": GameweekNumber,
    "safeHandsGameweek": GameweekNumber,
    "principalId": IDL.Text,
    "passMasterPlayerId": ClubId,
    "captainId": ClubId,
    "canisterId": CanisterId,
    "monthlyBonusesAvailable": IDL.Nat8
  });
  const Result_21 = IDL.Variant({ "ok": PickTeamDTO, "err": Error2 });
  const DataHashDTO = IDL.Record({ "hash": IDL.Text, "category": IDL.Text });
  const Result_20 = IDL.Variant({ "ok": IDL.Vec(DataHashDTO), "err": Error2 });
  const SeasonId = IDL.Nat16;
  const PrincipalId = IDL.Text;
  const GetFantasyTeamSnapshotDTO = IDL.Record({
    "seasonId": SeasonId,
    "managerPrincipalId": PrincipalId,
    "gameweek": GameweekNumber
  });
  const CalendarMonth = IDL.Nat8;
  const FantasyTeamSnapshotDTO = IDL.Record({
    "playerIds": IDL.Vec(ClubId),
    "month": CalendarMonth,
    "teamValueQuarterMillions": IDL.Nat16,
    "username": IDL.Text,
    "goalGetterPlayerId": ClubId,
    "oneNationCountryId": CountryId,
    "hatTrickHeroGameweek": GameweekNumber,
    "transfersAvailable": IDL.Nat8,
    "oneNationGameweek": GameweekNumber,
    "teamBoostGameweek": GameweekNumber,
    "captainFantasticGameweek": GameweekNumber,
    "bankQuarterMillions": IDL.Nat16,
    "noEntryPlayerId": ClubId,
    "monthlyPoints": IDL.Int16,
    "safeHandsPlayerId": ClubId,
    "seasonId": SeasonId,
    "braceBonusGameweek": GameweekNumber,
    "favouriteClubId": ClubId,
    "passMasterGameweek": GameweekNumber,
    "teamBoostClubId": ClubId,
    "goalGetterGameweek": GameweekNumber,
    "captainFantasticPlayerId": ClubId,
    "gameweek": GameweekNumber,
    "seasonPoints": IDL.Int16,
    "transferWindowGameweek": GameweekNumber,
    "noEntryGameweek": GameweekNumber,
    "prospectsGameweek": GameweekNumber,
    "safeHandsGameweek": GameweekNumber,
    "principalId": IDL.Text,
    "passMasterPlayerId": ClubId,
    "captainId": ClubId,
    "points": IDL.Int16,
    "monthlyBonusesAvailable": IDL.Nat8
  });
  const Result_19 = IDL.Variant({
    "ok": FantasyTeamSnapshotDTO,
    "err": Error2
  });
  const FixtureStatusType = IDL.Variant({
    "Unplayed": IDL.Null,
    "Finalised": IDL.Null,
    "Active": IDL.Null,
    "Complete": IDL.Null
  });
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
  const Result_12 = IDL.Variant({ "ok": IDL.Vec(FixtureDTO), "err": Error2 });
  const Result_17 = IDL.Variant({ "ok": IDL.Vec(CanisterId), "err": Error2 });
  const LeagueId = IDL.Nat16;
  const LeagueStatus = IDL.Record({
    "transferWindowEndMonth": IDL.Nat8,
    "transferWindowEndDay": IDL.Nat8,
    "transferWindowStartMonth": IDL.Nat8,
    "transferWindowActive": IDL.Bool,
    "totalGameweeks": IDL.Nat8,
    "completedGameweek": GameweekNumber,
    "transferWindowStartDay": IDL.Nat8,
    "unplayedGameweek": GameweekNumber,
    "activeMonth": CalendarMonth,
    "activeSeasonId": SeasonId,
    "activeGameweek": GameweekNumber,
    "leagueId": LeagueId,
    "seasonActive": IDL.Bool
  });
  const Result_18 = IDL.Variant({ "ok": LeagueStatus, "err": Error2 });
  const ClubFilterDTO = IDL.Record({
    "clubId": ClubId,
    "leagueId": LeagueId
  });
  const PlayerStatus = IDL.Variant({
    "OnLoan": IDL.Null,
    "Active": IDL.Null,
    "FreeAgent": IDL.Null,
    "Retired": IDL.Null
  });
  const PlayerPosition = IDL.Variant({
    "Goalkeeper": IDL.Null,
    "Midfielder": IDL.Null,
    "Forward": IDL.Null,
    "Defender": IDL.Null
  });
  const PlayerDTO = IDL.Record({
    "id": IDL.Nat16,
    "status": PlayerStatus,
    "clubId": ClubId,
    "valueQuarterMillions": IDL.Nat16,
    "dateOfBirth": IDL.Int,
    "nationality": CountryId,
    "shirtNumber": IDL.Nat8,
    "position": PlayerPosition,
    "lastName": IDL.Text,
    "firstName": IDL.Text
  });
  const Result_5 = IDL.Variant({ "ok": IDL.Vec(PlayerDTO), "err": Error2 });
  const RequestManagerDTO = IDL.Record({
    "month": CalendarMonth,
    "clubId": ClubId,
    "seasonId": SeasonId,
    "managerId": IDL.Text,
    "gameweek": GameweekNumber
  });
  const PlayerId = IDL.Nat16;
  const FantasyTeamSnapshot = IDL.Record({
    "playerIds": IDL.Vec(PlayerId),
    "month": CalendarMonth,
    "teamValueQuarterMillions": IDL.Nat16,
    "username": IDL.Text,
    "goalGetterPlayerId": PlayerId,
    "oneNationCountryId": CountryId,
    "hatTrickHeroGameweek": GameweekNumber,
    "transfersAvailable": IDL.Nat8,
    "oneNationGameweek": GameweekNumber,
    "teamBoostGameweek": GameweekNumber,
    "captainFantasticGameweek": GameweekNumber,
    "bankQuarterMillions": IDL.Nat16,
    "noEntryPlayerId": PlayerId,
    "monthlyPoints": IDL.Int16,
    "safeHandsPlayerId": PlayerId,
    "seasonId": SeasonId,
    "braceBonusGameweek": GameweekNumber,
    "favouriteClubId": IDL.Opt(ClubId),
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
    "favouriteClubId": IDL.Opt(ClubId),
    "monthlyPosition": IDL.Int,
    "seasonPosition": IDL.Int,
    "monthlyPositionText": IDL.Text,
    "profilePicture": IDL.Opt(IDL.Vec(IDL.Nat8)),
    "seasonPoints": IDL.Int16,
    "profilePictureType": IDL.Text,
    "principalId": IDL.Text,
    "seasonPositionText": IDL.Text
  });
  const Result_1 = IDL.Variant({ "ok": ManagerDTO, "err": Error2 });
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
    "clubId": ClubId,
    "totalEntries": IDL.Nat,
    "seasonId": SeasonId,
    "entries": IDL.Vec(LeaderboardEntry)
  });
  const Result_16 = IDL.Variant({
    "ok": MonthlyLeaderboardDTO,
    "err": Error2
  });
  const GetPlayerDetailsDTO = IDL.Record({
    "playerId": ClubId,
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
    "changedOn": IDL.Int,
    "newValue": IDL.Nat16
  });
  const PlayerDetailDTO = IDL.Record({
    "id": ClubId,
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
  const Result_15 = IDL.Variant({ "ok": PlayerDetailDTO, "err": Error2 });
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
  const Result_14 = IDL.Variant({
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
  const Result_13 = IDL.Variant({
    "ok": IDL.Vec(IDL.Tuple(IDL.Nat16, PlayerScoreDTO)),
    "err": Error2
  });
  const GetSnapshotPlayers = IDL.Record({
    "seasonId": SeasonId,
    "gameweek": GameweekNumber,
    "leagueId": LeagueId
  });
  const ProfileDTO = IDL.Record({
    "username": IDL.Text,
    "termsAccepted": IDL.Bool,
    "createDate": IDL.Int,
    "favouriteClubId": IDL.Opt(ClubId),
    "profilePicture": IDL.Opt(IDL.Vec(IDL.Nat8)),
    "profilePictureType": IDL.Text,
    "principalId": IDL.Text
  });
  const Result_11 = IDL.Variant({ "ok": ProfileDTO, "err": Error2 });
  const GetRewardPoolDTO = IDL.Record({ "seasonId": SeasonId });
  const RewardPool = IDL.Record({
    "monthlyLeaderboardPool": IDL.Nat64,
    "allTimeSeasonHighScorePool": IDL.Nat64,
    "mostValuableTeamPool": IDL.Nat64,
    "highestScoringMatchPlayerPool": IDL.Nat64,
    "seasonId": SeasonId,
    "seasonLeaderboardPool": IDL.Nat64,
    "allTimeWeeklyHighScorePool": IDL.Nat64,
    "allTimeMonthlyHighScorePool": IDL.Nat64,
    "weeklyLeaderboardPool": IDL.Nat64
  });
  const RewardPoolDTO = IDL.Record({
    "seasonId": SeasonId,
    "rewardPool": RewardPool
  });
  const Result_10 = IDL.Variant({ "ok": RewardPoolDTO, "err": Error2 });
  const GetSeasonLeaderboardDTO = IDL.Record({
    "offset": IDL.Nat,
    "seasonId": SeasonId,
    "limit": IDL.Nat,
    "searchTerm": IDL.Text
  });
  const SeasonLeaderboardDTO = IDL.Record({
    "totalEntries": IDL.Nat,
    "seasonId": SeasonId,
    "entries": IDL.Vec(LeaderboardEntry)
  });
  const Result_9 = IDL.Variant({ "ok": SeasonLeaderboardDTO, "err": Error2 });
  const SeasonDTO = IDL.Record({
    "id": SeasonId,
    "name": IDL.Text,
    "year": IDL.Nat16
  });
  const Result_8 = IDL.Variant({ "ok": IDL.Vec(SeasonDTO), "err": Error2 });
  const AppStatusDTO = IDL.Record({
    "version": IDL.Text,
    "onHold": IDL.Bool
  });
  const Result_7 = IDL.Variant({ "ok": AppStatusDTO, "err": Error2 });
  const Result_6 = IDL.Variant({ "ok": IDL.Nat, "err": Error2 });
  const Result_4 = IDL.Variant({
    "ok": IDL.Vec(
      IDL.Tuple(SeasonId, IDL.Vec(IDL.Tuple(GameweekNumber, CanisterId)))
    ),
    "err": Error2
  });
  const GetWeeklyLeaderboardDTO = IDL.Record({
    "offset": IDL.Nat,
    "seasonId": SeasonId,
    "limit": IDL.Nat,
    "searchTerm": IDL.Text,
    "gameweek": GameweekNumber
  });
  const WeeklyLeaderboardDTO = IDL.Record({
    "totalEntries": IDL.Nat,
    "seasonId": SeasonId,
    "entries": IDL.Vec(LeaderboardEntry),
    "gameweek": GameweekNumber
  });
  const Result_3 = IDL.Variant({ "ok": WeeklyLeaderboardDTO, "err": Error2 });
  List.fill(IDL.Opt(IDL.Tuple(LeaderboardEntry, List)));
  const WeeklyLeaderboard = IDL.Record({
    "totalEntries": IDL.Nat,
    "seasonId": SeasonId,
    "entries": List,
    "gameweek": GameweekNumber
  });
  const RewardType = IDL.Variant({
    "MonthlyLeaderboard": IDL.Null,
    "MostValuableTeam": IDL.Null,
    "MonthlyATHScore": IDL.Null,
    "WeeklyATHScore": IDL.Null,
    "SeasonATHScore": IDL.Null,
    "SeasonLeaderboard": IDL.Null,
    "WeeklyLeaderboard": IDL.Null,
    "HighestScoringPlayer": IDL.Null
  });
  const RewardEntry = IDL.Record({
    "rewardType": RewardType,
    "position": IDL.Nat,
    "amount": IDL.Nat64,
    "principalId": IDL.Text
  });
  const WeeklyRewardsDTO = IDL.Record({
    "seasonId": SeasonId,
    "rewards": IDL.Vec(RewardEntry),
    "gameweek": GameweekNumber
  });
  const Result_2 = IDL.Variant({ "ok": WeeklyRewardsDTO, "err": Error2 });
  const UsernameFilterDTO = IDL.Record({ "username": IDL.Text });
  const UpdateTeamSelectionDTO = IDL.Record({
    "playerIds": IDL.Vec(ClubId),
    "username": IDL.Text,
    "goalGetterPlayerId": ClubId,
    "oneNationCountryId": CountryId,
    "hatTrickHeroGameweek": GameweekNumber,
    "oneNationGameweek": GameweekNumber,
    "teamBoostGameweek": GameweekNumber,
    "captainFantasticGameweek": GameweekNumber,
    "noEntryPlayerId": ClubId,
    "safeHandsPlayerId": ClubId,
    "braceBonusGameweek": GameweekNumber,
    "passMasterGameweek": GameweekNumber,
    "teamBoostClubId": ClubId,
    "goalGetterGameweek": GameweekNumber,
    "captainFantasticPlayerId": ClubId,
    "transferWindowGameweek": GameweekNumber,
    "noEntryGameweek": GameweekNumber,
    "prospectsGameweek": GameweekNumber,
    "safeHandsGameweek": GameweekNumber,
    "passMasterPlayerId": ClubId,
    "captainId": ClubId
  });
  const UpdateFavouriteClubDTO = IDL.Record({ "favouriteClubId": ClubId });
  const UpdateProfilePictureDTO = IDL.Record({
    "profilePicture": IDL.Vec(IDL.Nat8),
    "extension": IDL.Text
  });
  const UpdateAppStatusDTO = IDL.Record({
    "version": IDL.Text,
    "onHold": IDL.Bool
  });
  const UpdateUsernameDTO = IDL.Record({ "username": IDL.Text });
  return IDL.Service({
    "calculateWeeklyRewards": IDL.Func([GameweekNumber], [Result], []),
    "getActiveLeaderboardCanisterId": IDL.Func([], [Result_26], []),
    "getAppStatus": IDL.Func([], [Result_25], ["query"]),
    "getCanisters": IDL.Func([GetCanistersDTO], [Result_24], []),
    "getClubs": IDL.Func([], [Result_23], ["composite_query"]),
    "getCountries": IDL.Func([], [Result_22], ["query"]),
    "getCurrentTeam": IDL.Func([], [Result_21], []),
    "getDataHashes": IDL.Func([], [Result_20], ["composite_query"]),
    "getFantasyTeamSnapshot": IDL.Func(
      [GetFantasyTeamSnapshotDTO],
      [Result_19],
      []
    ),
    "getFixtures": IDL.Func([], [Result_12], ["composite_query"]),
    "getLeaderboardCanisterIds": IDL.Func([], [Result_17], []),
    "getLeagueStatus": IDL.Func([], [Result_18], []),
    "getLoanedPlayers": IDL.Func(
      [ClubFilterDTO],
      [Result_5],
      ["composite_query"]
    ),
    "getManager": IDL.Func([RequestManagerDTO], [Result_1], []),
    "getManagerCanisterIds": IDL.Func([], [Result_17], []),
    "getManagerSnapshotData": IDL.Func([], [IDL.Vec(FantasyTeamSnapshot)], []),
    "getMonthlyLeaderboard": IDL.Func(
      [GetMonthlyLeaderboardDTO],
      [Result_16],
      []
    ),
    "getPlayerDetails": IDL.Func([GetPlayerDetailsDTO], [Result_15], []),
    "getPlayerDetailsForGameweek": IDL.Func(
      [GameweekFiltersDTO],
      [Result_14],
      ["composite_query"]
    ),
    "getPlayers": IDL.Func([], [Result_5], ["composite_query"]),
    "getPlayersMap": IDL.Func([GameweekFiltersDTO], [Result_13], []),
    "getPlayersSnapshot": IDL.Func(
      [GetSnapshotPlayers],
      [IDL.Vec(PlayerDTO)],
      ["query"]
    ),
    "getPostponedFixtures": IDL.Func(
      [LeagueId],
      [Result_12],
      ["composite_query"]
    ),
    "getProfile": IDL.Func([], [Result_11], []),
    "getRetiredPlayers": IDL.Func(
      [ClubFilterDTO],
      [Result_5],
      ["composite_query"]
    ),
    "getRewardPool": IDL.Func([GetRewardPoolDTO], [Result_10], []),
    "getSeasonLeaderboard": IDL.Func(
      [GetSeasonLeaderboardDTO],
      [Result_9],
      []
    ),
    "getSeasons": IDL.Func([], [Result_8], ["composite_query"]),
    "getSystemState": IDL.Func([], [Result_7], ["query"]),
    "getTopups": IDL.Func([], [IDL.Vec(CanisterTopup)], ["query"]),
    "getTotalManagers": IDL.Func([], [Result_6], ["query"]),
    "getVerifiedPlayers": IDL.Func([], [Result_5], []),
    "getWeeklyCanisters": IDL.Func([], [Result_4], ["query"]),
    "getWeeklyLeaderboard": IDL.Func(
      [GetWeeklyLeaderboardDTO],
      [Result_3],
      []
    ),
    "getWeeklyLeaderboards": IDL.Func([], [IDL.Vec(WeeklyLeaderboard)], []),
    "getWeeklyRewards": IDL.Func(
      [SeasonId, GameweekNumber],
      [Result_2],
      ["query"]
    ),
    "isUsernameValid": IDL.Func([UsernameFilterDTO], [IDL.Bool], ["query"]),
    "notifyAppsOfFixtureFinalised": IDL.Func(
      [SeasonId, GameweekNumber],
      [Result],
      []
    ),
    "notifyAppsOfGameweekStarting": IDL.Func(
      [SeasonId, GameweekNumber],
      [Result],
      []
    ),
    "notifyAppsOfLoan": IDL.Func([LeagueId, PlayerId], [Result], []),
    "notifyAppsOfPositionChange": IDL.Func([LeagueId, PlayerId], [Result], []),
    "notifyAppsOfTransfer": IDL.Func([LeagueId, PlayerId], [Result], []),
    "payWeeklyRewards": IDL.Func([GameweekNumber], [Result], []),
    "saveFantasyTeam": IDL.Func([UpdateTeamSelectionDTO], [Result], []),
    "searchUsername": IDL.Func([UsernameFilterDTO], [Result_1], []),
    "updateDataHashes": IDL.Func([IDL.Text], [Result], []),
    "updateFavouriteClub": IDL.Func([UpdateFavouriteClubDTO], [Result], []),
    "updateProfilePicture": IDL.Func([UpdateProfilePictureDTO], [Result], []),
    "updateSystemState": IDL.Func([UpdateAppStatusDTO], [Result], []),
    "updateUsername": IDL.Func([UpdateUsernameDTO], [Result], [])
  });
};
var define_process_env_default$i = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
const canisterId = define_process_env_default$i.CANISTER_ID_OPENFPL_BACKEND;
const createActor = (canisterId2, options2 = {}) => {
  const agent = options2.agent || new HttpAgent({ ...options2.agentOptions });
  if (options2.agent && options2.agentOptions) {
    console.warn(
      "Detected both agent and agentOptions passed to createActor. Ignoring agentOptions and proceeding with the provided agent."
    );
  }
  return Actor.createActor(idlFactory, {
    agent,
    canisterId: canisterId2,
    ...options2.actorOptions
  });
};
canisterId ? createActor(canisterId) : void 0;
var define_process_env_default$h = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
class ActorFactory {
  static createActor(idlFactory2, canisterId2 = "", identity = null, options2 = null) {
    const hostOptions = {
      host: `https://${canisterId2}.icp-api.io`,
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
    return Actor.createActor(idlFactory2, {
      agent,
      canisterId: canisterId2,
      ...options2?.actorOptions
    });
  }
  static getAgent(canisterId2 = "", identity = null, options2 = null) {
    const hostOptions = {
      host: `https://${canisterId2}.icp-api.io`,
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
  static getGovernanceAgent(identity = null, options2 = null) {
    let canisterId2 = define_process_env_default$h.CANISTER_ID_SNS_GOVERNANCE;
    const hostOptions = {
      host: `https://${canisterId2}.icp-api.io`,
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
}
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
function convertPositionToIndex(playerPosition) {
  if ("Goalkeeper" in playerPosition) return 0;
  if ("Defender" in playerPosition) return 1;
  if ("Midfielder" in playerPosition) return 2;
  if ("Forward" in playerPosition) return 3;
  return 0;
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
function convertEvent(playerEvent) {
  if ("Appearance" in playerEvent) return 0;
  if ("Goal" in playerEvent) return 1;
  if ("GoalAssisted" in playerEvent) return 2;
  if ("GoalConceded" in playerEvent) return 3;
  if ("KeeperSave" in playerEvent) return 4;
  if ("CleanSheet" in playerEvent) return 5;
  if ("PenaltySaved" in playerEvent) return 6;
  if ("PenaltyMissed" in playerEvent) return 7;
  if ("YellowCard" in playerEvent) return 8;
  if ("RedCard" in playerEvent) return 9;
  if ("OwnGoal" in playerEvent) return 10;
  if ("HighestScoringPlayer" in playerEvent) return 11;
  return 0;
}
function isError(response) {
  return response && response.err !== void 0;
}
function formatCycles(cycles) {
  const trillionsOfCycles = Number(cycles) / 1e12;
  return trillionsOfCycles.toLocaleString(void 0, {
    minimumFractionDigits: 4,
    maximumFractionDigits: 4
  }) + "T";
}
function extractPlayerData(playerPointsDTO, player) {
  let goals = 0, assists = 0, redCards = 0, yellowCards = 0, missedPenalties = 0, ownGoals = 0, saves = 0, cleanSheets = 0, penaltySaves = 0, goalsConceded = 0, appearance = 0, highestScoringPlayerId = 0;
  let goalPoints = 0, assistPoints = 0, goalsConcededPoints = 0, cleanSheetPoints = 0;
  playerPointsDTO.events.forEach((event) => {
    switch (convertEvent(event.eventType)) {
      case 0:
        appearance += 1;
        break;
      case 1:
        goals += 1;
        switch (convertPositionToIndex(playerPointsDTO.position)) {
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
        switch (convertPositionToIndex(playerPointsDTO.position)) {
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
        if (convertPositionToIndex(playerPointsDTO.position) < 2 && goalsConceded % 2 === 0) {
          goalsConcededPoints += -15;
        }
        break;
      case 4:
        saves += 1;
        break;
      case 5:
        cleanSheets += 1;
        if (convertPositionToIndex(playerPointsDTO.position) < 2 && goalsConceded === 0) {
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
  switch (convertPositionToIndex(gameweekData.player.position)) {
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
function createToastsStore() {
  const { subscribe, update } = writable([]);
  let idCounter = 0;
  function addToast2(toast) {
    update((toasts2) => [...toasts2, { ...toast, id: ++idCounter }]);
  }
  function removeToast(id) {
    update((toasts2) => toasts2.filter((toast) => toast.id !== id));
  }
  return {
    subscribe,
    addToast: addToast2,
    removeToast
  };
}
const toasts = createToastsStore();
var define_process_env_default$g = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
class PlayerService {
  actor;
  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      define_process_env_default$g.OPENFPL_BACKEND_CANISTER_ID
    );
  }
  async getPlayers() {
    try {
      const result = await this.actor.getPlayers();
      if (isError(result)) throw new Error("Failed to fetch league players");
      return result.ok;
    } catch (error) {
      console.error("Error fetching league players: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching league players."
      });
    }
  }
  async getLoanedPlayers(clubId) {
    try {
      const dto = { leagueId: 1, clubId };
      const result = await this.actor.getLoanedPlayers(dto);
      if (isError(result)) throw new Error("Failed to fetch loaned players");
      return result.ok;
    } catch (error) {
      console.error("Error fetching loaned players: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching loaned players."
      });
    }
  }
  async getRetiredPlayers(clubId) {
    try {
      const dto = { leagueId: 1, clubId };
      const result = await this.actor.getRetiredPlayers(dto);
      if (isError(result)) throw new Error("Failed to fetch retired players");
      return result.ok;
    } catch (error) {
      console.error("Error fetching retired players: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching retired players."
      });
    }
  }
}
function createPlayerStore() {
  const { subscribe, set: set2 } = writable([]);
  async function getLoanedPlayers(clubId) {
    return new PlayerService().getLoanedPlayers(clubId);
  }
  async function getRetiredPlayers(clubId) {
    return new PlayerService().getRetiredPlayers(clubId);
  }
  return {
    subscribe,
    setPlayers: (players) => set2(players),
    getLoanedPlayers,
    getRetiredPlayers
  };
}
const playerStore = createPlayerStore();
var define_process_env_default$f = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
class PlayerEventsService {
  actor;
  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      define_process_env_default$f.OPENFPL_BACKEND_CANISTER_ID
    );
  }
  async getPlayerDetailsForGameweek(seasonId, gameweek) {
    let dto = {
      seasonId,
      gameweek
    };
    const result = await this.actor.getPlayerDetailsForGameweek(dto);
    if (isError(result))
      throw new Error(
        "Failed to fetch player details for gameweek in player events service"
      );
    return result.ok;
  }
  async getPlayerDetails(playerId, seasonId) {
    try {
      let dto = {
        playerId,
        seasonId
      };
      let result = await this.actor.getPlayerDetails(dto);
      if (isError(result)) {
        console.error("Error fetching player details");
      }
      return result.ok;
    } catch (error) {
      console.error("Error fetching player data:", error);
      throw error;
    }
  }
  async getPlayerEvents(seasonId, gameweek) {
    try {
      let dto = {
        seasonId,
        gameweek
      };
      let result = await this.actor.getPlayerDetailsForGameweek(dto);
      if (isError(result)) {
        console.error("Error fetching player details for gameweek");
      }
      return result.ok;
    } catch (error) {
      console.error("Error fetching player events: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching player events."
      });
    }
  }
}
var define_process_env_default$e = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
class FixtureService {
  actor;
  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      define_process_env_default$e.OPENFPL_BACKEND_CANISTER_ID
    );
  }
  async getPostponedFixtures() {
    try {
      const result = await this.actor.getPostponedFixtures();
      if (isError(result))
        throw new Error("Failed to fetch postponed fixtures");
      return result.ok;
    } catch (error) {
      console.error("Error fetching postponed fixtures: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching postponed fixtures."
      });
    }
  }
  async getFixtures() {
    try {
      const result = await this.actor.getFixtures();
      if (isError(result)) throw new Error("Failed to fetch fixtures");
      return result.ok;
    } catch (error) {
      console.error("Error fetching fixtures: ", error);
      toasts.addToast({ type: "error", message: "Error fetching fixtures." });
    }
  }
}
function createFixtureStore() {
  const { subscribe, set: set2 } = writable([]);
  async function getPostponedFixtures() {
    return new FixtureService().getPostponedFixtures();
  }
  async function getNextFixture() {
    let fixtures = [];
    await subscribe((value) => {
      fixtures = value;
    })();
    if (fixtures.length == 0) {
      return;
    }
    fixtures.sort((a, b) => {
      return new Date(Number(a.kickOff) / 1e6).getTime() - new Date(Number(b.kickOff) / 1e6).getTime();
    });
    const now = /* @__PURE__ */ new Date();
    return fixtures.find(
      (fixture) => new Date(Number(fixture.kickOff) / 1e6) > now
    );
  }
  return {
    subscribe,
    setFixtures: (fixtures) => set2(fixtures),
    getNextFixture,
    getPostponedFixtures
  };
}
const fixtureStore = createFixtureStore();
function getTotalBonusPoints(gameweekData, fantasyTeam, points) {
  if (!gameweekData) {
    console.error("No gameweek data found:", gameweekData);
    return 0;
  }
  let bonusPoints = 0;
  var pointsForGoal = 0;
  var pointsForAssist = 0;
  switch (convertPositionToIndex(gameweekData.player.position)) {
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
  if (fantasyTeam.noEntryGameweek === gameweekData.gameweek && fantasyTeam.noEntryPlayerId === gameweekData.player.id && (convertPositionToIndex(gameweekData.player.position) === 0 || convertPositionToIndex(gameweekData.player.position) === 1) && gameweekData.cleanSheets) {
    bonusPoints = points * 2;
  }
  if (fantasyTeam.safeHandsGameweek === gameweekData.gameweek && convertPositionToIndex(gameweekData.player.position) === 0 && gameweekData.saves >= 5) {
    bonusPoints = points * 2;
  }
  if (fantasyTeam.captainFantasticGameweek === gameweekData.gameweek && fantasyTeam.captainId === gameweekData.player.id && gameweekData.goals > 0) {
    bonusPoints = points;
  }
  if (fantasyTeam.oneNationGameweek === gameweekData.gameweek && fantasyTeam.oneNationCountryId === gameweekData.player.nationality) {
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
function getGridSetup(formation) {
  const formationSplits = formation.split("-").map(Number);
  const setups = [
    [1],
    ...formationSplits.map(
      (s2) => Array(s2).fill(0).map((_, i) => i + 1)
    )
  ];
  return setups;
}
var define_process_env_default$d = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
class AppService {
  actor;
  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      define_process_env_default$d.OPENFPL_BACKEND_CANISTER_ID
    );
  }
  async getAppStatus() {
    try {
      const result = await this.actor.getAppStatus();
      if (isError(result)) throw new Error("Failed to fetch system state");
      return result.ok;
    } catch (error) {
      console.error("Error fetching app status: ", error);
      toasts.addToast({ type: "error", message: "Error fetching app status." });
    }
  }
}
function createAppStore() {
  const { subscribe, set: set2 } = writable(null);
  async function getAppStatus() {
    return await new AppService().getAppStatus();
  }
  async function copyTextAndShowToast(text2) {
    try {
      await navigator.clipboard.writeText(text2);
      toasts.addToast({
        type: "success",
        message: "Copied to clipboard.",
        duration: 2e3
      });
    } catch (err) {
      console.error("Failed to copy:", err);
    }
  }
  return {
    subscribe,
    getAppStatus,
    setAppStatus: (appStatus) => set2(appStatus),
    copyTextAndShowToast
  };
}
const appStore = createAppStore();
var define_process_env_default$c = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
class LeagueService {
  actor;
  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      define_process_env_default$c.OPENFPL_BACKEND_CANISTER_ID
    );
  }
  async getLeagueStatus() {
    try {
      const result = await this.actor.getLeagueStatus();
      if (isError(result)) throw new Error("Failed to fetch league status");
      return result.ok;
    } catch (error) {
      console.error("Error fetching league status: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching league status."
      });
    }
  }
}
function createLeagueStore() {
  const { subscribe, set: set2 } = writable(null);
  async function getActiveOrUnplayedGameweek() {
    let leagueStatus = null;
    subscribe((result) => {
      if (result == null) {
        throw new Error("Failed to subscribe to league store");
      }
      leagueStatus = result;
      if (!leagueStatus) {
        return;
      }
      if (leagueStatus.activeGameweek == 0) {
        return leagueStatus.unplayedGameweek;
      }
      return leagueStatus.activeGameweek;
    });
    return 0;
  }
  return {
    subscribe,
    getActiveOrUnplayedGameweek,
    setLeagueStatus: (leagueStatus) => set2(leagueStatus)
  };
}
const leagueStore = createLeagueStore();
function createPlayerEventsStore() {
  const { subscribe, set: set2 } = writable([]);
  async function getPlayerDetails(playerId, seasonId) {
    return new PlayerEventsService().getPlayerDetails(playerId, seasonId);
  }
  async function getGameweekPlayers(fantasyTeam, seasonId, gameweek) {
    let allPlayerEvents = [];
    appStore.subscribe((result) => {
      if (result == null) {
        throw new Error("Failed to subscribe to application store");
      }
      ({
        version: result.version,
        onHold: result.onHold
      });
    });
    let leagueStatus = null;
    leagueStore.subscribe((result) => {
      if (result == null) {
        throw new Error("Failed to subscribe to league store");
      }
      leagueStatus = result;
    });
    let activeOrUnplayedGameweek = await leagueStore.getActiveOrUnplayedGameweek();
    if (leagueStatus.activeSeasonId === seasonId && activeOrUnplayedGameweek === gameweek) {
      allPlayerEvents = await getPlayerEventsFromLocalStorage();
    } else {
      let allPlayerEventsResult = await getPlayerEventsFromBackend(
        seasonId,
        gameweek
      );
      allPlayerEvents = allPlayerEventsResult ? allPlayerEventsResult : [];
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
    let allFixtures = [];
    const unsubscribeFixtures = fixtureStore.subscribe((fixtures) => {
      allFixtures = fixtures;
    });
    unsubscribeFixtures();
    const playersWithPoints = gameweekData.map((entry) => {
      const score = calculatePlayerScore(entry, allFixtures);
      const bonusPoints = getTotalBonusPoints(entry, fantasyTeam, score);
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
  async function getPlayerEventsFromLocalStorage() {
    const cachedPlayersData = localStorage.getItem("player_events");
    let cachedPlayerEvents = [];
    try {
      cachedPlayerEvents = JSON.parse(cachedPlayersData || "[]");
    } catch (e) {
      cachedPlayerEvents = [];
    }
    return cachedPlayerEvents;
  }
  async function getPlayerEventsFromBackend(seasonId, gameweek) {
    return new PlayerEventsService().getPlayerEvents(seasonId, gameweek);
  }
  return {
    subscribe,
    setPlayerEvents: (players) => set2(players),
    getPlayerDetails,
    getGameweekPlayers,
    getPlayerEventsFromBackend
  };
}
const playerEventsStore = createPlayerEventsStore();
var define_process_env_default$b = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
class WeeklyLeaderboardService {
  actor;
  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      define_process_env_default$b.OPENFPL_BACKEND_CANISTER_ID
    );
  }
  async getWeeklyLeaderboard(offset, seasonId, gameweek) {
    try {
      let dto = {
        offset: BigInt(offset),
        seasonId,
        limit: BigInt(25),
        searchTerm: "",
        gameweek
      };
      const result = await this.actor.getWeeklyLeaderboard(dto);
      if (isError(result))
        throw new Error("Failed to fetch weekly leaderboard");
      return result.ok;
    } catch (error) {
      console.error("Failed to get weekly leaderboard: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching weekly leaderboard."
      });
    }
  }
  async getWeeklyRewards(seasonId, gameweek) {
    try {
      const result = await this.actor.getWeeklyRewards(seasonId, gameweek);
      if (isError(result)) throw new Error("Failed to get weekly rewards");
      return result.ok;
    } catch (error) {
      console.error("Failed to get weekly rewards: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching weekly rewards."
      });
    }
  }
}
function createWeeklyLeaderboardStore() {
  const { subscribe, set: set2 } = writable(null);
  async function getWeeklyLeaderboard(seasonId, gameweek, page2) {
    const offset = (page2 - 1) * 25;
    return new WeeklyLeaderboardService().getWeeklyLeaderboard(
      offset,
      seasonId,
      gameweek
    );
  }
  async function getWeeklyRewards(seasonId, gameweek) {
    return new WeeklyLeaderboardService().getWeeklyRewards(seasonId, gameweek);
  }
  return {
    subscribe,
    setWeeklyLeaderboard: (leaderboard) => set2(leaderboard),
    getWeeklyLeaderboard,
    getWeeklyRewards
  };
}
const weeklyLeaderboardStore = createWeeklyLeaderboardStore();
var define_process_env_default$a = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
class DataHashService {
  actor;
  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      define_process_env_default$a.OPENFPL_BACKEND_CANISTER_ID
    );
  }
  async getDataHashes() {
    try {
      const result = await this.actor.getDataHashes();
      if (isError(result)) throw new Error("Failed to fetch data hashes");
      return result.ok;
    } catch (error) {
      console.error("Error fetching data hashes: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching data hashes."
      });
    }
  }
}
var define_process_env_default$9 = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
class CountryService {
  actor;
  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      define_process_env_default$9.OPENFPL_BACKEND_CANISTER_ID
    );
  }
  async getCountries() {
    try {
      const result = await this.actor.getCountries();
      if (isError(result)) throw new Error("Failed to fetch countries");
      return result.ok;
    } catch (error) {
      console.error("Error fetching countries: ", error);
      toasts.addToast({ type: "error", message: "Error fetching countries." });
    }
  }
}
var define_process_env_default$8 = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
class SeasonService {
  actor;
  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      define_process_env_default$8.OPENFPL_BACKEND_CANISTER_ID
    );
  }
  async getSeasons() {
    try {
      const result = await this.actor.getSeasons();
      if (isError(result)) throw new Error("Failed to fetch seasons");
      return result.ok;
    } catch (error) {
      console.error("Error fetching seasons: ", error);
      toasts.addToast({ type: "error", message: "Error fetching seasons." });
    }
  }
}
var define_process_env_default$7 = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
class ClubService {
  actor;
  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      define_process_env_default$7.OPENFPL_BACKEND_CANISTER_ID
    );
  }
  async getClubs() {
    try {
      const result = await this.actor.getClubs();
      if (isError(result)) throw new Error("Failed to fetch clubs");
      return result.ok;
    } catch (error) {
      console.error("Error fetching clubs: ", error);
      toasts.addToast({ type: "error", message: "Error fetching clubs." });
    }
  }
}
var define_process_env_default$6 = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
class RewardPoolService {
  actor;
  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      define_process_env_default$6.OPENFPL_BACKEND_CANISTER_ID
    );
  }
  async getRewardPool(seasonId) {
    try {
      let dto = {
        seasonId
      };
      const result = await this.actor.getRewardPool(dto);
      if (isError(result)) throw new Error("Failed to fetch reward pool");
      let rewardPoolResult = result.ok;
      return rewardPoolResult.rewardPool;
    } catch (error) {
      console.error("Error fetching reward pool: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching reward pool."
      });
    }
  }
}
function createRewardPoolStore() {
  const { subscribe, set: set2 } = writable(void 0);
  return {
    subscribe,
    setRewardPool: (rewardPool) => set2(rewardPool)
  };
}
const rewardPoolStore = createRewardPoolStore();
class StoreManager {
  dataHashService;
  countryService;
  appService;
  leagueService;
  seasonService;
  clubService;
  playerService;
  playerEventsService;
  fixtureService;
  weeklyLeaderboardService;
  rewardPoolService;
  categories = [
    "countries",
    "app_status",
    "league_status",
    "seasons",
    "clubs",
    "players",
    "player_events",
    "fixtures",
    "reward_pool"
  ];
  constructor() {
    this.dataHashService = new DataHashService();
    this.countryService = new CountryService();
    this.appService = new AppService();
    this.leagueService = new LeagueService();
    this.seasonService = new SeasonService();
    this.clubService = new ClubService();
    this.playerService = new PlayerService();
    this.playerEventsService = new PlayerEventsService();
    this.fixtureService = new FixtureService();
    this.weeklyLeaderboardService = new WeeklyLeaderboardService();
    this.rewardPoolService = new RewardPoolService();
  }
  async syncStores() {
    const newHashes = await this.dataHashService.getDataHashes();
    if (newHashes == void 0) {
      return;
    }
    for (const category of this.categories) {
      const categoryHash = newHashes.find((hash2) => hash2.category === category);
      if (categoryHash?.hash !== localStorage.getItem(`${category}_hash`)) {
        await this.syncCategory(category);
        localStorage.setItem(`${category}_hash`, categoryHash?.hash || "");
      } else {
        this.loadFromCache(category);
      }
    }
  }
  async syncCategory(category) {
    switch (category) {
      case "countries":
        const updatedCountries = await this.countryService.getCountries();
        if (!updatedCountries) {
          return;
        }
        countryStore.setCountries(updatedCountries);
        localStorage.setItem(
          "countries",
          JSON.stringify(updatedCountries, replacer)
        );
        break;
      case "league_status":
        const updatedLeagueStatus = await this.leagueService.getLeagueStatus();
        if (!updatedLeagueStatus) {
          return;
        }
        leagueStore.setLeagueStatus(updatedLeagueStatus);
        localStorage.setItem(
          "league_status",
          JSON.stringify(updatedLeagueStatus, replacer)
        );
        break;
      case "app_status":
        const updatedAppStatus = await this.appService.getAppStatus();
        if (!updatedAppStatus) {
          return;
        }
        appStore.setAppStatus(updatedAppStatus);
        localStorage.setItem(
          "app_status",
          JSON.stringify(updatedAppStatus, replacer)
        );
        break;
      case "seasons":
        const updatedSeasons = await this.seasonService.getSeasons();
        if (!updatedSeasons) {
          return;
        }
        seasonStore.setSeasons(updatedSeasons);
        localStorage.setItem(
          "seasons",
          JSON.stringify(updatedSeasons, replacer)
        );
        break;
      case "clubs":
        const updatedClubs = await this.clubService.getClubs();
        if (!updatedClubs) {
          return;
        }
        clubStore.setClubs(updatedClubs);
        localStorage.setItem("clubs", JSON.stringify(updatedClubs, replacer));
        break;
      case "players":
        const updatedPlayers = await this.playerService.getPlayers();
        if (!updatedPlayers) {
          return;
        }
        playerStore.setPlayers(updatedPlayers);
        localStorage.setItem(
          "players",
          JSON.stringify(updatedPlayers, replacer)
        );
        break;
      case "player_events":
        const leagueStatus = await this.leagueService.getLeagueStatus();
        if (!leagueStatus) {
          return;
        }
        const updatedPlayerEvents = await this.playerEventsService.getPlayerDetailsForGameweek(
          leagueStatus.activeSeasonId,
          leagueStatus.activeGameweek == 0 ? leagueStatus.unplayedGameweek : leagueStatus.activeGameweek
        );
        if (!updatedPlayerEvents) {
          return;
        }
        playerEventsStore.setPlayerEvents(updatedPlayerEvents);
        localStorage.setItem(
          "player_events",
          JSON.stringify(updatedPlayerEvents, replacer)
        );
        break;
      case "fixtures":
        const updatedFixtures = await this.fixtureService.getFixtures();
        if (!updatedFixtures) {
          return;
        }
        fixtureStore.setFixtures(updatedFixtures);
        localStorage.setItem(
          "fixtures",
          JSON.stringify(updatedFixtures, replacer)
        );
        break;
      case "weekly_leaderboard":
        leagueStore.subscribe(async (leagueStatus2) => {
          if (!leagueStatus2) {
            return;
          }
          const updatedWeeklyLeaderboard = await this.weeklyLeaderboardService.getWeeklyLeaderboard(
            0,
            leagueStatus2?.activeSeasonId ?? 0,
            leagueStatus2?.activeGameweek ?? 0
          );
          if (!updatedWeeklyLeaderboard) {
            return;
          }
          weeklyLeaderboardStore.setWeeklyLeaderboard(updatedWeeklyLeaderboard);
          localStorage.setItem(
            "weekly_leaderboard",
            JSON.stringify(updatedWeeklyLeaderboard, replacer)
          );
        });
        break;
      case "reward_pool":
        leagueStore.subscribe(async (leagueStatus2) => {
          if (!leagueStatus2) {
            return;
          }
          const updatedRewardPool = await this.rewardPoolService.getRewardPool(
            leagueStatus2.activeSeasonId
          );
          if (!updatedRewardPool) {
            return;
          }
          rewardPoolStore.setRewardPool(updatedRewardPool);
          localStorage.setItem(
            "reward_pool",
            JSON.stringify(updatedRewardPool, replacer)
          );
        });
        break;
    }
  }
  loadFromCache(category) {
    const cachedData = localStorage.getItem(category);
    switch (category) {
      case "countries":
        const cachedCountries = JSON.parse(cachedData || "[]");
        countryStore.setCountries(cachedCountries);
        break;
      case "app_status":
        const cachedAppStatus = JSON.parse(cachedData || "null");
        appStore.setAppStatus(cachedAppStatus);
        break;
      case "league_status":
        const cachedLeagueStatus = JSON.parse(cachedData || "null");
        leagueStore.setLeagueStatus(cachedLeagueStatus);
        break;
      case "seasons":
        const cachedSeasons = JSON.parse(cachedData || "");
        seasonStore.setSeasons(cachedSeasons);
        break;
      case "clubs":
        const cachedClubs = JSON.parse(cachedData || "[]");
        clubStore.setClubs(cachedClubs);
        break;
      case "players":
        const cachedPlayers = JSON.parse(cachedData || "[]");
        playerStore.setPlayers(cachedPlayers);
        break;
      case "fixtures":
        const cachedFixtures = JSON.parse(cachedData || "[]");
        fixtureStore.setFixtures(cachedFixtures);
        break;
      case "weekly_leaderboard":
        const cachedWeeklyLeaderboard = JSON.parse(cachedData || "null");
        weeklyLeaderboardStore.setWeeklyLeaderboard(cachedWeeklyLeaderboard);
        break;
      case "reward_pool":
        const cachedRewardPool = JSON.parse(cachedData || "null");
        rewardPoolStore.setRewardPool(cachedRewardPool);
        break;
    }
  }
}
const storeManager = new StoreManager();
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
const NNS_IC_APP_DERIVATION_ORIGIN = "https://5gbds-naaaa-aaaal-qmzqa-cai.icp0.io";
const isNnsAlternativeOrigin = () => {
  return window.location.origin === NNS_IC_ORG_ALTERNATIVE_ORIGIN;
};
const initAuthStore = () => {
  const { subscribe, set: set2, update } = writable({
    identity: void 0
  });
  return {
    subscribe,
    sync: async () => {
      authClient = authClient ?? await createAuthClient();
      const isAuthenticated = await authClient.isAuthenticated();
      set2({
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
function OpenFPLIcon($$payload, $$props) {
  let className = fallback($$props["className"], "");
  $$payload.out += `<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"${attr("class", className)} fill="currentColor" viewBox="0 0 137 188"><path d="M68.8457 0C43.0009 4.21054 19.8233 14.9859 0.331561 30.5217L0.264282 30.6627V129.685L68.7784 187.97L136.528 129.685L136.543 30.6204C117.335 15.7049 94.1282 4.14474 68.8457 0ZM82.388 145.014C82.388 145.503 82.0804 145.992 81.5806 146.114L68.7784 150.329C68.5285 150.39 68.2786 150.39 68.0287 150.329L55.2265 146.114C54.7267 145.931 54.4143 145.503 54.4143 145.014V140.738C54.4143 140.31 54.6642 139.883 55.039 139.7L67.8413 133.102C68.2161 132.919 68.591 132.919 68.9658 133.102L81.768 139.7C82.1429 139.883 82.388 140.31 82.388 140.738V145.014ZM106.464 97.9137C106.464 98.3414 106.214 98.769 105.777 98.9523L96.6607 103.534C96.036 103.84 95.8486 104.573 96.1609 105.122L105.027 121.189C105.277 121.678 105.215 122.228 104.84 122.594L89.7262 137.134C89.2889 137.561 88.6641 137.561 88.1644 137.256L70.9313 125.099C70.369 124.671 70.2441 123.877 70.7439 123.327L84.4208 108.421C85.2329 107.505 84.2958 106.161 83.1713 106.527L68.7447 111.109C68.4948 111.17 68.2449 111.17 67.9951 111.109L53.6358 106.527C52.4488 106.161 51.5742 107.566 52.3863 108.421L66.0584 123.327C66.5582 123.877 66.4332 124.671 65.871 125.099L48.6379 137.256C48.1381 137.561 47.5134 137.561 47.0761 137.134L31.9671 122.533C31.5923 122.167 31.5298 121.617 31.7797 121.128L40.6461 105.061C40.9585 104.45 40.7086 103.778 40.1463 103.473L31.03 98.8912C30.6552 98.7079 30.3428 98.2803 30.3428 97.8526V65.8413C30.3428 64.9249 31.4049 64.314 32.217 64.8639L39.709 69.8122C40.0214 70.0565 40.2088 70.362 40.2088 70.7896L40.2713 79.0368C40.2713 79.4034 40.4587 79.7699 40.7711 80.0143L51.7616 87.5284C52.5737 88.0782 53.6983 87.4673 53.6358 86.4898L52.9486 71.9503C52.9486 71.5838 52.7612 71.2173 52.4488 71.034L30.8426 56.5556C30.5302 56.3112 30.3428 55.9447 30.3428 55.5781V48.4305C30.3428 48.1862 30.4053 47.8807 30.5927 47.6975L38.3971 38.0452C38.7094 37.6176 39.2717 37.4954 39.7715 37.6786L67.9326 47.8807C68.1825 48.0029 68.4948 48.0029 68.7447 47.8807L96.9106 37.6786C97.4104 37.4954 97.9679 37.6786 98.2802 38.0452L106.089 47.6975C106.277 47.8807 106.339 48.1862 106.339 48.4305V55.5781C106.339 55.9447 106.152 56.3112 105.84 56.5556L84.2333 71.034C84.0459 71.2783 83.8585 71.6449 83.8585 72.0114L83.1713 86.5509C83.1088 87.5284 84.2333 88.1393 85.0455 87.5895L96.036 80.0753C96.3484 79.831 96.5358 79.5255 96.5358 79.0979L96.5983 70.8507C96.5983 70.4842 96.7857 70.1176 97.098 69.8733L104.59 64.9249C105.402 64.3751 106.464 64.9249 106.464 65.9024V97.9137Z" fill="#fffff"></path></svg>`;
  bind_props($$props, { className });
}
function WalletIcon($$payload, $$props) {
  let className = fallback($$props["className"], "");
  $$payload.out += `<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" aria-hidden="true"${attr("class", className)} fill="currentColor" viewBox="0 0 24 24"><path d="M12.136.326A1.5 1.5 0 0 1 14 1.78V3h.5A1.5 1.5 0 0 1 16 4.5v9a1.5 1.5 0 0 1-1.5 1.5h-13A1.5 1.5 0 0 1 0 13.5v-9a1.5 1.5 0 0 1 1.432-1.499L12.136.326zM5.562 3H13V1.78a.5.5 0 0 0-.621-.484L5.562 3zM1.5 4a.5.5 0 0 0-.5.5v9a.5.5 0 0 0 .5.5h13a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-13z"></path><path d="M15.5,6.5v3a1,1,0,0,1-1,1h-3.5v-5H14.5A1,1,0,0,1,15.5,6.5Z"></path><path d="M12,8a.5,.5 0,1,1,.001,0Z"></path></svg>`;
  bind_props($$props, { className });
}
const authSignedInStore = derived(
  authStore,
  ({ identity }) => identity !== null && identity !== void 0
);
var define_process_env_default$5 = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
class UserService {
  async getUser() {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default$5.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let getProfileResponse = await identityActor.getProfile();
      if (isError(getProfileResponse))
        throw new Error("Failed to fetch profile");
      return getProfileResponse.ok;
    } catch (error) {
      console.error("Error fetching user profile: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching user profile."
      });
    }
  }
}
var define_process_env_default$4 = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
function createUserStore() {
  const { subscribe, set: set2 } = writable(null);
  async function sync() {
    let localStorageString = localStorage.getItem("user_profile_data");
    if (localStorageString) {
      const localProfile = JSON.parse(localStorageString);
      set2(localProfile);
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
        define_process_env_default$4.OPENFPL_BACKEND_CANISTER_ID ?? ""
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
        define_process_env_default$4.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let dto = {
        favouriteClubId: favouriteTeamId
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
            define_process_env_default$4.OPENFPL_BACKEND_CANISTER_ID ?? ""
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
      define_process_env_default$4.OPENFPL_BACKEND_CANISTER_ID
    );
    let dto = {
      username
    };
    return await identityActor.isUsernameValid(dto);
  }
  async function cacheProfile() {
    let profile = new UserService().getUser();
    set2(profile);
  }
  async function withdrawFPL(withdrawalAddress, withdrawalAmount) {
    try {
      let identity;
      authStore.subscribe(async (auth) => {
        identity = auth.identity;
      });
      if (!identity) {
        return;
      }
      let principalId = identity.getPrincipal();
      const agent = await createAgent({
        identity,
        host: "https://identity.ic0.app",
        fetchRootKey: define_process_env_default$4.DFX_NETWORK === "local"
      });
      const { transfer } = IcrcLedgerCanister.create({
        agent,
        canisterId: define_process_env_default$4.DFX_NETWORK === "ic" ? Principal.fromText("ddsp7-7iaaa-aaaaq-aacqq-cai") : Principal.fromText("avqkn-guaaa-aaaaa-qaaea-cai")
      });
      if (principalId) {
        try {
          let transfer_result = await transfer({
            to: {
              owner: Principal.fromText(withdrawalAddress),
              subaccount: []
            },
            fee: 100000n,
            memo: new Uint8Array(Text$1.encodeValue("0")),
            from_subaccount: void 0,
            created_at_time: BigInt(Date.now()) * BigInt(1e6),
            amount: withdrawalAmount - 100000n
          });
        } catch (err) {
          console.error(err.errorType);
        }
      }
    } catch (error) {
      console.error("Error withdrawing FPL.", error);
      throw error;
    }
  }
  async function getFPLBalance() {
    let identity;
    authStore.subscribe(async (auth) => {
      identity = auth.identity;
    });
    if (!identity) {
      return 0n;
    }
    let principalId = identity.getPrincipal();
    const agent = await createAgent({
      identity,
      host: "https://identity.ic0.app",
      fetchRootKey: define_process_env_default$4.DFX_NETWORK === "local"
    });
    const { balance } = IcrcLedgerCanister.create({
      agent,
      canisterId: Principal.fromText("ddsp7-7iaaa-aaaaq-aacqq-cai")
    });
    if (principalId) {
      try {
        let result = await balance({
          owner: principalId,
          certified: false
        });
        return result;
      } catch (err) {
        console.error(err);
      }
    }
    return 0n;
  }
  return {
    subscribe,
    sync,
    cacheProfile,
    updateUsername,
    updateFavouriteTeam,
    updateProfilePicture,
    isUsernameAvailable,
    withdrawFPL,
    getFPLBalance
  };
}
const userStore = createUserStore();
const userGetProfilePicture = derived(
  userStore,
  ($user) => {
    if (!$user) {
      return "/profile_placeholder.png";
    }
    return getProfilePictureString($user.profilePicture);
  }
);
function getProfilePictureString(profilePicture) {
  try {
    let byteArray;
    if (profilePicture) {
      if (Array.isArray(profilePicture) && profilePicture[0] instanceof Uint8Array) {
        byteArray = profilePicture[0];
        return `data:image/${profilePicture};base64,${uint8ArrayToBase64(byteArray)}`;
      } else if (profilePicture instanceof Uint8Array) {
        return `data:${profilePicture};base64,${uint8ArrayToBase64(
          profilePicture
        )}`;
      } else {
        if (typeof profilePicture === "string") {
          return `data:${profilePicture};base64,${profilePicture}`;
        }
      }
    }
    return "/profile_placeholder.png";
  } catch (error) {
    console.error(error);
    return "/profile_placeholder.png";
  }
}
derived(
  userStore,
  (user) => user !== null && user !== void 0 ? user.favouriteTeamId : 0
);
function Header($$payload, $$props) {
  push();
  var $$store_subs;
  let currentClass, currentBorder;
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
  currentClass = (route) => page.url.pathname === route ? "text-blue-500 nav-underline active" : "nav-underline";
  currentBorder = (route) => page.url.pathname === route ? "active-border" : "";
  $$payload.out += `<header><nav class="text-white"><div class="px-4 h-16 flex justify-between items-center w-full"><a href="/" class="hover:text-gray-400 flex items-center">`;
  OpenFPLIcon($$payload, { className: "h-8 w-auto" });
  $$payload.out += `<!----><b class="ml-2">OpenFPL</b></a> <button class="menu-toggle md:hidden focus:outline-none"><svg width="24" height="18" viewBox="0 0 24 18" fill="none" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><rect width="24" height="2" rx="1" fill="currentColor"></rect><rect y="8" width="24" height="2" rx="1" fill="currentColor"></rect><rect y="16" width="24" height="2" rx="1" fill="currentColor"></rect></svg></button> `;
  if (store_get($$store_subs ??= {}, "$authSignedInStore", authSignedInStore)) {
    $$payload.out += "<!--[-->";
    $$payload.out += `<ul class="hidden md:flex h-16"><li class="mx-2 flex items-center h-16"><a href="/"${attr("class", `flex items-center h-full nav-underline hover:text-gray-400 $${stringify(currentClass("/"))}`)}><span class="flex items-center h-full px-4">Home</span></a></li> <li class="mx-2 flex items-center h-16"><a href="/pick-team"${attr("class", `flex items-center h-full nav-underline hover:text-gray-400 $${stringify(currentClass("/pick-team"))}`)}><span class="flex items-center h-full px-4">Squad Selection</span></a></li> <li class="flex flex-1 items-center"><div class="relative inline-block"><button${attr("class", `h-full flex items-center rounded-sm ${currentBorder("/profile")}`)}><img${attr("src", store_get($$store_subs ??= {}, "$userGetProfilePicture", userGetProfilePicture))} alt="Profile" class="h-12 rounded-sm profile-pic" aria-label="Toggle Profile"></button> <div${attr("class", `absolute right-0 top-full w-48 bg-black rounded-b-md rounded-l-md shadow-lg z-50 profile-dropdown ${showProfileDropdown ? "block" : "hidden"}`)}><ul class="text-gray-700"><li><a href="/profile" class="flex items-center h-full w-full nav-underline hover:text-gray-400"><span class="flex items-center h-full w-full"><img${attr("src", store_get($$store_subs ??= {}, "$userGetProfilePicture", userGetProfilePicture))} alt="logo" class="h-8 my-2 ml-4 mr-2"> <p class="w-full min-w-[125px] max-w-[125px] truncate">Profile</p></span></a></li> <li><button class="flex items-center justify-center px-4 pb-2 pt-1 text-white rounded-md shadow focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button">Disconnect `;
    WalletIcon($$payload, { className: "ml-2 h-6 w-6 mt-1" });
    $$payload.out += `<!----></button></li></ul></div></div></li></ul> <div${attr("class", `mobile-menu-panel absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${"hidden"} md:hidden`)}><ul class="flex flex-col"><li class="p-2"><a href="/"${attr("class", `nav-underline hover:text-gray-400 ${currentClass("/")}`)}>Home</a></li> <li class="p-2"><a href="/pick-team"${attr("class", currentClass("/pick-team"))}>Squad Selection</a></li> <li class="p-2"><a href="/profile"${attr("class", `flex h-full w-full nav-underline hover:text-gray-400 w-full $${stringify(currentClass("/profile"))}`)}><span class="flex items-center h-full w-full"><img${attr("src", store_get($$store_subs ??= {}, "$userGetProfilePicture", userGetProfilePicture))} alt="logo" class="w-8 h-8 rounded-sm"> <p class="w-full min-w-[100px] max-w-[100px] truncate p-2">Profile</p></span></a></li> <li class="px-2"><button class="flex h-full w-full hover:text-gray-400 w-full items-center">Disconnect `;
    WalletIcon($$payload, { className: "ml-2 h-6 w-6 mt-1" });
    $$payload.out += `<!----></button></li></ul></div>`;
  } else {
    $$payload.out += "<!--[!-->";
    $$payload.out += `<ul class="hidden md:flex"><li class="mx-2 flex items-center h-16"><button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button">Connect `;
    WalletIcon($$payload, { className: "ml-2 h-6 w-6 mt-1" });
    $$payload.out += `<!----></button></li></ul> <div${attr("class", `mobile-menu-panel absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${"hidden"} md:hidden`)}><ul class="flex flex-col"><li class="p-2"><button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button">Connect `;
    WalletIcon($$payload, { className: "ml-2 h-6 w-6 mt-1" });
    $$payload.out += `<!----></button></li></ul></div>`;
  }
  $$payload.out += `<!--]--></div></nav></header>`;
  if ($$store_subs) unsubscribe_stores($$store_subs);
  pop();
}
function JunoIcon($$payload, $$props) {
  let className = fallback($$props["className"], "");
  $$payload.out += `<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"${attr("class", className)} fill="currentColor" viewBox="0 0 130 130"><g id="Layer_1-2"><g><path d="M91.99,64.798c0,-20.748 -16.845,-37.593 -37.593,-37.593l-0.003,-0c-20.749,-0 -37.594,16.845 -37.594,37.593l0,0.004c0,20.748 16.845,37.593 37.594,37.593l0.003,0c20.748,0 37.593,-16.845 37.593,-37.593l0,-0.004Z"></path><circle cx="87.153" cy="50.452" r="23.247" style="fill:#7888ff;"></circle></g></g></svg>`;
  bind_props($$props, { className });
}
function Footer($$payload) {
  $$payload.out += `<footer class="bg-gray-900 text-white py-3"><div class="container mx-1 xs:mx-2 md:mx-auto flex flex-col md:flex-row items-start md:items-center justify-between text-xs"><div class="flex-1"><div class="flex justify-start"><div class="flex flex-row pl-4"><a href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/?ref=zv6hh-xaaaa-aaaar-ac35q-cai" target="_blank" rel="noopener noreferrer"><img src="/openchat.png" class="h-4 w-auto mb-2 mr-2" alt="OpenChat"></a> <a href="https://x.com/OpenFPL_DAO" target="_blank" rel="noopener noreferrer"><img src="/twitter.png" class="h-4 w-auto mr-2 mb-2" alt="X"></a> <a href="https://github.com/jamesbeadle/OpenFPL" target="_blank" rel="noopener noreferrer"><img src="/github.png" class="h-4 w-auto mb-2" alt="GitHub"></a></div></div> <div class="flex justify-start"><div class="flex flex-col md:flex-row md:space-x-2 pl-4"><a href="/whitepaper" class="hover:text-gray-300">Whitepaper</a> <span class="hidden md:flex">|</span> <a href="/gameplay-rules" class="hover:text-gray-300 md:hidden lg:block">Gameplay Rules</a> <a href="/gameplay-rules" class="hover:text-gray-300 hidden md:block lg:hidden">Rules</a> <span class="hidden md:flex">|</span> <a href="/terms" class="hover:text-gray-300">Terms &amp; Conditions</a></div></div></div> <div class="flex-0"><a href="/"><b class="px-4 mt-2 md:mt-0 md:px-10 flex items-center">`;
  OpenFPLIcon($$payload, { className: "h-6 w-auto mr-2" });
  $$payload.out += `<!---->OpenFPL</b></a></div> <div class="flex-1"><div class="flex justify-end"><div class="text-right px-4 md:px-0 mt-1 md:mt-0 md:mr-4"><a href="https://juno.build" target="_blank" class="hover:text-gray-300 flex items-center">Sponsored By juno.build `;
  JunoIcon($$payload, { className: "h-8 w-auto ml-2" });
  $$payload.out += `<!----></a></div></div></div></div></footer>`;
}
function Widget_spinner($$payload) {
  $$payload.out += `<div class="widget svelte-1tvdi4g"><div class="widget-spinner svelte-1tvdi4g"></div></div>`;
}
function Toast_item($$payload, $$props) {
  push();
  let toast = $$props["toast"];
  $$payload.out += `<div${attr("class", `fixed top-0 left-0 right-0 z-[9999] p-4 text-white shadow-md flex justify-between items-center bg-${toast.type}`)}><span>${escape_html(toast.message)}</span> <button class="font-bold ml-4">×</button></div>`;
  bind_props($$props, { toast });
  pop();
}
function Toasts($$payload) {
  var $$store_subs;
  const each_array = ensure_array_like(store_get($$store_subs ??= {}, "$toasts", toasts));
  $$payload.out += `<!--[-->`;
  for (let $$index = 0, $$length = each_array.length; $$index < $$length; $$index++) {
    let toast = each_array[$$index];
    $$payload.out += `<div>`;
    Toast_item($$payload, { toast });
    $$payload.out += `<!----></div>`;
  }
  $$payload.out += `<!--]-->`;
  if ($$store_subs) unsubscribe_stores($$store_subs);
}
function Layout($$payload, $$props) {
  push();
  var $$store_subs;
  const init2 = async () => await Promise.all([syncAuthStore()]);
  const syncAuthStore = async () => {
    {
      return;
    }
  };
  store_get($$store_subs ??= {}, "$authStore", authStore);
  $$payload.out += `<!---->`;
  await_block(
    init2(),
    () => {
      $$payload.out += `<div>`;
      Widget_spinner($$payload);
      $$payload.out += `<!----></div>`;
    },
    (_) => {
      $$payload.out += `<div class="flex flex-col h-screen justify-between default-text">`;
      Header($$payload);
      $$payload.out += `<!----> <main class="page-wrapper"><!---->`;
      slot($$payload, $$props, "default", {});
      $$payload.out += `<!----></main> `;
      Footer($$payload);
      $$payload.out += `<!----> `;
      Toasts($$payload);
      $$payload.out += `<!----></div>`;
    }
  );
  $$payload.out += `<!---->`;
  if ($$store_subs) unsubscribe_stores($$store_subs);
  pop();
}
function Content_panel($$payload, $$props) {
  $$payload.out += `<div class="content-panel"><!---->`;
  slot($$payload, $$props, "default", {});
  $$payload.out += `<!----></div>`;
}
function Page_header($$payload, $$props) {
  $$payload.out += `<div class="page-header-wrapper"><!---->`;
  slot($$payload, $$props, "default", {});
  $$payload.out += `<!----></div>`;
}
var define_process_env_default$3 = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
function createManagerStore() {
  let actor = ActorFactory.createActor(
    idlFactory,
    define_process_env_default$3.OPENFPL_BACKEND_CANISTER_ID
  );
  let newManager = {
    playerIds: [],
    oneNationCountryId: 0,
    username: "",
    goalGetterPlayerId: 0,
    hatTrickHeroGameweek: 0,
    transfersAvailable: 0,
    termsAccepted: false,
    teamBoostGameweek: 0,
    captainFantasticGameweek: 0,
    createDate: 0n,
    oneNationGameweek: 0,
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
    monthlyBonusesAvailable: 0,
    canisterId: "",
    firstGameweek: false
  };
  async function getPublicProfile(principalId) {
    await storeManager.syncStores();
    try {
      let activeOrUnplayedGameweek = await leagueStore.getActiveOrUnplayedGameweek();
      let leagueStatus = null;
      leagueStore.subscribe((result2) => {
        if (result2 == null) {
          throw new Error("Failed to subscribe to league store");
        }
        leagueStatus = result2;
      });
      let dto = {
        managerId: principalId,
        month: 0,
        seasonId: leagueStatus.activeSeasonId,
        gameweek: activeOrUnplayedGameweek,
        clubId: 0
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
  async function getFantasyTeamForGameweek(managerId, seasonId, gameweek) {
    try {
      let dto = {
        managerPrincipalId: managerId,
        gameweek,
        seasonId
      };
      let result = await actor.getFantasyTeamSnapshot(dto);
      if (isError(result)) {
        console.error("Error fetching fantasy team for gameweek:");
      }
      return result.ok;
    } catch (error) {
      console.error("Error fetching fantasy team for gameweek:", error);
      throw error;
    }
  }
  async function getCurrentTeam() {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        define_process_env_default$3.OPENFPL_BACKEND_CANISTER_ID ?? ""
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
        define_process_env_default$3.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let dto = {
        playerIds: userFantasyTeam.playerIds,
        captainId: userFantasyTeam.captainId,
        goalGetterGameweek: bonusPlayed == 1 ? activeGameweek : userFantasyTeam.goalGetterGameweek,
        goalGetterPlayerId: bonusUsedInSession ? bonusPlayerId : userFantasyTeam.goalGetterPlayerId,
        passMasterGameweek: bonusPlayed == 2 ? activeGameweek : userFantasyTeam.passMasterGameweek,
        passMasterPlayerId: bonusUsedInSession ? bonusPlayerId : userFantasyTeam.passMasterPlayerId,
        noEntryGameweek: bonusPlayed == 3 ? activeGameweek : userFantasyTeam.noEntryGameweek,
        noEntryPlayerId: bonusUsedInSession ? bonusPlayerId : userFantasyTeam.noEntryPlayerId,
        teamBoostGameweek: bonusPlayed == 4 ? activeGameweek : userFantasyTeam.teamBoostGameweek,
        teamBoostClubId: bonusUsedInSession ? bonusTeamId : userFantasyTeam.teamBoostClubId,
        safeHandsGameweek: bonusPlayed == 5 ? activeGameweek : userFantasyTeam.safeHandsGameweek,
        safeHandsPlayerId: bonusUsedInSession ? bonusPlayerId : userFantasyTeam.safeHandsPlayerId,
        captainFantasticGameweek: bonusPlayed == 6 ? activeGameweek : userFantasyTeam.captainFantasticGameweek,
        captainFantasticPlayerId: bonusUsedInSession ? bonusPlayerId : userFantasyTeam.captainFantasticPlayerId,
        oneNationGameweek: bonusPlayed == 7 ? activeGameweek : userFantasyTeam.oneNationGameweek,
        oneNationCountryId: bonusUsedInSession ? bonusCountryId : userFantasyTeam.oneNationCountryId,
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
      toasts.addToast({
        message: "Team saved successully!",
        type: "success",
        duration: 2e3
      });
      return fantasyTeam;
    } catch (error) {
      console.error("Error saving fantasy team:", error);
      toasts.addToast({
        message: "Error saving team.",
        type: "error"
      });
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
    if (userFantasyTeam.oneNationGameweek === activeGameweek) {
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
    if (userFantasyTeam.oneNationGameweek === activeGameweek) {
      bonusCountryId = userFantasyTeam.oneNationCountryId;
    }
    return bonusCountryId;
  }
  return {
    getTotalManagers,
    getFantasyTeamForGameweek,
    getCurrentTeam,
    saveFantasyTeam,
    getPublicProfile
  };
}
createManagerStore();
var define_process_env_default$2 = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
function createMonthlyLeaderboardStore() {
  const { subscribe, set: set2 } = writable(null);
  ActorFactory.createActor(
    idlFactory,
    define_process_env_default$2.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync(seasonId, month, clubId) {
  }
  async function getMonthlyLeaderboard(seasonId, clubId, month, currentPage, searchTerm) {
    return {
      month: 0,
      clubId: 0,
      totalEntries: 0n,
      seasonId: 0,
      entries: []
    };
  }
  return {
    subscribe,
    sync,
    getMonthlyLeaderboard
  };
}
createMonthlyLeaderboardStore();
var define_process_env_default$1 = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
function createSeasonLeaderboardStore() {
  const { subscribe, set: set2 } = writable(null);
  const itemsPerPage = 25;
  const category = "season_leaderboard";
  let actor = ActorFactory.createActor(
    idlFactory,
    define_process_env_default$1.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync(seasonId) {
    let category2 = "season_leaderboard";
    const newHashValues = await actor.getDataHashes();
    let error = isError(newHashValues);
    if (error) {
      console.error("Error fetching leaderboard store.");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category2) ?? null;
    const localHash = localStorage.getItem(`${category2}_hash`);
    if (categoryHash?.hash != localHash) {
      const limit = itemsPerPage;
      const offset = 0;
      let dto = {
        offset: BigInt(offset),
        seasonId,
        limit: BigInt(limit),
        searchTerm: ""
      };
      let result = await actor.getSeasonLeaderboard(dto);
      if (isError(result)) {
        return;
      }
      let updatedLeaderboardData = result.ok;
      localStorage.setItem(
        category2,
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(`${category2}_hash`, categoryHash?.hash ?? "");
      set2(updatedLeaderboardData);
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
      set2(cachedSeasonLeaderboard);
    }
  }
  async function getSeasonLeaderboard(seasonId, currentPage, searchTerm) {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    await storeManager.syncStores();
    let dto = null;
    leagueStore.subscribe(async (value) => {
      if (!value) {
        return;
      }
      if (currentPage <= 4 && seasonId == value.activeSeasonId) {
        const cachedData = localStorage.getItem(category);
        if (cachedData && cachedData != "undefined") {
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
      let dto2 = {
        offset: BigInt(offset),
        seasonId,
        limit: BigInt(limit),
        searchTerm: ""
      };
      let result = await actor.getSeasonLeaderboard(dto2);
      if (isError(result)) {
        return {
          totalEntries: 0n,
          seasonId: 1,
          entries: []
        };
      }
      dto2 = result.ok;
      localStorage.setItem(category, JSON.stringify(dto2, replacer));
    });
    return dto;
  }
  return {
    subscribe,
    sync,
    getSeasonLeaderboard
  };
}
createSeasonLeaderboardStore();
function Tab_container($$payload, $$props) {
  push();
  let activeTab = $$props["activeTab"];
  let setActiveTab = $$props["setActiveTab"];
  let tabs = $$props["tabs"];
  let isLoggedIn = $$props["isLoggedIn"];
  const each_array = ensure_array_like(tabs);
  $$payload.out += `<div class="flex w-full"><ul class="flex w-full rounded-t-lg bg-light-gray border-b border-gray-700 px-4 pt-2"><!--[-->`;
  for (let $$index = 0, $$length = each_array.length; $$index < $$length; $$index++) {
    let tab = each_array[$$index];
    if (!tab.authOnly || isLoggedIn) {
      $$payload.out += "<!--[-->";
      $$payload.out += `<li${attr("class", `mr-4 ${activeTab === tab.id ? "active-tab" : ""}`)}><button${attr("class", `p-2 ${activeTab === tab.id ? "text-white" : "text-gray-400"}`)}>${escape_html(tab.label)}</button></li>`;
    } else {
      $$payload.out += "<!--[!-->";
    }
    $$payload.out += `<!--]-->`;
  }
  $$payload.out += `<!--]--></ul></div>`;
  bind_props($$props, { activeTab, setActiveTab, tabs, isLoggedIn });
  pop();
}
function _page$9($$payload, $$props) {
  push();
  Layout($$payload, {
    children: ($$payload2) => {
      {
        $$payload2.out += "<!--[-->";
        Widget_spinner($$payload2);
      }
      $$payload2.out += `<!--]-->`;
    },
    $$slots: { default: true }
  });
  pop();
}
var define_process_env_default = { OPENFPL_BACKEND_CANISTER_ID: "y22zx-giaaa-aaaal-qmzpq-cai", OPENFPL_FRONTEND_CANISTER_ID: "5gbds-naaaa-aaaal-qmzqa-cai", DFX_NETWORK: "ic", CANISTER_ID_SNS_GOVERNANCE: "detjl-sqaaa-aaaaq-aacqa-cai", CANISTER_ID_SNS_ROOT: "gyito-zyaaa-aaaaq-aacpq-cai", TOTAL_GAMEWEEKS: 38 };
class CanisterService {
  actor;
  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      define_process_env_default.OPENFPL_BACKEND_CANISTER_ID
    );
  }
  async getCanisters(dto) {
    try {
      const result = await this.actor.getCanisters(dto);
      if (isError(result)) throw new Error("Failed to fetch canisters");
      return result.ok;
    } catch (error) {
      console.error("Error fetching canisters: ", error);
      toasts.addToast({ type: "error", message: "Error fetching canisters." });
    }
  }
}
function createCanisterStore() {
  async function getCanisters(dto) {
    return new CanisterService().getCanisters(dto);
  }
  return {
    getCanisters
  };
}
const canisterStore = createCanisterStore();
function _page$8($$payload, $$props) {
  push();
  let selectedCanisterType = 0;
  let loadingCanisters = true;
  let canisters = [];
  let dropdownOptions = [
    { id: 0, name: "App" },
    { id: 1, name: "Manager" },
    { id: 2, name: "Leaderboard" },
    { id: 3, name: "SNS" }
  ];
  async function loadCanisters() {
    loadingCanisters = true;
    let filterCanisterType = { Dapp: null };
    switch (selectedCanisterType) {
      case 0:
        filterCanisterType = { Dapp: null };
        break;
      case 1:
        filterCanisterType = { Manager: null };
        break;
      case 2:
        filterCanisterType = { Leaderboard: null };
        break;
      case 3:
        filterCanisterType = { SNS: null };
        break;
    }
    let dto = { canisterType: filterCanisterType };
    let canistersResult = await canisterStore.getCanisters(dto);
    canisters = canistersResult ? canistersResult : [];
    loadingCanisters = false;
  }
  {
    loadCanisters();
  }
  Layout($$payload, {
    children: ($$payload2) => {
      Page_header($$payload2, {
        children: ($$payload3) => {
          Content_panel($$payload3, {
            children: ($$payload4) => {
              const each_array = ensure_array_like(dropdownOptions);
              $$payload4.out += `<div class="w-full mt-4 px-2"><p class="text-center w-full mb-6 text-xl font-semibold">OpenFPL Managed Canisters</p> <div class="flex flex-col sm:flex-row items-start sm:items-center gap-2 mb-4"><label class="font-medium" for="canisterType">Select Canister Type:</label> <select id="canisterType" class="fpl-dropdown"><!--[-->`;
              for (let $$index = 0, $$length = each_array.length; $$index < $$length; $$index++) {
                let option = each_array[$$index];
                $$payload4.out += `<option${attr("value", option.id)}>option.name</option>`;
              }
              $$payload4.out += `<!--]--></select></div> `;
              if (loadingCanisters) {
                $$payload4.out += "<!--[-->";
                $$payload4.out += `<div class="flex justify-center">`;
                Widget_spinner($$payload4);
                $$payload4.out += `<!----></div>`;
              } else {
                $$payload4.out += "<!--[!-->";
                const each_array_1 = ensure_array_like(canisters);
                $$payload4.out += `<div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4"><!--[-->`;
                for (let $$index_1 = 0, $$length = each_array_1.length; $$index_1 < $$length; $$index_1++) {
                  let canister = each_array_1[$$index_1];
                  $$payload4.out += `<div class="border border-gray-200 rounded shadow-sm p-4 flex flex-col space-y-2"><p class="font-medium">Canister Id: ${escape_html(canister.canisterId)}</p> <p class="font-medium mt-2">Cycles Balance: ${escape_html(formatCycles(canister.cycles))}</p> <p class="font-medium mt-2">Compute Allocation: ${escape_html(canister.computeAllocation)}</p> <p class="font-medium mt-2">Total Topups: ${escape_html(canister.topups.length)}</p></div>`;
                }
                $$payload4.out += `<!--]--></div>`;
              }
              $$payload4.out += `<!--]--></div>`;
            },
            $$slots: { default: true }
          });
        },
        $$slots: { default: true }
      });
    },
    $$slots: { default: true }
  });
  pop();
}
function _page$7($$payload, $$props) {
  push();
  Number(page.url.searchParams.get("id"));
  Layout($$payload, {
    children: ($$payload2) => {
      {
        $$payload2.out += "<!--[-->";
        Widget_spinner($$payload2);
      }
      $$payload2.out += `<!--]-->`;
    },
    $$slots: { default: true }
  });
  pop();
}
function _page$6($$payload) {
  Layout($$payload, {
    children: ($$payload2) => {
      $$payload2.out += `<div class="bg-panel p-4 mt-4"><h1 class="default-header">OpenFPL Gameplay Rules</h1> <div><p class="my-2">Please see the below OpenFPL fantasy football gameplay rules.</p> <p class="my-2">Each user begins with £300m to purchase players for their team. The value of a player can go up or down depending on how the player is rated in the DAO. Provided a certain voting threshold is reached for either a £0.25m increase or decrease, the player's value will change in that gameweek. A players value can only change when the season is active (the first game has kicked off and the final game has not finished).</p> <p class="my-2">Each team has 11 players, with no more than 2 selected from any single team. The team must be in a valid formation, with 1 goalkeeper, 3-5 defenders, 3-5 midfielders and 1-3 strikers.</p> <p class="my-2">Users will setup their team before the gameweek deadline each week. When playing OpenFPL, users have the chance to win FPL tokens depending on how well the players in their team perform.</p> <p class="my-2">In January, a user can change their entire team once.</p> <p class="my-2">A user is allowed to make 3 transfers per week which are never carried over.</p> <p class="my-2">Each week a user can select a star player. This player will receive double points for the gameweek. If one is not set by the start of the gameweek it will automatically be set to the most valuable player in your team.</p> <h2 class="default-sub-header">Points</h2> <p class="my-2">The user can get the following points during a gameweek for their team:</p> <table class="w-full border-collapse striped mb-8 mt-4"><tbody><tr><th class="text-left px-4 py-2">For</th><th class="text-left">Points</th></tr><tr><td class="text-left px-4 py-2">Appearing in the game.</td><td>5</td></tr><tr><td class="text-left px-4 py-2">Every 3 saves a goalkeeper makes.</td><td>5</td></tr><tr><td class="text-left px-4 py-2">Goalkeeper or defender cleansheet.</td><td>10</td></tr><tr><td class="text-left px-4 py-2">Forward scores a goal.</td><td>10</td></tr><tr><td class="text-left px-4 py-2">Midfielder or Forward assists a goal.</td><td>10</td></tr><tr><td class="text-left px-4 py-2">Midfielder scores a goal.</td><td>15</td></tr><tr><td class="text-left px-4 py-2">Goalkeeper or defender assists a goal.</td><td>15</td></tr><tr><td class="text-left px-4 py-2">Goalkeeper or defender scores a goal.</td><td>20</td></tr><tr><td class="text-left px-4 py-2">Goalkeeper saves a penalty.</td><td>20</td></tr><tr><td class="text-left px-4 py-2">Player is highest scoring player in match.</td><td>25</td></tr><tr><td class="text-left px-4 py-2">Player receives a red card.</td><td>-20</td></tr><tr><td class="text-left px-4 py-2">Player misses a penalty.</td><td>-15</td></tr><tr><td class="text-left px-4 py-2">Each time a goalkeeper or defender concedes 2 goals.</td><td>-15</td></tr><tr><td class="text-left px-4 py-2">A player scores an own goal.</td><td>-10</td></tr><tr><td class="text-left px-4 py-2">A player receives a yellow card.</td><td>-5</td></tr></tbody></table> <h2 class="default-sub-header">Bonuses</h2> <p class="my-2">A user can play 1 bonus per gameweek. Each season a user starts with the following 8 bonuses:</p> <table class="w-full border-collapse striped mb-8 mt-4"><tbody><tr><th class="text-left px-4 py-2">Bonus</th><th class="text-left">Description</th></tr><tr><td class="text-left px-4 py-2">Goal Getter</td><td>Select a player you think will score in a game to receive a X3 mulitplier for each goal scored.</td></tr><tr><td class="text-left px-4 py-2">Pass Master</td><td>Select a player you think will assist in a game to receive a X3 mulitplier for each assist.</td></tr><tr><td class="text-left px-4 py-2">No Entry</td><td>Select a goalkeeper or defender you think will keep a clean sheet to receive a X3 multipler on their total score.</td></tr><tr><td class="text-left px-4 py-2">Team Boost</td><td>Receive a X2 multiplier from all players from a single club that are in your team.</td></tr><tr><td class="text-left px-4 py-2">Safe Hands</td><td>Receive a X3 multiplier on your goalkeeper if they make 5 saves in a match.</td></tr><tr><td class="text-left px-4 py-2">Captain Fantastic</td><td>Receive a X2 multiplier on your team captain's score if they score a goal in a match.</td></tr><tr><td class="text-left px-4 py-2">One Nation</td><td>Receive a X2 multiplier for players of a selected nationality.</td></tr><tr><td class="text-left px-4 py-2">Prospects</td><td>Receive a X2 multiplier for players under the age of 21.</td></tr><tr><td class="text-left px-4 py-2">Brace Bonus</td><td>Receive a X2 multiplier on a player's score if they score 2 or more goals in a game. Applies to every player who scores a brace.</td></tr><tr><td class="text-left px-4 py-2">Hat Trick Hero</td><td>Receive a X3 multiplier on a player's score if they score 3 or more goals in a game. Applies to every player who scores a hat-trick.</td></tr></tbody></table></div></div>`;
    },
    $$slots: { default: true }
  });
}
function _page$5($$payload, $$props) {
  push();
  let formation;
  page.url.searchParams.get("id");
  formation = "4-4-2";
  getGridSetup(formation);
  Layout($$payload, {
    children: ($$payload2) => {
      {
        $$payload2.out += "<!--[-->";
        Widget_spinner($$payload2);
      }
      $$payload2.out += `<!--]-->`;
    },
    $$slots: { default: true }
  });
  pop();
}
function _page$4($$payload, $$props) {
  push();
  Layout($$payload, {
    children: ($$payload2) => {
      {
        $$payload2.out += "<!--[-->";
        Widget_spinner($$payload2);
      }
      $$payload2.out += `<!--]-->`;
    },
    $$slots: { default: true }
  });
  pop();
}
function _page$3($$payload, $$props) {
  push();
  Number(page.url.searchParams.get("id"));
  Layout($$payload, {
    children: ($$payload2) => {
      {
        $$payload2.out += "<!--[-->";
        Widget_spinner($$payload2);
      }
      $$payload2.out += `<!--]-->`;
    },
    $$slots: { default: true }
  });
  pop();
}
function _page$2($$payload, $$props) {
  push();
  Layout($$payload, {
    children: ($$payload2) => {
      {
        $$payload2.out += "<!--[-->";
        Widget_spinner($$payload2);
      }
      $$payload2.out += `<!--]-->`;
    },
    $$slots: { default: true }
  });
  pop();
}
function _page$1($$payload) {
  Layout($$payload, {
    children: ($$payload2) => {
      $$payload2.out += `<div class="bg-panel p-4 mt-4"><h1 class="default-header">OpenFPL DAO Terms &amp; Conditions</h1> <div><p class="my-2 text-xs">Last Updated: 13th October 2023</p> <p class="my-4">By accessing the OpenFPL website ("Site") and participating in the
        OpenFPL Fantasy Football DAO ("Service"), you agree to comply with and
        be bound by the following Terms and Conditions.</p> <h2 class="default-sub-header">Acceptance of Terms</h2> <p class="my-4">You acknowledge that you have read, understood, and agree to be bound by
        these Terms. These Terms are subject to change by a DAO proposal and
        vote.</p> <h2 class="default-sub-header">Decentralised Structure</h2> <p class="my-4">OpenFPL operates as a decentralised autonomous organisation (DAO). As
        such, traditional legal and liability structures may not apply. Members
        and users are responsible for their own actions within the DAO
        framework.</p> <h2 class="default-sub-header">Eligibility</h2> <p class="my-4">The Service is open to users of all ages.</p> <h2 class="default-sub-header">User Conduct</h2> <p class="my-4">No Automation or Bots: You agree not to use bots, automated methods, or
        other non-human ways of interacting with the site.</p> <h2 class="default-sub-header">Username Policy</h2> <p class="my-4">You agree not to use usernames that are offensive, vulgar, or infringe
        on the rights of others.</p> <h2 class="default-sub-header">Changes to Terms</h2> <p class="my-4">These Terms and Conditions are subject to change. Amendments will be
        effective upon DAO members' approval via proposal and vote.</p></div></div>`;
    },
    $$slots: { default: true }
  });
}
function Architecture($$payload) {
  $$payload.out += `<div class="m-4"><h1 class="default-header my-4">System Architecture</h1> <p class="my-2">OpenFPL is a progressive web application, built with Svelte and Motoko. The
    Github is publicly available <a class="underline" href="github.com/jamesbeadle/openfpl">here</a>. OpenFPL's architecture is designed for scalability and efficiency,
    ensuring robust performance even as user numbers grow. Here's how the system
    is structured:</p> <h2 class="default-sub-header mt-4">Main Backend Canister</h2> <p class="my-2">OpenFPL' Main Backend Canister stores indexes for a manager's principal and
    canister Id for efficient data retrieval. The Main Backend Canister also
    stores a dictionary of each users principal and username for efficient
    existing username checks.</p> <p class="my-2">The Main Backend canister also stores a list of each unique manager canister
    to enable efficient grouped lookups. Even with 10m users the Main Backend
    Canister only uses 2GB of its available storage, however it is likely that
    the players and user indexes are refactored into their own canisters after
    the SNS sale but before the season starts.</p> <h2 class="default-sub-header mt-4">Manager Data</h2> <p class="my-2">A snapshot of a fantasy team is around 147 bytes. So if a manager's players
    for 100 seasons that is a total history of 546 KB (100 x 38 x 147 bytes).
    With the manager's current team, including a 100KB profile picture a manager
    object could take around 646KB of space.</p> <p class="my-2">This means a 96GB canister could theoretically hold around 155,826 managers.
    We divide the canister into 12 partitions and limit the number of managers
    in each partition to 1,000. This gives plenty of storage and calculation
    overhead for future features.</p> <h2 class="default-sub-header mt-4">Leaderboard Data</h2> <p class="my-2">A leaderboard canister holds an array of leaderboard entries, with each
    entry taking up roughly 121 bytes of space. This means the leaderboard
    canister can hold over 35m entries within its 4GB heap memory, more than 3
    times the players of the market leading game.</p></div>`;
}
function Dao($$payload) {
  $$payload.out += `<div class="m-4"><h1 class="default-header">OpenFPL DAO</h1> <p class="my-4">OpenFPL functions entirely on-chain as a DAO, aspiring to operate under the
    Internet Computer’s Service Nervous System. The DAO is structured to run in
    parallel with the Premier League season, relying on input from its neuron
    holders who are rewarded for maintaining independence from third-party
    services.</p> <h2 class="default-sub-header">DAO Reward Structure</h2> <p class="my-2">The DAO incentivises participation through monthly minting of new FPL
    tokens, calculated annually at 1.875% of the total $FPL supply as of August
    1st.</p> <p class="my-2">Along with gameplay rewards, voting rewards are applied at a reward rate of
    1% per year.</p> <h2 class="default-sub-header mt-4">Gameplay Rewards</h2> <p class="my-2">The DAO is designed to reward users for their expertise in fantasy football,
    with rewards distributed weekly, monthly, and annually based on performance.
    The rewards are tiered to encourage ongoing engagement. Here’s the
    breakdown:</p> <ul class="list-disc ml-4"><li>Global Season Leaderboard Rewards: 30% for the top 100 global season
      positions.</li> <li>Club Monthly Leaderboard Rewards: 20% for the top 100 in each monthly club
      leaderboard, adjusted for the number of fans in each club.</li> <li>Global Weekly Leaderboard Rewards: 15% for the top 100 weekly positions.</li> <li>Most Valuable Team Rewards: 10% for the top 100 most valuable teams at
      season's end.</li> <li>Highest Scoring Match Player Rewards: 10% split among managers selecting
      the highest-scoring player in a fixture.</li> <li>Weekly/Monthly/Season ATH Score Rewards: 5% each, reserved for breaking
      all-time high scores in respective categories.</li></ul> <p class="my-2">A user is rewarded for their leaderboard position across the top 100
    positions. The following is a breakdown of the reward share for each
    position:</p> <table class="w-full text-center border-collapse striped mb-8 mt-8"><tbody><tr><th>Pos</th><th>Share</th><th>Pos</th><th>Share</th><th>Pos</th><th>Share</th><th>Pos</th><th>Share</th></tr><tr><td>1</td><td>36.09%</td><td>26</td><td>0.391%</td><td>51</td><td>0.0662%</td><td>76</td><td>0.012%</td></tr><tr><td>2</td><td>18.91%</td><td>27</td><td>0.365%</td><td>52</td><td>0.0627%</td><td>77</td><td>0.0112%</td></tr><tr><td>3</td><td>10.32%</td><td>28</td><td>0.339%</td><td>53</td><td>0.0593%</td><td>78</td><td>0.0103%</td></tr><tr><td>4</td><td>6.02%</td><td>29</td><td>0.314%</td><td>54</td><td>0.0558%</td><td>79</td><td>0.0095%</td></tr><tr><td>5</td><td>3.87%</td><td>30</td><td>0.288%</td><td>55</td><td>0.0524%</td><td>80</td><td>0.0086%</td></tr><tr><td>6</td><td>2.80%</td><td>31</td><td>0.262%</td><td>56</td><td>0.0490%</td><td>81</td><td>0.0082%</td></tr><tr><td>7</td><td>2.26%</td><td>32</td><td>0.248%</td><td>57</td><td>0.0455%</td><td>82</td><td>0.0077%</td></tr><tr><td>8</td><td>1.83%</td><td>33</td><td>0.235%</td><td>58</td><td>0.0421%</td><td>83</td><td>0.0073%</td></tr><tr><td>9</td><td>1.51%</td><td>34</td><td>0.221%</td><td>59</td><td>0.0387%</td><td>84</td><td>0.0069%</td></tr><tr><td>10</td><td>1.30%</td><td>35</td><td>0.207%</td><td>60</td><td>0.0352%</td><td>85</td><td>0.0064%</td></tr><tr><td>11</td><td>1.19%</td><td>36</td><td>0.193%</td><td>61</td><td>0.0335%</td><td>86</td><td>0.0060%</td></tr><tr><td>12</td><td>1.08%</td><td>37</td><td>0.180%</td><td>62</td><td>0.0318%</td><td>87</td><td>0.0056%</td></tr><tr><td>13</td><td>0.98%</td><td>38</td><td>0.166%</td><td>63</td><td>0.0301%</td><td>88</td><td>0.0052%</td></tr><tr><td>14</td><td>0.87%</td><td>39</td><td>0.152%</td><td>64</td><td>0.0284%</td><td>89</td><td>0.0047%</td></tr><tr><td>15</td><td>0.76%</td><td>40</td><td>0.138%</td><td>65</td><td>0.0266%</td><td>90</td><td>0.0043%</td></tr><tr><td>16</td><td>0.72%</td><td>41</td><td>0.131%</td><td>66</td><td>0.0249%</td><td>91</td><td>0.0041%</td></tr><tr><td>17</td><td>0.67%</td><td>42</td><td>0.125%</td><td>67</td><td>0.0232%</td><td>92</td><td>0.0039%</td></tr><tr><td>18</td><td>0.63%</td><td>43</td><td>0.118%</td><td>68</td><td>0.0215%</td><td>93</td><td>0.0037%</td></tr><tr><td>19</td><td>0.59%</td><td>44</td><td>0.111%</td><td>69</td><td>0.0198%</td><td>94</td><td>0.0034%</td></tr><tr><td>20</td><td>0.55%</td><td>45</td><td>0.104%</td><td>70</td><td>0.0180%</td><td>95</td><td>0.0032%</td></tr><tr><td>21</td><td>0.52%</td><td>46</td><td>0.097%</td><td>71</td><td>0.0172%</td><td>96</td><td>0.0030%</td></tr><tr><td>22</td><td>0.49%</td><td>47</td><td>0.090%</td><td>72</td><td>0.0155%</td><td>97</td><td>0.0028%</td></tr><tr><td>23</td><td>0.47%</td><td>48</td><td>0.083%</td><td>73</td><td>0.0146%</td><td>98</td><td>0.0026%</td></tr><tr><td>24</td><td>0.44%</td><td>49</td><td>0.076%</td><td>74</td><td>0.0137%</td><td>99</td><td>0.0024%</td></tr><tr><td>25</td><td>0.42%</td><td>50</td><td>0.070%</td><td>75</td><td>0.0129%</td><td>100</td><td>0.0021%</td></tr></tbody></table> <p class="my-2">To ensure rewards are paid for active participation, a user would need to do
    the following to qualify for the following OpenFPL gameplay rewards:</p> <ul class="list-disc ml-4"><li>A user must have made at least 2 changes in a month to qualify for that
      month's club leaderboard rewards and monthly ATH record rewards.</li> <li>A user must have made at least 1 change in a gameweek to qualify for that
      week's leaderboard rewards, highest-scoring match player rewards and
      weekly ATH record rewards.</li> <li>Rewards for the season total, most valuable team have and annual ATH have
      no entry restrictions as it is based on the cumulative action of managers
      transfers throughout the season.</li></ul></div>`;
}
function Gameplay($$payload) {
  $$payload.out += `<div class="m-4"><h1 class="default-header">OpenFPL Gameplay</h1> <p class="my-4">OpenFPL has been designed to create a unique and engaging fantasy football
    experience. We understand the passion and strategy that goes into fantasy
    football, and our gameplay rules are crafted to reflect this, enhancing the
    fun and competitiveness of each gameweek.</p> <h2 class="default-header">Starting Funds and Team Composition</h2> <p class="my-2">Each user begins their season with a £300m budget to build their fantasy
    team. A player's value can change based on their performance if a proposal
    is raised to change their value up or down. If the proposal passes, their
    value can either increase or decrease by £0.25m each gameweek.</p> <p class="my-2">A user's team consists of 11 players. Picking from a range of clubs is key,
    so a maximum of 2 players from any single club can be selected. Teams must
    adhere to a valid formation: 1 goalkeeper, 3-5 defenders, 3-5 midfielders,
    and 1-3 strikers.</p> <h2 class="default-header mt-4">Transfers and Team Management</h2> <p class="my-2">To give managers flexibility, we give you 3 new transfers each week. These
    transfers don't roll over, encouraging active participation each week. There
    are no substitutes in our game, eliminating the frustration of unused bench
    points.</p> <p class="my-4">Each January, users can overhaul their team completely once, adding another
    strategic layer to the game reflecting the January transfer window.</p> <p class="my-4">If a player is loaned or transferred from a club they are removed from any
    fantasy team that contains them. This will leave a space in your team you
    must fill when saving your team next.</p> <p class="my-4">If the DAO votes to change a player's position, for example from a forward
    to a midfielder, then the player is again removed from any fantasy team that
    contains them.</p> <p class="my-4">Scores will still be calculated on teams with less than 11 players that have
    not updated their team since an automatic system change.</p> <h2 class="default-header mt-4">Scoring System</h2> <p class="my-2">Our scoring system rewards players for key contributions on the field:</p> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">Appearing in the game:</div> <div class="flex min-w-[50px] min-w-none">+5 points</div></div> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">Every 3 saves a goalkeeper makes:</div> <div class="flex min-w-[50px]">+5 points</div></div> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">Goalkeeper or defender cleansheet:</div> <div class="flex min-w-[50px]">+10 points</div></div> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">Forward scores a goal:</div> <div class="flex min-w-[50px]">+10 points</div></div> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">Midfielder or Forward assists a goal:</div> <div class="flex min-w-[50px]">+10 points</div></div> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">Midfielder scores a goal:</div> <div class="flex min-w-[50px]">+15 points</div></div> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">Goalkeeper or defender assists a goal:</div> <div class="flex min-w-[50px]">+15 points</div></div> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">Goalkeeper or defender scores a goal:</div> <div class="flex min-w-[50px]">+20 points</div></div> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">Goalkeeper saves a penalty:</div> <div class="flex min-w-[50px]">+20 points</div></div> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">Player is highest scoring player in match:</div> <div class="flex min-w-[50px]">+25 points</div></div> <p class="my-2">Points are also deducted for the following on field events:</p> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">Player receives a red card:</div> <div class="flex min-w-[50px]">-20 points</div></div> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">Player misses a penalty:</div> <div class="flex min-w-[50px]">-15 points</div></div> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">Each time a goalkeeper or defender concedes 2 goals:</div> <div class="flex min-w-[50px]">-15 points</div></div> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">A player scores an own goal:</div> <div class="flex min-w-[50px]">-10 points</div></div> <div class="flex flex-row"><div class="flex-1 mr-4 md:flex-grow-0 md:min-w-[500px]">A player receives a yellow card:</div> <div class="flex min-w-[50px]">-5 points</div></div> <h2 class="default-header mt-4">Bonuses</h2> <p class="my-2">OpenFPL elevates the gameplay with a diverse set of bonuses. These bonuses
    are designed to allow significant shifts in the leadeboard, ensuring that
    the competition remains interesting. Users can only play 2 bonuses per
    month, further fostering repeated engagement while avoiding all bonuses
    being played at once. Our bonuses are as follows:</p> <div class="flex flex-row"><div class="flex mr-4 min-w-[100px] xs:min-w-[110px] sm:min-w-[150px]">Goal Getter:</div> <div class="flex-1">X3 multiplier for each goal scored by a selected player.</div></div> <div class="flex flex-row"><div class="flex mr-4 min-w-[100px] xs:min-w-[110px] sm:min-w-[150px]">Pass Master:</div> <div class="flex-1">X3 multiplier for each assist by a selected player.</div></div> <div class="flex flex-row"><div class="flex mr-4 min-w-[100px] xs:min-w-[110px] sm:min-w-[150px]">No Entry:</div> <div class="flex-1">X3 multiplier for a selected goalkeeper/defender for a clean sheet.</div></div> <div class="flex flex-row"><div class="flex mr-4 min-w-[100px] xs:min-w-[110px] sm:min-w-[150px]">Safe Hands:</div> <div class="flex-1">X3 multiplier for a goalkeeper making 5 saves.</div></div> <div class="flex flex-row"><div class="flex mr-4 min-w-[100px] xs:min-w-[110px] sm:min-w-[150px]">Captain Fantastic:</div> <div class="flex-1">X2 multiplier on the captain’s score for scoring a goal.</div></div> <div class="flex flex-row"><div class="flex mr-4 min-w-[100px] xs:min-w-[110px] sm:min-w-[150px]">Team Boost:</div> <div class="flex-1">X2 multiplier for all players from a single club.</div></div> <div class="flex flex-row"><div class="flex mr-4 min-w-[100px] xs:min-w-[110px] sm:min-w-[150px]">Brace Bonus:</div> <div class="flex-1">X2 multiplier for any player scoring 2+ goals.</div></div> <div class="flex flex-row"><div class="flex mr-4 min-w-[100px] xs:min-w-[110px] sm:min-w-[150px]">Hat-Trick Hero:</div> <div class="flex-1">X3 multiplier for any player scoring 3+ goals.</div></div> <div class="flex flex-row"><div class="flex mr-4 min-w-[100px] xs:min-w-[110px] sm:min-w-[150px]">One Nation:</div> <div class="flex-1">Double points for players of a selected nationality.</div></div> <div class="flex flex-row"><div class="flex mr-4 min-w-[100px] xs:min-w-[110px] sm:min-w-[150px]">Prospects:</div> <div class="flex-1">Double points for players under 21.</div></div> <h2 class="default-header mt-4">Star Player</h2> <p class="my-2">Each week a user can select a star player. This player will receive double
    points for the gameweek. If one is not set by the start of the gameweek it
    will automatically be set to the most valuable player in your team.</p> <h2 class="default-header mt-4">Abandonded Fixtures</h2> <p class="my-2">When a fixture is abandonded it will remain in the fixtures list for a
    gameweek, awaiting the Premier League's decision. Rewards for gameweeks
    where a fixture is abandonded will be witheld until the Premier League
    decide whether one of the follow scenarios occur:</p> <ul class="list-disc ml-4"><li>Result Stands at Abandoned Time: The game be completed with the events as
      at abandoned time and will trigger the gameweek to complete and the
      rewards pool to be paid.</li> <li>Fixture Replayed from Abandonded Time: The game will remain in its initial
      gameweek, apon completion it will trigger the gameweek to complete and the
      rewards pool to be paid.</li> <li>Fixture Rescheduled to New Gameweek: The game will move into a new
      gameweek, the events will be removed from all players and no points from
      the fixture will be awarded.</li></ul> <p class="my-4">OpenFPL's gameplay combines strategic team management, a dynamic scoring
    system, and diverse bonuses to create a unique and competitive fantasy
    football experience. Each decision impacts your journey through the Premier
    League season, where football knowledge and strategy lead to rewarding
    outcomes.</p></div>`;
}
function Marketing($$payload) {
  $$payload.out += `<div class="m-4"><h1 class="default-header">Marketing</h1> <p class="my-4">We will be marketing both online and in-person, taking advantage of being
    based in the UK and having access to millions of Premier League fans.</p> <h2 class="default-header mb-4">Online Marketing Strategy</h2> <p class="my-2">After the SNS we will begin a comprehensive online marketing campaign on all
    major social media platforms using our existing talented team.</p> <h2 class="default-header mt-4">OpenFPL's Initiatives</h2> <p class="my-2">OpenFPL's will integrate its online marketing campaigns with its broader
    initiatives. A key focus will be on targeted local advertising, aiming to
    highlight the distribution of 200 junior football club kits to grassroots
    football causes across the UK.</p> <p class="my-2">In November 2023, a proposal was passed in the OpenChat DAO for them to
    become the official sponsor of OpenFPL. They will appear on our pick team
    advertising boards along with the football apparel given to grassroots
    football causes and sold through the ICPFA shop. We feel this partnership is
    important as promoting the wide arrange of apps available on the IC ecosytem
    will increase the pace at which the world adopts Internet Computer services.</p> <h2 class="default-header mt-4">Future Considerations</h2> <p class="my-2">Outside of traditional digital marketing we plan to explore additional
    areas, such as influencer marketing.</p> <h2 class="default-header">In-Person Event Marketing Strategy</h2> <p class="my-2">As part of our comprehensive marketing plan, OpenFPL is preparing to launch
    a series of in-person, interactive events in cities home to Premier League
    clubs. These events, expected to start from Q2 2024, are inspired by the
    successful engagement strategies of major UK brands like IBM, Ford and
    Coca-Cola.</p> <h2 class="default-header mt-4">Event Planning and Execution</h2> <p class="my-2">We are in discussions with experienced interactive hardware providers and
    event management professionals to assist in creating immersive event
    experiences. We will utilise the expertise of OpenFPL founder, James Beadle,
    in developing and delivering these interactive experiences.</p> <h2 class="default-header mt-4">Event Objectives and Content</h2> <p class="my-2">We would like to teach attendees about OpenFPL and the broader Internet
    Computer ecosystem, including Internet Identity and a variety of IC dApps.
    Facilitating hands-on interactions and demonstrations will provide a deeper
    understanding of OpenFPL's features and benefits.</p> <h2 class="default-header mt-4">Promotion and Community Engagement</h2> <p class="my-2">We plan to promote these events through targeted local advertising, social
    media campaigns, and collaborations with local football clubs and
    communities. We will encouraging participants to share their experiences on
    social media through various reward scheme, amplifying our reach and impact.</p> <h2 class="default-header mt-4">Long-Term Vision</h2> <p class="my-2">We will be exploring opportunities to replicate this event model in other
    regions, expanding OpenFPL's global footprint.</p></div>`;
}
function Revenue($$payload) {
  $$payload.out += `<div class="m-4"><h1 class="default-header">OpenFPL Revenue Streams</h1> <p class="my-4">OpenFPL's revenue model is thoughtfully designed to sustain and grow the DAO
    while ensuring practical utility and value for its users.</p> <h2 class="default-header">Diversified Revenue Model</h2> <p class="my-2">To avoid creating a supply shock by pegging services to a fixed token
    amount, OpenFPL's revenue streams are diversified. This approach mitigates
    the risk of reduced service usage due to infeasibility, ensuring long-term
    stability and utility.</p> <p class="my-2">Revenue streams include Private Leagues, Site Sponsorship, Content Creators,
    Advertising, and Merchandise. These channels provide a balanced mix of $FPL
    and $ICP revenue, enhancing the DAO's financial resilience.</p> <h2 class="default-header mt-4">Private Leagues</h2> <p class="my-2">Private league fees in OpenFPL are charged in ICP to establish a stable
    revenue base. This approach aligns the revenue directly with the number of
    managers, ensuring it scales with user engagement.</p> <h2 class="default-header mt-4">Merchandise</h2> <p class="my-2">We have setup a shop at <a class="text-blue-500" href="https://icpga.org/shop">icpfa.org/shop</a> where you will be able to purchase OpenFPL merchandise in FPL or ICP. All profits
    after the promotion, marketing and production of this merchandise will be deposited
    into the DAO's treasury.</p> <h2 class="default-header">Advertising</h2> <p class="my-2">OpenFPL provides many instances to implement non-intrusive advertising to
    increase the value of the DAO. This includes on the board behind the goal on
    the pick team view along within the content subscription video reel and
    podcasting infrastructure.</p> <h2 class="default-header mt-4">Site Sponsorship</h2> <p class="my-2">Starting from August 2025, following the conclusion of the sponsorship deal
    with OpenChat, OpenFPL will offer the site sponsorship rights for bidding
    through the DAO. This will open opportunities for interested parties to
    become the named sponsor for an entire season.</p> <p class="my-2">Each year, sponsors can submit their bids to become the main site sponsor
    for the upcoming season, offering any ICRC-1 currency. Once a sponsor is
    selected, their exclusive rights will be secure for the entirety of that
    season. The DAO will not allow further proposals for site sponsorship until
    the subsequent preseason, ensuring the sponsor's exclusive visibility and
    association with OpenFPL.</p> <p class="my-2">All sponsorship revenue will be directed into the DAO's treasury,
    contributing to the financial health and sustainability of OpenFPL.</p> <h2 class="default-header mt-4">Content Creators</h2> <p class="my-2">OpenFPL will create a platform for content creators that is designed to both
    empower creators and enhance the utility of the FPL token. Creators will
    produce fantasy football-related content and share it on OpenFPL. This
    content will be available through a video reel format accessible to all
    users.</p> <p class="my-2">For general reel content, creators earn from a pool of FPL tokens, allocated
    based on user likes. Creators can also offer exclusive content for
    subscribers. They will receive 95% of the FPL tokens from these
    subscriptions.</p> <p class="my-2">Subscriptions are purchased exclusively with FPL tokens, enhancing their
    utility. The remaining 5% from subscriptions remains in the DAO's treasury.
    This approach aligns with OpenFPL's commitment to supporting content
    creators, increasing FPL token utility, and rewarding its community of
    neuron holders.</p> <p class="my-2">Revenue will be generated from advertising within OpenFPL services.
    Off-chain profits generated by the ICPFA will be deposited into the DAO's
    treasury.</p> <h2 class="default-header mt-4">Revenue Redistribution Plan</h2> <p class="my-2">In line with our commitment to directly benefit neuron holders, OpenFPL will
    use up to 50% of any ICRC-1 token received by the DAO to purchase $FPL from
    exchanges each month. We will only purchase enough $FPL to burn the total
    supply back down to 100m $FPL. This is also attractive to investors as it
    will remove an inflationary pressures when holding an $FPL position.</p> <p class="my-2">Any remaining ICRC-1 tokens earned by the DAO will remain liquid and can be
    used for whatever the DAO decides.</p></div>`;
}
function Roadmap($$payload) {
  $$payload.out += `<div class="m-4"><h1 class="default-header">Roadmap</h1> <p class="my-4">We have an ambitious roadmap of features:</p> <h2 class="default-sub-header mt-4">Jan - Feb 2024: SNS Testing</h2> <p class="my-2">We will perform comprehensive testing of the OpenFPL gameplay and governance
    features. Detailed descriptions and outcomes of various use case tests,
    demonstrating how gameplay and governance features perform in different
    situations.</p> <h2 class="default-sub-header mt-4">March 1st 2024: OpenFPL SNS Decentralisation Sale</h2> <p class="my-2">We aim to begin our decentralisation sale in March 2024, selling 25 million
    $FPL tokens (25%).</p> <h2 class="default-sub-header mt-4">April 2024: Shirt Production Begins</h2> <p class="my-2">We are actively engaged in shirt production for OpenFPL, moving beyond mere
    concepts to tangible products. Our collaboration with a UK supplier is set
    to kit out 200 junior clubs with OpenFPL-branded shirts for charity, marking
    our first foray into merging style with the spirit of the game. This
    initiative is further elevated by a successful partnership with OpenChat. A
    recent proposal in the OpenChat DAO has been passed, resulting in OpenChat
    sponsoring half of these shirts, a testament to our collaborative efforts
    and shared vision. Concurrently, we are in advanced talks with a
    manufacturer in India, having already developed a promising prototype. We
    are fine-tuning the details to perfect the shirts, with production
    anticipated to commence in just a few months. Additionally, these shirts
    will be available for sale in the ICPFA shop, with a portion of each sale
    benefiting our NFT holders. This dual approach not only strengthens our
    brand presence but also underscores our commitment to supporting grassroots
    football communities and providing value to our NFT investors.</p> <h2 class="default-sub-header mt-4">May 2024: Online Marketing Campaigns</h2> <p class="my-2">We are actively in discussions with a digital marketing agency, preparing to
    launch campaigns aimed at organically growing our base of genuine managers.
    The strategy being formulated focuses on SEO and PPC methods aligned with
    OpenFPL's objectives. These deliberations include choosing the most suitable
    online platforms and crafting a strategy that resonates with our ethos. The
    direction of these campaigns is geared towards measurable outcomes,
    especially in attracting genuine manager sign-ups and naturally expanding
    our online footprint. This approach is designed to cultivate a genuine and
    engaged community, enhancing OpenFPL's presence in a manner that's both
    authentic and impactful.</p> <h2 class="default-sub-header mt-4">June 2024: Private Leagues</h2> <p class="my-2">The Private Leagues feature is the start of building your own OpenFPL
    community within the DAO. Managers will be able to create a Private League
    for a fee of 1 $ICP. Managers will have full control over their rewards
    structure, with features such as: Deciding on the entry fee, if any. Any
    entry fee can be in $FPL, $ICP or ckBTC. Deciding on the rewards structure
    currency, amount and percentage payouts per finishing position.</p> <h2 class="default-sub-header mt-4">June 2024: OpenChat Integration</h2> <p class="my-2">Integrating OpenChat for seamless communication within the OpenFPL
    community, providing updates and increasing engagement through group
    channels and private league communication.</p> <h2 class="default-sub-header mt-4">July 2024: 'The OpenFPL Podcast' Launch</h2> <p class="my-2">Starting with a main podcast, we aim to expand into fan-focused podcasts,
    emulating the model of successful platforms like Arsenal Fan TV. Initially
    audio-based, these podcasts will eventually include video content, adding
    another dimension to our engagement strategy.</p> <h2 class="default-sub-header mt-4">July 2024: OpenFPL Events</h2> <p class="my-2">OpenFPL is set to create a series of interactive experiences at event
    locations in Premier League club cities, drawing inspiration from major UK
    brands like IBM, Ford and Coca-Cola. Planned from Q2 2024 onwards, these
    events will leverage the expertise of OpenFPL founder James Beadle. With his
    experience in creating successful and engaging interactive experiences,
    James will play a key role in educating attendees about OpenFPL, Internet
    Identity and the range of other IC dApps available.</p> <h2 class="default-sub-header mt-4">July 2024: Mobile App Launch</h2> <p class="my-2">We will release a mobile app shortly before the genesis season begins to
    make OpenFPL more accessible and convenient for users on the go.</p> <h2 class="default-sub-header mt-4">August 2024: OpenFPL Genesis Season Begins</h2> <p class="my-2">In August 2024, we launch our inaugural season, where fantasy teams start
    competing for $FPL rewards on a weekly, monthly and annual basis to maximise
    user engagment.</p> <h2 class="default-sub-header mt-4">November 2024: Content Subscription Launch</h2> <p class="my-2">Partnering with Premier League content creators to offer exclusive insights,
    with a unique monetisation model for both free and subscription-based
    content.</p> <h2 class="default-sub-header mt-4">Future: 100% On-Chain AI</h2> <p class="my-2">At OpenFPL, we are exploring the deployment of a 100% on-chain AI model
    within a dedicated canister. Our initial use case for this AI would be to
    integrate a feature within the team selection interface, allowing users to
    receive AI-recommended changes. Users will then have the option to review
    and decide whether to implement these AI suggestions in their team
    management decisions. However, given that the Internet Computer's
    infrastructure is still evolving, especially in terms of on-chain training
    capabilities, our immediate strategy involves training the model off-chain.
    As the IC infrastructure evolves we would look to transition to real-time,
    continual learning for the AI model directly on the IC. Looking ahead, we're
    excited about the potential to develop new models using our constantly
    expanding on-chain dataset, opening up more innovative possibilities for
    OpenFPL.</p></div>`;
}
function Tokenomics($$payload) {
  $$payload.out += `<div class="m-4"><h1 class="default-header my-4">$FPL Utility Token</h1> <h2 class="default-sub-header">Utility and Functionality</h2> <p class="my-2">OpenFPL will be revenue generating and the most important role of the $FPL
    utility token is to manage the OpenFPL treasury. The token is also used
    throughout the OpenFPL ecosystem:</p> <ul class="list-disc ml-4"><li>Rewarding users for gameplay achievements on weekly, monthly, and annual
      bases.</li> <li>Facilitating participation in DAO governance, like raising proposals for
      player revaluation and team detail updates.</li> <li>Rewarding neuron holders upon maturity.</li> <li>Accepting bids for season site sponsorship from organisations.</li> <li>Used for customisable entry fee (along with any ICRC-1 token) requirements
      for private leagues.</li> <li>Purchase of merchandise from the ICPFA shop.</li> <li>Reward content creators for engagement on a football video reel.</li> <li>Facilitate subscriptions to access premium football content from creators.</li></ul> <h2 class="default-sub-header mt-4">Genesis Token Allocation</h2> <p class="my-2">At the outset, OpenFPL's token allocation will be as follows:</p> <ul class="list-disc ml-4"><li>ICPFA: 12%</li> <li>Funded NFT Holders: 12%</li> <li>SNS Decentralisation Sale: 25%</li> <li>DAO Treasury: 51%</li></ul> <p class="my-2">Each SNS decentralisation swap participant will receive their $FPL within 5
    baskets of equal neurons. The neurons will contain the following
    configuration:</p> <ul class="list-disc ml-4"><li>Basket 1: Unlocked with zero dissolve delay.</li> <li>Basket 2: Unlocked with a 3 month dissolve delay.</li> <li>Basket 3: Unlocked with a 6 month dissolve delay.</li> <li>Basket 4: Unlocked with a 9 month dissolve delay.</li> <li>Basket 5: Unlocked with a 12 month dissolve delay.</li></ul> <p class="my-2">Due to an upper limit of 100 neurons being specified when creating a DAO
    each ICPFA team member and funded NFT holder will receive their $FPL within
    a single neuron with a 1 month dissolve delay.</p> <p class="my-2">The OpenFPL founder, James Beadle, will receive his neuron locked for 4
    years with a 2 year dissolve delay.</p> <h2 class="default-sub-header mt-4">DAO Valuation</h2> <p class="my-4">We have used the discounted cashflow method to value the DAO:</p> <p class="text-xs">The financials below are in ICP(ICP/USD = ~$13.50):</p> <div class="hidden md:flex"><table class="w-full text-right border-collapse striped mb-8 mt-4 text-xs lg:text-base"><tbody><tr class="text-right"><th class="text-left px-4">Year</th><th>1</th><th>2</th><th>3</th><th>4</th><th>5</th><th>6</th><th>7</th><th>8</th></tr><tr><td class="h-6"><span></span></td></tr><tr><td class="text-left px-4">Managers</td><td>10,000</td><td>50,000</td><td>250,000</td><td>1,000,000</td><td>2,500,000</td><td>5,000,000</td><td>7,500,000</td><td>10,000,000</td></tr><tr><td class="h-6"><span></span></td></tr><tr><td class="text-left px-4" colspan="9">Revenue:</td></tr><tr><td class="text-left px-4">Private Leagues</td><td>500</td><td>2,500</td><td>12,500</td><td>50,000</td><td>125,000</td><td>250,000</td><td>375,000</td><td>500,000</td></tr><tr><td class="text-left px-4">Merchandising</td><td>5,000</td><td>25,000</td><td>125,000</td><td>500,000</td><td>1,250,000</td><td>2,500,000</td><td>3,750,000</td><td>5,000,000</td></tr><tr><td class="text-left px-4">Content Subscriptions</td><td>10</td><td>50</td><td>250</td><td>1,000</td><td>2,500</td><td>5,000</td><td>7,500</td><td>10,000</td></tr><tr><td class="text-left px-4">Advertising</td><td>1,930</td><td>9,648</td><td>48,241</td><td>192,963</td><td>482,407</td><td>964,815</td><td>1,447,222</td><td>1,929,630</td></tr><tr><td class="text-left px-4">API Data Feed Subscriptions</td><td>370</td><td>1,850</td><td>9,250</td><td>37,000</td><td>92,500</td><td>185,000</td><td>277,500</td><td>370,000</td></tr><tr><td colspan="9" class="h-6"><span></span></td></tr><tr class="font-bold"><td class="text-left px-4">Total Revenue</td><td>7,810</td><td>39,048</td><td>195,241</td><td>780,963</td><td>1,952,407</td><td>3,904,815</td><td>5,857,222</td><td>7,809,630</td></tr><tr><td colspan="9" class="h-6"><span></span></td></tr><tr class="font-bold"><td class="text-left px-4" colspan="8">DAO Valuation:</td><td><b>10,834,969 ICP</b></td></tr></tbody></table></div> <p>The following assumptions have been made:</p> <ul class="list-disc ml-4 text-xs"><li>We can grow to the size of our Web2 competitor over 8 years.</li> <li>Assumed 5% user conversion, each setting up a league at 1 ICP.</li> <li>Estimated 5% user content subscription rate at 5 ICP/month with 5% of this
      revenue going to the DAO.</li> <li>Estimated 5% users spending 10ICP per year on merchandise.</li> <li>In game advertising charged at $0.50 cost per mile.</li></ul> <table class="w-full text-right border-collapse striped mb-8 mt-4 md:hidden"><tbody><tr class="text-right"><th class="text-left">Year</th><th>1</th><th>2</th><th>3</th><th>4</th></tr><tr><td class="h-6"><span></span></td></tr><tr><td class="text-left">Managers</td><td>10,000</td><td>50,000</td><td>250,000</td><td>1,000,000</td></tr><tr><td class="h-6"><span></span></td></tr><tr><td class="text-left" colspan="5">Revenue:</td></tr><tr><td class="text-left">Private Leagues</td><td>500</td><td>2,500</td><td>12,500</td><td>50,000</td></tr><tr><td class="text-left">Merchandising</td><td>5,000</td><td>25,000</td><td>125,000</td><td>500,000</td></tr><tr><td class="text-left">Content Subscriptions</td><td>10</td><td>50</td><td>250</td><td>1,000</td></tr><tr><td class="text-left">Advertising</td><td>482,407</td><td>964,815</td><td>1,447,222</td><td>1,929,630</td></tr><tr><td class="text-left">API Data Feed Subscriptions</td><td>370</td><td>1,850</td><td>9,250</td><td>37,000</td></tr><tr><td colspan="5" class="h-6"><span></span></td></tr><tr class="font-bold"><td class="text-left">Total</td><td>~0.007m</td><td>~0.039m</td><td>~0.19m</td><td>~0.78m</td></tr></tbody><tbody></tbody></table> <table class="w-full text-right border-collapse striped mb-8 mt-4 md:hidden"><tbody><tr class="text-right"><th class="text-left">Year</th><th>5</th><th>6</th><th>7</th><th>8</th></tr><tr><td class="h-6"><span></span></td></tr><tr><td class="text-left">Managers</td><td>2.5m</td><td>5.0m</td><td>7,5m</td><td>10m</td></tr><tr><td class="h-6"><span></span></td></tr><tr><td class="text-left" colspan="5">Revenue:</td></tr><tr><td class="text-left">Private Leagues</td><td>0.125m</td><td>0.25m</td><td>0.375m</td><td>0.5m</td></tr><tr><td class="text-left">Merchandising</td><td>1.25m</td><td>2.5m</td><td>3.75m</td><td>5m</td></tr><tr><td class="text-left">Content Subscriptions</td><td>2,500</td><td>5,000</td><td>7,500</td><td>10,000</td></tr><tr><td class="text-left">Advertising</td><td>0.48m</td><td>0.96m</td><td>1.44m</td><td>1.92m</td></tr><tr><td class="text-left">API Data Feed Subscriptions</td><td>0.09m</td><td>0.18m</td><td>0.27m</td><td>0.37m</td></tr><tr><td colspan="5" class="h-6"><span></span></td></tr><tr class="font-bold"><td class="text-left">Total</td><td>~1.95m</td><td>~3.9m</td><td>~5.8m</td><td>~7.8m</td></tr><tr><td colspan="5" class="h-6"><span></span></td></tr><tr class="font-bold"><td class="text-left" colspan="4">SNS Value (25%)</td><td>1,531,250</td></tr></tbody></table> <h2 class="default-sub-header mt-4">SNS Decentralisation Sale Configuration</h2> <table class="w-full text-left border-collapse striped mb-8 mt-4"><tbody><tr><th>Configuration</th><th>Value</th></tr><tr><td class="h-6"><span></span></td></tr><tr><td>The total number of FPL tokens to be sold.</td><td>25,000,000 (25%)</td></tr><tr><td>The maximum ICP to be raised.</td><td>1,000,000</td></tr><tr><td>The minimum ICP to be raised (otherwise sale fails and ICP returned).</td><td>100</td></tr><tr><td>The ICP from the Community Fund.</td><td>Matched Funding Enabled</td></tr><tr><td>Sale start date.</td><td>15th March 2024</td></tr><tr><td>Minimum number of sale participants.</td><td>100</td></tr><tr><td>Minimum ICP per buyer.</td><td>1</td></tr><tr><td>Maximum ICP per buyer.</td><td>100,000</td></tr></tbody></table> <h2 class="default-sub-header mt-4">Mitigation against a 51% Attack</h2> <p class="my-2">There is a danger that the OpenFPL SNS treasury could be the target of an
    attack. One possible scenario is for an attacker to buy a large proportion
    of the FPL tokens in the decentralisation sale and immediately increase the
    dissolve delay of all of their neurons to the maximum 4 year in an attempt
    to gain more than 50% of the SNS voting power. If successful they could
    force through a proposal to transfer the entire ICP and FPL treasury to
    themselves. The Community Fund actually provides a great deal of mitigation
    against this scenario because it limits the proportion of voting power an
    attacker would be able to acquire.</p> <p class="my-2">The amount raised in the decentralisation will be used as follows:</p> <ul class="list-disc ml-4"><li>80% will be staked in an 8 year neuron with the maturity interest paid to
      the ICPFA.</li> <li>10% will be available for exchange liquidity to enable trading of the FPL
      token.</li> <li>5% will be paid directly to the ICPFA after the decentralisation sale.</li> <li>5% will be held in reserve for cycles to run OpenFPL, likely to be unused
      as OpenFPL begins generating revenue.</li></ul> <p class="my-2">This treasury balance will be topped up with the DAO's revenue, with 50%
    being use to buy back &amp; burn $FPL with any excess balance can available for
    the DAO to use.</p> <h2 class="default-sub-header mt-4">Tokenomics</h2> <p class="my-2">Each season, 1.875% of the total $FPL supply will be minted for gameplay
    rewards. It will be ICPFA policy to raise proposals to use up to 50% of the
    revenue deposited into the DAO's treasury to purchase $FPL from exchanges.
    Using this available ICP, the DAO will purchase $FPL up to an amount that
    would burn the total supply back to 100m $FPL.</p> <h2 class="default-sub-header mt-4">ICPFA Overview</h2> <p class="my-2">The ICPFA oversees the development, marketing, and management of OpenFPL.
    The aim is to build a strong team to guide OpenFPL's growth and bring new
    users to the ICP blockchain. Additionally, 25% of the ICPFA's earned
    maturity interest will contribute to the ICPFA Community Fund, supporting
    grassroots football projects. Maturity interest will be claimed
    retrospectively after it has been earned by the ICPFA.</p> <p class="my-2">The ICPFA will receive 5% of the decentralisation sale along with the
    maturity interest from the staked neuron. These funds will be use for the
    following:</p> <ul class="list-disc ml-4"><li>The ongoing promotion and marketing of OpenFPL both online and offline.</li> <li>Hiring of a frontend and backend developer to assist the founder with the
      development on the private leagues and mobile app features.</li> <li>Hiring of a UAT Test Engineer to ensure all ICPFA products are of the
      highest quality.</li> <li>Hiring of a Marketing Manager.</li></ul> <p class="my-2">Along with paying the founding team members:</p> <ul class="list-disc ml-4"><li>James Beadle - Founder, Lead Developer</li> <li>George Robinson - Community Manager</li></ul> <p class="my-2">More details about the ICPFA and its members can be found at <a class="text-blue-500" href="https://icpfa.org/team">icpfa.org/team</a>.</p></div>`;
}
function Vision($$payload) {
  $$payload.out += `<div class="m-4"><h1 class="default-header">Our Vision</h1> <p class="my-4">OpenFPL was created as our answer to the question:</p> <p class="my-2"><i>"How do you introduce the most new users to the Internet Computer
      Blockchain?"</i>.</p> <p class="my-4">Football is the most popular sport in the world, with billions of fans, the
    leading fantasy football game engages over 10 million players a season.
    OpenFPL is a better, more equitable, decentralised fantasy football platform
    for football fans worldwide. We have used our football knowledge to create a
    more engaging game, coupled with token distribution to ensure users are more
    equitably rewarded for their successful pariticipation.</p> <p class="my-4 default-header">Why The Internet Computer?</p> <p>The Internet Computer (IC) is the only computer system in the world that
    allows users of an online service to truly own that service. The IC's unique
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
    OpenFPL's ability to bring about positive change in the football community
    using the IC.</p> <p class="my-4 mb-4">In essence OpenFPL will be the world's game on the world's computer. A truly
    decentralised service, the fans home for Premier League football.</p></div>`;
}
function _page($$payload) {
  let activeTab = "vision";
  const tabs = [
    {
      id: "vision",
      label: "Vision",
      authOnly: false
    },
    {
      id: "gameplay",
      label: "Gameplay",
      authOnly: false
    },
    { id: "dao", label: "DAO", authOnly: false },
    {
      id: "tokenomics",
      label: "Tokenomics",
      authOnly: false
    },
    {
      id: "revenue",
      label: "Revenue",
      authOnly: false
    },
    {
      id: "marketing",
      label: "Marketing",
      authOnly: false
    },
    {
      id: "architecture",
      label: "Architecture",
      authOnly: false
    },
    {
      id: "roadmap",
      label: "Roadmap",
      authOnly: false
    }
  ];
  function setActiveTab(tab) {
    activeTab = tab;
  }
  Layout($$payload, {
    children: ($$payload2) => {
      $$payload2.out += `<div class="bg-panel mt-4"><h1 class="p-4 mx-1 default-header">OpenFPL Whitepaper</h1> `;
      Tab_container($$payload2, {
        tabs,
        activeTab,
        setActiveTab,
        isLoggedIn: false
      });
      $$payload2.out += `<!----> `;
      if (activeTab === "vision") {
        $$payload2.out += "<!--[-->";
        Vision($$payload2);
      } else {
        $$payload2.out += "<!--[!-->";
        if (activeTab === "gameplay") {
          $$payload2.out += "<!--[-->";
          Gameplay($$payload2);
        } else {
          $$payload2.out += "<!--[!-->";
          if (activeTab === "roadmap") {
            $$payload2.out += "<!--[-->";
            Roadmap($$payload2);
          } else {
            $$payload2.out += "<!--[!-->";
            if (activeTab === "revenue") {
              $$payload2.out += "<!--[-->";
              Revenue($$payload2);
            } else {
              $$payload2.out += "<!--[!-->";
              if (activeTab === "marketing") {
                $$payload2.out += "<!--[-->";
                Marketing($$payload2);
              } else {
                $$payload2.out += "<!--[!-->";
                if (activeTab === "dao") {
                  $$payload2.out += "<!--[-->";
                  Dao($$payload2);
                } else {
                  $$payload2.out += "<!--[!-->";
                  if (activeTab === "tokenomics") {
                    $$payload2.out += "<!--[-->";
                    Tokenomics($$payload2);
                  } else {
                    $$payload2.out += "<!--[!-->";
                    if (activeTab === "architecture") {
                      $$payload2.out += "<!--[-->";
                      Architecture($$payload2);
                    } else {
                      $$payload2.out += "<!--[!-->";
                    }
                    $$payload2.out += `<!--]-->`;
                  }
                  $$payload2.out += `<!--]-->`;
                }
                $$payload2.out += `<!--]-->`;
              }
              $$payload2.out += `<!--]-->`;
            }
            $$payload2.out += `<!--]-->`;
          }
          $$payload2.out += `<!--]-->`;
        }
        $$payload2.out += `<!--]-->`;
      }
      $$payload2.out += `<!--]--></div>`;
    },
    $$slots: { default: true }
  });
}
export {
  Error$1 as E,
  Layout$1 as L,
  Server as S,
  _page$9 as _,
  set_building as a,
  set_manifest as b,
  set_prerendering as c,
  set_private_env as d,
  set_public_env as e,
  set_read_implementation as f,
  get_hooks as g,
  set_safe_public_env as h,
  _page$8 as i,
  _page$7 as j,
  _page$6 as k,
  _page$5 as l,
  _page$4 as m,
  _page$3 as n,
  options as o,
  _page$2 as p,
  _page$1 as q,
  _page as r,
  set_assets as s
};
