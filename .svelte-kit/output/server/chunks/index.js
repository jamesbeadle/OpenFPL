import { D as DEV } from "./vendor.js";
import * as devalue from "devalue";
import { parse, serialize } from "cookie";
import * as set_cookie_parser from "set-cookie-parser";
import { HttpAgent, Actor } from "@dfinity/agent";
import { nonNullish, isNullish } from "@dfinity/utils";
import "dompurify";
import { AuthClient } from "@dfinity/auth-client";
let base = "";
let assets = base;
const initial = { base, assets };
function reset() {
  base = initial.base;
  assets = initial.assets;
}
function set_assets(path) {
  assets = initial.assets = path;
}
const SVELTE_KIT_ASSETS = "/_svelte_kit_assets";
const ENDPOINT_METHODS = /* @__PURE__ */ new Set([
  "GET",
  "POST",
  "PUT",
  "PATCH",
  "DELETE",
  "OPTIONS",
  "HEAD"
]);
const PAGE_METHODS = /* @__PURE__ */ new Set(["GET", "POST", "HEAD"]);
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
  constructor(status, body) {
    this.status = status;
    if (typeof body === "string") {
      this.body = { message: body };
    } else if (body) {
      this.body = body;
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
class ActionFailure {
  /**
   * @param {number} status
   * @param {T} [data]
   */
  constructor(status, data) {
    this.status = status;
    this.data = data;
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
function error(status, body) {
  if (isNaN(status) || status < 400 || status > 599) {
    throw new Error(`HTTP error status codes must be between 400 and 599 — ${status} is invalid`);
  }
  return new HttpError(status, body);
}
function json(data, init2) {
  const body = JSON.stringify(data);
  const headers = new Headers(init2?.headers);
  if (!headers.has("content-length")) {
    headers.set("content-length", encoder$3.encode(body).byteLength.toString());
  }
  if (!headers.has("content-type")) {
    headers.set("content-type", "application/json");
  }
  return new Response(body, {
    ...init2,
    headers
  });
}
const encoder$3 = new TextEncoder();
function text(body, init2) {
  const headers = new Headers(init2?.headers);
  if (!headers.has("content-length")) {
    const encoded = encoder$3.encode(body);
    headers.set("content-length", encoded.byteLength.toString());
    return new Response(encoded, {
      ...init2,
      headers
    });
  }
  return new Response(body, {
    ...init2,
    headers
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
function normalize_error(error2) {
  return (
    /** @type {import('../runtime/control.js').Redirect | import('../runtime/control.js').HttpError | Error} */
    error2
  );
}
let public_env = {};
function set_private_env(environment) {
}
function set_public_env(environment) {
  public_env = environment;
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
  const allowed = Array.from(ENDPOINT_METHODS).filter((method) => method in mod);
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
async function handle_fatal_error(event, options2, error2) {
  error2 = error2 instanceof HttpError ? error2 : coalesce_to_error(error2);
  const status = error2 instanceof HttpError ? error2.status : 500;
  const body = await handle_error_and_jsonify(event, options2, error2);
  const type = negotiate(event.request.headers.get("accept") || "text/html", [
    "application/json",
    "text/html"
  ]);
  if (event.isDataRequest || type === "application/json") {
    return json(body, {
      status
    });
  }
  return static_error_page(options2, status, body.message);
}
async function handle_error_and_jsonify(event, options2, error2) {
  if (error2 instanceof HttpError) {
    return error2.body;
  } else {
    return await options2.hooks.handleError({ error: error2, event }) ?? {
      message: event.route.id != null ? "Internal Error" : "Not Found"
    };
  }
}
function redirect_response(status, location) {
  const response = new Response(void 0, {
    status,
    headers: { location }
  });
  return response;
}
function clarify_devalue_error(event, error2) {
  if (error2.path) {
    return `Data returned from \`load\` while rendering ${event.route.id} is not serializable: ${error2.message} (data${error2.path})`;
  }
  if (error2.path === "") {
    return `Data returned from \`load\` while rendering ${event.route.id} is not a plain object`;
  }
  return error2.message;
}
function stringify_uses(node) {
  const uses = [];
  if (node.uses && node.uses.dependencies.size > 0) {
    uses.push(`"dependencies":${JSON.stringify(Array.from(node.uses.dependencies))}`);
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
  const { method, headers } = event.request;
  if (ENDPOINT_METHODS.has(method) && !PAGE_METHODS.has(method)) {
    return true;
  }
  if (method === "POST" && headers.get("x-sveltekit-action") === "true")
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
    "searchParams",
    "toString",
    "toJSON"
  ]
);
function make_trackable(url, callback) {
  const tracked = new URL(url);
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
  disable_hash(tracked);
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
function has_data_suffix(pathname) {
  return pathname.endsWith(DATA_SUFFIX);
}
function add_data_suffix(pathname) {
  return pathname.replace(/\/$/, "") + DATA_SUFFIX;
}
function strip_data_suffix(pathname) {
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
    const no_actions_error = error(405, "POST method not allowed. No actions exist for this page");
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
        status: err instanceof HttpError ? err.status : 500
      }
    );
  }
}
function check_incorrect_fail_use(error2) {
  return error2 instanceof ActionFailure ? new Error('Cannot "throw fail()". Use "return fail()"') : error2;
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
      error: error(405, "POST method not allowed. No actions exist for this page")
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
    throw new Error(`No action with name '${name}' found`);
  }
  if (!is_form_content_type(event.request)) {
    throw new Error(
      `Actions expect form-encoded data (received ${event.request.headers.get("content-type")})`
    );
  }
  return action(event);
}
function validate_action_return(data) {
  if (data instanceof Redirect) {
    throw new Error("Cannot `return redirect(...)` — use `throw redirect(...)` instead");
  }
  if (data instanceof HttpError) {
    throw new Error(
      "Cannot `return error(...)` — use `throw error(...)` or `return fail(...)` instead"
    );
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
    const error2 = (
      /** @type {any} */
      e
    );
    if ("path" in error2) {
      let message = `Data returned from action inside ${route_id} is not serializable: ${error2.message}`;
      if (error2.path !== "")
        message += ` (data.${error2.path})`;
      throw new Error(message);
    }
    throw error2;
  }
}
async function unwrap_promises(object) {
  for (const key2 in object) {
    if (typeof object[key2]?.then === "function") {
      return Object.fromEntries(
        await Promise.all(Object.entries(object).map(async ([key3, value]) => [key3, await value]))
      );
    }
  }
  return object;
}
const INVALIDATED_PARAM = "x-sveltekit-invalidated";
const TRAILING_SLASH_PARAM = "x-sveltekit-trailing-slash";
async function load_server_data({
  event,
  state,
  node,
  parent,
  // TODO 2.0: Remove this
  track_server_fetches
}) {
  if (!node?.server)
    return null;
  const uses = {
    dependencies: /* @__PURE__ */ new Set(),
    params: /* @__PURE__ */ new Set(),
    parent: false,
    route: false,
    url: false
  };
  const url = make_trackable(event.url, () => {
    uses.url = true;
  });
  if (state.prerendering) {
    disable_search(url);
  }
  const result = await node.server.load?.call(null, {
    ...event,
    fetch: (info, init2) => {
      const url2 = new URL(info instanceof Request ? info.url : info, event.url);
      if (track_server_fetches) {
        uses.dependencies.add(url2.href);
      }
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
        uses.params.add(key2);
        return target[
          /** @type {string} */
          key2
        ];
      }
    }),
    parent: async () => {
      uses.parent = true;
      return parent();
    },
    route: new Proxy(event.route, {
      get: (target, key2) => {
        uses.route = true;
        return target[
          /** @type {'id'} */
          key2
        ];
      }
    }),
    url
  });
  const data = result ? await unwrap_promises(result) : null;
  return {
    type: "data",
    data,
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
    parent
  });
  const data = result ? await unwrap_promises(result) : null;
  return data;
}
function create_universal_fetch(event, state, fetched, csr, resolve_opts) {
  return async (input, init2) => {
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
        async function text2() {
          const body = await response2.text();
          if (!body || typeof body === "string") {
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
              response_body: body,
              response: response2
            });
          }
          if (dependency) {
            dependency.body = body;
          }
          return body;
        }
        if (key2 === "arrayBuffer") {
          return async () => {
            const buffer = await response2.arrayBuffer();
            if (dependency) {
              dependency.body = new Uint8Array(buffer);
            }
            return buffer;
          };
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
      const get = response.headers.get;
      response.headers.get = (key2) => {
        const lower = key2.toLowerCase();
        const value = get.call(response.headers, lower);
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
function serialize_data(fetched, filter, prerendering = false) {
  const headers = {};
  let cache_control = null;
  let age = null;
  let varyAny = false;
  for (const [key2, value] of fetched.response.headers) {
    if (filter(key2, value)) {
      headers[key2] = value;
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
    headers,
    body: fetched.response_body
  };
  const safe_payload = JSON.stringify(payload).replace(pattern, (match) => replacements[match]);
  const attrs = [
    'type="application/json"',
    "data-sveltekit-fetched",
    `data-url=${escape_html_attr(fetched.url)}`
  ];
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
  if (!prerendering && fetched.method === "GET" && cache_control && !varyAny) {
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
  #style_src;
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
    this.#style_src = [];
    const effective_script_src = d["script-src"] || d["default-src"];
    const effective_style_src = d["style-src"] || d["default-src"];
    this.#script_needs_csp = !!effective_script_src && effective_script_src.filter((value) => value !== "unsafe-inline").length > 0;
    this.#style_needs_csp = !!effective_style_src && effective_style_src.filter((value) => value !== "unsafe-inline").length > 0;
    this.script_needs_nonce = this.#script_needs_csp && !this.#use_hashes;
    this.style_needs_nonce = this.#style_needs_csp && !this.#use_hashes;
    this.#nonce = nonce;
  }
  /** @param {string} content */
  add_script(content) {
    if (this.#script_needs_csp) {
      if (this.#use_hashes) {
        this.#script_src.push(`sha256-${sha256(content)}`);
      } else if (this.#script_src.length === 0) {
        this.#script_src.push(`nonce-${this.#nonce}`);
      }
    }
  }
  /** @param {string} content */
  add_style(content) {
    if (this.#style_needs_csp) {
      if (this.#use_hashes) {
        this.#style_src.push(`sha256-${sha256(content)}`);
      } else if (this.#style_src.length === 0) {
        this.#style_src.push(`nonce-${this.#nonce}`);
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
    if (this.#script_src.length > 0) {
      directives["script-src"] = [
        ...directives["script-src"] || directives["default-src"] || [],
        ...this.#script_src
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
  error: error2 = null,
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
      error: error2,
      params: (
        /** @type {Record<string, any>} */
        event.params
      ),
      route: event.route,
      status,
      url: event.url,
      data: data2,
      form: form_value
    };
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
  let body = rendered.html;
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
    body += `
			${fetched.map(
      (item) => serialize_data(item, resolve_opts.filterSerializedResponseHeaders, !!state.prerendering)
    ).join("\n			")}`;
  }
  if (page_config.csr) {
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
    const properties = [
      assets && `assets: ${s(assets)}`,
      `base: ${base_expression}`,
      `env: ${s(public_env)}`
    ].filter(Boolean);
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
      if (error2) {
        serialized.error = devalue.uneval(error2);
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
      args.push(`{
							${hydrate.join(",\n							")}
						}`);
    }
    blocks.push(`Promise.all([
						import(${s(prefixed(client.start))}),
						import(${s(prefixed(client.app))})
					]).then(([kit, app]) => {
						kit.start(${args.join(", ")});
					});`);
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
    body += `
			<script${csp.script_needs_nonce ? ` nonce="${csp.nonce}"` : ""}>${init_app}<\/script>
		`;
  }
  const headers = new Headers({
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
      headers.set("content-security-policy", csp_header);
    }
    const report_only_header = csp.report_only_provider.get_header();
    if (report_only_header) {
      headers.set("content-security-policy-report-only", report_only_header);
    }
    if (link_header_preloads.size) {
      headers.set("link", Array.from(link_header_preloads).join(", "));
    }
  }
  head += rendered.head;
  const html = options2.templates.app({
    head,
    body,
    assets: assets$1,
    nonce: (
      /** @type {string} */
      csp.nonce
    ),
    env: public_env
  });
  const transformed = await resolve_opts.transformPageChunk({
    html,
    done: true
  }) || "";
  if (!chunks) {
    headers.set("etag", `"${hash(transformed)}"`);
  }
  return !chunks ? text(transformed, {
    status,
    headers
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
        async (error2) => ({
          error: await handle_error_and_jsonify(event, options2, error2)
        })
      ).then(
        /**
         * @param {{data: any; error: any}} result
         */
        async ({ data, error: error2 }) => {
          count -= 1;
          let str;
          try {
            str = devalue.uneval({ id, data, error: error2 }, replacer2);
          } catch (e) {
            error2 = await handle_error_and_jsonify(
              event,
              options2,
              new Error(`Failed to serialize promise while rendering ${event.route.id}`)
            );
            data = void 0;
            str = devalue.uneval({ id, data, error: error2 }, replacer2);
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
  error: error2,
  resolve_opts
}) {
  if (event.request.headers.get("x-sveltekit-error")) {
    return static_error_page(
      options2,
      status,
      /** @type {Error} */
      error2.message
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
        parent: async () => ({}),
        track_server_fetches: options2.track_server_fetches
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
        csr: get_option([default_layout], "csr") ?? true
      },
      status,
      error: await handle_error_and_jsonify(event, options2, error2),
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
      e instanceof HttpError ? e.status : 500,
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
            },
            track_server_fetches: options2.track_server_fetches
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
        (p, i) => p.catch(async (error2) => {
          if (error2 instanceof Redirect) {
            throw error2;
          }
          length = Math.min(length, i + 1);
          return (
            /** @type {import('types').ServerErrorNode} */
            {
              type: "error",
              error: await handle_error_and_jsonify(event, options2, error2),
              status: error2 instanceof HttpError ? error2.status : void 0
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
    const error2 = normalize_error(e);
    if (error2 instanceof Redirect) {
      return redirect_json_response(error2);
    } else {
      return json_response(await handle_error_and_jsonify(event, options2, error2), 500);
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
              const error2 = await handle_error_and_jsonify(
                event,
                options2,
                new Error(`Failed to serialize promise while rendering ${event.route.id}`)
              );
              key2 = "error";
              str = devalue.stringify(error2, reducers);
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
    const nodes = await Promise.all([
      // we use == here rather than === because [undefined] serializes as "[null]"
      ...page2.layouts.map((n) => n == void 0 ? n : manifest._.nodes[n]()),
      manifest._.nodes[page2.leaf]()
    ]);
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
        const error2 = action_result.error;
        status = error2 instanceof HttpError ? error2.status : 500;
      }
      if (action_result?.type === "failure") {
        status = action_result.status;
      }
    }
    const should_prerender_data = nodes.some((node) => node?.server);
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
    if (get_option(nodes, "ssr") === false && !state.prerendering) {
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
            },
            track_server_fetches: options2.track_server_fetches
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
              const body = JSON.stringify({
                type: "redirect",
                location: err.location
              });
              state.prerendering.dependencies.set(data_pathname, {
                response: text(body),
                body
              });
            }
            return redirect_response(err.status, err.location);
          }
          const status2 = err instanceof HttpError ? err.status : 500;
          const error2 = await handle_error_and_jsonify(event, options2, err);
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
                error: error2,
                branch: compact(branch.slice(0, j + 1)).concat({
                  node: node2,
                  data: null,
                  server_data: null
                }),
                fetched
              });
            }
          }
          return static_error_page(options2, status2, error2.message);
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
    return await render_response({
      event,
      options: options2,
      manifest,
      state,
      resolve_opts,
      page_config: {
        csr: get_option(nodes, "csr") ?? true,
        ssr: get_option(nodes, "ssr") ?? true
      },
      status,
      error: null,
      branch: compact(branch),
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
function get_cookies(request, url, trailing_slash) {
  const header = request.headers.get("cookie") ?? "";
  const initial_cookies = parse(header, { decode: (value) => value });
  const normalized_url = normalize_path(url.pathname, trailing_slash);
  const default_path = normalized_url.split("/").slice(0, -1).join("/") || "/";
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
     * @param {import('cookie').CookieSerializeOptions} opts
     */
    set(name, value, opts = {}) {
      set_internal(name, value, { ...defaults, ...opts });
    },
    /**
     * @param {string} name
     * @param {import('cookie').CookieSerializeOptions} opts
     */
    delete(name, opts = {}) {
      cookies.set(name, "", {
        ...opts,
        maxAge: 0
      });
    },
    /**
     * @param {string} name
     * @param {string} value
     * @param {import('cookie').CookieSerializeOptions} opts
     */
    serialize(name, value, opts) {
      return serialize(name, value, {
        ...defaults,
        ...opts
      });
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
  function set_internal(name, value, opts) {
    const path = opts.path ?? default_path;
    new_cookies[name] = {
      name,
      value,
      options: {
        ...opts,
        path
      }
    };
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
function add_cookies_to_headers(headers, cookies) {
  for (const new_cookie of cookies) {
    const { name, value, options: options2 } = new_cookie;
    headers.append("set-cookie", serialize(name, value, options2));
  }
}
function create_fetch({ event, options: options2, manifest, state, get_cookie_header, set_internal }) {
  return async (info, init2) => {
    const original_request = normalize_fetch_input(info, init2, event.url);
    let mode = (info instanceof Request ? info.mode : init2?.mode) ?? "cors";
    let credentials = (info instanceof Request ? info.credentials : init2?.credentials) ?? "same-origin";
    return await options2.hooks.handleFetch({
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
            set_internal(
              name,
              value,
              /** @type {import('cookie').CookieSerializeOptions} */
              options3
            );
          }
        }
        return response;
      }
    });
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
      const csrf_error = error(403, `Cross-site ${request.method} form submissions are forbidden`);
      if (request.headers.get("accept") === "application/json") {
        return json(csrf_error.body, { status: csrf_error.status });
      }
      return text(csrf_error.body.message, { status: csrf_error.status });
    }
  }
  let decoded;
  try {
    decoded = decode_pathname(url.pathname);
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
  const headers = {};
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
        } else if (lower in headers) {
          throw new Error(`"${key2}" header is already set`);
        } else {
          headers[lower] = value;
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
        const nodes = await Promise.all([
          // we use == here rather than === because [undefined] serializes as "[null]"
          ...route.page.layouts.map((n) => n == void 0 ? n : manifest._.nodes[n]()),
          manifest._.nodes[route.page.leaf]()
        ]);
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
      resolve: (event2, opts) => resolve(event2, opts).then((response2) => {
        for (const key2 in headers) {
          const value = headers[key2];
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
      const etag = (
        /** @type {string} */
        response.headers.get("etag")
      );
      if (if_none_match_value === etag) {
        const headers2 = new Headers({ etag });
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
            headers2.set(key2, value);
        }
        return new Response(void 0, {
          status: 304,
          headers: headers2
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
  async function resolve(event2, opts) {
    try {
      if (opts) {
        if ("ssr" in opts) {
          throw new Error(
            "ssr has been removed, set it in the appropriate +layout.js instead. See the PR for more information: https://github.com/sveltejs/kit/pull/6197"
          );
        }
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
          error: new Error(`Not found: ${event2.url.pathname}`),
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
function set_building() {
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
const options = {
  app_template_contains_nonce: false,
  csp: { "mode": "auto", "directives": { "upgrade-insecure-requests": false, "block-all-mixed-content": false }, "reportOnly": { "upgrade-insecure-requests": false, "block-all-mixed-content": false } },
  csrf_check_origin: true,
  track_server_fetches: false,
  embedded: false,
  env_public_prefix: "PUBLIC_",
  env_private_prefix: "",
  hooks: null,
  // added lazily, via `get_hooks`
  preload_strategy: "modulepreload",
  root: Root,
  service_worker: false,
  templates: {
    app: ({ head, body, assets: assets2, nonce, env }) => '<!DOCTYPE html>\n<html lang="en">\n  <head>\n    <meta charset="utf-8" />\n    <meta content="width=device-width, initial-scale=1" name="viewport" />\n\n    <title>OpenFPL</title>\n    <link href="https://openfpl.xyz" rel="canonical" />\n    <meta\n      content="OpenFPL is a decentralised fantasy football game on the Internet Computer blockchain."\n      name="description"\n    />\n    <meta content="OpenFPL" property="og:title" />\n    <meta\n      content="OpenFPL is a decentralised fantasy football game on the Internet Computer blockchain."\n      property="og:description"\n    />\n    <meta content="website" property="og:type" />\n    <meta content="https://openfpl.xyz" property="og:url" />\n    <meta content="https://openfpl.xyz/meta-share.jpg" property="og:image" />\n    <meta content="summary_large_image" name="twitter:card" />\n    <meta content="OpenFPL" name="twitter:title" />\n    <meta\n      content="OpenFPL is a decentralised fantasy football game on the Internet Computer blockchain."\n      name="twitter:description"\n    />\n    <meta content="https://openfpl.xyz/meta-share.jpg" name="twitter:image" />\n    <meta content="@beadle1989" name="twitter:creator" />\n\n    <link crossorigin="anonymous" href="/manifest.webmanifest" rel="manifest" />\n\n    <!-- Favicon -->\n    <link\n      rel="icon"\n      type="image/png"\n      sizes="32x32"\n      href="' + assets2 + '/favicons/favicon-32x32.png"\n    />\n    <link\n      rel="icon"\n      type="image/png"\n      sizes="16x16"\n      href="' + assets2 + '/favicons/favicon-16x16.png"\n    />\n    <link rel="shortcut icon" href="' + assets2 + '/favicons/favicon.ico" />\n\n    <!-- iOS meta tags & icons -->\n    <meta name="apple-mobile-web-app-capable" content="yes" />\n    <meta name="apple-mobile-web-app-status-bar-style" content="#2CE3A6" />\n    <meta name="apple-mobile-web-app-title" content="OpenFPL" />\n    <link\n      rel="apple-touch-icon"\n      href="' + assets2 + '/favicons/apple-touch-icon.png"\n    />\n    <link\n      rel="mask-icon"\n      href="' + assets2 + '/favicons/safari-pinned-tab.svg"\n      color="#2CE3A6"\n    />\n\n    <!-- MS -->\n    <meta name="msapplication-TileColor" content="#2CE3A6" />\n    <meta\n      name="msapplication-config"\n      content="' + assets2 + '/favicons/browserconfig.xml"\n    />\n\n    <meta content="#2CE3A6" name="theme-color" />\n    ' + head + '\n\n    <style>\n      html,\n      body {\n        height: 100%;\n        margin: 0;\n      }\n\n      @font-face {\n        font-display: swap;\n        font-family: "Poppins";\n        font-style: normal;\n        font-weight: 400;\n        src: url("' + assets2 + '/poppins-regular-webfont.woff2")\n          format("woff2");\n      }\n\n      @font-face {\n        font-display: swap;\n        font-family: "Manrope";\n        font-style: normal;\n        font-weight: 400;\n        src: url("' + assets2 + '/Manrope-Regular.woff2") format("woff2");\n      }\n      body {\n        font-family: "Poppins", sans-serif !important;\n        color: white !important;\n        background-color: #1a1a1d;\n        height: 100vh;\n        margin: 0;\n        background-image: url("' + assets2 + '/background.jpg");\n        background-size: cover;\n        background-position: center;\n        background-repeat: no-repeat;\n        background-attachment: fixed;\n      }\n\n      #app-spinner {\n        --spinner-size: 30px;\n\n        width: var(--spinner-size);\n        height: var(--spinner-size);\n\n        animation: app-spinner-linear-rotate 2000ms linear infinite;\n\n        position: absolute;\n        top: calc(50% - (var(--spinner-size) / 2));\n        left: calc(50% - (var(--spinner-size) / 2));\n\n        --radius: 45px;\n        --circumference: calc(3.14159265359 * var(--radius) * 2);\n\n        --start: calc((1 - 0.05) * var(--circumference));\n        --end: calc((1 - 0.8) * var(--circumference));\n      }\n\n      #app-spinner circle {\n        stroke-dasharray: var(--circumference);\n        stroke-width: 10%;\n        transform-origin: 50% 50% 0;\n\n        transition-property: stroke;\n\n        animation-name: app-spinner-stroke-rotate-100;\n        animation-duration: 4000ms;\n        animation-timing-function: cubic-bezier(0.35, 0, 0.25, 1);\n        animation-iteration-count: infinite;\n\n        fill: transparent;\n        stroke: currentColor;\n\n        transition: stroke-dashoffset 225ms linear;\n      }\n\n      @keyframes app-spinner-linear-rotate {\n        0% {\n          transform: rotate(0deg);\n        }\n        100% {\n          transform: rotate(360deg);\n        }\n      }\n\n      @keyframes app-spinner-stroke-rotate-100 {\n        0% {\n          stroke-dashoffset: var(--start);\n          transform: rotate(0);\n        }\n        12.5% {\n          stroke-dashoffset: var(--end);\n          transform: rotate(0);\n        }\n        12.5001% {\n          stroke-dashoffset: var(--end);\n          transform: rotateX(180deg) rotate(72.5deg);\n        }\n        25% {\n          stroke-dashoffset: var(--start);\n          transform: rotateX(180deg) rotate(72.5deg);\n        }\n\n        25.0001% {\n          stroke-dashoffset: var(--start);\n          transform: rotate(270deg);\n        }\n        37.5% {\n          stroke-dashoffset: var(--end);\n          transform: rotate(270deg);\n        }\n        37.5001% {\n          stroke-dashoffset: var(--end);\n          transform: rotateX(180deg) rotate(161.5deg);\n        }\n        50% {\n          stroke-dashoffset: var(--start);\n          transform: rotateX(180deg) rotate(161.5deg);\n        }\n\n        50.0001% {\n          stroke-dashoffset: var(--start);\n          transform: rotate(180deg);\n        }\n        62.5% {\n          stroke-dashoffset: var(--end);\n          transform: rotate(180deg);\n        }\n        62.5001% {\n          stroke-dashoffset: var(--end);\n          transform: rotateX(180deg) rotate(251.5deg);\n        }\n        75% {\n          stroke-dashoffset: var(--start);\n          transform: rotateX(180deg) rotate(251.5deg);\n        }\n\n        75.0001% {\n          stroke-dashoffset: var(--start);\n          transform: rotate(90deg);\n        }\n        87.5% {\n          stroke-dashoffset: var(--end);\n          transform: rotate(90deg);\n        }\n        87.5001% {\n          stroke-dashoffset: var(--end);\n          transform: rotateX(180deg) rotate(341.5deg);\n        }\n        100% {\n          stroke-dashoffset: var(--start);\n          transform: rotateX(180deg) rotate(341.5deg);\n        }\n      }\n    </style>\n  </head>\n  <body data-sveltekit-preload-data="hover">\n    <div style="display: contents">' + body + '</div>\n\n    <svg\n      id="app-spinner"\n      preserveAspectRatio="xMidYMid meet"\n      focusable="false"\n      aria-hidden="true"\n      data-tid="spinner"\n      viewBox="0 0 100 100"\n    >\n      <circle cx="50%" cy="50%" r="45" />\n    </svg>\n  </body>\n</html>\n',
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
  version_hash: "1pliv5o"
};
function get_hooks() {
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
   *   env: Record<string, string>
   * }} opts
   */
  async init({ env }) {
    set_private_env(
      filter_private_env(env, {
        public_prefix: this.#options.env_public_prefix,
        private_prefix: this.#options.env_private_prefix
      })
    );
    set_public_env(
      filter_public_env(env, {
        public_prefix: this.#options.env_public_prefix,
        private_prefix: this.#options.env_private_prefix
      })
    );
    if (!this.#options.hooks) {
      try {
        const module = await get_hooks();
        this.#options.hooks = {
          handle: module.handle || (({ event, resolve }) => resolve(event)),
          handleError: module.handleError || (({ error: error2 }) => console.error(error2)),
          handleFetch: module.handleFetch || (({ request, fetch: fetch2 }) => fetch2(request))
        };
      } catch (error2) {
        {
          throw error2;
        }
      }
    }
  }
  /**
   * @param {Request} request
   * @param {import('types').RequestOptions} options
   */
  async respond(request, options2) {
    if (!(request instanceof Request)) {
      throw new Error(
        "The first argument to server.respond must be a Request object. See https://github.com/sveltejs/kit/pull/3384 for details"
      );
    }
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
function client_method(key2) {
  {
    if (key2 === "before_navigate" || key2 === "after_navigate" || key2 === "on_navigate") {
      return () => {
      };
    } else {
      const name_lookup = {
        disable_scroll_handling: "disableScrollHandling",
        preload_data: "preloadData",
        preload_code: "preloadCode",
        invalidate_all: "invalidateAll"
      };
      return () => {
        throw new Error(`Cannot call ${name_lookup[key2] ?? key2}(...) on the server`);
      };
    }
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
const localIdentityCanisterId = {}.VITE_INTERNET_IDENTITY_CANISTER_ID;
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
      new Promise(async (resolve, reject) => {
        authClient = authClient ?? await createAuthClient();
        const identityProvider = nonNullish(localIdentityCanisterId) ? `http://localhost:4943?canisterId=${localIdentityCanisterId}` : `${domain ?? "https://identity.ic0.app"}`;
        await authClient?.login({
          maxTimeToLive: AUTH_MAX_TIME_TO_LIVE,
          onSuccess: () => {
            update((state) => ({
              ...state,
              identity: authClient?.getIdentity()
            }));
            resolve();
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
    }
  };
};
const authStore = initAuthStore();
const idlFactory = ({ IDL }) => {
  const List = IDL.Rec();
  const List_1 = IDL.Rec();
  const List_2 = IDL.Rec();
  const SeasonId = IDL.Nat16;
  const FixtureStatusType = IDL.Variant({
    Unplayed: IDL.Null,
    Finalised: IDL.Null,
    Active: IDL.Null,
    Complete: IDL.Null
  });
  const ClubId = IDL.Nat16;
  const FixtureId = IDL.Nat32;
  const PlayerEventType = IDL.Variant({
    PenaltyMissed: IDL.Null,
    Goal: IDL.Null,
    GoalConceded: IDL.Null,
    Appearance: IDL.Null,
    PenaltySaved: IDL.Null,
    RedCard: IDL.Null,
    KeeperSave: IDL.Null,
    CleanSheet: IDL.Null,
    YellowCard: IDL.Null,
    GoalAssisted: IDL.Null,
    OwnGoal: IDL.Null,
    HighestScoringPlayer: IDL.Null
  });
  const PlayerEventData = IDL.Record({
    fixtureId: FixtureId,
    clubId: ClubId,
    playerId: IDL.Nat16,
    eventStartMinute: IDL.Nat8,
    eventEndMinute: IDL.Nat8,
    eventType: PlayerEventType
  });
  const GameweekNumber = IDL.Nat8;
  const FixtureDTO = IDL.Record({
    id: IDL.Nat32,
    status: FixtureStatusType,
    highestScoringPlayerId: IDL.Nat16,
    seasonId: SeasonId,
    awayClubId: ClubId,
    events: IDL.Vec(PlayerEventData),
    homeClubId: ClubId,
    kickOff: IDL.Int,
    homeGoals: IDL.Nat8,
    gameweek: GameweekNumber,
    awayGoals: IDL.Nat8
  });
  const AddInitialFixturesDTO = IDL.Record({
    seasonId: SeasonId,
    seasonFixtures: IDL.Vec(FixtureDTO)
  });
  const Result = IDL.Variant({ ok: IDL.Text, err: IDL.Text });
  const CountryId = IDL.Nat16;
  const PlayerPosition = IDL.Variant({
    Goalkeeper: IDL.Null,
    Midfielder: IDL.Null,
    Forward: IDL.Null,
    Defender: IDL.Null
  });
  const CreatePlayerDTO = IDL.Record({
    clubId: ClubId,
    valueQuarterMillions: IDL.Nat16,
    dateOfBirth: IDL.Int,
    nationality: CountryId,
    shirtNumber: IDL.Nat8,
    position: PlayerPosition,
    lastName: IDL.Text,
    firstName: IDL.Text
  });
  const ShirtType = IDL.Variant({ Filled: IDL.Null, Striped: IDL.Null });
  const ClubDTO = IDL.Record({
    id: ClubId,
    secondaryColourHex: IDL.Text,
    name: IDL.Text,
    friendlyName: IDL.Text,
    thirdColourHex: IDL.Text,
    abbreviatedName: IDL.Text,
    shirtType: ShirtType,
    primaryColourHex: IDL.Text
  });
  const AdminClubList = IDL.Record({
    totalEntries: IDL.Nat,
    clubs: IDL.Vec(ClubDTO),
    offset: IDL.Nat,
    limit: IDL.Nat
  });
  const Error2 = IDL.Variant({
    DecodeError: IDL.Null,
    NotAllowed: IDL.Null,
    NotFound: IDL.Null,
    NotAuthorized: IDL.Null,
    InvalidData: IDL.Null,
    SystemOnHold: IDL.Null,
    AlreadyExists: IDL.Null,
    InvalidTeamError: IDL.Null
  });
  const Result_29 = IDL.Variant({ ok: AdminClubList, err: Error2 });
  const AdminFixtureList = IDL.Record({
    seasonId: SeasonId,
    fixtures: IDL.Vec(FixtureDTO)
  });
  const Result_28 = IDL.Variant({ ok: AdminFixtureList, err: Error2 });
  const AdminMainCanisterInfo = IDL.Record({
    cycles: IDL.Nat,
    canisterId: IDL.Text
  });
  const Result_27 = IDL.Variant({
    ok: AdminMainCanisterInfo,
    err: Error2
  });
  const PlayerId = IDL.Nat16;
  const FantasyTeamSnapshot = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
    teamValueQuarterMillions: IDL.Nat16,
    countrymenCountryId: CountryId,
    username: IDL.Text,
    goalGetterPlayerId: PlayerId,
    hatTrickHeroGameweek: GameweekNumber,
    transfersAvailable: IDL.Nat8,
    teamBoostGameweek: GameweekNumber,
    captainFantasticGameweek: GameweekNumber,
    countrymenGameweek: GameweekNumber,
    bankQuarterMillions: IDL.Nat16,
    noEntryPlayerId: PlayerId,
    safeHandsPlayerId: PlayerId,
    braceBonusGameweek: GameweekNumber,
    favouriteClubId: ClubId,
    passMasterGameweek: GameweekNumber,
    teamBoostClubId: ClubId,
    goalGetterGameweek: GameweekNumber,
    captainFantasticPlayerId: PlayerId,
    gameweek: GameweekNumber,
    transferWindowGameweek: GameweekNumber,
    noEntryGameweek: GameweekNumber,
    prospectsGameweek: GameweekNumber,
    safeHandsGameweek: GameweekNumber,
    principalId: IDL.Text,
    passMasterPlayerId: PlayerId,
    captainId: PlayerId,
    points: IDL.Int16,
    monthlyBonusesAvailable: IDL.Nat8
  });
  List_1.fill(IDL.Opt(IDL.Tuple(FantasyTeamSnapshot, List_1)));
  const FantasyTeamSeason = IDL.Record({
    seasonId: SeasonId,
    gameweeks: List_1,
    totalPoints: IDL.Int16
  });
  List.fill(IDL.Opt(IDL.Tuple(FantasyTeamSeason, List)));
  const ProfileDTO = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
    countrymenCountryId: CountryId,
    username: IDL.Text,
    goalGetterPlayerId: PlayerId,
    hatTrickHeroGameweek: GameweekNumber,
    transfersAvailable: IDL.Nat8,
    termsAccepted: IDL.Bool,
    teamBoostGameweek: GameweekNumber,
    captainFantasticGameweek: GameweekNumber,
    createDate: IDL.Int,
    countrymenGameweek: GameweekNumber,
    bankQuarterMillions: IDL.Nat16,
    noEntryPlayerId: PlayerId,
    safeHandsPlayerId: PlayerId,
    history: List,
    braceBonusGameweek: GameweekNumber,
    favouriteClubId: ClubId,
    passMasterGameweek: GameweekNumber,
    teamBoostClubId: ClubId,
    goalGetterGameweek: GameweekNumber,
    captainFantasticPlayerId: PlayerId,
    profilePicture: IDL.Vec(IDL.Nat8),
    transferWindowGameweek: GameweekNumber,
    noEntryGameweek: GameweekNumber,
    prospectsGameweek: GameweekNumber,
    safeHandsGameweek: GameweekNumber,
    principalId: IDL.Text,
    passMasterPlayerId: PlayerId,
    captainId: PlayerId,
    monthlyBonusesAvailable: IDL.Nat8
  });
  const AdminProfileList = IDL.Record({
    totalEntries: IDL.Nat,
    offset: IDL.Nat,
    limit: IDL.Nat,
    profiles: IDL.Vec(ProfileDTO)
  });
  const Result_26 = IDL.Variant({ ok: AdminProfileList, err: Error2 });
  const CalendarMonth = IDL.Nat8;
  const MonthlyLeaderboardCanister = IDL.Record({
    month: CalendarMonth,
    clubId: ClubId,
    seasonId: SeasonId,
    canisterId: IDL.Text
  });
  const MonthlyCanisterDTO = IDL.Record({
    cycles: IDL.Nat,
    canister: MonthlyLeaderboardCanister
  });
  const AdminMonthlyCanisterList = IDL.Record({
    totalEntries: IDL.Nat,
    offset: IDL.Nat,
    limit: IDL.Nat,
    canisters: IDL.Vec(MonthlyCanisterDTO)
  });
  const Result_25 = IDL.Variant({
    ok: AdminMonthlyCanisterList,
    err: Error2
  });
  const PlayerStatus = IDL.Variant({
    OnLoan: IDL.Null,
    Former: IDL.Null,
    Active: IDL.Null,
    Retired: IDL.Null
  });
  const PlayerDTO = IDL.Record({
    id: IDL.Nat16,
    status: PlayerStatus,
    clubId: ClubId,
    valueQuarterMillions: IDL.Nat16,
    dateOfBirth: IDL.Int,
    nationality: CountryId,
    shirtNumber: IDL.Nat8,
    totalPoints: IDL.Int16,
    position: PlayerPosition,
    lastName: IDL.Text,
    firstName: IDL.Text
  });
  const AdminPlayerList = IDL.Record({
    playerStatus: PlayerStatus,
    players: IDL.Vec(PlayerDTO)
  });
  const Result_24 = IDL.Variant({ ok: AdminPlayerList, err: Error2 });
  const ProfileCanisterDTO = IDL.Record({
    cycles: IDL.Nat,
    canisterId: IDL.Text
  });
  const AdminProfilePictureCanisterList = IDL.Record({
    totalEntries: IDL.Nat,
    canisters: IDL.Vec(ProfileCanisterDTO)
  });
  const Result_23 = IDL.Variant({
    ok: AdminProfilePictureCanisterList,
    err: Error2
  });
  const SeasonLeaderboardCanister = IDL.Record({
    seasonId: SeasonId,
    canisterId: IDL.Text
  });
  const SeasonCanisterDTO = IDL.Record({
    cycles: IDL.Nat,
    canister: SeasonLeaderboardCanister
  });
  const AdminSeasonCanisterList = IDL.Record({
    totalEntries: IDL.Nat,
    offset: IDL.Nat,
    limit: IDL.Nat,
    canisters: IDL.Vec(SeasonCanisterDTO)
  });
  const Result_22 = IDL.Variant({
    ok: AdminSeasonCanisterList,
    err: Error2
  });
  const TimerDTO = IDL.Record({
    id: IDL.Int,
    callbackName: IDL.Text,
    triggerTime: IDL.Int
  });
  const AdminTimerList = IDL.Record({
    timers: IDL.Vec(TimerDTO),
    totalEntries: IDL.Nat,
    offset: IDL.Nat,
    limit: IDL.Nat,
    cyclesCheck: TimerDTO,
    category: IDL.Text,
    cyclesWalletCheck: TimerDTO
  });
  const Result_21 = IDL.Variant({ ok: AdminTimerList, err: Error2 });
  const WeeklyLeaderboardCanister = IDL.Record({
    seasonId: SeasonId,
    gameweek: GameweekNumber,
    canisterId: IDL.Text
  });
  const WeeklyCanisterDTO = IDL.Record({
    cycles: IDL.Nat,
    canister: WeeklyLeaderboardCanister
  });
  const AdminWeeklyCanisterList = IDL.Record({
    totalEntries: IDL.Nat,
    offset: IDL.Nat,
    limit: IDL.Nat,
    canisters: IDL.Vec(WeeklyCanisterDTO)
  });
  const Result_20 = IDL.Variant({
    ok: AdminWeeklyCanisterList,
    err: Error2
  });
  const LoanPlayerDTO = IDL.Record({
    loanEndDate: IDL.Int,
    playerId: PlayerId,
    loanClubId: ClubId
  });
  const PromoteFormerClubDTO = IDL.Record({ clubId: ClubId });
  const PromoteNewClubDTO = IDL.Record({
    secondaryColourHex: IDL.Text,
    name: IDL.Text,
    friendlyName: IDL.Text,
    thirdColourHex: IDL.Text,
    abbreviatedName: IDL.Text,
    shirtType: ShirtType,
    primaryColourHex: IDL.Text
  });
  const RecallPlayerDTO = IDL.Record({ playerId: PlayerId });
  const RescheduleFixtureDTO = IDL.Record({
    fixtureId: FixtureId,
    updatedFixtureGameweek: GameweekNumber,
    updatedFixtureDate: IDL.Int,
    seasonId: SeasonId
  });
  const RetirePlayerDTO = IDL.Record({
    playerId: PlayerId,
    retirementDate: IDL.Int
  });
  const RevaluePlayerDownDTO = IDL.Record({ playerId: PlayerId });
  const RevaluePlayerUpDTO = IDL.Record({ playerId: PlayerId });
  const SetPlayerInjuryDTO = IDL.Record({
    playerId: PlayerId,
    description: IDL.Text,
    expectedEndDate: IDL.Int
  });
  const SubmitFixtureDataDTO = IDL.Record({
    fixtureId: FixtureId,
    seasonId: SeasonId,
    gameweek: GameweekNumber,
    playerEventData: IDL.Vec(PlayerEventData)
  });
  const TransferPlayerDTO = IDL.Record({
    playerId: PlayerId,
    newClubId: ClubId
  });
  const UnretirePlayerDTO = IDL.Record({ playerId: PlayerId });
  const UpdateClubDTO = IDL.Record({
    clubId: ClubId,
    secondaryColourHex: IDL.Text,
    name: IDL.Text,
    friendlyName: IDL.Text,
    thirdColourHex: IDL.Text,
    abbreviatedName: IDL.Text,
    shirtType: ShirtType,
    primaryColourHex: IDL.Text
  });
  const UpdatePlayerDTO = IDL.Record({
    dateOfBirth: IDL.Int,
    playerId: PlayerId,
    nationality: CountryId,
    shirtNumber: IDL.Nat8,
    position: PlayerPosition,
    lastName: IDL.Text,
    firstName: IDL.Text
  });
  const Result_16 = IDL.Variant({ ok: IDL.Vec(ClubDTO), err: Error2 });
  const CountryDTO = IDL.Record({
    id: CountryId,
    code: IDL.Text,
    name: IDL.Text
  });
  const Result_19 = IDL.Variant({ ok: IDL.Vec(CountryDTO), err: Error2 });
  const DataCacheDTO = IDL.Record({ hash: IDL.Text, category: IDL.Text });
  const Result_18 = IDL.Variant({
    ok: IDL.Vec(DataCacheDTO),
    err: Error2
  });
  const Result_17 = IDL.Variant({ ok: IDL.Vec(FixtureDTO), err: Error2 });
  const Result_6 = IDL.Variant({ ok: IDL.Vec(PlayerDTO), err: Error2 });
  const ManagerDTO = IDL.Record({
    username: IDL.Text,
    weeklyPosition: IDL.Int,
    createDate: IDL.Int,
    monthlyPoints: IDL.Int16,
    weeklyPoints: IDL.Int16,
    weeklyPositionText: IDL.Text,
    gameweeks: IDL.Vec(FantasyTeamSnapshot),
    favouriteClubId: ClubId,
    monthlyPosition: IDL.Int,
    seasonPosition: IDL.Int,
    monthlyPositionText: IDL.Text,
    profilePicture: IDL.Vec(IDL.Nat8),
    seasonPoints: IDL.Int16,
    principalId: IDL.Text,
    seasonPositionText: IDL.Text
  });
  const Result_15 = IDL.Variant({ ok: ManagerDTO, err: Error2 });
  const ManagerGameweekDTO = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
    teamValueQuarterMillions: IDL.Nat16,
    countrymenCountryId: CountryId,
    username: IDL.Text,
    goalGetterPlayerId: PlayerId,
    hatTrickHeroGameweek: GameweekNumber,
    transfersAvailable: IDL.Nat8,
    teamBoostGameweek: GameweekNumber,
    captainFantasticGameweek: GameweekNumber,
    countrymenGameweek: GameweekNumber,
    bankQuarterMillions: IDL.Nat16,
    noEntryPlayerId: PlayerId,
    safeHandsPlayerId: PlayerId,
    braceBonusGameweek: GameweekNumber,
    favouriteClubId: ClubId,
    passMasterGameweek: GameweekNumber,
    teamBoostClubId: ClubId,
    goalGetterGameweek: GameweekNumber,
    captainFantasticPlayerId: PlayerId,
    gameweek: GameweekNumber,
    transferWindowGameweek: GameweekNumber,
    noEntryGameweek: GameweekNumber,
    prospectsGameweek: GameweekNumber,
    safeHandsGameweek: GameweekNumber,
    principalId: IDL.Text,
    passMasterPlayerId: PlayerId,
    captainId: PlayerId,
    points: IDL.Int16,
    monthlyBonusesAvailable: IDL.Nat8
  });
  const Result_14 = IDL.Variant({ ok: ManagerGameweekDTO, err: Error2 });
  const LeaderboardEntry = IDL.Record({
    username: IDL.Text,
    positionText: IDL.Text,
    position: IDL.Nat,
    principalId: IDL.Text,
    points: IDL.Int16
  });
  const MonthlyLeaderboardDTO = IDL.Record({
    month: IDL.Nat8,
    clubId: ClubId,
    totalEntries: IDL.Nat,
    seasonId: SeasonId,
    entries: IDL.Vec(LeaderboardEntry)
  });
  const Result_13 = IDL.Variant({
    ok: MonthlyLeaderboardDTO,
    err: Error2
  });
  const Result_12 = IDL.Variant({
    ok: IDL.Vec(MonthlyLeaderboardDTO),
    err: Error2
  });
  const InjuryHistory = IDL.Record({
    description: IDL.Text,
    injuryStartDate: IDL.Int,
    expectedEndDate: IDL.Int
  });
  const PlayerGameweekDTO = IDL.Record({
    fixtureId: FixtureId,
    events: IDL.Vec(PlayerEventData),
    number: IDL.Nat8,
    points: IDL.Int16
  });
  const ValueHistory = IDL.Record({
    oldValue: IDL.Nat16,
    newValue: IDL.Nat16,
    seasonId: IDL.Nat16,
    gameweek: IDL.Nat8
  });
  const PlayerDetailDTO = IDL.Record({
    id: PlayerId,
    status: PlayerStatus,
    clubId: ClubId,
    parentClubId: ClubId,
    valueQuarterMillions: IDL.Nat16,
    dateOfBirth: IDL.Int,
    injuryHistory: IDL.Vec(InjuryHistory),
    seasonId: SeasonId,
    gameweeks: IDL.Vec(PlayerGameweekDTO),
    nationality: CountryId,
    retirementDate: IDL.Int,
    valueHistory: IDL.Vec(ValueHistory),
    latestInjuryEndDate: IDL.Int,
    shirtNumber: IDL.Nat8,
    position: PlayerPosition,
    lastName: IDL.Text,
    firstName: IDL.Text
  });
  const Result_11 = IDL.Variant({ ok: PlayerDetailDTO, err: Error2 });
  const PlayerPointsDTO = IDL.Record({
    id: IDL.Nat16,
    clubId: ClubId,
    events: IDL.Vec(PlayerEventData),
    position: PlayerPosition,
    gameweek: GameweekNumber,
    points: IDL.Int16
  });
  const Result_10 = IDL.Variant({
    ok: IDL.Vec(PlayerPointsDTO),
    err: Error2
  });
  List_2.fill(IDL.Opt(IDL.Tuple(PlayerEventData, List_2)));
  const PlayerScoreDTO = IDL.Record({
    id: IDL.Nat16,
    clubId: ClubId,
    assists: IDL.Int16,
    dateOfBirth: IDL.Int,
    nationality: CountryId,
    goalsScored: IDL.Int16,
    saves: IDL.Int16,
    goalsConceded: IDL.Int16,
    events: List_2,
    position: PlayerPosition,
    points: IDL.Int16
  });
  const Result_9 = IDL.Variant({
    ok: IDL.Vec(IDL.Tuple(IDL.Nat16, PlayerScoreDTO)),
    err: Error2
  });
  const Result_8 = IDL.Variant({ ok: ProfileDTO, err: Error2 });
  const PublicProfileDTO = IDL.Record({
    username: IDL.Text,
    createDate: IDL.Int,
    gameweeks: IDL.Vec(FantasyTeamSnapshot),
    favouriteClubId: IDL.Nat16,
    profilePicture: IDL.Vec(IDL.Nat8),
    principalId: IDL.Text
  });
  const Result_7 = IDL.Variant({ ok: PublicProfileDTO, err: Error2 });
  const SeasonLeaderboardDTO = IDL.Record({
    totalEntries: IDL.Nat,
    seasonId: SeasonId,
    entries: IDL.Vec(LeaderboardEntry)
  });
  const Result_5 = IDL.Variant({ ok: SeasonLeaderboardDTO, err: Error2 });
  const SystemStateDTO = IDL.Record({
    pickTeamSeasonId: SeasonId,
    pickTeamSeasonName: IDL.Text,
    calculationSeasonName: IDL.Text,
    calculationGameweek: GameweekNumber,
    pickTeamGameweek: GameweekNumber,
    calculationMonth: CalendarMonth,
    calculationSeasonId: SeasonId
  });
  const Result_4 = IDL.Variant({ ok: SystemStateDTO, err: Error2 });
  const Result_3 = IDL.Variant({ ok: IDL.Nat, err: Error2 });
  const WeeklyLeaderboardDTO = IDL.Record({
    totalEntries: IDL.Nat,
    seasonId: SeasonId,
    entries: IDL.Vec(LeaderboardEntry),
    gameweek: GameweekNumber
  });
  const Result_2 = IDL.Variant({ ok: WeeklyLeaderboardDTO, err: Error2 });
  const UpdateFantasyTeamDTO = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
    countrymenCountryId: CountryId,
    username: IDL.Text,
    goalGetterPlayerId: PlayerId,
    hatTrickHeroGameweek: GameweekNumber,
    teamBoostGameweek: GameweekNumber,
    captainFantasticGameweek: GameweekNumber,
    countrymenGameweek: GameweekNumber,
    noEntryPlayerId: PlayerId,
    safeHandsPlayerId: PlayerId,
    braceBonusGameweek: GameweekNumber,
    passMasterGameweek: GameweekNumber,
    teamBoostClubId: ClubId,
    goalGetterGameweek: GameweekNumber,
    captainFantasticPlayerId: PlayerId,
    transferWindowGameweek: GameweekNumber,
    noEntryGameweek: GameweekNumber,
    prospectsGameweek: GameweekNumber,
    safeHandsGameweek: GameweekNumber,
    passMasterPlayerId: PlayerId,
    captainId: PlayerId
  });
  const Result_1 = IDL.Variant({ ok: IDL.Null, err: Error2 });
  const UpdateFixtureDTO = IDL.Record({
    status: FixtureStatusType,
    fixtureId: FixtureId,
    seasonId: SeasonId,
    kickOff: IDL.Int,
    gameweek: GameweekNumber
  });
  const UpdateSystemStateDTO = IDL.Record({
    pickTeamSeasonId: SeasonId,
    calculationGameweek: GameweekNumber,
    transferWindowActive: IDL.Bool,
    pickTeamGameweek: GameweekNumber,
    calculationMonth: CalendarMonth,
    calculationSeasonId: SeasonId,
    onHold: IDL.Bool
  });
  return IDL.Service({
    adminAddInitialFixtures: IDL.Func([AddInitialFixturesDTO], [Result], []),
    adminCreatePlayer: IDL.Func([CreatePlayerDTO], [Result], []),
    adminGetClubs: IDL.Func([IDL.Nat, IDL.Nat], [Result_29], ["query"]),
    adminGetFixtures: IDL.Func([SeasonId], [Result_28], ["query"]),
    adminGetMainCanisterInfo: IDL.Func([], [Result_27], []),
    adminGetManagers: IDL.Func([IDL.Nat, IDL.Nat], [Result_26], ["query"]),
    adminGetMonthlyCanisters: IDL.Func([IDL.Nat, IDL.Nat], [Result_25], []),
    adminGetPlayers: IDL.Func([PlayerStatus], [Result_24], ["query"]),
    adminGetProfileCanisters: IDL.Func([IDL.Nat, IDL.Nat], [Result_23], []),
    adminGetSeasonCanisters: IDL.Func([IDL.Nat, IDL.Nat], [Result_22], []),
    adminGetTimers: IDL.Func(
      [IDL.Text, IDL.Nat, IDL.Nat],
      [Result_21],
      ["query"]
    ),
    adminGetWeeklyCanisters: IDL.Func([IDL.Nat, IDL.Nat], [Result_20], []),
    adminLoanPlayer: IDL.Func([LoanPlayerDTO], [Result], []),
    adminPromoteFormerClub: IDL.Func([PromoteFormerClubDTO], [Result], []),
    adminPromoteNewClub: IDL.Func([PromoteNewClubDTO], [Result], []),
    adminRecallPlayer: IDL.Func([RecallPlayerDTO], [Result], []),
    adminRescheduleFixture: IDL.Func([RescheduleFixtureDTO], [Result], []),
    adminRetirePlayer: IDL.Func([RetirePlayerDTO], [Result], []),
    adminRevaluePlayerDown: IDL.Func([RevaluePlayerDownDTO], [Result], []),
    adminRevaluePlayerUp: IDL.Func([RevaluePlayerUpDTO], [Result], []),
    adminSetPlayerInjury: IDL.Func([SetPlayerInjuryDTO], [Result], []),
    adminSubmitFixtureData: IDL.Func([SubmitFixtureDataDTO], [Result], []),
    adminTransferPlayer: IDL.Func([TransferPlayerDTO], [Result], []),
    adminUnretirePlayer: IDL.Func([UnretirePlayerDTO], [Result], []),
    adminUpdateClub: IDL.Func([UpdateClubDTO], [Result], []),
    adminUpdatePlayer: IDL.Func([UpdatePlayerDTO], [Result], []),
    burnICPToCycles: IDL.Func([IDL.Nat64], [], []),
    executeAddInitialFixtures: IDL.Func([AddInitialFixturesDTO], [], []),
    executeCreatePlayer: IDL.Func([CreatePlayerDTO], [], []),
    executeLoanPlayer: IDL.Func([LoanPlayerDTO], [], []),
    executePromoteFormerClub: IDL.Func([PromoteFormerClubDTO], [], []),
    executePromoteNewClub: IDL.Func([PromoteNewClubDTO], [], []),
    executeRecallPlayer: IDL.Func([RecallPlayerDTO], [], []),
    executeRescheduleFixture: IDL.Func([RescheduleFixtureDTO], [], []),
    executeRetirePlayer: IDL.Func([RetirePlayerDTO], [], []),
    executeRevaluePlayerDown: IDL.Func([RevaluePlayerDownDTO], [], []),
    executeRevaluePlayerUp: IDL.Func([RevaluePlayerUpDTO], [], []),
    executeSetPlayerInjury: IDL.Func([SetPlayerInjuryDTO], [], []),
    executeSubmitFixtureData: IDL.Func([SubmitFixtureDataDTO], [], []),
    executeTransferPlayer: IDL.Func([TransferPlayerDTO], [], []),
    executeUnretirePlayer: IDL.Func([UnretirePlayerDTO], [], []),
    executeUpdateClub: IDL.Func([UpdateClubDTO], [], []),
    executeUpdatePlayer: IDL.Func([UpdatePlayerDTO], [], []),
    getClubs: IDL.Func([], [Result_16], ["query"]),
    getCountries: IDL.Func([], [Result_19], ["query"]),
    getDataHashes: IDL.Func([], [Result_18], ["query"]),
    getFixtures: IDL.Func([SeasonId], [Result_17], ["query"]),
    getFormerClubs: IDL.Func([], [Result_16], ["query"]),
    getLoanedPlayers: IDL.Func([ClubId], [Result_6], ["query"]),
    getManager: IDL.Func([], [Result_15], []),
    getManagerGameweek: IDL.Func(
      [IDL.Text, SeasonId, GameweekNumber],
      [Result_14],
      []
    ),
    getMonthlyLeaderboard: IDL.Func(
      [SeasonId, ClubId, CalendarMonth, IDL.Nat, IDL.Nat],
      [Result_13],
      []
    ),
    getMonthlyLeaderboards: IDL.Func(
      [SeasonId, CalendarMonth],
      [Result_12],
      []
    ),
    getPlayerDetails: IDL.Func([PlayerId, SeasonId], [Result_11], []),
    getPlayerDetailsForGameweek: IDL.Func(
      [SeasonId, GameweekNumber],
      [Result_10],
      ["query"]
    ),
    getPlayers: IDL.Func([], [Result_6], ["query"]),
    getPlayersMap: IDL.Func([SeasonId, GameweekNumber], [Result_9], []),
    getProfile: IDL.Func([], [Result_8], []),
    getPublicProfile: IDL.Func(
      [IDL.Text, SeasonId, GameweekNumber],
      [Result_7],
      []
    ),
    getRetiredPlayers: IDL.Func([ClubId], [Result_6], ["query"]),
    getSeasonLeaderboard: IDL.Func(
      [SeasonId, IDL.Nat, IDL.Nat],
      [Result_5],
      []
    ),
    getSystemState: IDL.Func([], [Result_4], ["query"]),
    getTotalManagers: IDL.Func([], [Result_3], ["query"]),
    getWeeklyLeaderboard: IDL.Func(
      [SeasonId, GameweekNumber, IDL.Nat, IDL.Nat],
      [Result_2],
      []
    ),
    init: IDL.Func([], [], []),
    isUsernameValid: IDL.Func([IDL.Text], [IDL.Bool], ["query"]),
    requestCanisterTopup: IDL.Func([], [], []),
    saveFantasyTeam: IDL.Func([UpdateFantasyTeamDTO], [Result_1], []),
    updateFavouriteClub: IDL.Func([ClubId], [Result_1], []),
    updateFixture: IDL.Func([UpdateFixtureDTO], [Result_1], []),
    updateProfilePicture: IDL.Func([IDL.Vec(IDL.Nat8)], [Result_1], []),
    updateSystemState: IDL.Func([UpdateSystemStateDTO], [Result_1], []),
    updateUsername: IDL.Func([IDL.Text], [Result_1], []),
    validateAddInitialFixtures: IDL.Func([AddInitialFixturesDTO], [Result], []),
    validateCreatePlayer: IDL.Func([CreatePlayerDTO], [Result], []),
    validateLoanPlayer: IDL.Func([LoanPlayerDTO], [Result], []),
    validatePromoteFormerClub: IDL.Func([PromoteFormerClubDTO], [Result], []),
    validatePromoteNewClub: IDL.Func([PromoteNewClubDTO], [Result], []),
    validateRecallPlayer: IDL.Func([RecallPlayerDTO], [Result], []),
    validateRescheduleFixture: IDL.Func([RescheduleFixtureDTO], [Result], []),
    validateRetirePlayer: IDL.Func([RetirePlayerDTO], [Result], []),
    validateRevaluePlayerDown: IDL.Func([RevaluePlayerDownDTO], [Result], []),
    validateRevaluePlayerUp: IDL.Func([RevaluePlayerUpDTO], [Result], []),
    validateSetPlayerInjury: IDL.Func([SetPlayerInjuryDTO], [Result], []),
    validateSubmitFixtureData: IDL.Func([SubmitFixtureDataDTO], [Result], []),
    validateTransferPlayer: IDL.Func([TransferPlayerDTO], [Result], []),
    validateUnretirePlayer: IDL.Func([UnretirePlayerDTO], [Result], []),
    validateUpdateClub: IDL.Func([UpdateClubDTO], [Result], []),
    validateUpdatePlayer: IDL.Func([UpdatePlayerDTO], [Result], [])
  });
};
class ActorFactory {
  static createActor(idlFactory2, canisterId = "", identity = null, options2 = null) {
    const hostOptions = {
      host: "http://127.0.0.1:8080",
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
    if ({ "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.NODE_ENV !== "production") {
      agent.fetchRootKey().catch((err) => {
        console.warn(
          "Unable to fetch root key. Ensure your local replica is running"
        );
        console.error(err);
      });
    }
    return Actor.createActor(idlFactory2, {
      agent,
      canisterId,
      ...options2?.actorOptions
    });
  }
  static createIdentityActor(authStore2, canisterId) {
    let unsubscribe;
    return new Promise((resolve, reject) => {
      unsubscribe = authStore2.subscribe((store) => {
        if (store.identity) {
          resolve(store.identity);
        }
      });
    }).then((identity) => {
      unsubscribe();
      return ActorFactory.createActor(idlFactory, canisterId, identity);
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
function createSystemStore() {
  const { subscribe: subscribe2, set } = writable(null);
  let actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category = "system_state";
    const newHashValues = await actor.getDataHashes();
    let error2 = isError(newHashValues);
    if (error2) {
      console.error("Error syncing system store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (categoryHash?.hash != localHash) {
      let updatedSystemStateData = await actor.getSystemState();
      if (isError(updatedSystemStateData)) {
        console.error("Error syncing system store");
        return;
      }
      localStorage.setItem(
        category,
        JSON.stringify(updatedSystemStateData.ok, replacer)
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedSystemStateData.ok);
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
  async function updateSystemState(systemState) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.updateSystemState(systemState);
      sync();
      return result;
    } catch (error2) {
      console.error("Error updating system state:", error2);
      throw error2;
    }
  }
  return {
    subscribe: subscribe2,
    sync,
    getSystemState,
    updateSystemState
  };
}
const systemStore = createSystemStore();
function createFixtureStore() {
  const { subscribe: subscribe2, set } = writable([]);
  let systemState;
  systemStore.subscribe((value) => {
    systemState = value;
  });
  let actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category = "fixtures";
    const newHashValues = await actor.getDataHashes();
    let error2 = isError(newHashValues);
    if (error2) {
      console.error("Error syncing fixture store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (categoryHash?.hash != localHash) {
      let updatedFixturesData = await actor.getFixtures(
        systemState.calculationSeasonId
      );
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
    await sync();
    await subscribe2((value) => {
      fixtures = value;
    })();
    const now = /* @__PURE__ */ new Date();
    return fixtures.find(
      (fixture) => new Date(Number(fixture.kickOff) / 1e6) > now
    );
  }
  async function updateFixture(updatedFixture) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      await identityActor.updateFixture(updatedFixture);
    } catch (error2) {
      console.error("Error updating fixtures:", error2);
      throw error2;
    }
  }
  return {
    subscribe: subscribe2,
    sync,
    getNextFixture,
    updateFixture
  };
}
const fixtureStore = createFixtureStore();
function createTeamStore() {
  const { subscribe: subscribe2, set } = writable([]);
  let actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    const category = "teams";
    const newHashValues = await actor.getDataHashes();
    let error2 = isError(newHashValues);
    if (error2) {
      console.error("Error syncing team store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
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
const Back_svelte_svelte_type_style_lang = "";
const Backdrop_svelte_svelte_type_style_lang = "";
const css$a = {
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
  $$result.css.add(css$a);
  $$unsubscribe_i18n();
  return `<div role="button" tabindex="-1"${add_attribute("aria-label", $i18n.core.close, 0)} class="${["backdrop svelte-whxjdd", disablePointerEvents ? "disablePointerEvents" : ""].join(" ").trim()}" data-tid="backdrop"></div>`;
});
const layoutBottomOffset = writable(0);
const BottomSheet_svelte_svelte_type_style_lang = "";
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
const Spinner_svelte_svelte_type_style_lang = "";
const css$9 = {
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
  $$result.css.add(css$9);
  return `  <svg class="${[escape(null_to_empty(size), true) + " svelte-85668t", inline ? "inline" : ""].join(" ").trim()}" preserveAspectRatio="xMidYMid meet" focusable="false" aria-hidden="true" data-tid="spinner" viewBox="0 0 100 100"><circle cx="50%" cy="50%" r="45" class="svelte-85668t"></circle></svg>`;
});
const BusyScreen_svelte_svelte_type_style_lang = "";
const css$8 = {
  code: "div.svelte-14plyno{z-index:calc(var(--z-index) + 1000);position:fixed;top:0;right:0;bottom:0;left:0;background:var(--backdrop);color:var(--backdrop-contrast)}.content.svelte-14plyno{display:flex;flex-direction:column;justify-content:center;align-items:center}p.svelte-14plyno{padding-bottom:var(--padding);max-width:calc(var(--section-max-width) / 2)}",
  map: null
};
const BusyScreen = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $busy, $$unsubscribe_busy;
  let $busyMessage, $$unsubscribe_busyMessage;
  $$unsubscribe_busy = subscribe(busy, (value) => $busy = value);
  $$unsubscribe_busyMessage = subscribe(busyMessage, (value) => $busyMessage = value);
  $$result.css.add(css$8);
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
const Card_svelte_svelte_type_style_lang = "";
const Checkbox_svelte_svelte_type_style_lang = "";
const TestIdWrapper_svelte_svelte_type_style_lang = "";
const Collapsible_svelte_svelte_type_style_lang = "";
const Toolbar_svelte_svelte_type_style_lang = "";
const IconClose = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { size = `${DEFAULT_ICON_SIZE}px` } = $$props;
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  return `  <svg${add_attribute("height", size, 0)}${add_attribute("width", size, 0)} viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><rect x="14.4194" y="4.52441" width="1.5" height="14" rx="0.75" transform="rotate(45 14.4194 4.52441)" fill="currentColor"></rect><rect x="4.5199" y="5.58496" width="1.5" height="14" rx="0.75" transform="rotate(-45 4.5199 5.58496)" fill="currentColor"></rect></svg>`;
});
const MenuButton_svelte_svelte_type_style_lang = "";
const Header_svelte_svelte_type_style_lang$1 = "";
const Content_svelte_svelte_type_style_lang = "";
const IconError = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { size = `${DEFAULT_ICON_SIZE}px` } = $$props;
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  return `  <svg xmlns="http://www.w3.org/2000/svg"${add_attribute("height", size, 0)} viewBox="0 0 24 24"${add_attribute("width", size, 0)} fill="currentColor"><path d="M0 0h24v24H0z" fill="none"></path><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"></path></svg>`;
});
const IconInfo_svelte_svelte_type_style_lang = "";
const css$7 = {
  code: "svg.svelte-1lui9gh{vertical-align:middle}",
  map: null
};
const IconInfo = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { size = `${DEFAULT_ICON_SIZE}px` } = $$props;
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  $$result.css.add(css$7);
  return `  <svg${add_attribute("width", size, 0)}${add_attribute("height", size, 0)} viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" data-tid="icon-info" class="svelte-1lui9gh"><path d="M10.2222 17.5C14.3643 17.5 17.7222 14.1421 17.7222 10C17.7222 5.85786 14.3643 2.5 10.2222 2.5C6.08003 2.5 2.72217 5.85786 2.72217 10C2.72217 14.1421 6.08003 17.5 10.2222 17.5Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path d="M10.2222 13.3333V10" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path d="M10.2222 6.66699H10.2305" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path></svg>`;
});
const IconMeter_svelte_svelte_type_style_lang = "";
const IconSync_svelte_svelte_type_style_lang = "";
const IconWarning = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { size = `${DEFAULT_ICON_SIZE}px` } = $$props;
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  return `  <svg xmlns="http://www.w3.org/2000/svg"${add_attribute("height", size, 0)} viewBox="0 0 24 24"${add_attribute("width", size, 0)} fill="currentColor"><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"></path></svg>`;
});
const Copy_svelte_svelte_type_style_lang = "";
const Dropdown_svelte_svelte_type_style_lang = "";
const ExternalLink_svelte_svelte_type_style_lang = "";
const HeaderTitle_svelte_svelte_type_style_lang = "";
let elementsCounters = {};
const nextElementId = (prefix) => {
  elementsCounters = {
    ...elementsCounters,
    [prefix]: (elementsCounters[prefix] ?? 0) + 1
  };
  return `${prefix}${elementsCounters[prefix]}`;
};
const InfiniteScroll_svelte_svelte_type_style_lang = "";
const Input_svelte_svelte_type_style_lang = "";
const InputRange_svelte_svelte_type_style_lang = "";
const Island_svelte_svelte_type_style_lang = "";
const ItemAction_svelte_svelte_type_style_lang = "";
const KeyValuePair_svelte_svelte_type_style_lang = "";
const KeyValuePairInfo_svelte_svelte_type_style_lang = "";
const SplitPane_svelte_svelte_type_style_lang = "";
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
const MenuBackground_svelte_svelte_type_style_lang = "";
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
const Menu_svelte_svelte_type_style_lang = "";
const StretchPane_svelte_svelte_type_style_lang = "";
const MenuItem_svelte_svelte_type_style_lang = "";
const Modal_svelte_svelte_type_style_lang = "";
const css$6 = {
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
  $$result.css.add(css$6);
  showHeader = nonNullish($$slots.title);
  showFooterAlert = nonNullish($$slots.footer) && role === "alert";
  $$unsubscribe_i18n();
  return `${visible ? `<div class="modal svelte-1bbimtl"${add_attribute("role", role, 0)}${add_attribute("data-tid", testId, 0)}${add_attribute("aria-labelledby", showHeader ? modalTitleId : void 0, 0)}${add_attribute("aria-describedby", modalContentId, 0)}>${validate_component(Backdrop, "Backdrop").$$render($$result, { disablePointerEvents }, {}, {})} <div class="${escape(null_to_empty(`wrapper ${role}`), true) + " svelte-1bbimtl"}">${showHeader ? `<div class="header svelte-1bbimtl"><h2${add_attribute("id", modalTitleId, 0)} data-tid="modal-title" class="svelte-1bbimtl">${slots.title ? slots.title({}) : ``}</h2> ${!disablePointerEvents ? `<button data-tid="close-modal"${add_attribute("aria-label", $i18n.core.close, 0)} class="svelte-1bbimtl">${validate_component(IconClose, "IconClose").$$render($$result, { size: "24px" }, {}, {})}</button>` : ``}</div>` : ``} <div class="container-wrapper svelte-1bbimtl">${slots["sub-title"] ? slots["sub-title"]({}) : ``} <div class="container svelte-1bbimtl"><div class="${["content svelte-1bbimtl", role === "alert" ? "alert" : ""].join(" ").trim()}"${add_attribute("id", modalContentId, 0)}>${slots.default ? slots.default({}) : ``}</div></div></div> ${showFooterAlert ? `<div class="footer toolbar svelte-1bbimtl">${slots.footer ? slots.footer({}) : ``}</div>` : ``}</div></div>` : ``}`;
});
const Nav_svelte_svelte_type_style_lang = "";
const PageBanner_svelte_svelte_type_style_lang = "";
const Popover_svelte_svelte_type_style_lang = "";
const ProgressBar_svelte_svelte_type_style_lang = "";
const ProgressSteps_svelte_svelte_type_style_lang = "";
const QRCode_svelte_svelte_type_style_lang = "";
const QRCodeReader_svelte_svelte_type_style_lang = "";
const QRCodeReaderModal_svelte_svelte_type_style_lang = "";
const Section_svelte_svelte_type_style_lang = "";
const Segment_svelte_svelte_type_style_lang = "";
const SegmentButton_svelte_svelte_type_style_lang = "";
const SkeletonText_svelte_svelte_type_style_lang = "";
const SplitBlock_svelte_svelte_type_style_lang = "";
const SplitContent_svelte_svelte_type_style_lang = "";
const Tag_svelte_svelte_type_style_lang = "";
const Toggle_svelte_svelte_type_style_lang = "";
const ThemeToggle_svelte_svelte_type_style_lang = "";
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
const Toast_svelte_svelte_type_style_lang = "";
const css$5 = {
  code: ".toast.svelte-1ih7d9r.svelte-1ih7d9r{display:flex;justify-content:space-between;align-items:center;gap:var(--padding-1_5x);background:var(--overlay-background);color:var(--overlay-background-contrast);--button-secondary-background:var(--focus-background);border-radius:var(--border-radius);box-shadow:var(--strong-shadow, 8px 8px 16px 0 rgba(0, 0, 0, 0.25));padding:var(--padding-1_5x);box-sizing:border-box}.toast.inverted.svelte-1ih7d9r.svelte-1ih7d9r{background:var(--toast-inverted-background);color:var(--toast-inverted-background-contrast)}.toast.svelte-1ih7d9r .icon.svelte-1ih7d9r{line-height:0}.toast.svelte-1ih7d9r .icon.success.svelte-1ih7d9r{color:var(--positive-emphasis)}.toast.svelte-1ih7d9r .icon.info.svelte-1ih7d9r{color:var(--primary)}.toast.svelte-1ih7d9r .icon.warn.svelte-1ih7d9r{color:var(--warning-emphasis-shade)}.toast.svelte-1ih7d9r .icon.error.svelte-1ih7d9r{color:var(--negative-emphasis)}.toast.svelte-1ih7d9r .msg.svelte-1ih7d9r{flex-grow:1;margin:0;word-break:break-word}.toast.svelte-1ih7d9r .msg.scroll.svelte-1ih7d9r{max-height:calc(8.5 * var(--padding));overflow-y:auto}.toast.svelte-1ih7d9r .msg.truncate.svelte-1ih7d9r{white-space:var(--text-white-space, nowrap);overflow:hidden;text-overflow:ellipsis}.toast.svelte-1ih7d9r .msg.truncate .title.svelte-1ih7d9r{white-space:var(--text-white-space, nowrap);overflow:hidden;text-overflow:ellipsis}.toast.svelte-1ih7d9r .msg.clamp.svelte-1ih7d9r{display:-webkit-box;-webkit-box-orient:vertical;-webkit-line-clamp:3;overflow:hidden}.toast.svelte-1ih7d9r .msg.clamp .title.svelte-1ih7d9r{display:-webkit-box;-webkit-box-orient:vertical;-webkit-line-clamp:2;overflow:hidden}.toast.svelte-1ih7d9r .title.svelte-1ih7d9r{display:block;font-size:var(--font-size-h4);line-height:var(--line-height-h4);font-weight:var(--font-weight-bold)}.toast.svelte-1ih7d9r button.close.svelte-1ih7d9r{padding:0;line-height:0;color:inherit}",
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
  $$result.css.add(css$5);
  ({ text: text2, level, spinner, title, overflow, position, icon, theme: theme2 } = msg);
  scroll = overflow === void 0 || overflow === "scroll";
  truncate = overflow === "truncate";
  clamp = overflow === "clamp";
  $$unsubscribe_i18n();
  return `<div role="dialog" class="${escape(null_to_empty(`toast ${theme2 ?? "themed"}`), true) + " svelte-1ih7d9r"}"><div class="${"icon " + escape(level, true) + " svelte-1ih7d9r"}" aria-hidden="true">${spinner ? `${validate_component(Spinner, "Spinner").$$render($$result, { size: "small", inline: true }, {}, {})}` : `${nonNullish(icon) ? `${validate_component(icon || missing_component, "svelte:component").$$render($$result, {}, {}, {})}` : `${iconMapper(level) ? `${validate_component(iconMapper(level) || missing_component, "svelte:component").$$render($$result, { size: DEFAULT_ICON_SIZE }, {}, {})}` : ``}`}`}</div> <p class="${[
    "msg svelte-1ih7d9r",
    (truncate ? "truncate" : "") + " " + (clamp ? "clamp" : "") + " " + (scroll ? "scroll" : "")
  ].join(" ").trim()}"${add_attribute("style", minHeightMessage, 0)}>${nonNullish(title) ? `<span class="title svelte-1ih7d9r">${escape(title)}</span>` : ``} ${escape(text2)}</p> <button class="close svelte-1ih7d9r"${add_attribute("aria-label", $i18n.core.close, 0)}>${validate_component(IconClose, "IconClose").$$render($$result, {}, {}, {})}</button> </div>`;
});
const Toasts_svelte_svelte_type_style_lang = "";
const css$4 = {
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
  $$result.css.add(css$4);
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
const WizardTransition_svelte_svelte_type_style_lang = "";
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
function createManagerStore() {
  const { subscribe: subscribe2, set } = writable(null);
  let systemState;
  systemStore.subscribe((value) => {
    systemState = value;
  });
  let actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function getManager() {
    try {
      return await actor.getManager();
    } catch (error2) {
      console.error("Error fetching manager for gameweek:", error2);
      throw error2;
    }
  }
  async function getPublicProfile(principalId) {
    try {
      return await actor.getPublicProfile(principalId);
    } catch (error2) {
      console.error("Error fetching manager profile for gameweek:", error2);
      throw error2;
    }
  }
  async function getTotalManagers() {
    try {
      const managerCountData = await actor.getTotalManagers();
      return Number(managerCountData);
    } catch (error2) {
      console.error("Error fetching total managers:", error2);
      throw error2;
    }
  }
  async function getFantasyTeamForGameweek(managerId, gameweek) {
    try {
      const fantasyTeamData = await actor.getFantasyTeamForGameweek(
        managerId,
        systemState?.calculationGameweek,
        gameweek
      );
      return fantasyTeamData;
    } catch (error2) {
      console.error("Error fetching fantasy team for gameweek:", error2);
      throw error2;
    }
  }
  async function getFantasyTeam() {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const fantasyTeam = await identityActor.getFantasyTeam();
      return fantasyTeam;
    } catch (error2) {
      console.error("Error fetching fantasy team:", error2);
      throw error2;
    }
  }
  async function saveFantasyTeam(userFantasyTeam, activeGameweek, bonusUsedInSession) {
    try {
      let bonusPlayed = 0;
      let bonusPlayerId = 0;
      let bonusTeamId = 0;
      if (bonusUsedInSession) {
        bonusPlayed = getBonusPlayed(userFantasyTeam, activeGameweek);
        bonusPlayerId = getBonusPlayerId(userFantasyTeam, activeGameweek);
        bonusTeamId = getBonusTeamId(userFantasyTeam, activeGameweek);
      }
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const fantasyTeam = await identityActor.saveFantasyTeam(
        userFantasyTeam.playerIds,
        userFantasyTeam.captainId,
        bonusPlayed,
        bonusPlayerId,
        bonusTeamId
      );
      return fantasyTeam;
    } catch (error2) {
      console.error("Error saving fantasy team:", error2);
      throw error2;
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
  async function snapshotFantasyTeams() {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      await identityActor.snapshotFantasyTeams();
    } catch (error2) {
      console.error("Error snapshotting fantasy teams:", error2);
      throw error2;
    }
  }
  return {
    subscribe: subscribe2,
    getManager,
    getTotalManagers,
    getFantasyTeamForGameweek,
    getFantasyTeam,
    saveFantasyTeam,
    snapshotFantasyTeams,
    getPublicProfile
  };
}
createManagerStore();
function createCountriesStore() {
  const { subscribe: subscribe2, set } = writable([]);
  let actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category = "countries";
    const newHashValues = await actor.getDataHashes();
    let error2 = isError(newHashValues);
    if (error2) {
      console.error("Error syncing countries store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (categoryHash?.hash != localHash) {
      let updatedCountriesData = await actor.getCountries();
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
createCountriesStore();
function createWeeklyLeaderboardStore() {
  const { subscribe: subscribe2, set } = writable(null);
  const itemsPerPage = 25;
  const category = "weekly_leaderboard";
  let actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync(seasonId, gameweek) {
    let category2 = "weekly_leaderboard";
    const newHashValues = await actor.getDataHashes();
    let error2 = isError(newHashValues);
    if (error2) {
      console.error("Error syncing leaderboard store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category2) ?? null;
    const localHash = localStorage.getItem(category2);
    if (categoryHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getWeeklyLeaderboard(
        seasonId,
        gameweek,
        100,
        0
      );
      if (isError(updatedLeaderboardData)) {
        console.error("error fetching leaderboard store");
      }
      localStorage.setItem(
        category2,
        JSON.stringify(updatedLeaderboardData.ok, replacer)
      );
      localStorage.setItem(`${category2}_hash`, categoryHash?.hash ?? "");
      set(updatedLeaderboardData.ok);
    }
  }
  async function getWeeklyLeaderboard(seasonId, gameweek, currentPage, calculationGameweek) {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    if (currentPage <= 4 && gameweek == calculationGameweek) {
      const cachedData = localStorage.getItem(category);
      if (cachedData) {
        let cachedWeeklyLeaderboard;
        cachedWeeklyLeaderboard = JSON.parse(
          cachedData || "{entries: [], gameweek: 0, seasonId: 0, totalEntries: 0n }"
        );
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
    let leaderboardData = await actor.getweeklyLeaderboard(
      seasonId,
      gameweek,
      limit,
      offset
    );
    localStorage.setItem(category, JSON.stringify(leaderboardData, replacer));
    return leaderboardData;
  }
  async function getLeadingWeeklyTeam(seasonId, gameweek) {
    let weeklyLeaderboard = await getWeeklyLeaderboard(
      seasonId,
      gameweek,
      1,
      0
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
function createPlayerStore() {
  const { subscribe: subscribe2, set } = writable([]);
  systemStore.subscribe((value) => {
  });
  fixtureStore.subscribe((value) => value);
  let actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category = "players";
    const newHashValues = await actor.getDataHashes();
    let error2 = isError(newHashValues);
    if (error2) {
      console.error("Error syncing player store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (categoryHash?.hash != localHash) {
      let updatedPlayersData = await actor.getPlayers();
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
    let loanedPlayers = await actor.getLoanPlayers(clubId);
    if (isError(loanedPlayers)) {
      console.error("Error fetching loaned players");
      return [];
    }
    return loanedPlayers.ok;
  }
  async function getRetiredPlayers(clubId) {
    let loanedPlayers = await actor.getRetiredPlayers(clubId);
    if (isError(loanedPlayers)) {
      console.error("Error fetching retired players");
      return [];
    }
    return loanedPlayers.ok;
  }
  return {
    subscribe: subscribe2,
    sync,
    getLoanedPlayers,
    getRetiredPlayers
  };
}
const playerStore = createPlayerStore();
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
    { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category = "player_events";
    const newHashValues = await actor.getDataHashes();
    let error2 = isError(newHashValues);
    if (error2) {
      console.error("Error syncing player events store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (categoryHash?.hash != localHash) {
      let updatedPlayerEventsData = await actor.getPlayerDetailsForGameweek(
        systemState.calculationSeasonId,
        systemState.calculationGameweek
      );
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
      const playerDetailData = await actor.getPlayerDetails(playerId, seasonId);
      return playerDetailData;
    } catch (error2) {
      console.error("Error fetching player data:", error2);
      throw error2;
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
      nationality: ""
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
function createUserStore() {
  const { subscribe: subscribe2, set } = writable(null);
  function uint8ArrayToBase64(bytes) {
    const binary = Array.from(bytes).map((byte) => String.fromCharCode(byte)).join("");
    return btoa(binary);
  }
  function base64ToUint8Array(base642) {
    const binary_string = atob(base642);
    const len = binary_string.length;
    const bytes = new Uint8Array(len);
    for (let i = 0; i < len; i++) {
      bytes[i] = binary_string.charCodeAt(i);
    }
    return bytes;
  }
  function getProfileFromLocalStorage() {
    const storedData = localStorage.getItem("user_profile_data");
    if (storedData) {
      const profileData = JSON.parse(storedData);
      if (profileData && typeof profileData.profilePicture === "string") {
        profileData.profilePicture = base64ToUint8Array(
          profileData.profilePicture
        );
      }
      return profileData;
    }
    return null;
  }
  async function sync() {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let getProfileResponse = await identityActor.getProfile();
      let error2 = isError(getProfileResponse);
      if (error2) {
        console.error("Error syncing user store");
        return;
      }
      if (!getProfileResponse) {
        await identityActor.createProfile();
        getProfileResponse = await identityActor.getProfile();
      }
      let profileData = getProfileResponse.ok;
      if (profileData && profileData.profilePicture instanceof Uint8Array) {
        const base64Picture = uint8ArrayToBase64(profileData.profilePicture);
        localStorage.setItem(
          "user_profile_data",
          JSON.stringify(
            {
              ...profileData,
              profilePicture: base64Picture
            },
            replacer
          )
        );
      } else {
        localStorage.setItem(
          "user_profile_data",
          JSON.stringify(profileData, replacer)
        );
      }
      set(profileData);
    } catch (error2) {
      console.error("Error fetching user profile:", error2);
      throw error2;
    }
  }
  async function createProfile() {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.createProfile();
      return result;
    } catch (error2) {
      console.error("Error updating username:", error2);
      throw error2;
    }
  }
  async function updateUsername(username) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.updateUsername(username);
      sync();
      return result;
    } catch (error2) {
      console.error("Error updating username:", error2);
      throw error2;
    }
  }
  async function updateFavouriteTeam(favouriteTeamId) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      sync();
      const result = await identityActor.updateFavouriteTeam(favouriteTeamId);
      return result;
    } catch (error2) {
      console.error("Error updating favourite team:", error2);
      throw error2;
    }
  }
  async function getProfile() {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.getProfile();
      set(result);
      return result;
    } catch (error2) {
      console.error("Error getting profile:", error2);
      throw error2;
    }
  }
  async function updateProfilePicture(picture) {
    try {
      const maxPictureSize = 1e3;
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
            { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
          );
          const result = await identityActor.updateProfilePicture(uint8Array);
          sync();
          return result;
        } catch (error2) {
          console.error(error2);
        }
      };
    } catch (error2) {
      console.error("Error updating username:", error2);
      throw error2;
    }
  }
  return {
    subscribe: subscribe2,
    sync,
    updateUsername,
    updateFavouriteTeam,
    getProfile,
    updateProfilePicture,
    createProfile,
    getProfileFromLocalStorage
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
const goto = /* @__PURE__ */ client_method("goto");
const adminPrincipal = "nn75s-ayupf-j6mj3-kluyb-wjj7y-eang2-dwzzr-cfdxk-etbw7-cgwnb-lqe";
const authSignedInStore = derived(
  authStore,
  ({ identity }) => identity !== null && identity !== void 0
);
const authIsAdmin = derived(
  authStore,
  ({ identity }) => identity !== null && identity !== void 0 && identity.getPrincipal().toString() === adminPrincipal
);
const userGetProfilePicture = derived(
  userStore,
  (user) => user !== null && user !== void 0 && user.profilePicture !== void 0 && user.profilePicture.length > 0 ? URL.createObjectURL(new Blob([new Uint8Array(user.profilePicture)])) : "profile_placeholder.png"
);
derived(
  userStore,
  (user) => user !== null && user !== void 0 ? user.favouriteTeamId : 0
);
const Header_svelte_svelte_type_style_lang = "";
const css$3 = {
  code: 'header.svelte-197nckd{background-color:rgba(36, 37, 41, 0.9)}.nav-underline.svelte-197nckd{position:relative;display:inline-block;color:white}.nav-underline.svelte-197nckd::after{content:"";position:absolute;width:100%;height:2px;background-color:#2ce3a6;bottom:0;left:0;transform:scaleX(0);transition:transform 0.3s ease-in-out;color:#2ce3a6}.nav-underline.svelte-197nckd:hover::after,.nav-underline.active.svelte-197nckd::after{transform:scaleX(1);color:#2ce3a6}.nav-underline.svelte-197nckd:hover::after{transform:scaleX(1);background-color:gray}.nav-button.svelte-197nckd{background-color:transparent}.nav-button.svelte-197nckd:hover{background-color:transparent;color:#2ce3a6;border:none}',
  map: null
};
const Header = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let currentClass;
  let currentBorder;
  let $page, $$unsubscribe_page;
  let $$unsubscribe_systemStore;
  let $authSignedInStore, $$unsubscribe_authSignedInStore;
  let $authIsAdmin, $$unsubscribe_authIsAdmin;
  let $userGetProfilePicture, $$unsubscribe_userGetProfilePicture;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  $$unsubscribe_systemStore = subscribe(systemStore, (value) => value);
  $$unsubscribe_authSignedInStore = subscribe(authSignedInStore, (value) => $authSignedInStore = value);
  $$unsubscribe_authIsAdmin = subscribe(authIsAdmin, (value) => $authIsAdmin = value);
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
  $$result.css.add(css$3);
  currentClass = (route) => $page.url.pathname === route ? "text-blue-500 nav-underline active" : "nav-underline";
  currentBorder = (route) => $page.url.pathname === route ? "active-border" : "";
  $$unsubscribe_page();
  $$unsubscribe_systemStore();
  $$unsubscribe_authSignedInStore();
  $$unsubscribe_authIsAdmin();
  $$unsubscribe_userGetProfilePicture();
  return `<header class="svelte-197nckd"><nav class="text-white"><div class="px-4 h-16 flex justify-between items-center w-full"><a href="/" class="hover:text-gray-400 flex items-center">${validate_component(OpenFPLIcon, "OpenFPLIcon").$$render($$result, { className: "h-8 w-auto" }, {}, {})}<b class="ml-2" data-svelte-h="svelte-6ko9z9">OpenFPL</b></a> <button class="menu-toggle md:hidden focus:outline-none" data-svelte-h="svelte-1xcvmve"><svg width="24" height="18" viewBox="0 0 24 18" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="24" height="2" rx="1" fill="currentColor"></rect><rect y="8" width="24" height="2" rx="1" fill="currentColor"></rect><rect y="16" width="24" height="2" rx="1" fill="currentColor"></rect></svg></button> ${$authSignedInStore ? `<ul class="hidden md:flex h-16"><li class="mx-2 flex items-center h-16"><a href="/" class="${"flex items-center h-full nav-underline hover:text-gray-400 $" + escape(currentClass("/"), true) + " svelte-197nckd"}"><span class="flex items-center h-full px-4" data-svelte-h="svelte-fx32ra">Home</span></a></li> <li class="mx-2 flex items-center h-16"><a href="/pick-team" class="${"flex items-center h-full nav-underline hover:text-gray-400 $" + escape(currentClass("/pick-team"), true) + " svelte-197nckd"}"><span class="flex items-center h-full px-4" data-svelte-h="svelte-1k6m4hl">Squad Selection</span></a></li> <li class="mx-2 flex items-center h-16"><a href="/governance" class="${"flex items-center h-full nav-underline hover:text-gray-400 $" + escape(currentClass("/governance"), true) + " svelte-197nckd"}"><span class="flex items-center h-full px-4" data-svelte-h="svelte-qfd2bh">Governance</span></a></li> ${$authIsAdmin ? `<li class="mx-2 flex items-center h-16"><a href="/admin" class="${"flex items-center h-full nav-underline hover:text-gray-400 $" + escape(currentClass("/admin"), true) + " svelte-197nckd"}"><span class="flex items-center h-full px-4" data-svelte-h="svelte-bcs0jk">Admin</span></a></li>` : ``} <li class="flex flex-1 items-center"><div class="relative inline-block"><button class="${escape(null_to_empty(`h-full flex items-center border rounded-sm ${currentBorder("/profile")}`), true) + " svelte-197nckd"}"><img${add_attribute("src", $userGetProfilePicture, 0)} alt="Profile" class="h-12 rounded-sm profile-pic" aria-label="Toggle Profile"></button> <div class="${escape(null_to_empty(`absolute right-0 top-full w-48 bg-black rounded-b-md rounded-l-md shadow-lg z-50 profile-dropdown ${showProfileDropdown ? "block" : "hidden"}`), true) + " svelte-197nckd"}"><ul class="text-gray-700"><li><a href="/profile" class="flex items-center h-full w-full nav-underline hover:text-gray-400 svelte-197nckd"><span class="flex items-center h-full w-full"><img${add_attribute("src", $userGetProfilePicture, 0)} alt="logo" class="w-8 h-8 my-2 ml-4 mr-2"> <p class="w-full min-w-[125px] max-w-[125px] truncate" data-svelte-h="svelte-1mjctb">Profile</p></span></a></li> <li><button class="flex items-center justify-center px-4 pb-2 pt-1 text-white rounded-md shadow focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-197nckd">Disconnect
                      ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul></div></div></li></ul> <div class="${escape(null_to_empty(`mobile-menu-panel absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${"hidden"} md:hidden`), true) + " svelte-197nckd"}"><ul class="flex flex-col"><li class="p-2"><a href="/" class="${escape(null_to_empty(`nav-underline hover:text-gray-400 ${currentClass("/")}`), true) + " svelte-197nckd"}">Home</a></li> <li class="p-2"><a href="/pick-team" class="${escape(null_to_empty(currentClass("/pick-team")), true) + " svelte-197nckd"}">Squad Selection</a></li> <li class="p-2"><a href="/governance" class="${escape(null_to_empty(currentClass("/governance")), true) + " svelte-197nckd"}">Governance</a></li> <li class="p-2"><a href="/profile" class="${"flex h-full w-full nav-underline hover:text-gray-400 w-full $" + escape(currentClass("/profile"), true) + " svelte-197nckd"}"><span class="flex items-center h-full w-full"><img${add_attribute("src", $userGetProfilePicture, 0)} alt="logo" class="w-8 h-8 rounded-sm"> <p class="w-full min-w-[100px] max-w-[100px] truncate p-2" data-svelte-h="svelte-f2gegq">Profile</p></span></a></li> <li class="px-2"><button class="flex h-full w-full hover:text-gray-400 w-full items-center">Disconnect
                ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul></div>` : `<ul class="hidden md:flex"><li class="mx-2 flex items-center h-16"><button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-197nckd">Connect
              ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul> <div class="${escape(null_to_empty(`mobile-menu-panel absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${"hidden"} md:hidden`), true) + " svelte-197nckd"}"><ul class="flex flex-col"><li class="p-2"><button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-197nckd">Connect
                ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul></div>`}</div></nav> </header>`;
});
const JunoIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 130 130"><g id="Layer_1-2"><g><path d="M91.99,64.798c0,-20.748 -16.845,-37.593 -37.593,-37.593l-0.003,-0c-20.749,-0 -37.594,16.845 -37.594,37.593l0,0.004c0,20.748 16.845,37.593 37.594,37.593l0.003,0c20.748,0 37.593,-16.845 37.593,-37.593l0,-0.004Z"></path><circle cx="87.153" cy="50.452" r="23.247" style="fill:#7888ff;"></circle></g></g></svg>`;
});
const Footer = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `<footer class="bg-gray-900 text-white py-3"><div class="container mx-1 xs:mx-2 md:mx-auto flex flex-col md:flex-row items-start md:items-center justify-between text-xs"><div class="flex-1" data-svelte-h="svelte-bvvjxr"><div class="flex justify-start"><div class="flex flex-row pl-4"><a href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/?ref=zv6hh-xaaaa-aaaar-ac35q-cai" target="_blank" rel="noopener noreferrer"><img src="openchat.png" class="h-4 w-auto mb-2 mr-2" alt="OpenChat"></a> <a href="https://twitter.com/OpenFPL_DAO" target="_blank" rel="noopener noreferrer"><img src="twitter.png" class="h-4 w-auto mb-2 mr-2" alt="Twitter"></a> <a href="https://t.co/WmOhFA8JUR" target="_blank" rel="noopener noreferrer"><img src="discord.png" class="h-4 w-auto mb-2 mr-2" alt="Discord"></a> <a href="https://t.co/vVkquMrdOu" target="_blank" rel="noopener noreferrer"><img src="telegram.png" class="h-4 w-auto mb-2 mr-2" alt="Telegram"></a> <a href="https://github.com/jamesbeadle/OpenFPL" target="_blank" rel="noopener noreferrer"><img src="github.png" class="h-4 w-auto mb-2" alt="GitHub"></a></div></div> <div class="flex justify-start"><div class="flex flex-col md:flex-row md:space-x-2 pl-4"><a href="/whitepaper" class="hover:text-gray-300">Whitepaper</a> <span class="hidden md:flex">|</span> <a href="/gameplay-rules" class="hover:text-gray-300 md:hidden lg:block">Gameplay Rules</a> <a href="/gameplay-rules" class="hover:text-gray-300 hidden md:block lg:hidden">Rules</a> <span class="hidden md:flex">|</span> <a href="/terms" class="hover:text-gray-300">Terms &amp; Conditions</a></div></div></div> <div class="flex-0"><a href="/"><b class="px-4 mt-2 md:mt-0 md:px-10 flex items-center">${validate_component(OpenFPLIcon, "OpenFplIcon").$$render($$result, { className: "h-6 w-auto mr-2" }, {}, {})}OpenFPL</b></a></div> <div class="flex-1"><div class="flex justify-end"><div class="text-right px-4 md:px-0 mt-1 md:mt-0 md:mr-4"><a href="https://juno.build" target="_blank" class="hover:text-gray-300 flex items-center">Sponsored By juno.build
            ${validate_component(JunoIcon, "JunoIcon").$$render($$result, { className: "h-8 w-auto ml-2" }, {}, {})}</a></div></div></div></div></footer>`;
});
const app = "";
const Layout_svelte_svelte_type_style_lang = "";
const css$2 = {
  code: "main.svelte-vmfccd{flex:1;display:flex;flex-direction:column}",
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
  $$result.css.add(css$2);
  $$unsubscribe_authStore();
  return ` ${function(__value) {
    if (is_promise(__value)) {
      __value.then(null, noop);
      return ` <div>${validate_component(Spinner, "Spinner").$$render($$result, {}, {}, {})}</div> `;
    }
    return function(_) {
      return ` <div class="flex flex-col h-screen justify-between default-text">${validate_component(Header, "Header").$$render($$result, {}, {}, {})} <main class="page-wrapper svelte-vmfccd">${slots.default ? slots.default({}) : ``}</main> ${validate_component(Toasts, "Toasts").$$render($$result, {}, {}, {})} ${validate_component(Footer, "Footer").$$render($$result, {}, {}, {})}</div> `;
    }();
  }(init2())} ${validate_component(BusyScreen, "BusyScreen").$$render($$result, {}, {}, {})}`;
});
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
    { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category2 = "monthly_leaderboards";
    const newHashValues = await actor.getDataHashes();
    let error2 = isError(newHashValues);
    if (error2) {
      console.error("Error syncing monthly leaderboard store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category2) ?? null;
    const localHash = localStorage.getItem(category2);
    if (categoryHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getMonthlyLeaderboards();
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
  async function getMonthlyLeaderboard(seasonId, clubId, month, currentPage) {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    if (currentPage <= 4 && month == systemState?.calculationMonth) {
      const cachedData = localStorage.getItem(category);
      if (cachedData) {
        let cachedLeaderboards = JSON.parse(cachedData);
        let clubLeaderboard = cachedLeaderboards.find(
          (x) => x.clubId === clubId
        );
        if (clubLeaderboard) {
          return {
            ...clubLeaderboard,
            entries: clubLeaderboard.entries.slice(offset, offset + limit)
          };
        }
      }
    }
    let leaderboardData = await actor.getClubLeaderboards(
      seasonId,
      month,
      clubId,
      limit,
      offset
    );
    if (leaderboardData) {
      let clubLeaderboard = leaderboardData.find((x) => x.clubId === clubId);
      if (clubLeaderboard == null) {
        return {
          month: 0,
          clubId: 0,
          totalEntries: 0n,
          seasonId: 0,
          entries: []
        };
      }
      return {
        ...clubLeaderboard,
        entries: clubLeaderboard.entries.slice(offset, offset + limit)
      };
    }
    return leaderboardData;
  }
  return {
    subscribe: subscribe2,
    sync,
    getMonthlyLeaderboard
  };
}
createMonthlyLeaderboardStore();
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
    { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category2 = "season_leaderboard";
    const newHashValues = await actor.getDataHashes();
    let error2 = isError(newHashValues);
    if (error2) {
      console.error("Error syncing season leaderboard store");
      return;
    }
    let dataCacheValues = newHashValues.ok;
    let categoryHash = dataCacheValues.find((x) => x.category === category2) ?? null;
    const localHash = localStorage.getItem(category2);
    if (categoryHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getSeasonLeaderboard(
        systemState?.calculationSeasonId
      );
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
  async function getSeasonLeaderboard(seasonId, currentPage) {
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
    let leaderboardData = await actor.getSeasonLeaderboard(
      seasonId,
      limit,
      offset
    );
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
const _page_svelte_svelte_type_style_lang$1 = "";
const css$1 = {
  code: ".w-v.svelte-18fkfyi{width:20px}",
  map: null
};
const Page$b = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $$unsubscribe_systemStore;
  let $$unsubscribe_teamStore;
  $$unsubscribe_systemStore = subscribe(systemStore, (value) => value);
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => value);
  $$result.css.add(css$1);
  $$unsubscribe_systemStore();
  $$unsubscribe_teamStore();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(Spinner, "Spinner").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
function createGovernanceStore() {
  async function revaluePlayerUp(playerId) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminRevaluePlayerUp(playerId);
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function revaluePlayerDown(playerId) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminRevaluePlayerDown(playerId);
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function submitFixtureData(seasonId, gameweek, fixtureId, playerEventData) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminSubmitFixtureData(
        seasonId,
        gameweek,
        fixtureId,
        playerEventData
      );
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function addInitialFixtures(seasonId, seasonFixtures) {
    if (seasonId == 0) {
      return;
    }
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminAddInitialFixtures(
        seasonId,
        seasonFixtures
      );
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function rescheduleFixture(seasonId, fixtureId, updatedFixtureGameweek, updatedFixtureDate) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminRescheduleFixture(
        seasonId,
        fixtureId,
        updatedFixtureGameweek,
        updatedFixtureDate
      );
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function loanPlayer(playerId, loanClubId, loanEndDate) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminLoanPlayer(
        playerId,
        loanClubId,
        loanEndDate
      );
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function transferPlayer(playerId, newClubId) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminTransferPlayer(playerId, newClubId);
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function recallPlayer(playerId) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminRecallPlayer(playerId);
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function createPlayer(clubId, position, firstName, lastName, shirtNumber, valueQuarterMillions, dateOfBirth, nationality) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminCreatePlayer(
        clubId,
        position,
        firstName,
        lastName,
        shirtNumber,
        valueQuarterMillions,
        dateOfBirth,
        nationality
      );
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function updatePlayer(playerId, position, firstName, lastName, shirtNumber, dateOfBirth, nationalityId) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminUpdatePlayer(
        playerId,
        position,
        firstName,
        lastName,
        shirtNumber,
        dateOfBirth,
        nationalityId
      );
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function setPlayerInjury(playerId, description, expectedEndDate) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminSetPlayerInjury(
        playerId,
        description,
        expectedEndDate
      );
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function retirePlayer(playerId, retirementDate) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminRetirePlayer(playerId, retirementDate);
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function unretirePlayer(playerId) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminUnretirePlayer(playerId);
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function promoteFormerClub(clubId) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminPromoteFormerClub(clubId);
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function promoteNewClub(name, friendlyName, primaryColourHex, secondaryColourHex, thirdColourHex, abbreviatedName, shirtType) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminPromoteNewClub(
        name,
        friendlyName,
        primaryColourHex,
        secondaryColourHex,
        thirdColourHex,
        abbreviatedName,
        shirtType
      );
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  async function updateClub(clubId, name, friendlyName, primaryColourHex, secondaryColourHex, thirdColourHex, abbreviatedName, shirtType) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "gl6nx-5maaa-aaaaa-qaaqq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "gc5gl-leaaa-aaaaa-qaara-cai", "__CANDID_UI_CANISTER_ID": "gx2xg-kmaaa-aaaaa-qaasq-cai", "PLAYER_CANISTER_CANISTER_ID": "gf4a7-g4aaa-aaaaa-qaarq-cai", "TOKEN_CANISTER_CANISTER_ID": "gq3rs-huaaa-aaaaa-qaasa-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = identityActor.adminUpdateClub(
        clubId,
        name,
        friendlyName,
        primaryColourHex,
        secondaryColourHex,
        thirdColourHex,
        abbreviatedName,
        shirtType
      );
      if (isError(result)) {
        console.error("Error submitting proposal");
        return;
      }
    } catch (error2) {
      console.error("Error submitting fixture data:", error2);
      throw error2;
    }
  }
  return {
    revaluePlayerUp,
    revaluePlayerDown,
    submitFixtureData,
    addInitialFixtures,
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
      return `<div class="p-4"><div class="flex justify-between items-center my-2"><h4 data-svelte-h="svelte-1yevh2p">Confirm Fixture Data</h4> <button class="text-black" data-svelte-h="svelte-naxdfo">✕</button></div> <div class="my-5" data-svelte-h="svelte-1kpybyt"><h1>Please confirm your fixture data.</h1> <p class="text-gray-600">You will not be able to edit your submission and entries that differ
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
      return `<div class="p-4"><div class="flex justify-between items-center my-2"><h3 class="default-header" data-svelte-h="svelte-rcqdii">Clear Draft</h3> <button class="times-button" data-svelte-h="svelte-2aq7vi">×</button></div> <p data-svelte-h="svelte-idipww">Please confirm you want to clear the draft from your cache.</p> <div class="items-center py-3 flex space-x-4"><button class="default-button fpl-cancel-btn" type="button" data-svelte-h="svelte-1husm0b">Cancel</button> <button class="default-button fpl-button" data-svelte-h="svelte-zv2dtu">Clear</button></div></div>`;
    }
  })}`;
});
const Page$a = create_ssr_component(($$result, $$props, $$bindings, slots) => {
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
    } catch (error2) {
      toastsError({
        msg: { text: "Error saving fixture data." },
        err: error2
      });
      console.error("Error saving fixture data: ", error2);
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
const Page$9 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { showSystemStateModal = false } = $$props;
  let { showSnapshotModal = false } = $$props;
  if ($$props.showSystemStateModal === void 0 && $$bindings.showSystemStateModal && showSystemStateModal !== void 0)
    $$bindings.showSystemStateModal(showSystemStateModal);
  if ($$props.showSnapshotModal === void 0 && $$bindings.showSnapshotModal && showSnapshotModal !== void 0)
    $$bindings.showSnapshotModal(showSnapshotModal);
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(Spinner, "Spinner").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
const Page$8 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
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
const _page_svelte_svelte_type_style_lang = "";
const css = {
  code: ".striped.svelte-58jp75 tr.svelte-58jp75:nth-child(odd){background-color:rgba(46, 50, 58, 0.6)}",
  map: null
};
const Page$7 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  $$result.css.add(css);
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="bg-panel rounded-md p-4 mt-4" data-svelte-h="svelte-1c0sjgs"><h1 class="default-header">OpenFPL Gameplay Rules</h1> <div><p class="my-2">Please see the below OpenFPL fantasy football gameplay rules.</p> <p class="my-2">Each user begins with £300m to purchase players for their team. The
        value of a player can go up or down depending on how the player is rated
        in the DAO. Provided a certain voting threshold is reached for either a
        £0.25m increase or decrease, the player&#39;s value will change in that
        gameweek.</p> <p class="my-2">Each team has 11 players, with no more than 2 selected from any single
        team. The team must be in a valid formation, with 1 goalkeeper, 3-5
        defenders, 3-5 midfielders and 1-3 strikers.</p> <p class="my-2">Users will setup their team before the gameweek deadline each week. When
        playing OpenFPL, users have the chance to win FPL tokens depending on
        how well the players in their team perform.</p> <p class="my-2">In January, a user can change their entire team once.</p> <p class="my-2">A user is allowed to make 3 transfers per week which are never carried
        over.</p> <p class="my-2">Each week a user can select a star player. This player will receive
        double points for the gameweek. If one is not set by the start of the
        gameweek it will automatically be set to the most valuable player in
        your team.</p> <h2 class="default-sub-header">Points</h2> <p class="my-2">The user can get the following points during a gameweek for their team:</p> <table class="w-full border-collapse striped mb-8 mt-4 svelte-58jp75"><tr class="svelte-58jp75"><th class="text-left px-4 py-2">For</th> <th class="text-left">Points</th></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Appearing in the game.</td> <td>5</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Every 3 saves a goalkeeper makes.</td> <td>5</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Goalkeeper or defender cleansheet.</td> <td>10</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Forward scores a goal.</td> <td>10</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Midfielder or Forward assists a goal.</td> <td>10</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Midfielder scores a goal.</td> <td>15</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Goalkeeper or defender assists a goal.</td> <td>15</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Goalkeeper or defender scores a goal.</td> <td>20</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Goalkeeper saves a penalty.</td> <td>20</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Player is highest scoring player in match.</td> <td>25</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Player receives a red card.</td> <td>-20</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Player misses a penalty.</td> <td>-15</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Each time a goalkeeper or defender concedes 2 goals.</td> <td>-15</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">A player scores an own goal.</td> <td>-10</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">A player receives a yellow card.</td> <td>-5</td></tr></table> <h2 class="default-sub-header">Bonuses</h2> <p class="my-2">A user can play 1 bonus per gameweek. Each season a user starts with the
        following 8 bonuses:</p> <table class="w-full border-collapse striped mb-8 mt-4 svelte-58jp75"><tr class="svelte-58jp75"><th class="text-left px-4 py-2">Bonus</th> <th class="text-left">Description</th></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Goal Getter</td> <td>Select a player you think will score in a game to receive a X3
            mulitplier for each goal scored.</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Pass Master</td> <td>Select a player you think will assist in a game to receive a X3
            mulitplier for each assist.</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">No Entry</td> <td>Select a goalkeeper or defender you think will keep a clean sheet
            to receive a X3 multipler on their total score.</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Team Boost</td> <td>Receive a X2 multiplier from all players from a single club that
            are in your team.</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Safe Hands</td> <td>Receive a X3 multiplier on your goalkeeper if they make 5 saves in
            a match.</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Captain Fantastic</td> <td>Receive a X2 multiplier on your team captain&#39;s score if they score
            a goal in a match.</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Countrymen</td> <td>Receive a X2 multiplier for players of a selected nationality.</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Prospects</td> <td>Receive a X2 multiplier for players under the age of 21.</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Brace Bonus</td> <td>Receive a X2 multiplier on a player&#39;s score if they score 2 or more
            goals in a game. Applies to every player who scores a brace.</td></tr> <tr class="svelte-58jp75"><td class="text-left px-4 py-2">Hat Trick Hero</td> <td>Receive a X3 multiplier on a player&#39;s score if they score 3 or more
            goals in a game. Applies to every player who scores a hat-trick.</td></tr></table></div></div>`;
    }
  })}`;
});
const Page$6 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return ` ${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="m-4"><div class="bg-panel rounded-md"><ul class="flex rounded-t-lg bg-light-gray border-b border-gray-700 px-4 pt-2"><li${add_attribute("class", `mr-4 ${"active-tab"}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-white"}`,
        0
      )}>Proposals</button></li></ul> ${`<div class="p-4" data-svelte-h="svelte-10zbl4w"><p>Proposals will appear here after the SNS decentralisation sale.</p> <p>For now the OpenFPL team will continue to add fixture data through <a class="text-blue-500" href="/fixture-validation">this</a> view.</p></div>`}</div></div>`;
    }
  })}`;
});
const Page$5 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
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
      return `${`${validate_component(Spinner, "Spinner").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
const bonusPanel_svelte_svelte_type_style_lang = "";
const addPlayerModal_svelte_svelte_type_style_lang = "";
function getGridSetup(formation) {
  const formationSplits = formation.split("-").map(Number);
  const setups = [[1], ...formationSplits.map((s2) => Array(s2).fill(0).map((_, i) => i + 1))];
  return setups;
}
function isBonusConditionMet(team) {
  if (!team) {
    return false;
  }
  const gameweekCounts = {};
  const bonusGameweeks = [
    team.hatTrickHeroGameweek,
    team.teamBoostGameweek,
    team.captainFantasticGameweek,
    team.braceBonusGameweek,
    team.passMasterGameweek,
    team.goalGetterGameweek,
    team.noEntryGameweek,
    team.safeHandsGameweek,
    team.countrymenGameweek,
    team.prospectsGameweek
  ];
  for (const gw of bonusGameweeks) {
    if (gw !== 0) {
      gameweekCounts[gw] = (gameweekCounts[gw] || 0) + 1;
      if (gameweekCounts[gw] > 1) {
        return false;
      }
    }
  }
  return true;
}
const Page$4 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $$unsubscribe_bonusUsedInSession;
  let $fantasyTeam, $$unsubscribe_fantasyTeam;
  let $playerStore, $$unsubscribe_playerStore;
  let $bankBalance, $$unsubscribe_bankBalance;
  let $transfersAvailable, $$unsubscribe_transfersAvailable;
  let $$unsubscribe_systemStore;
  let $$unsubscribe_newCaptain;
  let $$unsubscribe_availableFormations;
  let $$unsubscribe_teamStore;
  $$unsubscribe_playerStore = subscribe(playerStore, (value) => $playerStore = value);
  $$unsubscribe_systemStore = subscribe(systemStore, (value) => value);
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => value);
  const formations = {
    "3-4-3": {
      positions: [0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3]
    },
    "3-5-2": {
      positions: [0, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3]
    },
    "4-3-3": {
      positions: [0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3]
    },
    "4-4-2": {
      positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3]
    },
    "4-5-1": {
      positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3]
    },
    "5-4-1": {
      positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3]
    },
    "5-3-2": {
      positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3]
    }
  };
  const availableFormations = writable(["3-4-3", "3-5-2", "4-3-3", "4-4-2", "4-5-1", "5-4-1", "5-3-2"]);
  $$unsubscribe_availableFormations = subscribe(availableFormations, (value) => value);
  let selectedFormation = "4-4-2";
  const fantasyTeam = writable(null);
  $$unsubscribe_fantasyTeam = subscribe(fantasyTeam, (value) => $fantasyTeam = value);
  const transfersAvailable = writable(Infinity);
  $$unsubscribe_transfersAvailable = subscribe(transfersAvailable, (value) => $transfersAvailable = value);
  const bankBalance = writable(1200);
  $$unsubscribe_bankBalance = subscribe(bankBalance, (value) => $bankBalance = value);
  const bonusUsedInSession = writable(false);
  $$unsubscribe_bonusUsedInSession = subscribe(bonusUsedInSession, (value) => value);
  const newCaptain = writable("");
  $$unsubscribe_newCaptain = subscribe(newCaptain, (value) => value);
  function getTeamFormation(team) {
    const positionCounts = { 0: 0, 1: 0, 2: 0, 3: 0 };
    team.playerIds.forEach((id) => {
      const teamPlayer = $playerStore.find((p) => p.id === id);
      if (teamPlayer) {
        positionCounts[convertPlayerPosition(teamPlayer.position)]++;
      }
    });
    for (const formation of Object.keys(formations)) {
      const formationPositions = formations[formation].positions;
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
    const formations2 = getAvailableFormations($playerStore, $fantasyTeam);
    availableFormations.set(formations2);
  }
  function updateTeamValue() {
    const team = $fantasyTeam;
    if (team) {
      let totalValue = 0;
      team.playerIds.forEach((id) => {
        const player = $playerStore.find((p) => p.id === id);
        if (player) {
          totalValue += player.valueQuarterMillions;
        }
      });
    }
  }
  function checkSaveButtonConditions() {
    const teamCount = /* @__PURE__ */ new Map();
    for (const playerId of $fantasyTeam?.playerIds || []) {
      if (playerId > 0) {
        const player = $playerStore.find((p) => p.id === playerId);
        if (player) {
          teamCount.set(player.clubId, (teamCount.get(player.clubId) || 0) + 1);
          if (teamCount.get(player.clubId) > 2) {
            return false;
          }
        }
      }
    }
    if (!isBonusConditionMet($fantasyTeam)) {
      return false;
    }
    if ($fantasyTeam?.playerIds.filter((id) => id > 0).length !== 11) {
      return false;
    }
    if ($bankBalance < 0) {
      return false;
    }
    if ($transfersAvailable < 0) {
      return false;
    }
    if (!isValidFormation($fantasyTeam, selectedFormation)) {
      return false;
    }
    return true;
  }
  function isValidFormation(team, selectedFormation2) {
    const positionCounts = { 0: 0, 1: 0, 2: 0, 3: 0 };
    team.playerIds.forEach((id) => {
      const teamPlayer = $playerStore.find((p) => p.id === id);
      if (teamPlayer) {
        positionCounts[convertPlayerPosition(teamPlayer.position)]++;
      }
    });
    const [def, mid, fwd] = selectedFormation2.split("-").map(Number);
    const minDef = Math.max(0, def - (positionCounts[1] || 0));
    const minMid = Math.max(0, mid - (positionCounts[2] || 0));
    const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
    const minGK = Math.max(0, 1 - (positionCounts[0] || 0));
    const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
    const totalPlayers = Object.values(positionCounts).reduce((a, b) => a + b, 0);
    return totalPlayers + additionalPlayersNeeded <= 11;
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
  getGridSetup(selectedFormation);
  {
    if ($fantasyTeam) {
      disableInvalidFormations();
      updateTeamValue();
      checkSaveButtonConditions();
    }
  }
  $$unsubscribe_bonusUsedInSession();
  $$unsubscribe_fantasyTeam();
  $$unsubscribe_playerStore();
  $$unsubscribe_bankBalance();
  $$unsubscribe_transfersAvailable();
  $$unsubscribe_systemStore();
  $$unsubscribe_newCaptain();
  $$unsubscribe_availableFormations();
  $$unsubscribe_teamStore();
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
  $$unsubscribe_teamStore = subscribe(teamStore, (value) => $teamStore = value);
  $$unsubscribe_fixtureStore = subscribe(fixtureStore, (value) => $fixtureStore = value);
  $$unsubscribe_playerStore = subscribe(playerStore, (value) => value);
  $$unsubscribe_systemStore = subscribe(systemStore, (value) => $systemStore = value);
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
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
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(Spinner, "Spinner").$$render($$result, {}, {}, {})}`}`;
    }
  })}`;
});
const profileDetail_svelte_svelte_type_style_lang = "";
const Page$2 = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${`${validate_component(Spinner, "Spinner").$$render($$result, {}, {}, {})}`}`;
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
const dao_svelte_svelte_type_style_lang = "";
const tokenomics_svelte_svelte_type_style_lang = "";
const Vision = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `<div class="m-4" data-svelte-h="svelte-xgyb9x"><h1 class="default-header">Our Vision</h1> <p class="my-4">In an evolving landscape where blockchain technology is still unlocking its
    potential, the Internet Computer offers a promising platform for innovative
    applications. OpenFPL is one such initiative, aiming to transform fantasy
    Premier League football into a more engaging and decentralised experience.</p> <p class="my-4">Our goal is to develop this popular service into a decentralised autonomous
    organisation (DAO), rewarding fans for their insight and participation in
    football.</p> <p class="my-4">Our vision for OpenFPL encompasses a commitment to societal impact,
    specifically through meaningful contributions to the ICPFA community fund.
    This effort is focused on supporting grassroots football initiatives,
    demonstrating our belief in OpenFPL&#39;s ability to bring about positive change
    in the football community.</p> <p class="my-4">OpenFPL aims to be recognised as more than just a digital platform; we
    aspire to build a brand that creates diverse revenue opportunities. We aim
    to distribute this revenue to token holders through the purchase and burning
    of $FPL from exchanges, aiming to increase the utility token&#39;s value.</p> <p class="my-4">Central to OpenFPL is our community focus. We strive to create a space where
    Premier League fans feel at home, with their input shaping the service. Our
    features, including community-based player valuations, customisable private
    leagues, and collaborations with football content creators, are all aimed at
    enhancing user engagement. As we attract more users, we expect an increased
    demand for our services, which will contribute to the growth and value of
    our governance token, $FPL.</p> <p class="my-4">In essence, OpenFPL represents a unique blend of football passion and
    blockchain innovation. Our approach is about more than just reinventing
    fantasy sports; it&#39;s about building a vibrant community, pushing
    technological boundaries, and generating new economic opportunities. OpenFPL
    seeks to redefine the way fans engage with the sport they love, making a
    real impact in the football world.</p> <p class="my-4">Innovation is at the heart of OpenFPL. We are excited about exploring the
    possibilities of integrating on-chain AI to assist managers with team
    selection. This endeavor is not just about enhancing the user experience;
    it&#39;s about exploring new frontiers for blockchain technology in sports.</p></div>`;
});
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="bg-panel mt-4"><h1 class="p-4 mx-1 default-header" data-svelte-h="svelte-pit84d">OpenFPL Whitepaper</h1> <ul class="flex flex-nowrap overflow-x-auto bg-light-gray border-b border-gray-700 px-4 pt-2"><li${add_attribute("class", `mr-4 ${"active-tab"}`, 0)}><button${add_attribute("class", `p-2 ${"text-white"}`, 0)}>Vision</button></li> <li${add_attribute("class", `mr-4 ${""}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-gray-400"}`,
        0
      )}>Gameplay</button></li> <li${add_attribute("class", `mr-4 ${""}`, 0)}><button${add_attribute("class", `p-2 ${"text-gray-400"}`, 0)}>Roadmap</button></li> <li${add_attribute("class", `mr-4 ${""}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-gray-400"}`,
        0
      )}>Marketing</button></li> <li${add_attribute("class", `mr-4 ${""}`, 0)}><button${add_attribute("class", `p-2 ${"text-gray-400"}`, 0)}>Revenue</button></li> <li${add_attribute("class", `mr-4 ${""}`, 0)}><button${add_attribute("class", `p-2 ${"text-gray-400"}`, 0)}>DAO</button></li> <li${add_attribute("class", `mr-4 ${""}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-gray-400"}`,
        0
      )}>Tokenomics</button></li> <li${add_attribute("class", `mr-4 ${""}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-gray-400"}`,
        0
      )}>Architecture</button></li></ul> ${`${validate_component(Vision, "Vision").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
export {
  Error$1 as E,
  Layout$1 as L,
  Page$b as P,
  Server as S,
  set_building as a,
  set_private_env as b,
  set_public_env as c,
  Page$a as d,
  Page$9 as e,
  Page$8 as f,
  get_hooks as g,
  Page$7 as h,
  Page$6 as i,
  Page$5 as j,
  Page$4 as k,
  Page$3 as l,
  Page$2 as m,
  Page$1 as n,
  options as o,
  Page as p,
  set_assets as s
};
