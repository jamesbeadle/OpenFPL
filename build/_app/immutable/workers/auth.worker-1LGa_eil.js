BigInt(60 * 60 * 1e3 * 1e3 * 1e3 * 24 * 14);
const hs = 1e3;
var Ee =
  typeof globalThis < "u"
    ? globalThis
    : typeof window < "u"
      ? window
      : typeof global < "u"
        ? global
        : typeof self < "u"
          ? self
          : {};
function ls(e) {
  return e && e.__esModule && Object.prototype.hasOwnProperty.call(e, "default")
    ? e.default
    : e;
}
var ds = {},
  ve = {};
ve.byteLength = ys;
ve.toByteArray = xs;
ve.fromByteArray = Es;
var qt = [],
  kt = [],
  ps = typeof Uint8Array < "u" ? Uint8Array : Array,
  or = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
for (var pe = 0, ws = or.length; pe < ws; ++pe)
  (qt[pe] = or[pe]), (kt[or.charCodeAt(pe)] = pe);
kt[45] = 62;
kt[95] = 63;
function Wn(e) {
  var t = e.length;
  if (t % 4 > 0)
    throw new Error("Invalid string. Length must be a multiple of 4");
  var r = e.indexOf("=");
  r === -1 && (r = t);
  var o = r === t ? 0 : 4 - (r % 4);
  return [r, o];
}
function ys(e) {
  var t = Wn(e),
    r = t[0],
    o = t[1];
  return ((r + o) * 3) / 4 - o;
}
function gs(e, t, r) {
  return ((t + r) * 3) / 4 - r;
}
function xs(e) {
  var t,
    r = Wn(e),
    o = r[0],
    u = r[1],
    d = new ps(gs(e, o, u)),
    g = 0,
    c = u > 0 ? o - 4 : o,
    b;
  for (b = 0; b < c; b += 4)
    (t =
      (kt[e.charCodeAt(b)] << 18) |
      (kt[e.charCodeAt(b + 1)] << 12) |
      (kt[e.charCodeAt(b + 2)] << 6) |
      kt[e.charCodeAt(b + 3)]),
      (d[g++] = (t >> 16) & 255),
      (d[g++] = (t >> 8) & 255),
      (d[g++] = t & 255);
  return (
    u === 2 &&
      ((t = (kt[e.charCodeAt(b)] << 2) | (kt[e.charCodeAt(b + 1)] >> 4)),
      (d[g++] = t & 255)),
    u === 1 &&
      ((t =
        (kt[e.charCodeAt(b)] << 10) |
        (kt[e.charCodeAt(b + 1)] << 4) |
        (kt[e.charCodeAt(b + 2)] >> 2)),
      (d[g++] = (t >> 8) & 255),
      (d[g++] = t & 255)),
    d
  );
}
function ms(e) {
  return (
    qt[(e >> 18) & 63] + qt[(e >> 12) & 63] + qt[(e >> 6) & 63] + qt[e & 63]
  );
}
function bs(e, t, r) {
  for (var o, u = [], d = t; d < r; d += 3)
    (o =
      ((e[d] << 16) & 16711680) + ((e[d + 1] << 8) & 65280) + (e[d + 2] & 255)),
      u.push(ms(o));
  return u.join("");
}
function Es(e) {
  for (
    var t, r = e.length, o = r % 3, u = [], d = 16383, g = 0, c = r - o;
    g < c;
    g += d
  )
    u.push(bs(e, g, g + d > c ? c : g + d));
  return (
    o === 1
      ? ((t = e[r - 1]), u.push(qt[t >> 2] + qt[(t << 4) & 63] + "=="))
      : o === 2 &&
        ((t = (e[r - 2] << 8) + e[r - 1]),
        u.push(qt[t >> 10] + qt[(t >> 4) & 63] + qt[(t << 2) & 63] + "=")),
    u.join("")
  );
}
var Re = {};
/*! ieee754. BSD-3-Clause License. Feross Aboukhadijeh <https://feross.org/opensource> */ Re.read =
  function (e, t, r, o, u) {
    var d,
      g,
      c = u * 8 - o - 1,
      b = (1 << c) - 1,
      A = b >> 1,
      U = -7,
      L = r ? u - 1 : 0,
      O = r ? -1 : 1,
      M = e[t + L];
    for (
      L += O, d = M & ((1 << -U) - 1), M >>= -U, U += c;
      U > 0;
      d = d * 256 + e[t + L], L += O, U -= 8
    );
    for (
      g = d & ((1 << -U) - 1), d >>= -U, U += o;
      U > 0;
      g = g * 256 + e[t + L], L += O, U -= 8
    );
    if (d === 0) d = 1 - A;
    else {
      if (d === b) return g ? NaN : (M ? -1 : 1) * (1 / 0);
      (g = g + Math.pow(2, o)), (d = d - A);
    }
    return (M ? -1 : 1) * g * Math.pow(2, d - o);
  };
Re.write = function (e, t, r, o, u, d) {
  var g,
    c,
    b,
    A = d * 8 - u - 1,
    U = (1 << A) - 1,
    L = U >> 1,
    O = u === 23 ? Math.pow(2, -24) - Math.pow(2, -77) : 0,
    M = o ? 0 : d - 1,
    Z = o ? 1 : -1,
    W = t < 0 || (t === 0 && 1 / t < 0) ? 1 : 0;
  for (
    t = Math.abs(t),
      isNaN(t) || t === 1 / 0
        ? ((c = isNaN(t) ? 1 : 0), (g = U))
        : ((g = Math.floor(Math.log(t) / Math.LN2)),
          t * (b = Math.pow(2, -g)) < 1 && (g--, (b *= 2)),
          g + L >= 1 ? (t += O / b) : (t += O * Math.pow(2, 1 - L)),
          t * b >= 2 && (g++, (b /= 2)),
          g + L >= U
            ? ((c = 0), (g = U))
            : g + L >= 1
              ? ((c = (t * b - 1) * Math.pow(2, u)), (g = g + L))
              : ((c = t * Math.pow(2, L - 1) * Math.pow(2, u)), (g = 0)));
    u >= 8;
    e[r + M] = c & 255, M += Z, c /= 256, u -= 8
  );
  for (
    g = (g << u) | c, A += u;
    A > 0;
    e[r + M] = g & 255, M += Z, g /= 256, A -= 8
  );
  e[r + M - Z] |= W * 128;
};
/*!
 * The buffer module from node.js, for the browser.
 *
 * @author   Feross Aboukhadijeh <https://feross.org>
 * @license  MIT
 */ (function (e) {
  const t = ve,
    r = Re,
    o =
      typeof Symbol == "function" && typeof Symbol.for == "function"
        ? Symbol.for("nodejs.util.inspect.custom")
        : null;
  (e.Buffer = c), (e.SlowBuffer = ut), (e.INSPECT_MAX_BYTES = 50);
  const u = 2147483647;
  (e.kMaxLength = u),
    (c.TYPED_ARRAY_SUPPORT = d()),
    !c.TYPED_ARRAY_SUPPORT &&
      typeof console < "u" &&
      typeof console.error == "function" &&
      console.error(
        "This browser lacks typed array (Uint8Array) support which is required by `buffer` v5.x. Use `buffer` v4.x if you require old browser support.",
      );
  function d() {
    try {
      const h = new Uint8Array(1),
        s = {
          foo: function () {
            return 42;
          },
        };
      return (
        Object.setPrototypeOf(s, Uint8Array.prototype),
        Object.setPrototypeOf(h, s),
        h.foo() === 42
      );
    } catch {
      return !1;
    }
  }
  Object.defineProperty(c.prototype, "parent", {
    enumerable: !0,
    get: function () {
      if (c.isBuffer(this)) return this.buffer;
    },
  }),
    Object.defineProperty(c.prototype, "offset", {
      enumerable: !0,
      get: function () {
        if (c.isBuffer(this)) return this.byteOffset;
      },
    });
  function g(h) {
    if (h > u)
      throw new RangeError(
        'The value "' + h + '" is invalid for option "size"',
      );
    const s = new Uint8Array(h);
    return Object.setPrototypeOf(s, c.prototype), s;
  }
  function c(h, s, a) {
    if (typeof h == "number") {
      if (typeof s == "string")
        throw new TypeError(
          'The "string" argument must be of type string. Received type number',
        );
      return L(h);
    }
    return b(h, s, a);
  }
  c.poolSize = 8192;
  function b(h, s, a) {
    if (typeof h == "string") return O(h, s);
    if (ArrayBuffer.isView(h)) return Z(h);
    if (h == null)
      throw new TypeError(
        "The first argument must be one of type string, Buffer, ArrayBuffer, Array, or Array-like Object. Received type " +
          typeof h,
      );
    if (
      F(h, ArrayBuffer) ||
      (h && F(h.buffer, ArrayBuffer)) ||
      (typeof SharedArrayBuffer < "u" &&
        (F(h, SharedArrayBuffer) || (h && F(h.buffer, SharedArrayBuffer))))
    )
      return W(h, s, a);
    if (typeof h == "number")
      throw new TypeError(
        'The "value" argument must not be of type number. Received type number',
      );
    const m = h.valueOf && h.valueOf();
    if (m != null && m !== h) return c.from(m, s, a);
    const B = ct(h);
    if (B) return B;
    if (
      typeof Symbol < "u" &&
      Symbol.toPrimitive != null &&
      typeof h[Symbol.toPrimitive] == "function"
    )
      return c.from(h[Symbol.toPrimitive]("string"), s, a);
    throw new TypeError(
      "The first argument must be one of type string, Buffer, ArrayBuffer, Array, or Array-like Object. Received type " +
        typeof h,
    );
  }
  (c.from = function (h, s, a) {
    return b(h, s, a);
  }),
    Object.setPrototypeOf(c.prototype, Uint8Array.prototype),
    Object.setPrototypeOf(c, Uint8Array);
  function A(h) {
    if (typeof h != "number")
      throw new TypeError('"size" argument must be of type number');
    if (h < 0)
      throw new RangeError(
        'The value "' + h + '" is invalid for option "size"',
      );
  }
  function U(h, s, a) {
    return (
      A(h),
      h <= 0
        ? g(h)
        : s !== void 0
          ? typeof a == "string"
            ? g(h).fill(s, a)
            : g(h).fill(s)
          : g(h)
    );
  }
  c.alloc = function (h, s, a) {
    return U(h, s, a);
  };
  function L(h) {
    return A(h), g(h < 0 ? 0 : mt(h) | 0);
  }
  (c.allocUnsafe = function (h) {
    return L(h);
  }),
    (c.allocUnsafeSlow = function (h) {
      return L(h);
    });
  function O(h, s) {
    if (((typeof s != "string" || s === "") && (s = "utf8"), !c.isEncoding(s)))
      throw new TypeError("Unknown encoding: " + s);
    const a = z(h, s) | 0;
    let m = g(a);
    const B = m.write(h, s);
    return B !== a && (m = m.slice(0, B)), m;
  }
  function M(h) {
    const s = h.length < 0 ? 0 : mt(h.length) | 0,
      a = g(s);
    for (let m = 0; m < s; m += 1) a[m] = h[m] & 255;
    return a;
  }
  function Z(h) {
    if (F(h, Uint8Array)) {
      const s = new Uint8Array(h);
      return W(s.buffer, s.byteOffset, s.byteLength);
    }
    return M(h);
  }
  function W(h, s, a) {
    if (s < 0 || h.byteLength < s)
      throw new RangeError('"offset" is outside of buffer bounds');
    if (h.byteLength < s + (a || 0))
      throw new RangeError('"length" is outside of buffer bounds');
    let m;
    return (
      s === void 0 && a === void 0
        ? (m = new Uint8Array(h))
        : a === void 0
          ? (m = new Uint8Array(h, s))
          : (m = new Uint8Array(h, s, a)),
      Object.setPrototypeOf(m, c.prototype),
      m
    );
  }
  function ct(h) {
    if (c.isBuffer(h)) {
      const s = mt(h.length) | 0,
        a = g(s);
      return a.length === 0 || h.copy(a, 0, 0, s), a;
    }
    if (h.length !== void 0)
      return typeof h.length != "number" || D(h.length) ? g(0) : M(h);
    if (h.type === "Buffer" && Array.isArray(h.data)) return M(h.data);
  }
  function mt(h) {
    if (h >= u)
      throw new RangeError(
        "Attempt to allocate Buffer larger than maximum size: 0x" +
          u.toString(16) +
          " bytes",
      );
    return h | 0;
  }
  function ut(h) {
    return +h != h && (h = 0), c.alloc(+h);
  }
  (c.isBuffer = function (s) {
    return s != null && s._isBuffer === !0 && s !== c.prototype;
  }),
    (c.compare = function (s, a) {
      if (
        (F(s, Uint8Array) && (s = c.from(s, s.offset, s.byteLength)),
        F(a, Uint8Array) && (a = c.from(a, a.offset, a.byteLength)),
        !c.isBuffer(s) || !c.isBuffer(a))
      )
        throw new TypeError(
          'The "buf1", "buf2" arguments must be one of type Buffer or Uint8Array',
        );
      if (s === a) return 0;
      let m = s.length,
        B = a.length;
      for (let R = 0, v = Math.min(m, B); R < v; ++R)
        if (s[R] !== a[R]) {
          (m = s[R]), (B = a[R]);
          break;
        }
      return m < B ? -1 : B < m ? 1 : 0;
    }),
    (c.isEncoding = function (s) {
      switch (String(s).toLowerCase()) {
        case "hex":
        case "utf8":
        case "utf-8":
        case "ascii":
        case "latin1":
        case "binary":
        case "base64":
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return !0;
        default:
          return !1;
      }
    }),
    (c.concat = function (s, a) {
      if (!Array.isArray(s))
        throw new TypeError('"list" argument must be an Array of Buffers');
      if (s.length === 0) return c.alloc(0);
      let m;
      if (a === void 0) for (a = 0, m = 0; m < s.length; ++m) a += s[m].length;
      const B = c.allocUnsafe(a);
      let R = 0;
      for (m = 0; m < s.length; ++m) {
        let v = s[m];
        if (F(v, Uint8Array))
          R + v.length > B.length
            ? (c.isBuffer(v) || (v = c.from(v)), v.copy(B, R))
            : Uint8Array.prototype.set.call(B, v, R);
        else if (c.isBuffer(v)) v.copy(B, R);
        else throw new TypeError('"list" argument must be an Array of Buffers');
        R += v.length;
      }
      return B;
    });
  function z(h, s) {
    if (c.isBuffer(h)) return h.length;
    if (ArrayBuffer.isView(h) || F(h, ArrayBuffer)) return h.byteLength;
    if (typeof h != "string")
      throw new TypeError(
        'The "string" argument must be one of type string, Buffer, or ArrayBuffer. Received type ' +
          typeof h,
      );
    const a = h.length,
      m = arguments.length > 2 && arguments[2] === !0;
    if (!m && a === 0) return 0;
    let B = !1;
    for (;;)
      switch (s) {
        case "ascii":
        case "latin1":
        case "binary":
          return a;
        case "utf8":
        case "utf-8":
          return n(h).length;
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return a * 2;
        case "hex":
          return a >>> 1;
        case "base64":
          return p(h).length;
        default:
          if (B) return m ? -1 : n(h).length;
          (s = ("" + s).toLowerCase()), (B = !0);
      }
  }
  c.byteLength = z;
  function At(h, s, a) {
    let m = !1;
    if (
      ((s === void 0 || s < 0) && (s = 0),
      s > this.length ||
        ((a === void 0 || a > this.length) && (a = this.length), a <= 0) ||
        ((a >>>= 0), (s >>>= 0), a <= s))
    )
      return "";
    for (h || (h = "utf8"); ; )
      switch (h) {
        case "hex":
          return j(this, s, a);
        case "utf8":
        case "utf-8":
          return Tt(this, s, a);
        case "ascii":
          return P(this, s, a);
        case "latin1":
        case "binary":
          return $(this, s, a);
        case "base64":
          return ht(this, s, a);
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return Q(this, s, a);
        default:
          if (m) throw new TypeError("Unknown encoding: " + h);
          (h = (h + "").toLowerCase()), (m = !0);
      }
  }
  c.prototype._isBuffer = !0;
  function ot(h, s, a) {
    const m = h[s];
    (h[s] = h[a]), (h[a] = m);
  }
  (c.prototype.swap16 = function () {
    const s = this.length;
    if (s % 2 !== 0)
      throw new RangeError("Buffer size must be a multiple of 16-bits");
    for (let a = 0; a < s; a += 2) ot(this, a, a + 1);
    return this;
  }),
    (c.prototype.swap32 = function () {
      const s = this.length;
      if (s % 4 !== 0)
        throw new RangeError("Buffer size must be a multiple of 32-bits");
      for (let a = 0; a < s; a += 4) ot(this, a, a + 3), ot(this, a + 1, a + 2);
      return this;
    }),
    (c.prototype.swap64 = function () {
      const s = this.length;
      if (s % 8 !== 0)
        throw new RangeError("Buffer size must be a multiple of 64-bits");
      for (let a = 0; a < s; a += 8)
        ot(this, a, a + 7),
          ot(this, a + 1, a + 6),
          ot(this, a + 2, a + 5),
          ot(this, a + 3, a + 4);
      return this;
    }),
    (c.prototype.toString = function () {
      const s = this.length;
      return s === 0
        ? ""
        : arguments.length === 0
          ? Tt(this, 0, s)
          : At.apply(this, arguments);
    }),
    (c.prototype.toLocaleString = c.prototype.toString),
    (c.prototype.equals = function (s) {
      if (!c.isBuffer(s)) throw new TypeError("Argument must be a Buffer");
      return this === s ? !0 : c.compare(this, s) === 0;
    }),
    (c.prototype.inspect = function () {
      let s = "";
      const a = e.INSPECT_MAX_BYTES;
      return (
        (s = this.toString("hex", 0, a)
          .replace(/(.{2})/g, "$1 ")
          .trim()),
        this.length > a && (s += " ... "),
        "<Buffer " + s + ">"
      );
    }),
    o && (c.prototype[o] = c.prototype.inspect),
    (c.prototype.compare = function (s, a, m, B, R) {
      if (
        (F(s, Uint8Array) && (s = c.from(s, s.offset, s.byteLength)),
        !c.isBuffer(s))
      )
        throw new TypeError(
          'The "target" argument must be one of type Buffer or Uint8Array. Received type ' +
            typeof s,
        );
      if (
        (a === void 0 && (a = 0),
        m === void 0 && (m = s ? s.length : 0),
        B === void 0 && (B = 0),
        R === void 0 && (R = this.length),
        a < 0 || m > s.length || B < 0 || R > this.length)
      )
        throw new RangeError("out of range index");
      if (B >= R && a >= m) return 0;
      if (B >= R) return -1;
      if (a >= m) return 1;
      if (((a >>>= 0), (m >>>= 0), (B >>>= 0), (R >>>= 0), this === s))
        return 0;
      let v = R - B,
        et = m - a;
      const lt = Math.min(v, et),
        st = this.slice(B, R),
        tt = s.slice(a, m);
      for (let Et = 0; Et < lt; ++Et)
        if (st[Et] !== tt[Et]) {
          (v = st[Et]), (et = tt[Et]);
          break;
        }
      return v < et ? -1 : et < v ? 1 : 0;
    });
  function q(h, s, a, m, B) {
    if (h.length === 0) return -1;
    if (
      (typeof a == "string"
        ? ((m = a), (a = 0))
        : a > 2147483647
          ? (a = 2147483647)
          : a < -2147483648 && (a = -2147483648),
      (a = +a),
      D(a) && (a = B ? 0 : h.length - 1),
      a < 0 && (a = h.length + a),
      a >= h.length)
    ) {
      if (B) return -1;
      a = h.length - 1;
    } else if (a < 0)
      if (B) a = 0;
      else return -1;
    if ((typeof s == "string" && (s = c.from(s, m)), c.isBuffer(s)))
      return s.length === 0 ? -1 : J(h, s, a, m, B);
    if (typeof s == "number")
      return (
        (s = s & 255),
        typeof Uint8Array.prototype.indexOf == "function"
          ? B
            ? Uint8Array.prototype.indexOf.call(h, s, a)
            : Uint8Array.prototype.lastIndexOf.call(h, s, a)
          : J(h, [s], a, m, B)
      );
    throw new TypeError("val must be string, number or Buffer");
  }
  function J(h, s, a, m, B) {
    let R = 1,
      v = h.length,
      et = s.length;
    if (
      m !== void 0 &&
      ((m = String(m).toLowerCase()),
      m === "ucs2" || m === "ucs-2" || m === "utf16le" || m === "utf-16le")
    ) {
      if (h.length < 2 || s.length < 2) return -1;
      (R = 2), (v /= 2), (et /= 2), (a /= 2);
    }
    function lt(tt, Et) {
      return R === 1 ? tt[Et] : tt.readUInt16BE(Et * R);
    }
    let st;
    if (B) {
      let tt = -1;
      for (st = a; st < v; st++)
        if (lt(h, st) === lt(s, tt === -1 ? 0 : st - tt)) {
          if ((tt === -1 && (tt = st), st - tt + 1 === et)) return tt * R;
        } else tt !== -1 && (st -= st - tt), (tt = -1);
    } else
      for (a + et > v && (a = v - et), st = a; st >= 0; st--) {
        let tt = !0;
        for (let Et = 0; Et < et; Et++)
          if (lt(h, st + Et) !== lt(s, Et)) {
            tt = !1;
            break;
          }
        if (tt) return st;
      }
    return -1;
  }
  (c.prototype.includes = function (s, a, m) {
    return this.indexOf(s, a, m) !== -1;
  }),
    (c.prototype.indexOf = function (s, a, m) {
      return q(this, s, a, m, !0);
    }),
    (c.prototype.lastIndexOf = function (s, a, m) {
      return q(this, s, a, m, !1);
    });
  function nt(h, s, a, m) {
    a = Number(a) || 0;
    const B = h.length - a;
    m ? ((m = Number(m)), m > B && (m = B)) : (m = B);
    const R = s.length;
    m > R / 2 && (m = R / 2);
    let v;
    for (v = 0; v < m; ++v) {
      const et = parseInt(s.substr(v * 2, 2), 16);
      if (D(et)) return v;
      h[a + v] = et;
    }
    return v;
  }
  function it(h, s, a, m) {
    return E(n(s, h.length - a), h, a, m);
  }
  function C(h, s, a, m) {
    return E(i(s), h, a, m);
  }
  function xt(h, s, a, m) {
    return E(p(s), h, a, m);
  }
  function ft(h, s, a, m) {
    return E(l(s, h.length - a), h, a, m);
  }
  (c.prototype.write = function (s, a, m, B) {
    if (a === void 0) (B = "utf8"), (m = this.length), (a = 0);
    else if (m === void 0 && typeof a == "string")
      (B = a), (m = this.length), (a = 0);
    else if (isFinite(a))
      (a = a >>> 0),
        isFinite(m)
          ? ((m = m >>> 0), B === void 0 && (B = "utf8"))
          : ((B = m), (m = void 0));
    else
      throw new Error(
        "Buffer.write(string, encoding, offset[, length]) is no longer supported",
      );
    const R = this.length - a;
    if (
      ((m === void 0 || m > R) && (m = R),
      (s.length > 0 && (m < 0 || a < 0)) || a > this.length)
    )
      throw new RangeError("Attempt to write outside buffer bounds");
    B || (B = "utf8");
    let v = !1;
    for (;;)
      switch (B) {
        case "hex":
          return nt(this, s, a, m);
        case "utf8":
        case "utf-8":
          return it(this, s, a, m);
        case "ascii":
        case "latin1":
        case "binary":
          return C(this, s, a, m);
        case "base64":
          return xt(this, s, a, m);
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return ft(this, s, a, m);
        default:
          if (v) throw new TypeError("Unknown encoding: " + B);
          (B = ("" + B).toLowerCase()), (v = !0);
      }
  }),
    (c.prototype.toJSON = function () {
      return {
        type: "Buffer",
        data: Array.prototype.slice.call(this._arr || this, 0),
      };
    });
  function ht(h, s, a) {
    return s === 0 && a === h.length
      ? t.fromByteArray(h)
      : t.fromByteArray(h.slice(s, a));
  }
  function Tt(h, s, a) {
    a = Math.min(h.length, a);
    const m = [];
    let B = s;
    for (; B < a; ) {
      const R = h[B];
      let v = null,
        et = R > 239 ? 4 : R > 223 ? 3 : R > 191 ? 2 : 1;
      if (B + et <= a) {
        let lt, st, tt, Et;
        switch (et) {
          case 1:
            R < 128 && (v = R);
            break;
          case 2:
            (lt = h[B + 1]),
              (lt & 192) === 128 &&
                ((Et = ((R & 31) << 6) | (lt & 63)), Et > 127 && (v = Et));
            break;
          case 3:
            (lt = h[B + 1]),
              (st = h[B + 2]),
              (lt & 192) === 128 &&
                (st & 192) === 128 &&
                ((Et = ((R & 15) << 12) | ((lt & 63) << 6) | (st & 63)),
                Et > 2047 && (Et < 55296 || Et > 57343) && (v = Et));
            break;
          case 4:
            (lt = h[B + 1]),
              (st = h[B + 2]),
              (tt = h[B + 3]),
              (lt & 192) === 128 &&
                (st & 192) === 128 &&
                (tt & 192) === 128 &&
                ((Et =
                  ((R & 15) << 18) |
                  ((lt & 63) << 12) |
                  ((st & 63) << 6) |
                  (tt & 63)),
                Et > 65535 && Et < 1114112 && (v = Et));
        }
      }
      v === null
        ? ((v = 65533), (et = 1))
        : v > 65535 &&
          ((v -= 65536),
          m.push(((v >>> 10) & 1023) | 55296),
          (v = 56320 | (v & 1023))),
        m.push(v),
        (B += et);
    }
    return X(m);
  }
  const _t = 4096;
  function X(h) {
    const s = h.length;
    if (s <= _t) return String.fromCharCode.apply(String, h);
    let a = "",
      m = 0;
    for (; m < s; )
      a += String.fromCharCode.apply(String, h.slice(m, (m += _t)));
    return a;
  }
  function P(h, s, a) {
    let m = "";
    a = Math.min(h.length, a);
    for (let B = s; B < a; ++B) m += String.fromCharCode(h[B] & 127);
    return m;
  }
  function $(h, s, a) {
    let m = "";
    a = Math.min(h.length, a);
    for (let B = s; B < a; ++B) m += String.fromCharCode(h[B]);
    return m;
  }
  function j(h, s, a) {
    const m = h.length;
    (!s || s < 0) && (s = 0), (!a || a < 0 || a > m) && (a = m);
    let B = "";
    for (let R = s; R < a; ++R) B += H[h[R]];
    return B;
  }
  function Q(h, s, a) {
    const m = h.slice(s, a);
    let B = "";
    for (let R = 0; R < m.length - 1; R += 2)
      B += String.fromCharCode(m[R] + m[R + 1] * 256);
    return B;
  }
  c.prototype.slice = function (s, a) {
    const m = this.length;
    (s = ~~s),
      (a = a === void 0 ? m : ~~a),
      s < 0 ? ((s += m), s < 0 && (s = 0)) : s > m && (s = m),
      a < 0 ? ((a += m), a < 0 && (a = 0)) : a > m && (a = m),
      a < s && (a = s);
    const B = this.subarray(s, a);
    return Object.setPrototypeOf(B, c.prototype), B;
  };
  function k(h, s, a) {
    if (h % 1 !== 0 || h < 0) throw new RangeError("offset is not uint");
    if (h + s > a)
      throw new RangeError("Trying to access beyond buffer length");
  }
  (c.prototype.readUintLE = c.prototype.readUIntLE =
    function (s, a, m) {
      (s = s >>> 0), (a = a >>> 0), m || k(s, a, this.length);
      let B = this[s],
        R = 1,
        v = 0;
      for (; ++v < a && (R *= 256); ) B += this[s + v] * R;
      return B;
    }),
    (c.prototype.readUintBE = c.prototype.readUIntBE =
      function (s, a, m) {
        (s = s >>> 0), (a = a >>> 0), m || k(s, a, this.length);
        let B = this[s + --a],
          R = 1;
        for (; a > 0 && (R *= 256); ) B += this[s + --a] * R;
        return B;
      }),
    (c.prototype.readUint8 = c.prototype.readUInt8 =
      function (s, a) {
        return (s = s >>> 0), a || k(s, 1, this.length), this[s];
      }),
    (c.prototype.readUint16LE = c.prototype.readUInt16LE =
      function (s, a) {
        return (
          (s = s >>> 0), a || k(s, 2, this.length), this[s] | (this[s + 1] << 8)
        );
      }),
    (c.prototype.readUint16BE = c.prototype.readUInt16BE =
      function (s, a) {
        return (
          (s = s >>> 0), a || k(s, 2, this.length), (this[s] << 8) | this[s + 1]
        );
      }),
    (c.prototype.readUint32LE = c.prototype.readUInt32LE =
      function (s, a) {
        return (
          (s = s >>> 0),
          a || k(s, 4, this.length),
          (this[s] | (this[s + 1] << 8) | (this[s + 2] << 16)) +
            this[s + 3] * 16777216
        );
      }),
    (c.prototype.readUint32BE = c.prototype.readUInt32BE =
      function (s, a) {
        return (
          (s = s >>> 0),
          a || k(s, 4, this.length),
          this[s] * 16777216 +
            ((this[s + 1] << 16) | (this[s + 2] << 8) | this[s + 3])
        );
      }),
    (c.prototype.readBigUInt64LE = V(function (s) {
      (s = s >>> 0), T(s, "offset");
      const a = this[s],
        m = this[s + 7];
      (a === void 0 || m === void 0) && S(s, this.length - 8);
      const B =
          a + this[++s] * 2 ** 8 + this[++s] * 2 ** 16 + this[++s] * 2 ** 24,
        R = this[++s] + this[++s] * 2 ** 8 + this[++s] * 2 ** 16 + m * 2 ** 24;
      return BigInt(B) + (BigInt(R) << BigInt(32));
    })),
    (c.prototype.readBigUInt64BE = V(function (s) {
      (s = s >>> 0), T(s, "offset");
      const a = this[s],
        m = this[s + 7];
      (a === void 0 || m === void 0) && S(s, this.length - 8);
      const B =
          a * 2 ** 24 + this[++s] * 2 ** 16 + this[++s] * 2 ** 8 + this[++s],
        R = this[++s] * 2 ** 24 + this[++s] * 2 ** 16 + this[++s] * 2 ** 8 + m;
      return (BigInt(B) << BigInt(32)) + BigInt(R);
    })),
    (c.prototype.readIntLE = function (s, a, m) {
      (s = s >>> 0), (a = a >>> 0), m || k(s, a, this.length);
      let B = this[s],
        R = 1,
        v = 0;
      for (; ++v < a && (R *= 256); ) B += this[s + v] * R;
      return (R *= 128), B >= R && (B -= Math.pow(2, 8 * a)), B;
    }),
    (c.prototype.readIntBE = function (s, a, m) {
      (s = s >>> 0), (a = a >>> 0), m || k(s, a, this.length);
      let B = a,
        R = 1,
        v = this[s + --B];
      for (; B > 0 && (R *= 256); ) v += this[s + --B] * R;
      return (R *= 128), v >= R && (v -= Math.pow(2, 8 * a)), v;
    }),
    (c.prototype.readInt8 = function (s, a) {
      return (
        (s = s >>> 0),
        a || k(s, 1, this.length),
        this[s] & 128 ? (255 - this[s] + 1) * -1 : this[s]
      );
    }),
    (c.prototype.readInt16LE = function (s, a) {
      (s = s >>> 0), a || k(s, 2, this.length);
      const m = this[s] | (this[s + 1] << 8);
      return m & 32768 ? m | 4294901760 : m;
    }),
    (c.prototype.readInt16BE = function (s, a) {
      (s = s >>> 0), a || k(s, 2, this.length);
      const m = this[s + 1] | (this[s] << 8);
      return m & 32768 ? m | 4294901760 : m;
    }),
    (c.prototype.readInt32LE = function (s, a) {
      return (
        (s = s >>> 0),
        a || k(s, 4, this.length),
        this[s] | (this[s + 1] << 8) | (this[s + 2] << 16) | (this[s + 3] << 24)
      );
    }),
    (c.prototype.readInt32BE = function (s, a) {
      return (
        (s = s >>> 0),
        a || k(s, 4, this.length),
        (this[s] << 24) | (this[s + 1] << 16) | (this[s + 2] << 8) | this[s + 3]
      );
    }),
    (c.prototype.readBigInt64LE = V(function (s) {
      (s = s >>> 0), T(s, "offset");
      const a = this[s],
        m = this[s + 7];
      (a === void 0 || m === void 0) && S(s, this.length - 8);
      const B =
        this[s + 4] + this[s + 5] * 2 ** 8 + this[s + 6] * 2 ** 16 + (m << 24);
      return (
        (BigInt(B) << BigInt(32)) +
        BigInt(
          a + this[++s] * 2 ** 8 + this[++s] * 2 ** 16 + this[++s] * 2 ** 24,
        )
      );
    })),
    (c.prototype.readBigInt64BE = V(function (s) {
      (s = s >>> 0), T(s, "offset");
      const a = this[s],
        m = this[s + 7];
      (a === void 0 || m === void 0) && S(s, this.length - 8);
      const B =
        (a << 24) + this[++s] * 2 ** 16 + this[++s] * 2 ** 8 + this[++s];
      return (
        (BigInt(B) << BigInt(32)) +
        BigInt(
          this[++s] * 2 ** 24 + this[++s] * 2 ** 16 + this[++s] * 2 ** 8 + m,
        )
      );
    })),
    (c.prototype.readFloatLE = function (s, a) {
      return (
        (s = s >>> 0), a || k(s, 4, this.length), r.read(this, s, !0, 23, 4)
      );
    }),
    (c.prototype.readFloatBE = function (s, a) {
      return (
        (s = s >>> 0), a || k(s, 4, this.length), r.read(this, s, !1, 23, 4)
      );
    }),
    (c.prototype.readDoubleLE = function (s, a) {
      return (
        (s = s >>> 0), a || k(s, 8, this.length), r.read(this, s, !0, 52, 8)
      );
    }),
    (c.prototype.readDoubleBE = function (s, a) {
      return (
        (s = s >>> 0), a || k(s, 8, this.length), r.read(this, s, !1, 52, 8)
      );
    });
  function K(h, s, a, m, B, R) {
    if (!c.isBuffer(h))
      throw new TypeError('"buffer" argument must be a Buffer instance');
    if (s > B || s < R)
      throw new RangeError('"value" argument is out of bounds');
    if (a + m > h.length) throw new RangeError("Index out of range");
  }
  (c.prototype.writeUintLE = c.prototype.writeUIntLE =
    function (s, a, m, B) {
      if (((s = +s), (a = a >>> 0), (m = m >>> 0), !B)) {
        const et = Math.pow(2, 8 * m) - 1;
        K(this, s, a, m, et, 0);
      }
      let R = 1,
        v = 0;
      for (this[a] = s & 255; ++v < m && (R *= 256); )
        this[a + v] = (s / R) & 255;
      return a + m;
    }),
    (c.prototype.writeUintBE = c.prototype.writeUIntBE =
      function (s, a, m, B) {
        if (((s = +s), (a = a >>> 0), (m = m >>> 0), !B)) {
          const et = Math.pow(2, 8 * m) - 1;
          K(this, s, a, m, et, 0);
        }
        let R = m - 1,
          v = 1;
        for (this[a + R] = s & 255; --R >= 0 && (v *= 256); )
          this[a + R] = (s / v) & 255;
        return a + m;
      }),
    (c.prototype.writeUint8 = c.prototype.writeUInt8 =
      function (s, a, m) {
        return (
          (s = +s),
          (a = a >>> 0),
          m || K(this, s, a, 1, 255, 0),
          (this[a] = s & 255),
          a + 1
        );
      }),
    (c.prototype.writeUint16LE = c.prototype.writeUInt16LE =
      function (s, a, m) {
        return (
          (s = +s),
          (a = a >>> 0),
          m || K(this, s, a, 2, 65535, 0),
          (this[a] = s & 255),
          (this[a + 1] = s >>> 8),
          a + 2
        );
      }),
    (c.prototype.writeUint16BE = c.prototype.writeUInt16BE =
      function (s, a, m) {
        return (
          (s = +s),
          (a = a >>> 0),
          m || K(this, s, a, 2, 65535, 0),
          (this[a] = s >>> 8),
          (this[a + 1] = s & 255),
          a + 2
        );
      }),
    (c.prototype.writeUint32LE = c.prototype.writeUInt32LE =
      function (s, a, m) {
        return (
          (s = +s),
          (a = a >>> 0),
          m || K(this, s, a, 4, 4294967295, 0),
          (this[a + 3] = s >>> 24),
          (this[a + 2] = s >>> 16),
          (this[a + 1] = s >>> 8),
          (this[a] = s & 255),
          a + 4
        );
      }),
    (c.prototype.writeUint32BE = c.prototype.writeUInt32BE =
      function (s, a, m) {
        return (
          (s = +s),
          (a = a >>> 0),
          m || K(this, s, a, 4, 4294967295, 0),
          (this[a] = s >>> 24),
          (this[a + 1] = s >>> 16),
          (this[a + 2] = s >>> 8),
          (this[a + 3] = s & 255),
          a + 4
        );
      });
  function yt(h, s, a, m, B) {
    _(s, m, B, h, a, 7);
    let R = Number(s & BigInt(4294967295));
    (h[a++] = R),
      (R = R >> 8),
      (h[a++] = R),
      (R = R >> 8),
      (h[a++] = R),
      (R = R >> 8),
      (h[a++] = R);
    let v = Number((s >> BigInt(32)) & BigInt(4294967295));
    return (
      (h[a++] = v),
      (v = v >> 8),
      (h[a++] = v),
      (v = v >> 8),
      (h[a++] = v),
      (v = v >> 8),
      (h[a++] = v),
      a
    );
  }
  function y(h, s, a, m, B) {
    _(s, m, B, h, a, 7);
    let R = Number(s & BigInt(4294967295));
    (h[a + 7] = R),
      (R = R >> 8),
      (h[a + 6] = R),
      (R = R >> 8),
      (h[a + 5] = R),
      (R = R >> 8),
      (h[a + 4] = R);
    let v = Number((s >> BigInt(32)) & BigInt(4294967295));
    return (
      (h[a + 3] = v),
      (v = v >> 8),
      (h[a + 2] = v),
      (v = v >> 8),
      (h[a + 1] = v),
      (v = v >> 8),
      (h[a] = v),
      a + 8
    );
  }
  (c.prototype.writeBigUInt64LE = V(function (s, a = 0) {
    return yt(this, s, a, BigInt(0), BigInt("0xffffffffffffffff"));
  })),
    (c.prototype.writeBigUInt64BE = V(function (s, a = 0) {
      return y(this, s, a, BigInt(0), BigInt("0xffffffffffffffff"));
    })),
    (c.prototype.writeIntLE = function (s, a, m, B) {
      if (((s = +s), (a = a >>> 0), !B)) {
        const lt = Math.pow(2, 8 * m - 1);
        K(this, s, a, m, lt - 1, -lt);
      }
      let R = 0,
        v = 1,
        et = 0;
      for (this[a] = s & 255; ++R < m && (v *= 256); )
        s < 0 && et === 0 && this[a + R - 1] !== 0 && (et = 1),
          (this[a + R] = (((s / v) >> 0) - et) & 255);
      return a + m;
    }),
    (c.prototype.writeIntBE = function (s, a, m, B) {
      if (((s = +s), (a = a >>> 0), !B)) {
        const lt = Math.pow(2, 8 * m - 1);
        K(this, s, a, m, lt - 1, -lt);
      }
      let R = m - 1,
        v = 1,
        et = 0;
      for (this[a + R] = s & 255; --R >= 0 && (v *= 256); )
        s < 0 && et === 0 && this[a + R + 1] !== 0 && (et = 1),
          (this[a + R] = (((s / v) >> 0) - et) & 255);
      return a + m;
    }),
    (c.prototype.writeInt8 = function (s, a, m) {
      return (
        (s = +s),
        (a = a >>> 0),
        m || K(this, s, a, 1, 127, -128),
        s < 0 && (s = 255 + s + 1),
        (this[a] = s & 255),
        a + 1
      );
    }),
    (c.prototype.writeInt16LE = function (s, a, m) {
      return (
        (s = +s),
        (a = a >>> 0),
        m || K(this, s, a, 2, 32767, -32768),
        (this[a] = s & 255),
        (this[a + 1] = s >>> 8),
        a + 2
      );
    }),
    (c.prototype.writeInt16BE = function (s, a, m) {
      return (
        (s = +s),
        (a = a >>> 0),
        m || K(this, s, a, 2, 32767, -32768),
        (this[a] = s >>> 8),
        (this[a + 1] = s & 255),
        a + 2
      );
    }),
    (c.prototype.writeInt32LE = function (s, a, m) {
      return (
        (s = +s),
        (a = a >>> 0),
        m || K(this, s, a, 4, 2147483647, -2147483648),
        (this[a] = s & 255),
        (this[a + 1] = s >>> 8),
        (this[a + 2] = s >>> 16),
        (this[a + 3] = s >>> 24),
        a + 4
      );
    }),
    (c.prototype.writeInt32BE = function (s, a, m) {
      return (
        (s = +s),
        (a = a >>> 0),
        m || K(this, s, a, 4, 2147483647, -2147483648),
        s < 0 && (s = 4294967295 + s + 1),
        (this[a] = s >>> 24),
        (this[a + 1] = s >>> 16),
        (this[a + 2] = s >>> 8),
        (this[a + 3] = s & 255),
        a + 4
      );
    }),
    (c.prototype.writeBigInt64LE = V(function (s, a = 0) {
      return yt(
        this,
        s,
        a,
        -BigInt("0x8000000000000000"),
        BigInt("0x7fffffffffffffff"),
      );
    })),
    (c.prototype.writeBigInt64BE = V(function (s, a = 0) {
      return y(
        this,
        s,
        a,
        -BigInt("0x8000000000000000"),
        BigInt("0x7fffffffffffffff"),
      );
    }));
  function dt(h, s, a, m, B, R) {
    if (a + m > h.length) throw new RangeError("Index out of range");
    if (a < 0) throw new RangeError("Index out of range");
  }
  function bt(h, s, a, m, B) {
    return (
      (s = +s),
      (a = a >>> 0),
      B || dt(h, s, a, 4),
      r.write(h, s, a, m, 23, 4),
      a + 4
    );
  }
  (c.prototype.writeFloatLE = function (s, a, m) {
    return bt(this, s, a, !0, m);
  }),
    (c.prototype.writeFloatBE = function (s, a, m) {
      return bt(this, s, a, !1, m);
    });
  function Ut(h, s, a, m, B) {
    return (
      (s = +s),
      (a = a >>> 0),
      B || dt(h, s, a, 8),
      r.write(h, s, a, m, 52, 8),
      a + 8
    );
  }
  (c.prototype.writeDoubleLE = function (s, a, m) {
    return Ut(this, s, a, !0, m);
  }),
    (c.prototype.writeDoubleBE = function (s, a, m) {
      return Ut(this, s, a, !1, m);
    }),
    (c.prototype.copy = function (s, a, m, B) {
      if (!c.isBuffer(s)) throw new TypeError("argument should be a Buffer");
      if (
        (m || (m = 0),
        !B && B !== 0 && (B = this.length),
        a >= s.length && (a = s.length),
        a || (a = 0),
        B > 0 && B < m && (B = m),
        B === m || s.length === 0 || this.length === 0)
      )
        return 0;
      if (a < 0) throw new RangeError("targetStart out of bounds");
      if (m < 0 || m >= this.length) throw new RangeError("Index out of range");
      if (B < 0) throw new RangeError("sourceEnd out of bounds");
      B > this.length && (B = this.length),
        s.length - a < B - m && (B = s.length - a + m);
      const R = B - m;
      return (
        this === s && typeof Uint8Array.prototype.copyWithin == "function"
          ? this.copyWithin(a, m, B)
          : Uint8Array.prototype.set.call(s, this.subarray(m, B), a),
        R
      );
    }),
    (c.prototype.fill = function (s, a, m, B) {
      if (typeof s == "string") {
        if (
          (typeof a == "string"
            ? ((B = a), (a = 0), (m = this.length))
            : typeof m == "string" && ((B = m), (m = this.length)),
          B !== void 0 && typeof B != "string")
        )
          throw new TypeError("encoding must be a string");
        if (typeof B == "string" && !c.isEncoding(B))
          throw new TypeError("Unknown encoding: " + B);
        if (s.length === 1) {
          const v = s.charCodeAt(0);
          ((B === "utf8" && v < 128) || B === "latin1") && (s = v);
        }
      } else
        typeof s == "number"
          ? (s = s & 255)
          : typeof s == "boolean" && (s = Number(s));
      if (a < 0 || this.length < a || this.length < m)
        throw new RangeError("Out of range index");
      if (m <= a) return this;
      (a = a >>> 0), (m = m === void 0 ? this.length : m >>> 0), s || (s = 0);
      let R;
      if (typeof s == "number") for (R = a; R < m; ++R) this[R] = s;
      else {
        const v = c.isBuffer(s) ? s : c.from(s, B),
          et = v.length;
        if (et === 0)
          throw new TypeError(
            'The value "' + s + '" is invalid for argument "value"',
          );
        for (R = 0; R < m - a; ++R) this[R + a] = v[R % et];
      }
      return this;
    });
  const G = {};
  function Y(h, s, a) {
    G[h] = class extends a {
      constructor() {
        super(),
          Object.defineProperty(this, "message", {
            value: s.apply(this, arguments),
            writable: !0,
            configurable: !0,
          }),
          (this.name = `${this.name} [${h}]`),
          this.stack,
          delete this.name;
      }
      get code() {
        return h;
      }
      set code(B) {
        Object.defineProperty(this, "code", {
          configurable: !0,
          enumerable: !0,
          value: B,
          writable: !0,
        });
      }
      toString() {
        return `${this.name} [${h}]: ${this.message}`;
      }
    };
  }
  Y(
    "ERR_BUFFER_OUT_OF_BOUNDS",
    function (h) {
      return h
        ? `${h} is outside of buffer bounds`
        : "Attempt to access memory outside buffer bounds";
    },
    RangeError,
  ),
    Y(
      "ERR_INVALID_ARG_TYPE",
      function (h, s) {
        return `The "${h}" argument must be of type number. Received type ${typeof s}`;
      },
      TypeError,
    ),
    Y(
      "ERR_OUT_OF_RANGE",
      function (h, s, a) {
        let m = `The value of "${h}" is out of range.`,
          B = a;
        return (
          Number.isInteger(a) && Math.abs(a) > 2 ** 32
            ? (B = w(String(a)))
            : typeof a == "bigint" &&
              ((B = String(a)),
              (a > BigInt(2) ** BigInt(32) || a < -(BigInt(2) ** BigInt(32))) &&
                (B = w(B)),
              (B += "n")),
          (m += ` It must be ${s}. Received ${B}`),
          m
        );
      },
      RangeError,
    );
  function w(h) {
    let s = "",
      a = h.length;
    const m = h[0] === "-" ? 1 : 0;
    for (; a >= m + 4; a -= 3) s = `_${h.slice(a - 3, a)}${s}`;
    return `${h.slice(0, a)}${s}`;
  }
  function x(h, s, a) {
    T(s, "offset"),
      (h[s] === void 0 || h[s + a] === void 0) && S(s, h.length - (a + 1));
  }
  function _(h, s, a, m, B, R) {
    if (h > a || h < s) {
      const v = typeof s == "bigint" ? "n" : "";
      let et;
      throw (
        (s === 0 || s === BigInt(0)
          ? (et = `>= 0${v} and < 2${v} ** ${(R + 1) * 8}${v}`)
          : (et = `>= -(2${v} ** ${(R + 1) * 8 - 1}${v}) and < 2 ** ${(R + 1) * 8 - 1}${v}`),
        new G.ERR_OUT_OF_RANGE("value", et, h))
      );
    }
    x(m, B, R);
  }
  function T(h, s) {
    if (typeof h != "number") throw new G.ERR_INVALID_ARG_TYPE(s, "number", h);
  }
  function S(h, s, a) {
    throw Math.floor(h) !== h
      ? (T(h, a), new G.ERR_OUT_OF_RANGE("offset", "an integer", h))
      : s < 0
        ? new G.ERR_BUFFER_OUT_OF_BOUNDS()
        : new G.ERR_OUT_OF_RANGE("offset", `>= 0 and <= ${s}`, h);
  }
  const N = /[^+/0-9A-Za-z-_]/g;
  function f(h) {
    if (((h = h.split("=")[0]), (h = h.trim().replace(N, "")), h.length < 2))
      return "";
    for (; h.length % 4 !== 0; ) h = h + "=";
    return h;
  }
  function n(h, s) {
    s = s || 1 / 0;
    let a;
    const m = h.length;
    let B = null;
    const R = [];
    for (let v = 0; v < m; ++v) {
      if (((a = h.charCodeAt(v)), a > 55295 && a < 57344)) {
        if (!B) {
          if (a > 56319) {
            (s -= 3) > -1 && R.push(239, 191, 189);
            continue;
          } else if (v + 1 === m) {
            (s -= 3) > -1 && R.push(239, 191, 189);
            continue;
          }
          B = a;
          continue;
        }
        if (a < 56320) {
          (s -= 3) > -1 && R.push(239, 191, 189), (B = a);
          continue;
        }
        a = (((B - 55296) << 10) | (a - 56320)) + 65536;
      } else B && (s -= 3) > -1 && R.push(239, 191, 189);
      if (((B = null), a < 128)) {
        if ((s -= 1) < 0) break;
        R.push(a);
      } else if (a < 2048) {
        if ((s -= 2) < 0) break;
        R.push((a >> 6) | 192, (a & 63) | 128);
      } else if (a < 65536) {
        if ((s -= 3) < 0) break;
        R.push((a >> 12) | 224, ((a >> 6) & 63) | 128, (a & 63) | 128);
      } else if (a < 1114112) {
        if ((s -= 4) < 0) break;
        R.push(
          (a >> 18) | 240,
          ((a >> 12) & 63) | 128,
          ((a >> 6) & 63) | 128,
          (a & 63) | 128,
        );
      } else throw new Error("Invalid code point");
    }
    return R;
  }
  function i(h) {
    const s = [];
    for (let a = 0; a < h.length; ++a) s.push(h.charCodeAt(a) & 255);
    return s;
  }
  function l(h, s) {
    let a, m, B;
    const R = [];
    for (let v = 0; v < h.length && !((s -= 2) < 0); ++v)
      (a = h.charCodeAt(v)), (m = a >> 8), (B = a % 256), R.push(B), R.push(m);
    return R;
  }
  function p(h) {
    return t.toByteArray(f(h));
  }
  function E(h, s, a, m) {
    let B;
    for (B = 0; B < m && !(B + a >= s.length || B >= h.length); ++B)
      s[B + a] = h[B];
    return B;
  }
  function F(h, s) {
    return (
      h instanceof s ||
      (h != null &&
        h.constructor != null &&
        h.constructor.name != null &&
        h.constructor.name === s.name)
    );
  }
  function D(h) {
    return h !== h;
  }
  const H = (function () {
    const h = "0123456789abcdef",
      s = new Array(256);
    for (let a = 0; a < 16; ++a) {
      const m = a * 16;
      for (let B = 0; B < 16; ++B) s[m + B] = h[a] + h[B];
    }
    return s;
  })();
  function V(h) {
    return typeof BigInt > "u" ? rt : h;
  }
  function rt() {
    throw new Error("BigInt not supported");
  }
})(ds);
var sn;
(function (e) {
  (e[(e.SysFatal = 1)] = "SysFatal"),
    (e[(e.SysTransient = 2)] = "SysTransient"),
    (e[(e.DestinationInvalid = 3)] = "DestinationInvalid"),
    (e[(e.CanisterReject = 4)] = "CanisterReject"),
    (e[(e.CanisterError = 5)] = "CanisterError");
})(sn || (sn = {}));
const Je = "abcdefghijklmnopqrstuvwxyz234567",
  _e = Object.create(null);
for (let e = 0; e < Je.length; e++) _e[Je[e]] = e;
_e[0] = _e.o;
_e[1] = _e.i;
function _s(e) {
  let t = 0,
    r = 0,
    o = "";
  function u(d) {
    return (
      t < 0 ? (r |= d >> -t) : (r = (d << t) & 248),
      t > 3 ? ((t -= 8), 1) : (t < 4 && ((o += Je[r >> 3]), (t += 5)), 0)
    );
  }
  for (let d = 0; d < e.length; ) d += u(e[d]);
  return o + (t < 0 ? Je[r >> 3] : "");
}
function Is(e) {
  let t = 0,
    r = 0;
  const o = new Uint8Array(((e.length * 4) / 3) | 0);
  let u = 0;
  function d(g) {
    let c = _e[g.toLowerCase()];
    if (c === void 0)
      throw new Error(`Invalid character: ${JSON.stringify(g)}`);
    (c <<= 3),
      (r |= c >>> t),
      (t += 5),
      t >= 8 &&
        ((o[u++] = r), (t -= 8), t > 0 ? (r = (c << (5 - t)) & 255) : (r = 0));
  }
  for (const g of e) d(g);
  return o.slice(0, u);
}
const As = new Uint32Array([
  0, 1996959894, 3993919788, 2567524794, 124634137, 1886057615, 3915621685,
  2657392035, 249268274, 2044508324, 3772115230, 2547177864, 162941995,
  2125561021, 3887607047, 2428444049, 498536548, 1789927666, 4089016648,
  2227061214, 450548861, 1843258603, 4107580753, 2211677639, 325883990,
  1684777152, 4251122042, 2321926636, 335633487, 1661365465, 4195302755,
  2366115317, 997073096, 1281953886, 3579855332, 2724688242, 1006888145,
  1258607687, 3524101629, 2768942443, 901097722, 1119000684, 3686517206,
  2898065728, 853044451, 1172266101, 3705015759, 2882616665, 651767980,
  1373503546, 3369554304, 3218104598, 565507253, 1454621731, 3485111705,
  3099436303, 671266974, 1594198024, 3322730930, 2970347812, 795835527,
  1483230225, 3244367275, 3060149565, 1994146192, 31158534, 2563907772,
  4023717930, 1907459465, 112637215, 2680153253, 3904427059, 2013776290,
  251722036, 2517215374, 3775830040, 2137656763, 141376813, 2439277719,
  3865271297, 1802195444, 476864866, 2238001368, 4066508878, 1812370925,
  453092731, 2181625025, 4111451223, 1706088902, 314042704, 2344532202,
  4240017532, 1658658271, 366619977, 2362670323, 4224994405, 1303535960,
  984961486, 2747007092, 3569037538, 1256170817, 1037604311, 2765210733,
  3554079995, 1131014506, 879679996, 2909243462, 3663771856, 1141124467,
  855842277, 2852801631, 3708648649, 1342533948, 654459306, 3188396048,
  3373015174, 1466479909, 544179635, 3110523913, 3462522015, 1591671054,
  702138776, 2966460450, 3352799412, 1504918807, 783551873, 3082640443,
  3233442989, 3988292384, 2596254646, 62317068, 1957810842, 3939845945,
  2647816111, 81470997, 1943803523, 3814918930, 2489596804, 225274430,
  2053790376, 3826175755, 2466906013, 167816743, 2097651377, 4027552580,
  2265490386, 503444072, 1762050814, 4150417245, 2154129355, 426522225,
  1852507879, 4275313526, 2312317920, 282753626, 1742555852, 4189708143,
  2394877945, 397917763, 1622183637, 3604390888, 2714866558, 953729732,
  1340076626, 3518719985, 2797360999, 1068828381, 1219638859, 3624741850,
  2936675148, 906185462, 1090812512, 3747672003, 2825379669, 829329135,
  1181335161, 3412177804, 3160834842, 628085408, 1382605366, 3423369109,
  3138078467, 570562233, 1426400815, 3317316542, 2998733608, 733239954,
  1555261956, 3268935591, 3050360625, 752459403, 1541320221, 2607071920,
  3965973030, 1969922972, 40735498, 2617837225, 3943577151, 1913087877,
  83908371, 2512341634, 3803740692, 2075208622, 213261112, 2463272603,
  3855990285, 2094854071, 198958881, 2262029012, 4057260610, 1759359992,
  534414190, 2176718541, 4139329115, 1873836001, 414664567, 2282248934,
  4279200368, 1711684554, 285281116, 2405801727, 4167216745, 1634467795,
  376229701, 2685067896, 3608007406, 1308918612, 956543938, 2808555105,
  3495958263, 1231636301, 1047427035, 2932959818, 3654703836, 1088359270,
  936918e3, 2847714899, 3736837829, 1202900863, 817233897, 3183342108,
  3401237130, 1404277552, 615818150, 3134207493, 3453421203, 1423857449,
  601450431, 3009837614, 3294710456, 1567103746, 711928724, 3020668471,
  3272380065, 1510334235, 755167117,
]);
function Bs(e) {
  const t = new Uint8Array(e);
  let r = -1;
  for (let o = 0; o < t.length; o++) {
    const d = (t[o] ^ r) & 255;
    r = As[d] ^ (r >>> 8);
  }
  return (r ^ -1) >>> 0;
}
function Ss(e) {
  return (
    e instanceof Uint8Array ||
    (e != null && typeof e == "object" && e.constructor.name === "Uint8Array")
  );
}
function Vn(e, ...t) {
  if (!Ss(e)) throw new Error("Uint8Array expected");
  if (t.length > 0 && !t.includes(e.length))
    throw new Error(
      `Uint8Array expected of length ${t}, not of length=${e.length}`,
    );
}
function on(e, t = !0) {
  if (e.destroyed) throw new Error("Hash instance has been destroyed");
  if (t && e.finished) throw new Error("Hash#digest() has already been called");
}
function Ts(e, t) {
  Vn(e);
  const r = t.outputLen;
  if (e.length < r)
    throw new Error(
      `digestInto() expects output buffer of length at least ${r}`,
    );
}
const we =
  typeof globalThis == "object" && "crypto" in globalThis
    ? globalThis.crypto
    : void 0;
/*! noble-hashes - MIT License (c) 2022 Paul Miller (paulmillr.com) */ const ar =
    (e) => new DataView(e.buffer, e.byteOffset, e.byteLength),
  Yt = (e, t) => (e << (32 - t)) | (e >>> t);
new Uint8Array(new Uint32Array([287454020]).buffer)[0];
function Us(e) {
  if (typeof e != "string")
    throw new Error(`utf8ToBytes expected string, got ${typeof e}`);
  return new Uint8Array(new TextEncoder().encode(e));
}
function qn(e) {
  return typeof e == "string" && (e = Us(e)), Vn(e), e;
}
class Ns {
  clone() {
    return this._cloneInto();
  }
}
function Mr(e) {
  const t = (o) => e().update(qn(o)).digest(),
    r = e();
  return (
    (t.outputLen = r.outputLen),
    (t.blockLen = r.blockLen),
    (t.create = () => e()),
    t
  );
}
function Fs(e = 32) {
  if (we && typeof we.getRandomValues == "function")
    return we.getRandomValues(new Uint8Array(e));
  if (we && typeof we.randomBytes == "function") return we.randomBytes(e);
  throw new Error("crypto.getRandomValues must be defined");
}
function vs(e, t, r, o) {
  if (typeof e.setBigUint64 == "function") return e.setBigUint64(t, r, o);
  const u = BigInt(32),
    d = BigInt(4294967295),
    g = Number((r >> u) & d),
    c = Number(r & d),
    b = o ? 4 : 0,
    A = o ? 0 : 4;
  e.setUint32(t + b, g, o), e.setUint32(t + A, c, o);
}
const Rs = (e, t, r) => (e & t) ^ (~e & r),
  Ls = (e, t, r) => (e & t) ^ (e & r) ^ (t & r);
class Jn extends Ns {
  constructor(t, r, o, u) {
    super(),
      (this.blockLen = t),
      (this.outputLen = r),
      (this.padOffset = o),
      (this.isLE = u),
      (this.finished = !1),
      (this.length = 0),
      (this.pos = 0),
      (this.destroyed = !1),
      (this.buffer = new Uint8Array(t)),
      (this.view = ar(this.buffer));
  }
  update(t) {
    on(this);
    const { view: r, buffer: o, blockLen: u } = this;
    t = qn(t);
    const d = t.length;
    for (let g = 0; g < d; ) {
      const c = Math.min(u - this.pos, d - g);
      if (c === u) {
        const b = ar(t);
        for (; u <= d - g; g += u) this.process(b, g);
        continue;
      }
      o.set(t.subarray(g, g + c), this.pos),
        (this.pos += c),
        (g += c),
        this.pos === u && (this.process(r, 0), (this.pos = 0));
    }
    return (this.length += t.length), this.roundClean(), this;
  }
  digestInto(t) {
    on(this), Ts(t, this), (this.finished = !0);
    const { buffer: r, view: o, blockLen: u, isLE: d } = this;
    let { pos: g } = this;
    (r[g++] = 128),
      this.buffer.subarray(g).fill(0),
      this.padOffset > u - g && (this.process(o, 0), (g = 0));
    for (let L = g; L < u; L++) r[L] = 0;
    vs(o, u - 8, BigInt(this.length * 8), d), this.process(o, 0);
    const c = ar(t),
      b = this.outputLen;
    if (b % 4) throw new Error("_sha2: outputLen should be aligned to 32bit");
    const A = b / 4,
      U = this.get();
    if (A > U.length) throw new Error("_sha2: outputLen bigger than state");
    for (let L = 0; L < A; L++) c.setUint32(4 * L, U[L], d);
  }
  digest() {
    const { buffer: t, outputLen: r } = this;
    this.digestInto(t);
    const o = t.slice(0, r);
    return this.destroy(), o;
  }
  _cloneInto(t) {
    t || (t = new this.constructor()), t.set(...this.get());
    const {
      blockLen: r,
      buffer: o,
      length: u,
      finished: d,
      destroyed: g,
      pos: c,
    } = this;
    return (
      (t.length = u),
      (t.pos = c),
      (t.finished = d),
      (t.destroyed = g),
      u % r && t.buffer.set(o),
      t
    );
  }
}
const Os = new Uint32Array([
    1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993,
    2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987,
    1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774,
    264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986,
    2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711,
    113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291,
    1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411,
    3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344,
    430227734, 506948616, 659060556, 883997877, 958139571, 1322822218,
    1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424,
    2428436474, 2756734187, 3204031479, 3329325298,
  ]),
  Qt = new Uint32Array([
    1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924,
    528734635, 1541459225,
  ]),
  te = new Uint32Array(64);
class Xn extends Jn {
  constructor() {
    super(64, 32, 8, !1),
      (this.A = Qt[0] | 0),
      (this.B = Qt[1] | 0),
      (this.C = Qt[2] | 0),
      (this.D = Qt[3] | 0),
      (this.E = Qt[4] | 0),
      (this.F = Qt[5] | 0),
      (this.G = Qt[6] | 0),
      (this.H = Qt[7] | 0);
  }
  get() {
    const { A: t, B: r, C: o, D: u, E: d, F: g, G: c, H: b } = this;
    return [t, r, o, u, d, g, c, b];
  }
  set(t, r, o, u, d, g, c, b) {
    (this.A = t | 0),
      (this.B = r | 0),
      (this.C = o | 0),
      (this.D = u | 0),
      (this.E = d | 0),
      (this.F = g | 0),
      (this.G = c | 0),
      (this.H = b | 0);
  }
  process(t, r) {
    for (let L = 0; L < 16; L++, r += 4) te[L] = t.getUint32(r, !1);
    for (let L = 16; L < 64; L++) {
      const O = te[L - 15],
        M = te[L - 2],
        Z = Yt(O, 7) ^ Yt(O, 18) ^ (O >>> 3),
        W = Yt(M, 17) ^ Yt(M, 19) ^ (M >>> 10);
      te[L] = (W + te[L - 7] + Z + te[L - 16]) | 0;
    }
    let { A: o, B: u, C: d, D: g, E: c, F: b, G: A, H: U } = this;
    for (let L = 0; L < 64; L++) {
      const O = Yt(c, 6) ^ Yt(c, 11) ^ Yt(c, 25),
        M = (U + O + Rs(c, b, A) + Os[L] + te[L]) | 0,
        W = ((Yt(o, 2) ^ Yt(o, 13) ^ Yt(o, 22)) + Ls(o, u, d)) | 0;
      (U = A),
        (A = b),
        (b = c),
        (c = (g + M) | 0),
        (g = d),
        (d = u),
        (u = o),
        (o = (M + W) | 0);
    }
    (o = (o + this.A) | 0),
      (u = (u + this.B) | 0),
      (d = (d + this.C) | 0),
      (g = (g + this.D) | 0),
      (c = (c + this.E) | 0),
      (b = (b + this.F) | 0),
      (A = (A + this.G) | 0),
      (U = (U + this.H) | 0),
      this.set(o, u, d, g, c, b, A, U);
  }
  roundClean() {
    te.fill(0);
  }
  destroy() {
    this.set(0, 0, 0, 0, 0, 0, 0, 0), this.buffer.fill(0);
  }
}
class Ds extends Xn {
  constructor() {
    super(),
      (this.A = -1056596264),
      (this.B = 914150663),
      (this.C = 812702999),
      (this.D = -150054599),
      (this.E = -4191439),
      (this.F = 1750603025),
      (this.G = 1694076839),
      (this.H = -1090891868),
      (this.outputLen = 28);
  }
}
const Ps = Mr(() => new Xn()),
  Ms = Mr(() => new Ds());
function Cs(e) {
  return Ms.create().update(new Uint8Array(e)).digest();
}
const Me = "__principal__",
  $s = 2,
  an = 4,
  ks = "aaaaa-aa",
  Gs = (e) => {
    var t;
    return new Uint8Array(
      ((t = e.match(/.{1,2}/g)) !== null && t !== void 0 ? t : []).map((r) =>
        parseInt(r, 16),
      ),
    );
  },
  Hs = (e) => e.reduce((t, r) => t + r.toString(16).padStart(2, "0"), "");
class ue {
  constructor(t) {
    (this._arr = t), (this._isPrincipal = !0);
  }
  static anonymous() {
    return new this(new Uint8Array([an]));
  }
  static managementCanister() {
    return this.fromHex(ks);
  }
  static selfAuthenticating(t) {
    const r = Cs(t);
    return new this(new Uint8Array([...r, $s]));
  }
  static from(t) {
    if (typeof t == "string") return ue.fromText(t);
    if (Object.getPrototypeOf(t) === Uint8Array.prototype) return new ue(t);
    if (typeof t == "object" && t !== null && t._isPrincipal === !0)
      return new ue(t._arr);
    throw new Error(`Impossible to convert ${JSON.stringify(t)} to Principal.`);
  }
  static fromHex(t) {
    return new this(Gs(t));
  }
  static fromText(t) {
    let r = t;
    if (t.includes(Me)) {
      const g = JSON.parse(t);
      Me in g && (r = g[Me]);
    }
    const o = r.toLowerCase().replace(/-/g, "");
    let u = Is(o);
    u = u.slice(4, u.length);
    const d = new this(u);
    if (d.toText() !== r)
      throw new Error(
        `Principal "${d.toText()}" does not have a valid checksum (original value "${r}" may not be a valid Principal ID).`,
      );
    return d;
  }
  static fromUint8Array(t) {
    return new this(t);
  }
  isAnonymous() {
    return this._arr.byteLength === 1 && this._arr[0] === an;
  }
  toUint8Array() {
    return this._arr;
  }
  toHex() {
    return Hs(this._arr).toUpperCase();
  }
  toText() {
    const t = new ArrayBuffer(4);
    new DataView(t).setUint32(0, Bs(this._arr));
    const o = new Uint8Array(t),
      u = Uint8Array.from(this._arr),
      d = new Uint8Array([...o, ...u]),
      c = _s(d).match(/.{1,5}/g);
    if (!c) throw new Error();
    return c.join("-");
  }
  toString() {
    return this.toText();
  }
  toJSON() {
    return { [Me]: this.toText() };
  }
  compareTo(t) {
    for (let r = 0; r < Math.min(this._arr.length, t._arr.length); r++) {
      if (this._arr[r] < t._arr[r]) return "lt";
      if (this._arr[r] > t._arr[r]) return "gt";
    }
    return this._arr.length < t._arr.length
      ? "lt"
      : this._arr.length > t._arr.length
        ? "gt"
        : "eq";
  }
  ltEq(t) {
    const r = this.compareTo(t);
    return r == "lt" || r == "eq";
  }
  gtEq(t) {
    const r = this.compareTo(t);
    return r == "gt" || r == "eq";
  }
}
class Cr {
  constructor(t, r = t?.byteLength || 0) {
    (this._buffer = Ir(t || new ArrayBuffer(0))),
      (this._view = new Uint8Array(this._buffer, 0, r));
  }
  get buffer() {
    return Ir(this._view.slice());
  }
  get byteLength() {
    return this._view.byteLength;
  }
  read(t) {
    const r = this._view.subarray(0, t);
    return (this._view = this._view.subarray(t)), r.slice().buffer;
  }
  readUint8() {
    const t = this._view[0];
    return (this._view = this._view.subarray(1)), t;
  }
  write(t) {
    const r = new Uint8Array(t),
      o = this._view.byteLength;
    this._view.byteOffset + this._view.byteLength + r.byteLength >=
    this._buffer.byteLength
      ? this.alloc(r.byteLength)
      : (this._view = new Uint8Array(
          this._buffer,
          this._view.byteOffset,
          this._view.byteLength + r.byteLength,
        )),
      this._view.set(r, o);
  }
  get end() {
    return this._view.byteLength === 0;
  }
  alloc(t) {
    const r = new ArrayBuffer(((this._buffer.byteLength + t) * 1.2) | 0),
      o = new Uint8Array(r, 0, this._view.byteLength + t);
    o.set(this._view), (this._buffer = r), (this._view = o);
  }
}
function ur(e) {
  return new DataView(e.buffer, e.byteOffset, e.byteLength).buffer;
}
function Ir(e) {
  return e instanceof Uint8Array
    ? ur(e)
    : e instanceof ArrayBuffer
      ? e
      : Array.isArray(e)
        ? ur(new Uint8Array(e))
        : "buffer" in e
          ? Ir(e.buffer)
          : ur(new Uint8Array(e));
}
function jn() {
  throw new Error("unexpected end of buffer");
}
function Ks(e, t) {
  return e.byteLength < t && jn(), e.read(t);
}
function un(e) {
  const t = e.readUint8();
  return t === void 0 && jn(), t;
}
function cn(e) {
  if ((typeof e == "number" && (e = BigInt(e)), e < BigInt(0)))
    throw new Error("Cannot leb encode negative values.");
  const t = (e === BigInt(0) ? 0 : Math.ceil(Math.log2(Number(e)))) + 1,
    r = new Cr(new ArrayBuffer(t), 0);
  for (;;) {
    const o = Number(e & BigInt(127));
    if (((e /= BigInt(128)), e === BigInt(0))) {
      r.write(new Uint8Array([o]));
      break;
    } else r.write(new Uint8Array([o | 128]));
  }
  return r.buffer;
}
function $r(e) {
  typeof e == "number" && (e = BigInt(e));
  const t = e < BigInt(0);
  t && (e = -e - BigInt(1));
  const r = (e === BigInt(0) ? 0 : Math.ceil(Math.log2(Number(e)))) + 1,
    o = new Cr(new ArrayBuffer(r), 0);
  for (;;) {
    const d = u(e);
    if (
      ((e /= BigInt(128)),
      (t && e === BigInt(0) && d & 64) || (!t && e === BigInt(0) && !(d & 64)))
    ) {
      o.write(new Uint8Array([d]));
      break;
    } else o.write(new Uint8Array([d | 128]));
  }
  function u(d) {
    const g = d % BigInt(128);
    return Number(t ? BigInt(128) - g - BigInt(1) : g);
  }
  return o.buffer;
}
function zs(e, t) {
  if (BigInt(e) < BigInt(0)) throw new Error("Cannot write negative values.");
  return Zn(e, t);
}
function Zn(e, t) {
  e = BigInt(e);
  const r = new Cr(new ArrayBuffer(Math.min(1, t)), 0);
  let o = 0,
    u = BigInt(256),
    d = BigInt(0),
    g = Number(e % u);
  for (r.write(new Uint8Array([g])); ++o < t; )
    e < 0 && d === BigInt(0) && g !== 0 && (d = BigInt(1)),
      (g = Number((e / u - d) % BigInt(256))),
      r.write(new Uint8Array([g])),
      (u *= BigInt(256));
  return r.buffer;
}
function Qn(e, t) {
  let r = BigInt(un(e)),
    o = BigInt(1),
    u = 0;
  for (; ++u < t; ) {
    o *= BigInt(256);
    const d = BigInt(un(e));
    r = r + o * d;
  }
  return r;
}
function Ys(e, t) {
  let r = Qn(e, t);
  const o = BigInt(2) ** (BigInt(8) * BigInt(t - 1) + BigInt(7));
  return r >= o && (r -= o * BigInt(2)), r;
}
function Ar(e) {
  const t = BigInt(e);
  if (e < 0) throw new RangeError("Input must be non-negative");
  return BigInt(1) << t;
}
const fn = 400;
class ti {
  display() {
    return this.name;
  }
  valueToString(t) {
    return Le(t);
  }
  buildTypeTable(t) {
    t.has(this) || this._buildTypeTableImpl(t);
  }
}
class kr extends ti {
  checkType(t) {
    if (this.name !== t.name)
      throw new Error(
        `type mismatch: type on the wire ${t.name}, expect type ${this.name}`,
      );
    return t;
  }
  _buildTypeTableImpl(t) {}
}
class Ws extends ti {
  checkType(t) {
    if (t instanceof rr) {
      const r = t.getType();
      if (typeof r > "u")
        throw new Error("type mismatch with uninitialized type");
      return r;
    }
    throw new Error(
      `type mismatch: type on the wire ${t.name}, expect type ${this.name}`,
    );
  }
  encodeType(t) {
    return t.indexOf(this.name);
  }
}
class ei extends kr {
  constructor(t) {
    if ((super(), (this._bits = t), t !== 32 && t !== 64))
      throw new Error("not a valid float type");
  }
  accept(t, r) {
    return t.visitFloat(this, r);
  }
  covariant(t) {
    if (typeof t == "number" || t instanceof Number) return !0;
    throw new Error(`Invalid ${this.display()} argument: ${Le(t)}`);
  }
  encodeValue(t) {
    const r = new ArrayBuffer(this._bits / 8),
      o = new DataView(r);
    return (
      this._bits === 32 ? o.setFloat32(0, t, !0) : o.setFloat64(0, t, !0), r
    );
  }
  encodeType() {
    const t = this._bits === 32 ? -13 : -14;
    return $r(t);
  }
  decodeValue(t, r) {
    this.checkType(r);
    const o = Ks(t, this._bits / 8),
      u = new DataView(o);
    return this._bits === 32 ? u.getFloat32(0, !0) : u.getFloat64(0, !0);
  }
  get name() {
    return "float" + this._bits;
  }
  valueToString(t) {
    return t.toString();
  }
}
class tr extends kr {
  constructor(t) {
    super(), (this._bits = t);
  }
  accept(t, r) {
    return t.visitFixedInt(this, r);
  }
  covariant(t) {
    const r = Ar(this._bits - 1) * BigInt(-1),
      o = Ar(this._bits - 1) - BigInt(1);
    let u = !1;
    if (typeof t == "bigint") u = t >= r && t <= o;
    else if (Number.isInteger(t)) {
      const d = BigInt(t);
      u = d >= r && d <= o;
    } else u = !1;
    if (u) return !0;
    throw new Error(`Invalid ${this.display()} argument: ${Le(t)}`);
  }
  encodeValue(t) {
    return Zn(t, this._bits / 8);
  }
  encodeType() {
    const t = Math.log2(this._bits) - 3;
    return $r(-9 - t);
  }
  decodeValue(t, r) {
    this.checkType(r);
    const o = Ys(t, this._bits / 8);
    return this._bits <= 32 ? Number(o) : o;
  }
  get name() {
    return `int${this._bits}`;
  }
  valueToString(t) {
    return t.toString();
  }
}
class er extends kr {
  constructor(t) {
    super(), (this._bits = t);
  }
  accept(t, r) {
    return t.visitFixedNat(this, r);
  }
  covariant(t) {
    const r = Ar(this._bits);
    let o = !1;
    if (
      (typeof t == "bigint" && t >= BigInt(0)
        ? (o = t < r)
        : Number.isInteger(t) && t >= 0
          ? (o = BigInt(t) < r)
          : (o = !1),
      o)
    )
      return !0;
    throw new Error(`Invalid ${this.display()} argument: ${Le(t)}`);
  }
  encodeValue(t) {
    return zs(t, this._bits / 8);
  }
  encodeType() {
    const t = Math.log2(this._bits) - 3;
    return $r(-5 - t);
  }
  decodeValue(t, r) {
    this.checkType(r);
    const o = Qn(t, this._bits / 8);
    return this._bits <= 32 ? Number(o) : o;
  }
  get name() {
    return `nat${this._bits}`;
  }
  valueToString(t) {
    return t.toString();
  }
}
class rr extends Ws {
  constructor() {
    super(...arguments), (this._id = rr._counter++), (this._type = void 0);
  }
  accept(t, r) {
    if (!this._type) throw Error("Recursive type uninitialized.");
    return t.visitRec(this, this._type, r);
  }
  fill(t) {
    this._type = t;
  }
  getType() {
    return this._type;
  }
  covariant(t) {
    if (this._type && this._type.covariant(t)) return !0;
    throw new Error(`Invalid ${this.display()} argument: ${Le(t)}`);
  }
  encodeValue(t) {
    if (!this._type) throw Error("Recursive type uninitialized.");
    return this._type.encodeValue(t);
  }
  _buildTypeTableImpl(t) {
    if (!this._type) throw Error("Recursive type uninitialized.");
    t.add(this, new Uint8Array([])),
      this._type.buildTypeTable(t),
      t.merge(this, this._type.name);
  }
  decodeValue(t, r) {
    if (!this._type) throw Error("Recursive type uninitialized.");
    return this._type.decodeValue(t, r);
  }
  get name() {
    return `rec_${this._id}`;
  }
  display() {
    if (!this._type) throw Error("Recursive type uninitialized.");
    return `μ${this.name}.${this._type.name}`;
  }
  valueToString(t) {
    if (!this._type) throw Error("Recursive type uninitialized.");
    return this._type.valueToString(t);
  }
}
rr._counter = 0;
function Le(e) {
  const t = JSON.stringify(e, (r, o) =>
    typeof o == "bigint" ? `BigInt(${o})` : o,
  );
  return t && t.length > fn ? t.substring(0, fn - 3) + "..." : t;
}
new ei(32);
new ei(64);
new tr(8);
new tr(16);
new tr(32);
new tr(64);
new er(8);
new er(16);
new er(32);
new er(64);
var ri = {},
  Oe = {};
/*!
 * The buffer module from node.js, for the browser.
 *
 * @author   Feross Aboukhadijeh <https://feross.org>
 * @license  MIT
 */ (function (e) {
  var t = ve,
    r = Re,
    o =
      typeof Symbol == "function" && typeof Symbol.for == "function"
        ? Symbol.for("nodejs.util.inspect.custom")
        : null;
  (e.Buffer = c), (e.SlowBuffer = ut), (e.INSPECT_MAX_BYTES = 50);
  var u = 2147483647;
  (e.kMaxLength = u),
    (c.TYPED_ARRAY_SUPPORT = d()),
    !c.TYPED_ARRAY_SUPPORT &&
      typeof console < "u" &&
      typeof console.error == "function" &&
      console.error(
        "This browser lacks typed array (Uint8Array) support which is required by `buffer` v5.x. Use `buffer` v4.x if you require old browser support.",
      );
  function d() {
    try {
      var f = new Uint8Array(1),
        n = {
          foo: function () {
            return 42;
          },
        };
      return (
        Object.setPrototypeOf(n, Uint8Array.prototype),
        Object.setPrototypeOf(f, n),
        f.foo() === 42
      );
    } catch {
      return !1;
    }
  }
  Object.defineProperty(c.prototype, "parent", {
    enumerable: !0,
    get: function () {
      if (c.isBuffer(this)) return this.buffer;
    },
  }),
    Object.defineProperty(c.prototype, "offset", {
      enumerable: !0,
      get: function () {
        if (c.isBuffer(this)) return this.byteOffset;
      },
    });
  function g(f) {
    if (f > u)
      throw new RangeError(
        'The value "' + f + '" is invalid for option "size"',
      );
    var n = new Uint8Array(f);
    return Object.setPrototypeOf(n, c.prototype), n;
  }
  function c(f, n, i) {
    if (typeof f == "number") {
      if (typeof n == "string")
        throw new TypeError(
          'The "string" argument must be of type string. Received type number',
        );
      return L(f);
    }
    return b(f, n, i);
  }
  c.poolSize = 8192;
  function b(f, n, i) {
    if (typeof f == "string") return O(f, n);
    if (ArrayBuffer.isView(f)) return Z(f);
    if (f == null)
      throw new TypeError(
        "The first argument must be one of type string, Buffer, ArrayBuffer, Array, or Array-like Object. Received type " +
          typeof f,
      );
    if (
      T(f, ArrayBuffer) ||
      (f && T(f.buffer, ArrayBuffer)) ||
      (typeof SharedArrayBuffer < "u" &&
        (T(f, SharedArrayBuffer) || (f && T(f.buffer, SharedArrayBuffer))))
    )
      return W(f, n, i);
    if (typeof f == "number")
      throw new TypeError(
        'The "value" argument must not be of type number. Received type number',
      );
    var l = f.valueOf && f.valueOf();
    if (l != null && l !== f) return c.from(l, n, i);
    var p = ct(f);
    if (p) return p;
    if (
      typeof Symbol < "u" &&
      Symbol.toPrimitive != null &&
      typeof f[Symbol.toPrimitive] == "function"
    )
      return c.from(f[Symbol.toPrimitive]("string"), n, i);
    throw new TypeError(
      "The first argument must be one of type string, Buffer, ArrayBuffer, Array, or Array-like Object. Received type " +
        typeof f,
    );
  }
  (c.from = function (f, n, i) {
    return b(f, n, i);
  }),
    Object.setPrototypeOf(c.prototype, Uint8Array.prototype),
    Object.setPrototypeOf(c, Uint8Array);
  function A(f) {
    if (typeof f != "number")
      throw new TypeError('"size" argument must be of type number');
    if (f < 0)
      throw new RangeError(
        'The value "' + f + '" is invalid for option "size"',
      );
  }
  function U(f, n, i) {
    return (
      A(f),
      f <= 0
        ? g(f)
        : n !== void 0
          ? typeof i == "string"
            ? g(f).fill(n, i)
            : g(f).fill(n)
          : g(f)
    );
  }
  c.alloc = function (f, n, i) {
    return U(f, n, i);
  };
  function L(f) {
    return A(f), g(f < 0 ? 0 : mt(f) | 0);
  }
  (c.allocUnsafe = function (f) {
    return L(f);
  }),
    (c.allocUnsafeSlow = function (f) {
      return L(f);
    });
  function O(f, n) {
    if (((typeof n != "string" || n === "") && (n = "utf8"), !c.isEncoding(n)))
      throw new TypeError("Unknown encoding: " + n);
    var i = z(f, n) | 0,
      l = g(i),
      p = l.write(f, n);
    return p !== i && (l = l.slice(0, p)), l;
  }
  function M(f) {
    for (
      var n = f.length < 0 ? 0 : mt(f.length) | 0, i = g(n), l = 0;
      l < n;
      l += 1
    )
      i[l] = f[l] & 255;
    return i;
  }
  function Z(f) {
    if (T(f, Uint8Array)) {
      var n = new Uint8Array(f);
      return W(n.buffer, n.byteOffset, n.byteLength);
    }
    return M(f);
  }
  function W(f, n, i) {
    if (n < 0 || f.byteLength < n)
      throw new RangeError('"offset" is outside of buffer bounds');
    if (f.byteLength < n + (i || 0))
      throw new RangeError('"length" is outside of buffer bounds');
    var l;
    return (
      n === void 0 && i === void 0
        ? (l = new Uint8Array(f))
        : i === void 0
          ? (l = new Uint8Array(f, n))
          : (l = new Uint8Array(f, n, i)),
      Object.setPrototypeOf(l, c.prototype),
      l
    );
  }
  function ct(f) {
    if (c.isBuffer(f)) {
      var n = mt(f.length) | 0,
        i = g(n);
      return i.length === 0 || f.copy(i, 0, 0, n), i;
    }
    if (f.length !== void 0)
      return typeof f.length != "number" || S(f.length) ? g(0) : M(f);
    if (f.type === "Buffer" && Array.isArray(f.data)) return M(f.data);
  }
  function mt(f) {
    if (f >= u)
      throw new RangeError(
        "Attempt to allocate Buffer larger than maximum size: 0x" +
          u.toString(16) +
          " bytes",
      );
    return f | 0;
  }
  function ut(f) {
    return +f != f && (f = 0), c.alloc(+f);
  }
  (c.isBuffer = function (n) {
    return n != null && n._isBuffer === !0 && n !== c.prototype;
  }),
    (c.compare = function (n, i) {
      if (
        (T(n, Uint8Array) && (n = c.from(n, n.offset, n.byteLength)),
        T(i, Uint8Array) && (i = c.from(i, i.offset, i.byteLength)),
        !c.isBuffer(n) || !c.isBuffer(i))
      )
        throw new TypeError(
          'The "buf1", "buf2" arguments must be one of type Buffer or Uint8Array',
        );
      if (n === i) return 0;
      for (
        var l = n.length, p = i.length, E = 0, F = Math.min(l, p);
        E < F;
        ++E
      )
        if (n[E] !== i[E]) {
          (l = n[E]), (p = i[E]);
          break;
        }
      return l < p ? -1 : p < l ? 1 : 0;
    }),
    (c.isEncoding = function (n) {
      switch (String(n).toLowerCase()) {
        case "hex":
        case "utf8":
        case "utf-8":
        case "ascii":
        case "latin1":
        case "binary":
        case "base64":
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return !0;
        default:
          return !1;
      }
    }),
    (c.concat = function (n, i) {
      if (!Array.isArray(n))
        throw new TypeError('"list" argument must be an Array of Buffers');
      if (n.length === 0) return c.alloc(0);
      var l;
      if (i === void 0) for (i = 0, l = 0; l < n.length; ++l) i += n[l].length;
      var p = c.allocUnsafe(i),
        E = 0;
      for (l = 0; l < n.length; ++l) {
        var F = n[l];
        if (T(F, Uint8Array))
          E + F.length > p.length
            ? c.from(F).copy(p, E)
            : Uint8Array.prototype.set.call(p, F, E);
        else if (c.isBuffer(F)) F.copy(p, E);
        else throw new TypeError('"list" argument must be an Array of Buffers');
        E += F.length;
      }
      return p;
    });
  function z(f, n) {
    if (c.isBuffer(f)) return f.length;
    if (ArrayBuffer.isView(f) || T(f, ArrayBuffer)) return f.byteLength;
    if (typeof f != "string")
      throw new TypeError(
        'The "string" argument must be one of type string, Buffer, or ArrayBuffer. Received type ' +
          typeof f,
      );
    var i = f.length,
      l = arguments.length > 2 && arguments[2] === !0;
    if (!l && i === 0) return 0;
    for (var p = !1; ; )
      switch (n) {
        case "ascii":
        case "latin1":
        case "binary":
          return i;
        case "utf8":
        case "utf-8":
          return G(f).length;
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return i * 2;
        case "hex":
          return i >>> 1;
        case "base64":
          return x(f).length;
        default:
          if (p) return l ? -1 : G(f).length;
          (n = ("" + n).toLowerCase()), (p = !0);
      }
  }
  c.byteLength = z;
  function At(f, n, i) {
    var l = !1;
    if (
      ((n === void 0 || n < 0) && (n = 0),
      n > this.length ||
        ((i === void 0 || i > this.length) && (i = this.length), i <= 0) ||
        ((i >>>= 0), (n >>>= 0), i <= n))
    )
      return "";
    for (f || (f = "utf8"); ; )
      switch (f) {
        case "hex":
          return j(this, n, i);
        case "utf8":
        case "utf-8":
          return Tt(this, n, i);
        case "ascii":
          return P(this, n, i);
        case "latin1":
        case "binary":
          return $(this, n, i);
        case "base64":
          return ht(this, n, i);
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return Q(this, n, i);
        default:
          if (l) throw new TypeError("Unknown encoding: " + f);
          (f = (f + "").toLowerCase()), (l = !0);
      }
  }
  c.prototype._isBuffer = !0;
  function ot(f, n, i) {
    var l = f[n];
    (f[n] = f[i]), (f[i] = l);
  }
  (c.prototype.swap16 = function () {
    var n = this.length;
    if (n % 2 !== 0)
      throw new RangeError("Buffer size must be a multiple of 16-bits");
    for (var i = 0; i < n; i += 2) ot(this, i, i + 1);
    return this;
  }),
    (c.prototype.swap32 = function () {
      var n = this.length;
      if (n % 4 !== 0)
        throw new RangeError("Buffer size must be a multiple of 32-bits");
      for (var i = 0; i < n; i += 4) ot(this, i, i + 3), ot(this, i + 1, i + 2);
      return this;
    }),
    (c.prototype.swap64 = function () {
      var n = this.length;
      if (n % 8 !== 0)
        throw new RangeError("Buffer size must be a multiple of 64-bits");
      for (var i = 0; i < n; i += 8)
        ot(this, i, i + 7),
          ot(this, i + 1, i + 6),
          ot(this, i + 2, i + 5),
          ot(this, i + 3, i + 4);
      return this;
    }),
    (c.prototype.toString = function () {
      var n = this.length;
      return n === 0
        ? ""
        : arguments.length === 0
          ? Tt(this, 0, n)
          : At.apply(this, arguments);
    }),
    (c.prototype.toLocaleString = c.prototype.toString),
    (c.prototype.equals = function (n) {
      if (!c.isBuffer(n)) throw new TypeError("Argument must be a Buffer");
      return this === n ? !0 : c.compare(this, n) === 0;
    }),
    (c.prototype.inspect = function () {
      var n = "",
        i = e.INSPECT_MAX_BYTES;
      return (
        (n = this.toString("hex", 0, i)
          .replace(/(.{2})/g, "$1 ")
          .trim()),
        this.length > i && (n += " ... "),
        "<Buffer " + n + ">"
      );
    }),
    o && (c.prototype[o] = c.prototype.inspect),
    (c.prototype.compare = function (n, i, l, p, E) {
      if (
        (T(n, Uint8Array) && (n = c.from(n, n.offset, n.byteLength)),
        !c.isBuffer(n))
      )
        throw new TypeError(
          'The "target" argument must be one of type Buffer or Uint8Array. Received type ' +
            typeof n,
        );
      if (
        (i === void 0 && (i = 0),
        l === void 0 && (l = n ? n.length : 0),
        p === void 0 && (p = 0),
        E === void 0 && (E = this.length),
        i < 0 || l > n.length || p < 0 || E > this.length)
      )
        throw new RangeError("out of range index");
      if (p >= E && i >= l) return 0;
      if (p >= E) return -1;
      if (i >= l) return 1;
      if (((i >>>= 0), (l >>>= 0), (p >>>= 0), (E >>>= 0), this === n))
        return 0;
      for (
        var F = E - p,
          D = l - i,
          H = Math.min(F, D),
          V = this.slice(p, E),
          rt = n.slice(i, l),
          h = 0;
        h < H;
        ++h
      )
        if (V[h] !== rt[h]) {
          (F = V[h]), (D = rt[h]);
          break;
        }
      return F < D ? -1 : D < F ? 1 : 0;
    });
  function q(f, n, i, l, p) {
    if (f.length === 0) return -1;
    if (
      (typeof i == "string"
        ? ((l = i), (i = 0))
        : i > 2147483647
          ? (i = 2147483647)
          : i < -2147483648 && (i = -2147483648),
      (i = +i),
      S(i) && (i = p ? 0 : f.length - 1),
      i < 0 && (i = f.length + i),
      i >= f.length)
    ) {
      if (p) return -1;
      i = f.length - 1;
    } else if (i < 0)
      if (p) i = 0;
      else return -1;
    if ((typeof n == "string" && (n = c.from(n, l)), c.isBuffer(n)))
      return n.length === 0 ? -1 : J(f, n, i, l, p);
    if (typeof n == "number")
      return (
        (n = n & 255),
        typeof Uint8Array.prototype.indexOf == "function"
          ? p
            ? Uint8Array.prototype.indexOf.call(f, n, i)
            : Uint8Array.prototype.lastIndexOf.call(f, n, i)
          : J(f, [n], i, l, p)
      );
    throw new TypeError("val must be string, number or Buffer");
  }
  function J(f, n, i, l, p) {
    var E = 1,
      F = f.length,
      D = n.length;
    if (
      l !== void 0 &&
      ((l = String(l).toLowerCase()),
      l === "ucs2" || l === "ucs-2" || l === "utf16le" || l === "utf-16le")
    ) {
      if (f.length < 2 || n.length < 2) return -1;
      (E = 2), (F /= 2), (D /= 2), (i /= 2);
    }
    function H(a, m) {
      return E === 1 ? a[m] : a.readUInt16BE(m * E);
    }
    var V;
    if (p) {
      var rt = -1;
      for (V = i; V < F; V++)
        if (H(f, V) === H(n, rt === -1 ? 0 : V - rt)) {
          if ((rt === -1 && (rt = V), V - rt + 1 === D)) return rt * E;
        } else rt !== -1 && (V -= V - rt), (rt = -1);
    } else
      for (i + D > F && (i = F - D), V = i; V >= 0; V--) {
        for (var h = !0, s = 0; s < D; s++)
          if (H(f, V + s) !== H(n, s)) {
            h = !1;
            break;
          }
        if (h) return V;
      }
    return -1;
  }
  (c.prototype.includes = function (n, i, l) {
    return this.indexOf(n, i, l) !== -1;
  }),
    (c.prototype.indexOf = function (n, i, l) {
      return q(this, n, i, l, !0);
    }),
    (c.prototype.lastIndexOf = function (n, i, l) {
      return q(this, n, i, l, !1);
    });
  function nt(f, n, i, l) {
    i = Number(i) || 0;
    var p = f.length - i;
    l ? ((l = Number(l)), l > p && (l = p)) : (l = p);
    var E = n.length;
    l > E / 2 && (l = E / 2);
    for (var F = 0; F < l; ++F) {
      var D = parseInt(n.substr(F * 2, 2), 16);
      if (S(D)) return F;
      f[i + F] = D;
    }
    return F;
  }
  function it(f, n, i, l) {
    return _(G(n, f.length - i), f, i, l);
  }
  function C(f, n, i, l) {
    return _(Y(n), f, i, l);
  }
  function xt(f, n, i, l) {
    return _(x(n), f, i, l);
  }
  function ft(f, n, i, l) {
    return _(w(n, f.length - i), f, i, l);
  }
  (c.prototype.write = function (n, i, l, p) {
    if (i === void 0) (p = "utf8"), (l = this.length), (i = 0);
    else if (l === void 0 && typeof i == "string")
      (p = i), (l = this.length), (i = 0);
    else if (isFinite(i))
      (i = i >>> 0),
        isFinite(l)
          ? ((l = l >>> 0), p === void 0 && (p = "utf8"))
          : ((p = l), (l = void 0));
    else
      throw new Error(
        "Buffer.write(string, encoding, offset[, length]) is no longer supported",
      );
    var E = this.length - i;
    if (
      ((l === void 0 || l > E) && (l = E),
      (n.length > 0 && (l < 0 || i < 0)) || i > this.length)
    )
      throw new RangeError("Attempt to write outside buffer bounds");
    p || (p = "utf8");
    for (var F = !1; ; )
      switch (p) {
        case "hex":
          return nt(this, n, i, l);
        case "utf8":
        case "utf-8":
          return it(this, n, i, l);
        case "ascii":
        case "latin1":
        case "binary":
          return C(this, n, i, l);
        case "base64":
          return xt(this, n, i, l);
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return ft(this, n, i, l);
        default:
          if (F) throw new TypeError("Unknown encoding: " + p);
          (p = ("" + p).toLowerCase()), (F = !0);
      }
  }),
    (c.prototype.toJSON = function () {
      return {
        type: "Buffer",
        data: Array.prototype.slice.call(this._arr || this, 0),
      };
    });
  function ht(f, n, i) {
    return n === 0 && i === f.length
      ? t.fromByteArray(f)
      : t.fromByteArray(f.slice(n, i));
  }
  function Tt(f, n, i) {
    i = Math.min(f.length, i);
    for (var l = [], p = n; p < i; ) {
      var E = f[p],
        F = null,
        D = E > 239 ? 4 : E > 223 ? 3 : E > 191 ? 2 : 1;
      if (p + D <= i) {
        var H, V, rt, h;
        switch (D) {
          case 1:
            E < 128 && (F = E);
            break;
          case 2:
            (H = f[p + 1]),
              (H & 192) === 128 &&
                ((h = ((E & 31) << 6) | (H & 63)), h > 127 && (F = h));
            break;
          case 3:
            (H = f[p + 1]),
              (V = f[p + 2]),
              (H & 192) === 128 &&
                (V & 192) === 128 &&
                ((h = ((E & 15) << 12) | ((H & 63) << 6) | (V & 63)),
                h > 2047 && (h < 55296 || h > 57343) && (F = h));
            break;
          case 4:
            (H = f[p + 1]),
              (V = f[p + 2]),
              (rt = f[p + 3]),
              (H & 192) === 128 &&
                (V & 192) === 128 &&
                (rt & 192) === 128 &&
                ((h =
                  ((E & 15) << 18) |
                  ((H & 63) << 12) |
                  ((V & 63) << 6) |
                  (rt & 63)),
                h > 65535 && h < 1114112 && (F = h));
        }
      }
      F === null
        ? ((F = 65533), (D = 1))
        : F > 65535 &&
          ((F -= 65536),
          l.push(((F >>> 10) & 1023) | 55296),
          (F = 56320 | (F & 1023))),
        l.push(F),
        (p += D);
    }
    return X(l);
  }
  var _t = 4096;
  function X(f) {
    var n = f.length;
    if (n <= _t) return String.fromCharCode.apply(String, f);
    for (var i = "", l = 0; l < n; )
      i += String.fromCharCode.apply(String, f.slice(l, (l += _t)));
    return i;
  }
  function P(f, n, i) {
    var l = "";
    i = Math.min(f.length, i);
    for (var p = n; p < i; ++p) l += String.fromCharCode(f[p] & 127);
    return l;
  }
  function $(f, n, i) {
    var l = "";
    i = Math.min(f.length, i);
    for (var p = n; p < i; ++p) l += String.fromCharCode(f[p]);
    return l;
  }
  function j(f, n, i) {
    var l = f.length;
    (!n || n < 0) && (n = 0), (!i || i < 0 || i > l) && (i = l);
    for (var p = "", E = n; E < i; ++E) p += N[f[E]];
    return p;
  }
  function Q(f, n, i) {
    for (var l = f.slice(n, i), p = "", E = 0; E < l.length - 1; E += 2)
      p += String.fromCharCode(l[E] + l[E + 1] * 256);
    return p;
  }
  c.prototype.slice = function (n, i) {
    var l = this.length;
    (n = ~~n),
      (i = i === void 0 ? l : ~~i),
      n < 0 ? ((n += l), n < 0 && (n = 0)) : n > l && (n = l),
      i < 0 ? ((i += l), i < 0 && (i = 0)) : i > l && (i = l),
      i < n && (i = n);
    var p = this.subarray(n, i);
    return Object.setPrototypeOf(p, c.prototype), p;
  };
  function k(f, n, i) {
    if (f % 1 !== 0 || f < 0) throw new RangeError("offset is not uint");
    if (f + n > i)
      throw new RangeError("Trying to access beyond buffer length");
  }
  (c.prototype.readUintLE = c.prototype.readUIntLE =
    function (n, i, l) {
      (n = n >>> 0), (i = i >>> 0), l || k(n, i, this.length);
      for (var p = this[n], E = 1, F = 0; ++F < i && (E *= 256); )
        p += this[n + F] * E;
      return p;
    }),
    (c.prototype.readUintBE = c.prototype.readUIntBE =
      function (n, i, l) {
        (n = n >>> 0), (i = i >>> 0), l || k(n, i, this.length);
        for (var p = this[n + --i], E = 1; i > 0 && (E *= 256); )
          p += this[n + --i] * E;
        return p;
      }),
    (c.prototype.readUint8 = c.prototype.readUInt8 =
      function (n, i) {
        return (n = n >>> 0), i || k(n, 1, this.length), this[n];
      }),
    (c.prototype.readUint16LE = c.prototype.readUInt16LE =
      function (n, i) {
        return (
          (n = n >>> 0), i || k(n, 2, this.length), this[n] | (this[n + 1] << 8)
        );
      }),
    (c.prototype.readUint16BE = c.prototype.readUInt16BE =
      function (n, i) {
        return (
          (n = n >>> 0), i || k(n, 2, this.length), (this[n] << 8) | this[n + 1]
        );
      }),
    (c.prototype.readUint32LE = c.prototype.readUInt32LE =
      function (n, i) {
        return (
          (n = n >>> 0),
          i || k(n, 4, this.length),
          (this[n] | (this[n + 1] << 8) | (this[n + 2] << 16)) +
            this[n + 3] * 16777216
        );
      }),
    (c.prototype.readUint32BE = c.prototype.readUInt32BE =
      function (n, i) {
        return (
          (n = n >>> 0),
          i || k(n, 4, this.length),
          this[n] * 16777216 +
            ((this[n + 1] << 16) | (this[n + 2] << 8) | this[n + 3])
        );
      }),
    (c.prototype.readIntLE = function (n, i, l) {
      (n = n >>> 0), (i = i >>> 0), l || k(n, i, this.length);
      for (var p = this[n], E = 1, F = 0; ++F < i && (E *= 256); )
        p += this[n + F] * E;
      return (E *= 128), p >= E && (p -= Math.pow(2, 8 * i)), p;
    }),
    (c.prototype.readIntBE = function (n, i, l) {
      (n = n >>> 0), (i = i >>> 0), l || k(n, i, this.length);
      for (var p = i, E = 1, F = this[n + --p]; p > 0 && (E *= 256); )
        F += this[n + --p] * E;
      return (E *= 128), F >= E && (F -= Math.pow(2, 8 * i)), F;
    }),
    (c.prototype.readInt8 = function (n, i) {
      return (
        (n = n >>> 0),
        i || k(n, 1, this.length),
        this[n] & 128 ? (255 - this[n] + 1) * -1 : this[n]
      );
    }),
    (c.prototype.readInt16LE = function (n, i) {
      (n = n >>> 0), i || k(n, 2, this.length);
      var l = this[n] | (this[n + 1] << 8);
      return l & 32768 ? l | 4294901760 : l;
    }),
    (c.prototype.readInt16BE = function (n, i) {
      (n = n >>> 0), i || k(n, 2, this.length);
      var l = this[n + 1] | (this[n] << 8);
      return l & 32768 ? l | 4294901760 : l;
    }),
    (c.prototype.readInt32LE = function (n, i) {
      return (
        (n = n >>> 0),
        i || k(n, 4, this.length),
        this[n] | (this[n + 1] << 8) | (this[n + 2] << 16) | (this[n + 3] << 24)
      );
    }),
    (c.prototype.readInt32BE = function (n, i) {
      return (
        (n = n >>> 0),
        i || k(n, 4, this.length),
        (this[n] << 24) | (this[n + 1] << 16) | (this[n + 2] << 8) | this[n + 3]
      );
    }),
    (c.prototype.readFloatLE = function (n, i) {
      return (
        (n = n >>> 0), i || k(n, 4, this.length), r.read(this, n, !0, 23, 4)
      );
    }),
    (c.prototype.readFloatBE = function (n, i) {
      return (
        (n = n >>> 0), i || k(n, 4, this.length), r.read(this, n, !1, 23, 4)
      );
    }),
    (c.prototype.readDoubleLE = function (n, i) {
      return (
        (n = n >>> 0), i || k(n, 8, this.length), r.read(this, n, !0, 52, 8)
      );
    }),
    (c.prototype.readDoubleBE = function (n, i) {
      return (
        (n = n >>> 0), i || k(n, 8, this.length), r.read(this, n, !1, 52, 8)
      );
    });
  function K(f, n, i, l, p, E) {
    if (!c.isBuffer(f))
      throw new TypeError('"buffer" argument must be a Buffer instance');
    if (n > p || n < E)
      throw new RangeError('"value" argument is out of bounds');
    if (i + l > f.length) throw new RangeError("Index out of range");
  }
  (c.prototype.writeUintLE = c.prototype.writeUIntLE =
    function (n, i, l, p) {
      if (((n = +n), (i = i >>> 0), (l = l >>> 0), !p)) {
        var E = Math.pow(2, 8 * l) - 1;
        K(this, n, i, l, E, 0);
      }
      var F = 1,
        D = 0;
      for (this[i] = n & 255; ++D < l && (F *= 256); )
        this[i + D] = (n / F) & 255;
      return i + l;
    }),
    (c.prototype.writeUintBE = c.prototype.writeUIntBE =
      function (n, i, l, p) {
        if (((n = +n), (i = i >>> 0), (l = l >>> 0), !p)) {
          var E = Math.pow(2, 8 * l) - 1;
          K(this, n, i, l, E, 0);
        }
        var F = l - 1,
          D = 1;
        for (this[i + F] = n & 255; --F >= 0 && (D *= 256); )
          this[i + F] = (n / D) & 255;
        return i + l;
      }),
    (c.prototype.writeUint8 = c.prototype.writeUInt8 =
      function (n, i, l) {
        return (
          (n = +n),
          (i = i >>> 0),
          l || K(this, n, i, 1, 255, 0),
          (this[i] = n & 255),
          i + 1
        );
      }),
    (c.prototype.writeUint16LE = c.prototype.writeUInt16LE =
      function (n, i, l) {
        return (
          (n = +n),
          (i = i >>> 0),
          l || K(this, n, i, 2, 65535, 0),
          (this[i] = n & 255),
          (this[i + 1] = n >>> 8),
          i + 2
        );
      }),
    (c.prototype.writeUint16BE = c.prototype.writeUInt16BE =
      function (n, i, l) {
        return (
          (n = +n),
          (i = i >>> 0),
          l || K(this, n, i, 2, 65535, 0),
          (this[i] = n >>> 8),
          (this[i + 1] = n & 255),
          i + 2
        );
      }),
    (c.prototype.writeUint32LE = c.prototype.writeUInt32LE =
      function (n, i, l) {
        return (
          (n = +n),
          (i = i >>> 0),
          l || K(this, n, i, 4, 4294967295, 0),
          (this[i + 3] = n >>> 24),
          (this[i + 2] = n >>> 16),
          (this[i + 1] = n >>> 8),
          (this[i] = n & 255),
          i + 4
        );
      }),
    (c.prototype.writeUint32BE = c.prototype.writeUInt32BE =
      function (n, i, l) {
        return (
          (n = +n),
          (i = i >>> 0),
          l || K(this, n, i, 4, 4294967295, 0),
          (this[i] = n >>> 24),
          (this[i + 1] = n >>> 16),
          (this[i + 2] = n >>> 8),
          (this[i + 3] = n & 255),
          i + 4
        );
      }),
    (c.prototype.writeIntLE = function (n, i, l, p) {
      if (((n = +n), (i = i >>> 0), !p)) {
        var E = Math.pow(2, 8 * l - 1);
        K(this, n, i, l, E - 1, -E);
      }
      var F = 0,
        D = 1,
        H = 0;
      for (this[i] = n & 255; ++F < l && (D *= 256); )
        n < 0 && H === 0 && this[i + F - 1] !== 0 && (H = 1),
          (this[i + F] = (((n / D) >> 0) - H) & 255);
      return i + l;
    }),
    (c.prototype.writeIntBE = function (n, i, l, p) {
      if (((n = +n), (i = i >>> 0), !p)) {
        var E = Math.pow(2, 8 * l - 1);
        K(this, n, i, l, E - 1, -E);
      }
      var F = l - 1,
        D = 1,
        H = 0;
      for (this[i + F] = n & 255; --F >= 0 && (D *= 256); )
        n < 0 && H === 0 && this[i + F + 1] !== 0 && (H = 1),
          (this[i + F] = (((n / D) >> 0) - H) & 255);
      return i + l;
    }),
    (c.prototype.writeInt8 = function (n, i, l) {
      return (
        (n = +n),
        (i = i >>> 0),
        l || K(this, n, i, 1, 127, -128),
        n < 0 && (n = 255 + n + 1),
        (this[i] = n & 255),
        i + 1
      );
    }),
    (c.prototype.writeInt16LE = function (n, i, l) {
      return (
        (n = +n),
        (i = i >>> 0),
        l || K(this, n, i, 2, 32767, -32768),
        (this[i] = n & 255),
        (this[i + 1] = n >>> 8),
        i + 2
      );
    }),
    (c.prototype.writeInt16BE = function (n, i, l) {
      return (
        (n = +n),
        (i = i >>> 0),
        l || K(this, n, i, 2, 32767, -32768),
        (this[i] = n >>> 8),
        (this[i + 1] = n & 255),
        i + 2
      );
    }),
    (c.prototype.writeInt32LE = function (n, i, l) {
      return (
        (n = +n),
        (i = i >>> 0),
        l || K(this, n, i, 4, 2147483647, -2147483648),
        (this[i] = n & 255),
        (this[i + 1] = n >>> 8),
        (this[i + 2] = n >>> 16),
        (this[i + 3] = n >>> 24),
        i + 4
      );
    }),
    (c.prototype.writeInt32BE = function (n, i, l) {
      return (
        (n = +n),
        (i = i >>> 0),
        l || K(this, n, i, 4, 2147483647, -2147483648),
        n < 0 && (n = 4294967295 + n + 1),
        (this[i] = n >>> 24),
        (this[i + 1] = n >>> 16),
        (this[i + 2] = n >>> 8),
        (this[i + 3] = n & 255),
        i + 4
      );
    });
  function yt(f, n, i, l, p, E) {
    if (i + l > f.length) throw new RangeError("Index out of range");
    if (i < 0) throw new RangeError("Index out of range");
  }
  function y(f, n, i, l, p) {
    return (
      (n = +n),
      (i = i >>> 0),
      p || yt(f, n, i, 4),
      r.write(f, n, i, l, 23, 4),
      i + 4
    );
  }
  (c.prototype.writeFloatLE = function (n, i, l) {
    return y(this, n, i, !0, l);
  }),
    (c.prototype.writeFloatBE = function (n, i, l) {
      return y(this, n, i, !1, l);
    });
  function dt(f, n, i, l, p) {
    return (
      (n = +n),
      (i = i >>> 0),
      p || yt(f, n, i, 8),
      r.write(f, n, i, l, 52, 8),
      i + 8
    );
  }
  (c.prototype.writeDoubleLE = function (n, i, l) {
    return dt(this, n, i, !0, l);
  }),
    (c.prototype.writeDoubleBE = function (n, i, l) {
      return dt(this, n, i, !1, l);
    }),
    (c.prototype.copy = function (n, i, l, p) {
      if (!c.isBuffer(n)) throw new TypeError("argument should be a Buffer");
      if (
        (l || (l = 0),
        !p && p !== 0 && (p = this.length),
        i >= n.length && (i = n.length),
        i || (i = 0),
        p > 0 && p < l && (p = l),
        p === l || n.length === 0 || this.length === 0)
      )
        return 0;
      if (i < 0) throw new RangeError("targetStart out of bounds");
      if (l < 0 || l >= this.length) throw new RangeError("Index out of range");
      if (p < 0) throw new RangeError("sourceEnd out of bounds");
      p > this.length && (p = this.length),
        n.length - i < p - l && (p = n.length - i + l);
      var E = p - l;
      return (
        this === n && typeof Uint8Array.prototype.copyWithin == "function"
          ? this.copyWithin(i, l, p)
          : Uint8Array.prototype.set.call(n, this.subarray(l, p), i),
        E
      );
    }),
    (c.prototype.fill = function (n, i, l, p) {
      if (typeof n == "string") {
        if (
          (typeof i == "string"
            ? ((p = i), (i = 0), (l = this.length))
            : typeof l == "string" && ((p = l), (l = this.length)),
          p !== void 0 && typeof p != "string")
        )
          throw new TypeError("encoding must be a string");
        if (typeof p == "string" && !c.isEncoding(p))
          throw new TypeError("Unknown encoding: " + p);
        if (n.length === 1) {
          var E = n.charCodeAt(0);
          ((p === "utf8" && E < 128) || p === "latin1") && (n = E);
        }
      } else
        typeof n == "number"
          ? (n = n & 255)
          : typeof n == "boolean" && (n = Number(n));
      if (i < 0 || this.length < i || this.length < l)
        throw new RangeError("Out of range index");
      if (l <= i) return this;
      (i = i >>> 0), (l = l === void 0 ? this.length : l >>> 0), n || (n = 0);
      var F;
      if (typeof n == "number") for (F = i; F < l; ++F) this[F] = n;
      else {
        var D = c.isBuffer(n) ? n : c.from(n, p),
          H = D.length;
        if (H === 0)
          throw new TypeError(
            'The value "' + n + '" is invalid for argument "value"',
          );
        for (F = 0; F < l - i; ++F) this[F + i] = D[F % H];
      }
      return this;
    });
  var bt = /[^+/0-9A-Za-z-_]/g;
  function Ut(f) {
    if (((f = f.split("=")[0]), (f = f.trim().replace(bt, "")), f.length < 2))
      return "";
    for (; f.length % 4 !== 0; ) f = f + "=";
    return f;
  }
  function G(f, n) {
    n = n || 1 / 0;
    for (var i, l = f.length, p = null, E = [], F = 0; F < l; ++F) {
      if (((i = f.charCodeAt(F)), i > 55295 && i < 57344)) {
        if (!p) {
          if (i > 56319) {
            (n -= 3) > -1 && E.push(239, 191, 189);
            continue;
          } else if (F + 1 === l) {
            (n -= 3) > -1 && E.push(239, 191, 189);
            continue;
          }
          p = i;
          continue;
        }
        if (i < 56320) {
          (n -= 3) > -1 && E.push(239, 191, 189), (p = i);
          continue;
        }
        i = (((p - 55296) << 10) | (i - 56320)) + 65536;
      } else p && (n -= 3) > -1 && E.push(239, 191, 189);
      if (((p = null), i < 128)) {
        if ((n -= 1) < 0) break;
        E.push(i);
      } else if (i < 2048) {
        if ((n -= 2) < 0) break;
        E.push((i >> 6) | 192, (i & 63) | 128);
      } else if (i < 65536) {
        if ((n -= 3) < 0) break;
        E.push((i >> 12) | 224, ((i >> 6) & 63) | 128, (i & 63) | 128);
      } else if (i < 1114112) {
        if ((n -= 4) < 0) break;
        E.push(
          (i >> 18) | 240,
          ((i >> 12) & 63) | 128,
          ((i >> 6) & 63) | 128,
          (i & 63) | 128,
        );
      } else throw new Error("Invalid code point");
    }
    return E;
  }
  function Y(f) {
    for (var n = [], i = 0; i < f.length; ++i) n.push(f.charCodeAt(i) & 255);
    return n;
  }
  function w(f, n) {
    for (var i, l, p, E = [], F = 0; F < f.length && !((n -= 2) < 0); ++F)
      (i = f.charCodeAt(F)), (l = i >> 8), (p = i % 256), E.push(p), E.push(l);
    return E;
  }
  function x(f) {
    return t.toByteArray(Ut(f));
  }
  function _(f, n, i, l) {
    for (var p = 0; p < l && !(p + i >= n.length || p >= f.length); ++p)
      n[p + i] = f[p];
    return p;
  }
  function T(f, n) {
    return (
      f instanceof n ||
      (f != null &&
        f.constructor != null &&
        f.constructor.name != null &&
        f.constructor.name === n.name)
    );
  }
  function S(f) {
    return f !== f;
  }
  var N = (function () {
    for (var f = "0123456789abcdef", n = new Array(256), i = 0; i < 16; ++i)
      for (var l = i * 16, p = 0; p < 16; ++p) n[l + p] = f[i] + f[p];
    return n;
  })();
})(Oe);
var ni = { exports: {} };
(function (e) {
  (function (t) {
    var r,
      o = /^-?(?:\d+(?:\.\d*)?|\.\d+)(?:e[+-]?\d+)?$/i,
      u = Math.ceil,
      d = Math.floor,
      g = "[BigNumber Error] ",
      c = g + "Number primitive has more than 15 significant digits: ",
      b = 1e14,
      A = 14,
      U = 9007199254740991,
      L = [
        1, 10, 100, 1e3, 1e4, 1e5, 1e6, 1e7, 1e8, 1e9, 1e10, 1e11, 1e12, 1e13,
      ],
      O = 1e7,
      M = 1e9;
    function Z(q) {
      var J,
        nt,
        it,
        C = (y.prototype = { constructor: y, toString: null, valueOf: null }),
        xt = new y(1),
        ft = 20,
        ht = 4,
        Tt = -7,
        _t = 21,
        X = -1e7,
        P = 1e7,
        $ = !1,
        j = 1,
        Q = 0,
        k = {
          prefix: "",
          groupSize: 3,
          secondaryGroupSize: 0,
          groupSeparator: ",",
          decimalSeparator: ".",
          fractionGroupSize: 0,
          fractionGroupSeparator: " ",
          suffix: "",
        },
        K = "0123456789abcdefghijklmnopqrstuvwxyz",
        yt = !0;
      function y(w, x) {
        var _,
          T,
          S,
          N,
          f,
          n,
          i,
          l,
          p = this;
        if (!(p instanceof y)) return new y(w, x);
        if (x == null) {
          if (w && w._isBigNumber === !0) {
            (p.s = w.s),
              !w.c || w.e > P
                ? (p.c = p.e = null)
                : w.e < X
                  ? (p.c = [(p.e = 0)])
                  : ((p.e = w.e), (p.c = w.c.slice()));
            return;
          }
          if ((n = typeof w == "number") && w * 0 == 0) {
            if (((p.s = 1 / w < 0 ? ((w = -w), -1) : 1), w === ~~w)) {
              for (N = 0, f = w; f >= 10; f /= 10, N++);
              N > P ? (p.c = p.e = null) : ((p.e = N), (p.c = [w]));
              return;
            }
            l = String(w);
          } else {
            if (!o.test((l = String(w)))) return it(p, l, n);
            p.s = l.charCodeAt(0) == 45 ? ((l = l.slice(1)), -1) : 1;
          }
          (N = l.indexOf(".")) > -1 && (l = l.replace(".", "")),
            (f = l.search(/e/i)) > 0
              ? (N < 0 && (N = f),
                (N += +l.slice(f + 1)),
                (l = l.substring(0, f)))
              : N < 0 && (N = l.length);
        } else {
          if ((ut(x, 2, K.length, "Base"), x == 10 && yt))
            return (p = new y(w)), G(p, ft + p.e + 1, ht);
          if (((l = String(w)), (n = typeof w == "number"))) {
            if (w * 0 != 0) return it(p, l, n, x);
            if (
              ((p.s = 1 / w < 0 ? ((l = l.slice(1)), -1) : 1),
              y.DEBUG && l.replace(/^0\.0*|\./, "").length > 15)
            )
              throw Error(c + w);
          } else p.s = l.charCodeAt(0) === 45 ? ((l = l.slice(1)), -1) : 1;
          for (_ = K.slice(0, x), N = f = 0, i = l.length; f < i; f++)
            if (_.indexOf((T = l.charAt(f))) < 0) {
              if (T == ".") {
                if (f > N) {
                  N = i;
                  continue;
                }
              } else if (
                !S &&
                ((l == l.toUpperCase() && (l = l.toLowerCase())) ||
                  (l == l.toLowerCase() && (l = l.toUpperCase())))
              ) {
                (S = !0), (f = -1), (N = 0);
                continue;
              }
              return it(p, String(w), n, x);
            }
          (n = !1),
            (l = nt(l, x, 10, p.s)),
            (N = l.indexOf(".")) > -1
              ? (l = l.replace(".", ""))
              : (N = l.length);
        }
        for (f = 0; l.charCodeAt(f) === 48; f++);
        for (i = l.length; l.charCodeAt(--i) === 48; );
        if ((l = l.slice(f, ++i))) {
          if (((i -= f), n && y.DEBUG && i > 15 && (w > U || w !== d(w))))
            throw Error(c + p.s * w);
          if ((N = N - f - 1) > P) p.c = p.e = null;
          else if (N < X) p.c = [(p.e = 0)];
          else {
            if (
              ((p.e = N),
              (p.c = []),
              (f = (N + 1) % A),
              N < 0 && (f += A),
              f < i)
            ) {
              for (f && p.c.push(+l.slice(0, f)), i -= A; f < i; )
                p.c.push(+l.slice(f, (f += A)));
              f = A - (l = l.slice(f)).length;
            } else f -= i;
            for (; f--; l += "0");
            p.c.push(+l);
          }
        } else p.c = [(p.e = 0)];
      }
      (y.clone = Z),
        (y.ROUND_UP = 0),
        (y.ROUND_DOWN = 1),
        (y.ROUND_CEIL = 2),
        (y.ROUND_FLOOR = 3),
        (y.ROUND_HALF_UP = 4),
        (y.ROUND_HALF_DOWN = 5),
        (y.ROUND_HALF_EVEN = 6),
        (y.ROUND_HALF_CEIL = 7),
        (y.ROUND_HALF_FLOOR = 8),
        (y.EUCLID = 9),
        (y.config = y.set =
          function (w) {
            var x, _;
            if (w != null)
              if (typeof w == "object") {
                if (
                  (w.hasOwnProperty((x = "DECIMAL_PLACES")) &&
                    ((_ = w[x]), ut(_, 0, M, x), (ft = _)),
                  w.hasOwnProperty((x = "ROUNDING_MODE")) &&
                    ((_ = w[x]), ut(_, 0, 8, x), (ht = _)),
                  w.hasOwnProperty((x = "EXPONENTIAL_AT")) &&
                    ((_ = w[x]),
                    _ && _.pop
                      ? (ut(_[0], -M, 0, x),
                        ut(_[1], 0, M, x),
                        (Tt = _[0]),
                        (_t = _[1]))
                      : (ut(_, -M, M, x), (Tt = -(_t = _ < 0 ? -_ : _)))),
                  w.hasOwnProperty((x = "RANGE")))
                )
                  if (((_ = w[x]), _ && _.pop))
                    ut(_[0], -M, -1, x),
                      ut(_[1], 1, M, x),
                      (X = _[0]),
                      (P = _[1]);
                  else if ((ut(_, -M, M, x), _)) X = -(P = _ < 0 ? -_ : _);
                  else throw Error(g + x + " cannot be zero: " + _);
                if (w.hasOwnProperty((x = "CRYPTO")))
                  if (((_ = w[x]), _ === !!_))
                    if (_)
                      if (
                        typeof crypto < "u" &&
                        crypto &&
                        (crypto.getRandomValues || crypto.randomBytes)
                      )
                        $ = _;
                      else throw (($ = !_), Error(g + "crypto unavailable"));
                    else $ = _;
                  else throw Error(g + x + " not true or false: " + _);
                if (
                  (w.hasOwnProperty((x = "MODULO_MODE")) &&
                    ((_ = w[x]), ut(_, 0, 9, x), (j = _)),
                  w.hasOwnProperty((x = "POW_PRECISION")) &&
                    ((_ = w[x]), ut(_, 0, M, x), (Q = _)),
                  w.hasOwnProperty((x = "FORMAT")))
                )
                  if (((_ = w[x]), typeof _ == "object")) k = _;
                  else throw Error(g + x + " not an object: " + _);
                if (w.hasOwnProperty((x = "ALPHABET")))
                  if (
                    ((_ = w[x]),
                    typeof _ == "string" && !/^.?$|[+\-.\s]|(.).*\1/.test(_))
                  )
                    (yt = _.slice(0, 10) == "0123456789"), (K = _);
                  else throw Error(g + x + " invalid: " + _);
              } else throw Error(g + "Object expected: " + w);
            return {
              DECIMAL_PLACES: ft,
              ROUNDING_MODE: ht,
              EXPONENTIAL_AT: [Tt, _t],
              RANGE: [X, P],
              CRYPTO: $,
              MODULO_MODE: j,
              POW_PRECISION: Q,
              FORMAT: k,
              ALPHABET: K,
            };
          }),
        (y.isBigNumber = function (w) {
          if (!w || w._isBigNumber !== !0) return !1;
          if (!y.DEBUG) return !0;
          var x,
            _,
            T = w.c,
            S = w.e,
            N = w.s;
          t: if ({}.toString.call(T) == "[object Array]") {
            if ((N === 1 || N === -1) && S >= -M && S <= M && S === d(S)) {
              if (T[0] === 0) {
                if (S === 0 && T.length === 1) return !0;
                break t;
              }
              if (
                ((x = (S + 1) % A), x < 1 && (x += A), String(T[0]).length == x)
              ) {
                for (x = 0; x < T.length; x++)
                  if (((_ = T[x]), _ < 0 || _ >= b || _ !== d(_))) break t;
                if (_ !== 0) return !0;
              }
            }
          } else if (
            T === null &&
            S === null &&
            (N === null || N === 1 || N === -1)
          )
            return !0;
          throw Error(g + "Invalid BigNumber: " + w);
        }),
        (y.maximum = y.max =
          function () {
            return bt(arguments, -1);
          }),
        (y.minimum = y.min =
          function () {
            return bt(arguments, 1);
          }),
        (y.random = (function () {
          var w = 9007199254740992,
            x =
              (Math.random() * w) & 2097151
                ? function () {
                    return d(Math.random() * w);
                  }
                : function () {
                    return (
                      ((Math.random() * 1073741824) | 0) * 8388608 +
                      ((Math.random() * 8388608) | 0)
                    );
                  };
          return function (_) {
            var T,
              S,
              N,
              f,
              n,
              i = 0,
              l = [],
              p = new y(xt);
            if ((_ == null ? (_ = ft) : ut(_, 0, M), (f = u(_ / A)), $))
              if (crypto.getRandomValues) {
                for (
                  T = crypto.getRandomValues(new Uint32Array((f *= 2)));
                  i < f;

                )
                  (n = T[i] * 131072 + (T[i + 1] >>> 11)),
                    n >= 9e15
                      ? ((S = crypto.getRandomValues(new Uint32Array(2))),
                        (T[i] = S[0]),
                        (T[i + 1] = S[1]))
                      : (l.push(n % 1e14), (i += 2));
                i = f / 2;
              } else if (crypto.randomBytes) {
                for (T = crypto.randomBytes((f *= 7)); i < f; )
                  (n =
                    (T[i] & 31) * 281474976710656 +
                    T[i + 1] * 1099511627776 +
                    T[i + 2] * 4294967296 +
                    T[i + 3] * 16777216 +
                    (T[i + 4] << 16) +
                    (T[i + 5] << 8) +
                    T[i + 6]),
                    n >= 9e15
                      ? crypto.randomBytes(7).copy(T, i)
                      : (l.push(n % 1e14), (i += 7));
                i = f / 7;
              } else throw (($ = !1), Error(g + "crypto unavailable"));
            if (!$) for (; i < f; ) (n = x()), n < 9e15 && (l[i++] = n % 1e14);
            for (
              f = l[--i],
                _ %= A,
                f && _ && ((n = L[A - _]), (l[i] = d(f / n) * n));
              l[i] === 0;
              l.pop(), i--
            );
            if (i < 0) l = [(N = 0)];
            else {
              for (N = -1; l[0] === 0; l.splice(0, 1), N -= A);
              for (i = 1, n = l[0]; n >= 10; n /= 10, i++);
              i < A && (N -= A - i);
            }
            return (p.e = N), (p.c = l), p;
          };
        })()),
        (y.sum = function () {
          for (var w = 1, x = arguments, _ = new y(x[0]); w < x.length; )
            _ = _.plus(x[w++]);
          return _;
        }),
        (nt = (function () {
          var w = "0123456789";
          function x(_, T, S, N) {
            for (var f, n = [0], i, l = 0, p = _.length; l < p; ) {
              for (i = n.length; i--; n[i] *= T);
              for (n[0] += N.indexOf(_.charAt(l++)), f = 0; f < n.length; f++)
                n[f] > S - 1 &&
                  (n[f + 1] == null && (n[f + 1] = 0),
                  (n[f + 1] += (n[f] / S) | 0),
                  (n[f] %= S));
            }
            return n.reverse();
          }
          return function (_, T, S, N, f) {
            var n,
              i,
              l,
              p,
              E,
              F,
              D,
              H,
              V = _.indexOf("."),
              rt = ft,
              h = ht;
            for (
              V >= 0 &&
                ((p = Q),
                (Q = 0),
                (_ = _.replace(".", "")),
                (H = new y(T)),
                (F = H.pow(_.length - V)),
                (Q = p),
                (H.c = x(ot(ct(F.c), F.e, "0"), 10, S, w)),
                (H.e = H.c.length)),
                D = x(_, T, S, f ? ((n = K), w) : ((n = w), K)),
                l = p = D.length;
              D[--p] == 0;
              D.pop()
            );
            if (!D[0]) return n.charAt(0);
            if (
              (V < 0
                ? --l
                : ((F.c = D),
                  (F.e = l),
                  (F.s = N),
                  (F = J(F, H, rt, h, S)),
                  (D = F.c),
                  (E = F.r),
                  (l = F.e)),
              (i = l + rt + 1),
              (V = D[i]),
              (p = S / 2),
              (E = E || i < 0 || D[i + 1] != null),
              (E =
                h < 4
                  ? (V != null || E) && (h == 0 || h == (F.s < 0 ? 3 : 2))
                  : V > p ||
                    (V == p &&
                      (h == 4 ||
                        E ||
                        (h == 6 && D[i - 1] & 1) ||
                        h == (F.s < 0 ? 8 : 7)))),
              i < 1 || !D[0])
            )
              _ = E ? ot(n.charAt(1), -rt, n.charAt(0)) : n.charAt(0);
            else {
              if (((D.length = i), E))
                for (--S; ++D[--i] > S; )
                  (D[i] = 0), i || (++l, (D = [1].concat(D)));
              for (p = D.length; !D[--p]; );
              for (V = 0, _ = ""; V <= p; _ += n.charAt(D[V++]));
              _ = ot(_, l, n.charAt(0));
            }
            return _;
          };
        })()),
        (J = (function () {
          function w(T, S, N) {
            var f,
              n,
              i,
              l,
              p = 0,
              E = T.length,
              F = S % O,
              D = (S / O) | 0;
            for (T = T.slice(); E--; )
              (i = T[E] % O),
                (l = (T[E] / O) | 0),
                (f = D * i + l * F),
                (n = F * i + (f % O) * O + p),
                (p = ((n / N) | 0) + ((f / O) | 0) + D * l),
                (T[E] = n % N);
            return p && (T = [p].concat(T)), T;
          }
          function x(T, S, N, f) {
            var n, i;
            if (N != f) i = N > f ? 1 : -1;
            else
              for (n = i = 0; n < N; n++)
                if (T[n] != S[n]) {
                  i = T[n] > S[n] ? 1 : -1;
                  break;
                }
            return i;
          }
          function _(T, S, N, f) {
            for (var n = 0; N--; )
              (T[N] -= n),
                (n = T[N] < S[N] ? 1 : 0),
                (T[N] = n * f + T[N] - S[N]);
            for (; !T[0] && T.length > 1; T.splice(0, 1));
          }
          return function (T, S, N, f, n) {
            var i,
              l,
              p,
              E,
              F,
              D,
              H,
              V,
              rt,
              h,
              s,
              a,
              m,
              B,
              R,
              v,
              et,
              lt = T.s == S.s ? 1 : -1,
              st = T.c,
              tt = S.c;
            if (!st || !st[0] || !tt || !tt[0])
              return new y(
                !T.s || !S.s || (st ? tt && st[0] == tt[0] : !tt)
                  ? NaN
                  : (st && st[0] == 0) || !tt
                    ? lt * 0
                    : lt / 0,
              );
            for (
              V = new y(lt),
                rt = V.c = [],
                l = T.e - S.e,
                lt = N + l + 1,
                n ||
                  ((n = b), (l = W(T.e / A) - W(S.e / A)), (lt = (lt / A) | 0)),
                p = 0;
              tt[p] == (st[p] || 0);
              p++
            );
            if ((tt[p] > (st[p] || 0) && l--, lt < 0)) rt.push(1), (E = !0);
            else {
              for (
                B = st.length,
                  v = tt.length,
                  p = 0,
                  lt += 2,
                  F = d(n / (tt[0] + 1)),
                  F > 1 &&
                    ((tt = w(tt, F, n)),
                    (st = w(st, F, n)),
                    (v = tt.length),
                    (B = st.length)),
                  m = v,
                  h = st.slice(0, v),
                  s = h.length;
                s < v;
                h[s++] = 0
              );
              (et = tt.slice()),
                (et = [0].concat(et)),
                (R = tt[0]),
                tt[1] >= n / 2 && R++;
              do {
                if (((F = 0), (i = x(tt, h, v, s)), i < 0)) {
                  if (
                    ((a = h[0]),
                    v != s && (a = a * n + (h[1] || 0)),
                    (F = d(a / R)),
                    F > 1)
                  )
                    for (
                      F >= n && (F = n - 1),
                        D = w(tt, F, n),
                        H = D.length,
                        s = h.length;
                      x(D, h, H, s) == 1;

                    )
                      F--, _(D, v < H ? et : tt, H, n), (H = D.length), (i = 1);
                  else F == 0 && (i = F = 1), (D = tt.slice()), (H = D.length);
                  if (
                    (H < s && (D = [0].concat(D)),
                    _(h, D, s, n),
                    (s = h.length),
                    i == -1)
                  )
                    for (; x(tt, h, v, s) < 1; )
                      F++, _(h, v < s ? et : tt, s, n), (s = h.length);
                } else i === 0 && (F++, (h = [0]));
                (rt[p++] = F),
                  h[0] ? (h[s++] = st[m] || 0) : ((h = [st[m]]), (s = 1));
              } while ((m++ < B || h[0] != null) && lt--);
              (E = h[0] != null), rt[0] || rt.splice(0, 1);
            }
            if (n == b) {
              for (p = 1, lt = rt[0]; lt >= 10; lt /= 10, p++);
              G(V, N + (V.e = p + l * A - 1) + 1, f, E);
            } else (V.e = l), (V.r = +E);
            return V;
          };
        })());
      function dt(w, x, _, T) {
        var S, N, f, n, i;
        if ((_ == null ? (_ = ht) : ut(_, 0, 8), !w.c)) return w.toString();
        if (((S = w.c[0]), (f = w.e), x == null))
          (i = ct(w.c)),
            (i =
              T == 1 || (T == 2 && (f <= Tt || f >= _t))
                ? At(i, f)
                : ot(i, f, "0"));
        else if (
          ((w = G(new y(w), x, _)),
          (N = w.e),
          (i = ct(w.c)),
          (n = i.length),
          T == 1 || (T == 2 && (x <= N || N <= Tt)))
        ) {
          for (; n < x; i += "0", n++);
          i = At(i, N);
        } else if (((x -= f), (i = ot(i, N, "0")), N + 1 > n)) {
          if (--x > 0) for (i += "."; x--; i += "0");
        } else if (((x += N - n), x > 0))
          for (N + 1 == n && (i += "."); x--; i += "0");
        return w.s < 0 && S ? "-" + i : i;
      }
      function bt(w, x) {
        for (var _, T, S = 1, N = new y(w[0]); S < w.length; S++)
          (T = new y(w[S])),
            (!T.s || (_ = mt(N, T)) === x || (_ === 0 && N.s === x)) && (N = T);
        return N;
      }
      function Ut(w, x, _) {
        for (var T = 1, S = x.length; !x[--S]; x.pop());
        for (S = x[0]; S >= 10; S /= 10, T++);
        return (
          (_ = T + _ * A - 1) > P
            ? (w.c = w.e = null)
            : _ < X
              ? (w.c = [(w.e = 0)])
              : ((w.e = _), (w.c = x)),
          w
        );
      }
      it = (function () {
        var w = /^(-?)0([xbo])(?=\w[\w.]*$)/i,
          x = /^([^.]+)\.$/,
          _ = /^\.([^.]+)$/,
          T = /^-?(Infinity|NaN)$/,
          S = /^\s*\+(?=[\w.])|^\s+|\s+$/g;
        return function (N, f, n, i) {
          var l,
            p = n ? f : f.replace(S, "");
          if (T.test(p)) N.s = isNaN(p) ? null : p < 0 ? -1 : 1;
          else {
            if (
              !n &&
              ((p = p.replace(w, function (E, F, D) {
                return (
                  (l = (D = D.toLowerCase()) == "x" ? 16 : D == "b" ? 2 : 8),
                  !i || i == l ? F : E
                );
              })),
              i && ((l = i), (p = p.replace(x, "$1").replace(_, "0.$1"))),
              f != p)
            )
              return new y(p, l);
            if (y.DEBUG)
              throw Error(
                g + "Not a" + (i ? " base " + i : "") + " number: " + f,
              );
            N.s = null;
          }
          N.c = N.e = null;
        };
      })();
      function G(w, x, _, T) {
        var S,
          N,
          f,
          n,
          i,
          l,
          p,
          E = w.c,
          F = L;
        if (E) {
          t: {
            for (S = 1, n = E[0]; n >= 10; n /= 10, S++);
            if (((N = x - S), N < 0))
              (N += A),
                (f = x),
                (i = E[(l = 0)]),
                (p = d((i / F[S - f - 1]) % 10));
            else if (((l = u((N + 1) / A)), l >= E.length))
              if (T) {
                for (; E.length <= l; E.push(0));
                (i = p = 0), (S = 1), (N %= A), (f = N - A + 1);
              } else break t;
            else {
              for (i = n = E[l], S = 1; n >= 10; n /= 10, S++);
              (N %= A),
                (f = N - A + S),
                (p = f < 0 ? 0 : d((i / F[S - f - 1]) % 10));
            }
            if (
              ((T =
                T ||
                x < 0 ||
                E[l + 1] != null ||
                (f < 0 ? i : i % F[S - f - 1])),
              (T =
                _ < 4
                  ? (p || T) && (_ == 0 || _ == (w.s < 0 ? 3 : 2))
                  : p > 5 ||
                    (p == 5 &&
                      (_ == 4 ||
                        T ||
                        (_ == 6 &&
                          (N > 0 ? (f > 0 ? i / F[S - f] : 0) : E[l - 1]) % 10 &
                            1) ||
                        _ == (w.s < 0 ? 8 : 7)))),
              x < 1 || !E[0])
            )
              return (
                (E.length = 0),
                T
                  ? ((x -= w.e + 1),
                    (E[0] = F[(A - (x % A)) % A]),
                    (w.e = -x || 0))
                  : (E[0] = w.e = 0),
                w
              );
            if (
              (N == 0
                ? ((E.length = l), (n = 1), l--)
                : ((E.length = l + 1),
                  (n = F[A - N]),
                  (E[l] = f > 0 ? d((i / F[S - f]) % F[f]) * n : 0)),
              T)
            )
              for (;;)
                if (l == 0) {
                  for (N = 1, f = E[0]; f >= 10; f /= 10, N++);
                  for (f = E[0] += n, n = 1; f >= 10; f /= 10, n++);
                  N != n && (w.e++, E[0] == b && (E[0] = 1));
                  break;
                } else {
                  if (((E[l] += n), E[l] != b)) break;
                  (E[l--] = 0), (n = 1);
                }
            for (N = E.length; E[--N] === 0; E.pop());
          }
          w.e > P ? (w.c = w.e = null) : w.e < X && (w.c = [(w.e = 0)]);
        }
        return w;
      }
      function Y(w) {
        var x,
          _ = w.e;
        return _ === null
          ? w.toString()
          : ((x = ct(w.c)),
            (x = _ <= Tt || _ >= _t ? At(x, _) : ot(x, _, "0")),
            w.s < 0 ? "-" + x : x);
      }
      return (
        (C.absoluteValue = C.abs =
          function () {
            var w = new y(this);
            return w.s < 0 && (w.s = 1), w;
          }),
        (C.comparedTo = function (w, x) {
          return mt(this, new y(w, x));
        }),
        (C.decimalPlaces = C.dp =
          function (w, x) {
            var _,
              T,
              S,
              N = this;
            if (w != null)
              return (
                ut(w, 0, M),
                x == null ? (x = ht) : ut(x, 0, 8),
                G(new y(N), w + N.e + 1, x)
              );
            if (!(_ = N.c)) return null;
            if (((T = ((S = _.length - 1) - W(this.e / A)) * A), (S = _[S])))
              for (; S % 10 == 0; S /= 10, T--);
            return T < 0 && (T = 0), T;
          }),
        (C.dividedBy = C.div =
          function (w, x) {
            return J(this, new y(w, x), ft, ht);
          }),
        (C.dividedToIntegerBy = C.idiv =
          function (w, x) {
            return J(this, new y(w, x), 0, 1);
          }),
        (C.exponentiatedBy = C.pow =
          function (w, x) {
            var _,
              T,
              S,
              N,
              f,
              n,
              i,
              l,
              p,
              E = this;
            if (((w = new y(w)), w.c && !w.isInteger()))
              throw Error(g + "Exponent not an integer: " + Y(w));
            if (
              (x != null && (x = new y(x)),
              (n = w.e > 14),
              !E.c ||
                !E.c[0] ||
                (E.c[0] == 1 && !E.e && E.c.length == 1) ||
                !w.c ||
                !w.c[0])
            )
              return (
                (p = new y(Math.pow(+Y(E), n ? w.s * (2 - z(w)) : +Y(w)))),
                x ? p.mod(x) : p
              );
            if (((i = w.s < 0), x)) {
              if (x.c ? !x.c[0] : !x.s) return new y(NaN);
              (T = !i && E.isInteger() && x.isInteger()), T && (E = E.mod(x));
            } else {
              if (
                w.e > 9 &&
                (E.e > 0 ||
                  E.e < -1 ||
                  (E.e == 0
                    ? E.c[0] > 1 || (n && E.c[1] >= 24e7)
                    : E.c[0] < 8e13 || (n && E.c[0] <= 9999975e7)))
              )
                return (
                  (N = E.s < 0 && z(w) ? -0 : 0),
                  E.e > -1 && (N = 1 / N),
                  new y(i ? 1 / N : N)
                );
              Q && (N = u(Q / A + 2));
            }
            for (
              n
                ? ((_ = new y(0.5)), i && (w.s = 1), (l = z(w)))
                : ((S = Math.abs(+Y(w))), (l = S % 2)),
                p = new y(xt);
              ;

            ) {
              if (l) {
                if (((p = p.times(E)), !p.c)) break;
                N ? p.c.length > N && (p.c.length = N) : T && (p = p.mod(x));
              }
              if (S) {
                if (((S = d(S / 2)), S === 0)) break;
                l = S % 2;
              } else if (((w = w.times(_)), G(w, w.e + 1, 1), w.e > 14))
                l = z(w);
              else {
                if (((S = +Y(w)), S === 0)) break;
                l = S % 2;
              }
              (E = E.times(E)),
                N
                  ? E.c && E.c.length > N && (E.c.length = N)
                  : T && (E = E.mod(x));
            }
            return T
              ? p
              : (i && (p = xt.div(p)), x ? p.mod(x) : N ? G(p, Q, ht, f) : p);
          }),
        (C.integerValue = function (w) {
          var x = new y(this);
          return w == null ? (w = ht) : ut(w, 0, 8), G(x, x.e + 1, w);
        }),
        (C.isEqualTo = C.eq =
          function (w, x) {
            return mt(this, new y(w, x)) === 0;
          }),
        (C.isFinite = function () {
          return !!this.c;
        }),
        (C.isGreaterThan = C.gt =
          function (w, x) {
            return mt(this, new y(w, x)) > 0;
          }),
        (C.isGreaterThanOrEqualTo = C.gte =
          function (w, x) {
            return (x = mt(this, new y(w, x))) === 1 || x === 0;
          }),
        (C.isInteger = function () {
          return !!this.c && W(this.e / A) > this.c.length - 2;
        }),
        (C.isLessThan = C.lt =
          function (w, x) {
            return mt(this, new y(w, x)) < 0;
          }),
        (C.isLessThanOrEqualTo = C.lte =
          function (w, x) {
            return (x = mt(this, new y(w, x))) === -1 || x === 0;
          }),
        (C.isNaN = function () {
          return !this.s;
        }),
        (C.isNegative = function () {
          return this.s < 0;
        }),
        (C.isPositive = function () {
          return this.s > 0;
        }),
        (C.isZero = function () {
          return !!this.c && this.c[0] == 0;
        }),
        (C.minus = function (w, x) {
          var _,
            T,
            S,
            N,
            f = this,
            n = f.s;
          if (((w = new y(w, x)), (x = w.s), !n || !x)) return new y(NaN);
          if (n != x) return (w.s = -x), f.plus(w);
          var i = f.e / A,
            l = w.e / A,
            p = f.c,
            E = w.c;
          if (!i || !l) {
            if (!p || !E) return p ? ((w.s = -x), w) : new y(E ? f : NaN);
            if (!p[0] || !E[0])
              return E[0]
                ? ((w.s = -x), w)
                : new y(p[0] ? f : ht == 3 ? -0 : 0);
          }
          if (((i = W(i)), (l = W(l)), (p = p.slice()), (n = i - l))) {
            for (
              (N = n < 0) ? ((n = -n), (S = p)) : ((l = i), (S = E)),
                S.reverse(),
                x = n;
              x--;
              S.push(0)
            );
            S.reverse();
          } else
            for (
              T = (N = (n = p.length) < (x = E.length)) ? n : x, n = x = 0;
              x < T;
              x++
            )
              if (p[x] != E[x]) {
                N = p[x] < E[x];
                break;
              }
          if (
            (N && ((S = p), (p = E), (E = S), (w.s = -w.s)),
            (x = (T = E.length) - (_ = p.length)),
            x > 0)
          )
            for (; x--; p[_++] = 0);
          for (x = b - 1; T > n; ) {
            if (p[--T] < E[T]) {
              for (_ = T; _ && !p[--_]; p[_] = x);
              --p[_], (p[T] += b);
            }
            p[T] -= E[T];
          }
          for (; p[0] == 0; p.splice(0, 1), --l);
          return p[0]
            ? Ut(w, p, l)
            : ((w.s = ht == 3 ? -1 : 1), (w.c = [(w.e = 0)]), w);
        }),
        (C.modulo = C.mod =
          function (w, x) {
            var _,
              T,
              S = this;
            return (
              (w = new y(w, x)),
              !S.c || !w.s || (w.c && !w.c[0])
                ? new y(NaN)
                : !w.c || (S.c && !S.c[0])
                  ? new y(S)
                  : (j == 9
                      ? ((T = w.s),
                        (w.s = 1),
                        (_ = J(S, w, 0, 3)),
                        (w.s = T),
                        (_.s *= T))
                      : (_ = J(S, w, 0, j)),
                    (w = S.minus(_.times(w))),
                    !w.c[0] && j == 1 && (w.s = S.s),
                    w)
            );
          }),
        (C.multipliedBy = C.times =
          function (w, x) {
            var _,
              T,
              S,
              N,
              f,
              n,
              i,
              l,
              p,
              E,
              F,
              D,
              H,
              V,
              rt,
              h = this,
              s = h.c,
              a = (w = new y(w, x)).c;
            if (!s || !a || !s[0] || !a[0])
              return (
                !h.s || !w.s || (s && !s[0] && !a) || (a && !a[0] && !s)
                  ? (w.c = w.e = w.s = null)
                  : ((w.s *= h.s),
                    !s || !a ? (w.c = w.e = null) : ((w.c = [0]), (w.e = 0))),
                w
              );
            for (
              T = W(h.e / A) + W(w.e / A),
                w.s *= h.s,
                i = s.length,
                E = a.length,
                i < E && ((H = s), (s = a), (a = H), (S = i), (i = E), (E = S)),
                S = i + E,
                H = [];
              S--;
              H.push(0)
            );
            for (V = b, rt = O, S = E; --S >= 0; ) {
              for (
                _ = 0, F = a[S] % rt, D = (a[S] / rt) | 0, f = i, N = S + f;
                N > S;

              )
                (l = s[--f] % rt),
                  (p = (s[f] / rt) | 0),
                  (n = D * l + p * F),
                  (l = F * l + (n % rt) * rt + H[N] + _),
                  (_ = ((l / V) | 0) + ((n / rt) | 0) + D * p),
                  (H[N--] = l % V);
              H[N] = _;
            }
            return _ ? ++T : H.splice(0, 1), Ut(w, H, T);
          }),
        (C.negated = function () {
          var w = new y(this);
          return (w.s = -w.s || null), w;
        }),
        (C.plus = function (w, x) {
          var _,
            T = this,
            S = T.s;
          if (((w = new y(w, x)), (x = w.s), !S || !x)) return new y(NaN);
          if (S != x) return (w.s = -x), T.minus(w);
          var N = T.e / A,
            f = w.e / A,
            n = T.c,
            i = w.c;
          if (!N || !f) {
            if (!n || !i) return new y(S / 0);
            if (!n[0] || !i[0]) return i[0] ? w : new y(n[0] ? T : S * 0);
          }
          if (((N = W(N)), (f = W(f)), (n = n.slice()), (S = N - f))) {
            for (
              S > 0 ? ((f = N), (_ = i)) : ((S = -S), (_ = n)), _.reverse();
              S--;
              _.push(0)
            );
            _.reverse();
          }
          for (
            S = n.length,
              x = i.length,
              S - x < 0 && ((_ = i), (i = n), (n = _), (x = S)),
              S = 0;
            x;

          )
            (S = ((n[--x] = n[x] + i[x] + S) / b) | 0),
              (n[x] = b === n[x] ? 0 : n[x] % b);
          return S && ((n = [S].concat(n)), ++f), Ut(w, n, f);
        }),
        (C.precision = C.sd =
          function (w, x) {
            var _,
              T,
              S,
              N = this;
            if (w != null && w !== !!w)
              return (
                ut(w, 1, M),
                x == null ? (x = ht) : ut(x, 0, 8),
                G(new y(N), w, x)
              );
            if (!(_ = N.c)) return null;
            if (((S = _.length - 1), (T = S * A + 1), (S = _[S]))) {
              for (; S % 10 == 0; S /= 10, T--);
              for (S = _[0]; S >= 10; S /= 10, T++);
            }
            return w && N.e + 1 > T && (T = N.e + 1), T;
          }),
        (C.shiftedBy = function (w) {
          return ut(w, -U, U), this.times("1e" + w);
        }),
        (C.squareRoot = C.sqrt =
          function () {
            var w,
              x,
              _,
              T,
              S,
              N = this,
              f = N.c,
              n = N.s,
              i = N.e,
              l = ft + 4,
              p = new y("0.5");
            if (n !== 1 || !f || !f[0])
              return new y(!n || (n < 0 && (!f || f[0])) ? NaN : f ? N : 1 / 0);
            if (
              ((n = Math.sqrt(+Y(N))),
              n == 0 || n == 1 / 0
                ? ((x = ct(f)),
                  (x.length + i) % 2 == 0 && (x += "0"),
                  (n = Math.sqrt(+x)),
                  (i = W((i + 1) / 2) - (i < 0 || i % 2)),
                  n == 1 / 0
                    ? (x = "5e" + i)
                    : ((x = n.toExponential()),
                      (x = x.slice(0, x.indexOf("e") + 1) + i)),
                  (_ = new y(x)))
                : (_ = new y(n + "")),
              _.c[0])
            ) {
              for (i = _.e, n = i + l, n < 3 && (n = 0); ; )
                if (
                  ((S = _),
                  (_ = p.times(S.plus(J(N, S, l, 1)))),
                  ct(S.c).slice(0, n) === (x = ct(_.c)).slice(0, n))
                )
                  if (
                    (_.e < i && --n,
                    (x = x.slice(n - 3, n + 1)),
                    x == "9999" || (!T && x == "4999"))
                  ) {
                    if (!T && (G(S, S.e + ft + 2, 0), S.times(S).eq(N))) {
                      _ = S;
                      break;
                    }
                    (l += 4), (n += 4), (T = 1);
                  } else {
                    (!+x || (!+x.slice(1) && x.charAt(0) == "5")) &&
                      (G(_, _.e + ft + 2, 1), (w = !_.times(_).eq(N)));
                    break;
                  }
            }
            return G(_, _.e + ft + 1, ht, w);
          }),
        (C.toExponential = function (w, x) {
          return w != null && (ut(w, 0, M), w++), dt(this, w, x, 1);
        }),
        (C.toFixed = function (w, x) {
          return (
            w != null && (ut(w, 0, M), (w = w + this.e + 1)), dt(this, w, x)
          );
        }),
        (C.toFormat = function (w, x, _) {
          var T,
            S = this;
          if (_ == null)
            w != null && x && typeof x == "object"
              ? ((_ = x), (x = null))
              : w && typeof w == "object"
                ? ((_ = w), (w = x = null))
                : (_ = k);
          else if (typeof _ != "object")
            throw Error(g + "Argument not an object: " + _);
          if (((T = S.toFixed(w, x)), S.c)) {
            var N,
              f = T.split("."),
              n = +_.groupSize,
              i = +_.secondaryGroupSize,
              l = _.groupSeparator || "",
              p = f[0],
              E = f[1],
              F = S.s < 0,
              D = F ? p.slice(1) : p,
              H = D.length;
            if ((i && ((N = n), (n = i), (i = N), (H -= N)), n > 0 && H > 0)) {
              for (N = H % n || n, p = D.substr(0, N); N < H; N += n)
                p += l + D.substr(N, n);
              i > 0 && (p += l + D.slice(N)), F && (p = "-" + p);
            }
            T = E
              ? p +
                (_.decimalSeparator || "") +
                ((i = +_.fractionGroupSize)
                  ? E.replace(
                      new RegExp("\\d{" + i + "}\\B", "g"),
                      "$&" + (_.fractionGroupSeparator || ""),
                    )
                  : E)
              : p;
          }
          return (_.prefix || "") + T + (_.suffix || "");
        }),
        (C.toFraction = function (w) {
          var x,
            _,
            T,
            S,
            N,
            f,
            n,
            i,
            l,
            p,
            E,
            F,
            D = this,
            H = D.c;
          if (
            w != null &&
            ((n = new y(w)), (!n.isInteger() && (n.c || n.s !== 1)) || n.lt(xt))
          )
            throw Error(
              g +
                "Argument " +
                (n.isInteger() ? "out of range: " : "not an integer: ") +
                Y(n),
            );
          if (!H) return new y(D);
          for (
            x = new y(xt),
              l = _ = new y(xt),
              T = i = new y(xt),
              F = ct(H),
              N = x.e = F.length - D.e - 1,
              x.c[0] = L[(f = N % A) < 0 ? A + f : f],
              w = !w || n.comparedTo(x) > 0 ? (N > 0 ? x : l) : n,
              f = P,
              P = 1 / 0,
              n = new y(F),
              i.c[0] = 0;
            (p = J(n, x, 0, 1)), (S = _.plus(p.times(T))), S.comparedTo(w) != 1;

          )
            (_ = T),
              (T = S),
              (l = i.plus(p.times((S = l)))),
              (i = S),
              (x = n.minus(p.times((S = x)))),
              (n = S);
          return (
            (S = J(w.minus(_), T, 0, 1)),
            (i = i.plus(S.times(l))),
            (_ = _.plus(S.times(T))),
            (i.s = l.s = D.s),
            (N = N * 2),
            (E =
              J(l, T, N, ht)
                .minus(D)
                .abs()
                .comparedTo(J(i, _, N, ht).minus(D).abs()) < 1
                ? [l, T]
                : [i, _]),
            (P = f),
            E
          );
        }),
        (C.toNumber = function () {
          return +Y(this);
        }),
        (C.toPrecision = function (w, x) {
          return w != null && ut(w, 1, M), dt(this, w, x, 2);
        }),
        (C.toString = function (w) {
          var x,
            _ = this,
            T = _.s,
            S = _.e;
          return (
            S === null
              ? T
                ? ((x = "Infinity"), T < 0 && (x = "-" + x))
                : (x = "NaN")
              : (w == null
                  ? (x =
                      S <= Tt || S >= _t ? At(ct(_.c), S) : ot(ct(_.c), S, "0"))
                  : w === 10 && yt
                    ? ((_ = G(new y(_), ft + S + 1, ht)),
                      (x = ot(ct(_.c), _.e, "0")))
                    : (ut(w, 2, K.length, "Base"),
                      (x = nt(ot(ct(_.c), S, "0"), 10, w, T, !0))),
                T < 0 && _.c[0] && (x = "-" + x)),
            x
          );
        }),
        (C.valueOf = C.toJSON =
          function () {
            return Y(this);
          }),
        (C._isBigNumber = !0),
        q != null && y.set(q),
        y
      );
    }
    function W(q) {
      var J = q | 0;
      return q > 0 || q === J ? J : J - 1;
    }
    function ct(q) {
      for (var J, nt, it = 1, C = q.length, xt = q[0] + ""; it < C; ) {
        for (J = q[it++] + "", nt = A - J.length; nt--; J = "0" + J);
        xt += J;
      }
      for (C = xt.length; xt.charCodeAt(--C) === 48; );
      return xt.slice(0, C + 1 || 1);
    }
    function mt(q, J) {
      var nt,
        it,
        C = q.c,
        xt = J.c,
        ft = q.s,
        ht = J.s,
        Tt = q.e,
        _t = J.e;
      if (!ft || !ht) return null;
      if (((nt = C && !C[0]), (it = xt && !xt[0]), nt || it))
        return nt ? (it ? 0 : -ht) : ft;
      if (ft != ht) return ft;
      if (((nt = ft < 0), (it = Tt == _t), !C || !xt))
        return it ? 0 : !C ^ nt ? 1 : -1;
      if (!it) return (Tt > _t) ^ nt ? 1 : -1;
      for (
        ht = (Tt = C.length) < (_t = xt.length) ? Tt : _t, ft = 0;
        ft < ht;
        ft++
      )
        if (C[ft] != xt[ft]) return (C[ft] > xt[ft]) ^ nt ? 1 : -1;
      return Tt == _t ? 0 : (Tt > _t) ^ nt ? 1 : -1;
    }
    function ut(q, J, nt, it) {
      if (q < J || q > nt || q !== d(q))
        throw Error(
          g +
            (it || "Argument") +
            (typeof q == "number"
              ? q < J || q > nt
                ? " out of range: "
                : " not an integer: "
              : " not a primitive number: ") +
            String(q),
        );
    }
    function z(q) {
      var J = q.c.length - 1;
      return W(q.e / A) == J && q.c[J] % 2 != 0;
    }
    function At(q, J) {
      return (
        (q.length > 1 ? q.charAt(0) + "." + q.slice(1) : q) +
        (J < 0 ? "e" : "e+") +
        J
      );
    }
    function ot(q, J, nt) {
      var it, C;
      if (J < 0) {
        for (C = nt + "."; ++J; C += nt);
        q = C + q;
      } else if (((it = q.length), ++J > it)) {
        for (C = nt, J -= it; --J; C += nt);
        q += C;
      } else J < it && (q = q.slice(0, J) + "." + q.slice(J));
      return q;
    }
    (r = Z()),
      (r.default = r.BigNumber = r),
      e.exports
        ? (e.exports = r)
        : (t || (t = typeof self < "u" && self ? self : window),
          (t.BigNumber = r));
  })(Ee);
})(ni);
var nr = ni.exports,
  Vs = function (t, r, o) {
    var u = new t.Uint8Array(o),
      d = r.pushInt,
      g = r.pushInt32,
      c = r.pushInt32Neg,
      b = r.pushInt64,
      A = r.pushInt64Neg,
      U = r.pushFloat,
      L = r.pushFloatSingle,
      O = r.pushFloatDouble,
      M = r.pushTrue,
      Z = r.pushFalse,
      W = r.pushUndefined,
      ct = r.pushNull,
      mt = r.pushInfinity,
      ut = r.pushInfinityNeg,
      z = r.pushNaN,
      At = r.pushNaNNeg,
      ot = r.pushArrayStart,
      q = r.pushArrayStartFixed,
      J = r.pushArrayStartFixed32,
      nt = r.pushArrayStartFixed64,
      it = r.pushObjectStart,
      C = r.pushObjectStartFixed,
      xt = r.pushObjectStartFixed32,
      ft = r.pushObjectStartFixed64,
      ht = r.pushByteString,
      Tt = r.pushByteStringStart,
      _t = r.pushUtf8String,
      X = r.pushUtf8StringStart,
      P = r.pushSimpleUnassigned,
      $ = r.pushTagStart,
      j = r.pushTagStart4,
      Q = r.pushTagStart8,
      k = r.pushTagUnassigned,
      K = r.pushBreak,
      yt = t.Math.pow,
      y = 0,
      dt = 0,
      bt = 0;
    function Ut(I) {
      for (
        I = I | 0, y = 0, dt = I;
        (y | 0) < (dt | 0) &&
        ((bt = fs[u[y] & 255](u[y] | 0) | 0), !((bt | 0) > 0));

      );
      return bt | 0;
    }
    function G(I) {
      return (I = I | 0), (((y | 0) + (I | 0)) | 0) < (dt | 0) ? 0 : 1;
    }
    function Y(I) {
      return (I = I | 0), (u[I | 0] << 8) | u[(I + 1) | 0] | 0;
    }
    function w(I) {
      return (
        (I = I | 0),
        (u[I | 0] << 24) |
          (u[(I + 1) | 0] << 16) |
          (u[(I + 2) | 0] << 8) |
          u[(I + 3) | 0] |
          0
      );
    }
    function x(I) {
      return (I = I | 0), d(I | 0), (y = (y + 1) | 0), 0;
    }
    function _(I) {
      return (
        (I = I | 0),
        G(1) | 0 ? 1 : (d(u[(y + 1) | 0] | 0), (y = (y + 2) | 0), 0)
      );
    }
    function T(I) {
      return (
        (I = I | 0),
        G(2) | 0 ? 1 : (d(Y((y + 1) | 0) | 0), (y = (y + 3) | 0), 0)
      );
    }
    function S(I) {
      return (
        (I = I | 0),
        G(4) | 0
          ? 1
          : (g(Y((y + 1) | 0) | 0, Y((y + 3) | 0) | 0), (y = (y + 5) | 0), 0)
      );
    }
    function N(I) {
      return (
        (I = I | 0),
        G(8) | 0
          ? 1
          : (b(
              Y((y + 1) | 0) | 0,
              Y((y + 3) | 0) | 0,
              Y((y + 5) | 0) | 0,
              Y((y + 7) | 0) | 0,
            ),
            (y = (y + 9) | 0),
            0)
      );
    }
    function f(I) {
      return (I = I | 0), d((-1 - ((I - 32) | 0)) | 0), (y = (y + 1) | 0), 0;
    }
    function n(I) {
      return (
        (I = I | 0),
        G(1) | 0
          ? 1
          : (d((-1 - (u[(y + 1) | 0] | 0)) | 0), (y = (y + 2) | 0), 0)
      );
    }
    function i(I) {
      I = I | 0;
      var wt = 0;
      return G(2) | 0
        ? 1
        : ((wt = Y((y + 1) | 0) | 0),
          d((-1 - (wt | 0)) | 0),
          (y = (y + 3) | 0),
          0);
    }
    function l(I) {
      return (
        (I = I | 0),
        G(4) | 0
          ? 1
          : (c(Y((y + 1) | 0) | 0, Y((y + 3) | 0) | 0), (y = (y + 5) | 0), 0)
      );
    }
    function p(I) {
      return (
        (I = I | 0),
        G(8) | 0
          ? 1
          : (A(
              Y((y + 1) | 0) | 0,
              Y((y + 3) | 0) | 0,
              Y((y + 5) | 0) | 0,
              Y((y + 7) | 0) | 0,
            ),
            (y = (y + 9) | 0),
            0)
      );
    }
    function E(I) {
      I = I | 0;
      var wt = 0,
        gt = 0,
        pt = 0;
      return (
        (pt = (I - 64) | 0),
        G(pt | 0) | 0
          ? 1
          : ((wt = (y + 1) | 0),
            (gt = (((y + 1) | 0) + (pt | 0)) | 0),
            ht(wt | 0, gt | 0),
            (y = gt | 0),
            0)
      );
    }
    function F(I) {
      I = I | 0;
      var wt = 0,
        gt = 0,
        pt = 0;
      return G(1) | 0 ||
        ((pt = u[(y + 1) | 0] | 0),
        (wt = (y + 2) | 0),
        (gt = (((y + 2) | 0) + (pt | 0)) | 0),
        G((pt + 1) | 0) | 0)
        ? 1
        : (ht(wt | 0, gt | 0), (y = gt | 0), 0);
    }
    function D(I) {
      I = I | 0;
      var wt = 0,
        gt = 0,
        pt = 0;
      return G(2) | 0 ||
        ((pt = Y((y + 1) | 0) | 0),
        (wt = (y + 3) | 0),
        (gt = (((y + 3) | 0) + (pt | 0)) | 0),
        G((pt + 2) | 0) | 0)
        ? 1
        : (ht(wt | 0, gt | 0), (y = gt | 0), 0);
    }
    function H(I) {
      I = I | 0;
      var wt = 0,
        gt = 0,
        pt = 0;
      return G(4) | 0 ||
        ((pt = w((y + 1) | 0) | 0),
        (wt = (y + 5) | 0),
        (gt = (((y + 5) | 0) + (pt | 0)) | 0),
        G((pt + 4) | 0) | 0)
        ? 1
        : (ht(wt | 0, gt | 0), (y = gt | 0), 0);
    }
    function V(I) {
      return (I = I | 0), 1;
    }
    function rt(I) {
      return (I = I | 0), Tt(), (y = (y + 1) | 0), 0;
    }
    function h(I) {
      I = I | 0;
      var wt = 0,
        gt = 0,
        pt = 0;
      return (
        (pt = (I - 96) | 0),
        G(pt | 0) | 0
          ? 1
          : ((wt = (y + 1) | 0),
            (gt = (((y + 1) | 0) + (pt | 0)) | 0),
            _t(wt | 0, gt | 0),
            (y = gt | 0),
            0)
      );
    }
    function s(I) {
      I = I | 0;
      var wt = 0,
        gt = 0,
        pt = 0;
      return G(1) | 0 ||
        ((pt = u[(y + 1) | 0] | 0),
        (wt = (y + 2) | 0),
        (gt = (((y + 2) | 0) + (pt | 0)) | 0),
        G((pt + 1) | 0) | 0)
        ? 1
        : (_t(wt | 0, gt | 0), (y = gt | 0), 0);
    }
    function a(I) {
      I = I | 0;
      var wt = 0,
        gt = 0,
        pt = 0;
      return G(2) | 0 ||
        ((pt = Y((y + 1) | 0) | 0),
        (wt = (y + 3) | 0),
        (gt = (((y + 3) | 0) + (pt | 0)) | 0),
        G((pt + 2) | 0) | 0)
        ? 1
        : (_t(wt | 0, gt | 0), (y = gt | 0), 0);
    }
    function m(I) {
      I = I | 0;
      var wt = 0,
        gt = 0,
        pt = 0;
      return G(4) | 0 ||
        ((pt = w((y + 1) | 0) | 0),
        (wt = (y + 5) | 0),
        (gt = (((y + 5) | 0) + (pt | 0)) | 0),
        G((pt + 4) | 0) | 0)
        ? 1
        : (_t(wt | 0, gt | 0), (y = gt | 0), 0);
    }
    function B(I) {
      return (I = I | 0), 1;
    }
    function R(I) {
      return (I = I | 0), X(), (y = (y + 1) | 0), 0;
    }
    function v(I) {
      return (I = I | 0), q((I - 128) | 0), (y = (y + 1) | 0), 0;
    }
    function et(I) {
      return (
        (I = I | 0),
        G(1) | 0 ? 1 : (q(u[(y + 1) | 0] | 0), (y = (y + 2) | 0), 0)
      );
    }
    function lt(I) {
      return (
        (I = I | 0),
        G(2) | 0 ? 1 : (q(Y((y + 1) | 0) | 0), (y = (y + 3) | 0), 0)
      );
    }
    function st(I) {
      return (
        (I = I | 0),
        G(4) | 0
          ? 1
          : (J(Y((y + 1) | 0) | 0, Y((y + 3) | 0) | 0), (y = (y + 5) | 0), 0)
      );
    }
    function tt(I) {
      return (
        (I = I | 0),
        G(8) | 0
          ? 1
          : (nt(
              Y((y + 1) | 0) | 0,
              Y((y + 3) | 0) | 0,
              Y((y + 5) | 0) | 0,
              Y((y + 7) | 0) | 0,
            ),
            (y = (y + 9) | 0),
            0)
      );
    }
    function Et(I) {
      return (I = I | 0), ot(), (y = (y + 1) | 0), 0;
    }
    function Nt(I) {
      I = I | 0;
      var wt = 0;
      return (
        (wt = (I - 160) | 0),
        G(wt | 0) | 0 ? 1 : (C(wt | 0), (y = (y + 1) | 0), 0)
      );
    }
    function Wi(I) {
      return (
        (I = I | 0),
        G(1) | 0 ? 1 : (C(u[(y + 1) | 0] | 0), (y = (y + 2) | 0), 0)
      );
    }
    function Vi(I) {
      return (
        (I = I | 0),
        G(2) | 0 ? 1 : (C(Y((y + 1) | 0) | 0), (y = (y + 3) | 0), 0)
      );
    }
    function qi(I) {
      return (
        (I = I | 0),
        G(4) | 0
          ? 1
          : (xt(Y((y + 1) | 0) | 0, Y((y + 3) | 0) | 0), (y = (y + 5) | 0), 0)
      );
    }
    function Ji(I) {
      return (
        (I = I | 0),
        G(8) | 0
          ? 1
          : (ft(
              Y((y + 1) | 0) | 0,
              Y((y + 3) | 0) | 0,
              Y((y + 5) | 0) | 0,
              Y((y + 7) | 0) | 0,
            ),
            (y = (y + 9) | 0),
            0)
      );
    }
    function Xi(I) {
      return (I = I | 0), it(), (y = (y + 1) | 0), 0;
    }
    function de(I) {
      return (I = I | 0), $((I - 192) | 0 | 0), (y = (y + 1) | 0), 0;
    }
    function G0(I) {
      return (I = I | 0), $(I | 0), (y = (y + 1) | 0), 0;
    }
    function H0(I) {
      return (I = I | 0), $(I | 0), (y = (y + 1) | 0), 0;
    }
    function K0(I) {
      return (I = I | 0), $(I | 0), (y = (y + 1) | 0), 0;
    }
    function z0(I) {
      return (I = I | 0), $(I | 0), (y = (y + 1) | 0), 0;
    }
    function Ot(I) {
      return (I = I | 0), $((I - 192) | 0 | 0), (y = (y + 1) | 0), 0;
    }
    function Y0(I) {
      return (I = I | 0), $(I | 0), (y = (y + 1) | 0), 0;
    }
    function W0(I) {
      return (I = I | 0), $(I | 0), (y = (y + 1) | 0), 0;
    }
    function V0(I) {
      return (I = I | 0), $(I | 0), (y = (y + 1) | 0), 0;
    }
    function ji(I) {
      return (
        (I = I | 0),
        G(1) | 0 ? 1 : ($(u[(y + 1) | 0] | 0), (y = (y + 2) | 0), 0)
      );
    }
    function Zi(I) {
      return (
        (I = I | 0),
        G(2) | 0 ? 1 : ($(Y((y + 1) | 0) | 0), (y = (y + 3) | 0), 0)
      );
    }
    function Qi(I) {
      return (
        (I = I | 0),
        G(4) | 0
          ? 1
          : (j(Y((y + 1) | 0) | 0, Y((y + 3) | 0) | 0), (y = (y + 5) | 0), 0)
      );
    }
    function ts(I) {
      return (
        (I = I | 0),
        G(8) | 0
          ? 1
          : (Q(
              Y((y + 1) | 0) | 0,
              Y((y + 3) | 0) | 0,
              Y((y + 5) | 0) | 0,
              Y((y + 7) | 0) | 0,
            ),
            (y = (y + 9) | 0),
            0)
      );
    }
    function vt(I) {
      return (I = I | 0), P(((I | 0) - 224) | 0), (y = (y + 1) | 0), 0;
    }
    function es(I) {
      return (I = I | 0), Z(), (y = (y + 1) | 0), 0;
    }
    function rs(I) {
      return (I = I | 0), M(), (y = (y + 1) | 0), 0;
    }
    function ns(I) {
      return (I = I | 0), ct(), (y = (y + 1) | 0), 0;
    }
    function is(I) {
      return (I = I | 0), W(), (y = (y + 1) | 0), 0;
    }
    function ss(I) {
      return (
        (I = I | 0),
        G(1) | 0 ? 1 : (P(u[(y + 1) | 0] | 0), (y = (y + 2) | 0), 0)
      );
    }
    function os(I) {
      I = I | 0;
      var wt = 0,
        gt = 0,
        pt = 1,
        Pe = 0,
        Ae = 0,
        q0 = 0;
      return G(2) | 0
        ? 1
        : ((wt = u[(y + 1) | 0] | 0),
          (gt = u[(y + 2) | 0] | 0),
          (wt | 0) & 128 && (pt = -1),
          (Pe = +(((wt | 0) & 124) >> 2)),
          (Ae = +((((wt | 0) & 3) << 8) | gt)),
          +Pe == 0
            ? U(+(+pt * 5960464477539063e-23 * +Ae))
            : +Pe == 31
              ? +pt == 1
                ? +Ae > 0
                  ? z()
                  : mt()
                : +Ae > 0
                  ? At()
                  : ut()
              : U(+(+pt * yt(2, +(+Pe - 25)) * +(1024 + Ae))),
          (y = (y + 3) | 0),
          0);
    }
    function as(I) {
      return (
        (I = I | 0),
        G(4) | 0
          ? 1
          : (L(
              u[(y + 1) | 0] | 0,
              u[(y + 2) | 0] | 0,
              u[(y + 3) | 0] | 0,
              u[(y + 4) | 0] | 0,
            ),
            (y = (y + 5) | 0),
            0)
      );
    }
    function us(I) {
      return (
        (I = I | 0),
        G(8) | 0
          ? 1
          : (O(
              u[(y + 1) | 0] | 0,
              u[(y + 2) | 0] | 0,
              u[(y + 3) | 0] | 0,
              u[(y + 4) | 0] | 0,
              u[(y + 5) | 0] | 0,
              u[(y + 6) | 0] | 0,
              u[(y + 7) | 0] | 0,
              u[(y + 8) | 0] | 0,
            ),
            (y = (y + 9) | 0),
            0)
      );
    }
    function Bt(I) {
      return (I = I | 0), 1;
    }
    function cs(I) {
      return (I = I | 0), K(), (y = (y + 1) | 0), 0;
    }
    var fs = [
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      _,
      T,
      S,
      N,
      Bt,
      Bt,
      Bt,
      Bt,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      n,
      i,
      l,
      p,
      Bt,
      Bt,
      Bt,
      Bt,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      F,
      D,
      H,
      V,
      Bt,
      Bt,
      Bt,
      rt,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      s,
      a,
      m,
      B,
      Bt,
      Bt,
      Bt,
      R,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      et,
      lt,
      st,
      tt,
      Bt,
      Bt,
      Bt,
      Et,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Nt,
      Wi,
      Vi,
      qi,
      Ji,
      Bt,
      Bt,
      Bt,
      Xi,
      de,
      de,
      de,
      de,
      de,
      de,
      Ot,
      Ot,
      Ot,
      Ot,
      Ot,
      Ot,
      Ot,
      Ot,
      Ot,
      Ot,
      Ot,
      Ot,
      Ot,
      Ot,
      Ot,
      Ot,
      Ot,
      Ot,
      ji,
      Zi,
      Qi,
      ts,
      Bt,
      Bt,
      Bt,
      Bt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      vt,
      es,
      rs,
      ns,
      is,
      ss,
      os,
      as,
      us,
      Bt,
      Bt,
      Bt,
      cs,
    ];
    return { parse: Ut };
  },
  ir = {},
  Pt = {};
const Gr = nr.BigNumber;
Pt.MT = {
  POS_INT: 0,
  NEG_INT: 1,
  BYTE_STRING: 2,
  UTF8_STRING: 3,
  ARRAY: 4,
  MAP: 5,
  TAG: 6,
  SIMPLE_FLOAT: 7,
};
Pt.TAG = {
  DATE_STRING: 0,
  DATE_EPOCH: 1,
  POS_BIGINT: 2,
  NEG_BIGINT: 3,
  DECIMAL_FRAC: 4,
  BIGFLOAT: 5,
  BASE64URL_EXPECTED: 21,
  BASE64_EXPECTED: 22,
  BASE16_EXPECTED: 23,
  CBOR: 24,
  URI: 32,
  BASE64URL: 33,
  BASE64: 34,
  REGEXP: 35,
  MIME: 36,
};
Pt.NUMBYTES = {
  ZERO: 0,
  ONE: 24,
  TWO: 25,
  FOUR: 26,
  EIGHT: 27,
  INDEFINITE: 31,
};
Pt.SIMPLE = { FALSE: 20, TRUE: 21, NULL: 22, UNDEFINED: 23 };
Pt.SYMS = {
  NULL: Symbol("null"),
  UNDEFINED: Symbol("undef"),
  PARENT: Symbol("parent"),
  BREAK: Symbol("break"),
  STREAM: Symbol("stream"),
};
Pt.SHIFT32 = Math.pow(2, 32);
Pt.SHIFT16 = Math.pow(2, 16);
Pt.MAX_SAFE_HIGH = 2097151;
Pt.NEG_ONE = new Gr(-1);
Pt.TEN = new Gr(10);
Pt.TWO = new Gr(2);
Pt.PARENT = {
  ARRAY: 0,
  OBJECT: 1,
  MAP: 2,
  TAG: 3,
  BYTE_STRING: 4,
  UTF8_STRING: 5,
};
(function (e) {
  const { Buffer: t } = Oe,
    r = nr.BigNumber,
    o = Pt,
    u = o.SHIFT32,
    d = o.SHIFT16,
    g = 2097151;
  e.parseHalf = function (A) {
    var U, L, O;
    return (
      (O = A[0] & 128 ? -1 : 1),
      (U = (A[0] & 124) >> 2),
      (L = ((A[0] & 3) << 8) | A[1]),
      U
        ? U === 31
          ? O * (L ? NaN : 1 / 0)
          : O * Math.pow(2, U - 25) * (1024 + L)
        : O * 5960464477539063e-23 * L
    );
  };
  function c(b) {
    return b < 16 ? "0" + b.toString(16) : b.toString(16);
  }
  (e.arrayBufferToBignumber = function (b) {
    const A = b.byteLength;
    let U = "";
    for (let L = 0; L < A; L++) U += c(b[L]);
    return new r(U, 16);
  }),
    (e.buildMap = (b) => {
      const A = new Map(),
        U = Object.keys(b),
        L = U.length;
      for (let O = 0; O < L; O++) A.set(U[O], b[U[O]]);
      return A;
    }),
    (e.buildInt32 = (b, A) => b * d + A),
    (e.buildInt64 = (b, A, U, L) => {
      const O = e.buildInt32(b, A),
        M = e.buildInt32(U, L);
      return O > g ? new r(O).times(u).plus(M) : O * u + M;
    }),
    (e.writeHalf = function (A, U) {
      const L = t.allocUnsafe(4);
      L.writeFloatBE(U, 0);
      const O = L.readUInt32BE(0);
      if (O & 8191) return !1;
      var M = (O >> 16) & 32768;
      const Z = (O >> 23) & 255,
        W = O & 8388607;
      if (Z >= 113 && Z <= 142) M += ((Z - 112) << 10) + (W >> 13);
      else if (Z >= 103 && Z < 113) {
        if (W & ((1 << (126 - Z)) - 1)) return !1;
        M += (W + 8388608) >> (126 - Z);
      } else return !1;
      return A.writeUInt16BE(M, 0), !0;
    }),
    (e.keySorter = function (b, A) {
      var U = b[0].byteLength,
        L = A[0].byteLength;
      return U > L ? 1 : L > U ? -1 : b[0].compare(A[0]);
    }),
    (e.isNegativeZero = (b) => b === 0 && 1 / b < 0),
    (e.nextPowerOf2 = (b) => {
      let A = 0;
      if (b && !(b & (b - 1))) return b;
      for (; b !== 0; ) (b >>= 1), (A += 1);
      return 1 << A;
    });
})(ir);
const Hr = Pt,
  qs = Hr.MT,
  Ce = Hr.SIMPLE,
  cr = Hr.SYMS;
let Js = class Br {
  constructor(t) {
    if (typeof t != "number")
      throw new Error("Invalid Simple type: " + typeof t);
    if (t < 0 || t > 255 || (t | 0) !== t)
      throw new Error("value must be a small positive integer: " + t);
    this.value = t;
  }
  toString() {
    return "simple(" + this.value + ")";
  }
  inspect() {
    return "simple(" + this.value + ")";
  }
  encodeCBOR(t) {
    return t._pushInt(this.value, qs.SIMPLE_FLOAT);
  }
  static isSimple(t) {
    return t instanceof Br;
  }
  static decode(t, r) {
    switch ((r == null && (r = !0), t)) {
      case Ce.FALSE:
        return !1;
      case Ce.TRUE:
        return !0;
      case Ce.NULL:
        return r ? null : cr.NULL;
      case Ce.UNDEFINED:
        return r ? void 0 : cr.UNDEFINED;
      case -1:
        if (!r) throw new Error("Invalid BREAK");
        return cr.BREAK;
      default:
        return new Br(t);
    }
  }
};
var ii = Js;
let Xs = class Sr {
  constructor(t, r, o) {
    if (
      ((this.tag = t),
      (this.value = r),
      (this.err = o),
      typeof this.tag != "number")
    )
      throw new Error("Invalid tag type (" + typeof this.tag + ")");
    if (this.tag < 0 || (this.tag | 0) !== this.tag)
      throw new Error("Tag must be a positive integer: " + this.tag);
  }
  toString() {
    return `${this.tag}(${JSON.stringify(this.value)})`;
  }
  encodeCBOR(t) {
    return t._pushTag(this.tag), t.pushAny(this.value);
  }
  convert(t) {
    var r, o;
    if (
      ((o = t?.[this.tag]),
      typeof o != "function" &&
        ((o = Sr["_tag" + this.tag]), typeof o != "function"))
    )
      return this;
    try {
      return o.call(Sr, this.value);
    } catch (u) {
      return (r = u), (this.err = r), this;
    }
  }
};
var si = Xs;
const oi = self.location
    ? self.location.protocol + "//" + self.location.host
    : "",
  Tr = self.URL;
let js = class {
  constructor(t = "", r = oi) {
    (this.super = new Tr(t, r)),
      (this.path = this.pathname + this.search),
      (this.auth =
        this.username && this.password
          ? this.username + ":" + this.password
          : null),
      (this.query =
        this.search && this.search.startsWith("?")
          ? this.search.slice(1)
          : null);
  }
  get hash() {
    return this.super.hash;
  }
  get host() {
    return this.super.host;
  }
  get hostname() {
    return this.super.hostname;
  }
  get href() {
    return this.super.href;
  }
  get origin() {
    return this.super.origin;
  }
  get password() {
    return this.super.password;
  }
  get pathname() {
    return this.super.pathname;
  }
  get port() {
    return this.super.port;
  }
  get protocol() {
    return this.super.protocol;
  }
  get search() {
    return this.super.search;
  }
  get searchParams() {
    return this.super.searchParams;
  }
  get username() {
    return this.super.username;
  }
  set hash(t) {
    this.super.hash = t;
  }
  set host(t) {
    this.super.host = t;
  }
  set hostname(t) {
    this.super.hostname = t;
  }
  set href(t) {
    this.super.href = t;
  }
  set origin(t) {
    this.super.origin = t;
  }
  set password(t) {
    this.super.password = t;
  }
  set pathname(t) {
    this.super.pathname = t;
  }
  set port(t) {
    this.super.port = t;
  }
  set protocol(t) {
    this.super.protocol = t;
  }
  set search(t) {
    this.super.search = t;
  }
  set searchParams(t) {
    this.super.searchParams = t;
  }
  set username(t) {
    this.super.username = t;
  }
  createObjectURL(t) {
    return this.super.createObjectURL(t);
  }
  revokeObjectURL(t) {
    this.super.revokeObjectURL(t);
  }
  toJSON() {
    return this.super.toJSON();
  }
  toString() {
    return this.super.toString();
  }
  format() {
    return this.toString();
  }
};
function Zs(e) {
  if (typeof e == "string") return new Tr(e).toString();
  if (!(e instanceof Tr)) {
    const t = e.username && e.password ? `${e.username}:${e.password}@` : "",
      r = e.auth ? e.auth + "@" : "",
      o = e.port ? ":" + e.port : "",
      u = e.protocol ? e.protocol + "//" : "",
      d = e.host || "",
      g = e.hostname || "",
      c = e.search || (e.query ? "?" + e.query : ""),
      b = e.hash || "",
      A = e.pathname || "",
      U = e.path || A + c;
    return `${u}${t || r}${d || g + o}${U}${b}`;
  }
}
var ai = {
  URLWithLegacySupport: js,
  URLSearchParams: self.URLSearchParams,
  defaultBase: oi,
  format: Zs,
};
const { URLWithLegacySupport: hn, format: Qs } = ai;
var to = (e, t = {}, r = {}, o) => {
  let u = t.protocol ? t.protocol.replace(":", "") : "http";
  u = (r[u] || o || u) + ":";
  let d;
  try {
    d = new hn(e);
  } catch {
    d = {};
  }
  const g = Object.assign({}, t, {
    protocol: u || d.protocol,
    host: t.host || d.host,
  });
  return new hn(e, Qs(g)).toString();
};
const {
    URLWithLegacySupport: eo,
    format: ro,
    URLSearchParams: no,
    defaultBase: io,
  } = ai,
  so = to;
var ui = {
  URL: eo,
  URLSearchParams: no,
  format: ro,
  relative: so,
  defaultBase: io,
};
const { Buffer: ye } = Oe,
  ln = Re,
  oo = nr.BigNumber,
  ao = Vs,
  Mt = ir,
  It = Pt,
  uo = ii,
  co = si,
  { URL: fo } = ui;
let Ur = class Nr {
  constructor(t) {
    (t = t || {}),
      !t.size || t.size < 65536
        ? (t.size = 65536)
        : (t.size = Mt.nextPowerOf2(t.size)),
      (this._heap = new ArrayBuffer(t.size)),
      (this._heap8 = new Uint8Array(this._heap)),
      (this._buffer = ye.from(this._heap)),
      this._reset(),
      (this._knownTags = Object.assign(
        {
          0: (r) => new Date(r),
          1: (r) => new Date(r * 1e3),
          2: (r) => Mt.arrayBufferToBignumber(r),
          3: (r) => It.NEG_ONE.minus(Mt.arrayBufferToBignumber(r)),
          4: (r) => It.TEN.pow(r[0]).times(r[1]),
          5: (r) => It.TWO.pow(r[0]).times(r[1]),
          32: (r) => new fo(r),
          35: (r) => new RegExp(r),
        },
        t.tags,
      )),
      (this.parser = ao(
        Ee,
        {
          log: console.log.bind(console),
          pushInt: this.pushInt.bind(this),
          pushInt32: this.pushInt32.bind(this),
          pushInt32Neg: this.pushInt32Neg.bind(this),
          pushInt64: this.pushInt64.bind(this),
          pushInt64Neg: this.pushInt64Neg.bind(this),
          pushFloat: this.pushFloat.bind(this),
          pushFloatSingle: this.pushFloatSingle.bind(this),
          pushFloatDouble: this.pushFloatDouble.bind(this),
          pushTrue: this.pushTrue.bind(this),
          pushFalse: this.pushFalse.bind(this),
          pushUndefined: this.pushUndefined.bind(this),
          pushNull: this.pushNull.bind(this),
          pushInfinity: this.pushInfinity.bind(this),
          pushInfinityNeg: this.pushInfinityNeg.bind(this),
          pushNaN: this.pushNaN.bind(this),
          pushNaNNeg: this.pushNaNNeg.bind(this),
          pushArrayStart: this.pushArrayStart.bind(this),
          pushArrayStartFixed: this.pushArrayStartFixed.bind(this),
          pushArrayStartFixed32: this.pushArrayStartFixed32.bind(this),
          pushArrayStartFixed64: this.pushArrayStartFixed64.bind(this),
          pushObjectStart: this.pushObjectStart.bind(this),
          pushObjectStartFixed: this.pushObjectStartFixed.bind(this),
          pushObjectStartFixed32: this.pushObjectStartFixed32.bind(this),
          pushObjectStartFixed64: this.pushObjectStartFixed64.bind(this),
          pushByteString: this.pushByteString.bind(this),
          pushByteStringStart: this.pushByteStringStart.bind(this),
          pushUtf8String: this.pushUtf8String.bind(this),
          pushUtf8StringStart: this.pushUtf8StringStart.bind(this),
          pushSimpleUnassigned: this.pushSimpleUnassigned.bind(this),
          pushTagUnassigned: this.pushTagUnassigned.bind(this),
          pushTagStart: this.pushTagStart.bind(this),
          pushTagStart4: this.pushTagStart4.bind(this),
          pushTagStart8: this.pushTagStart8.bind(this),
          pushBreak: this.pushBreak.bind(this),
        },
        this._heap,
      ));
  }
  get _depth() {
    return this._parents.length;
  }
  get _currentParent() {
    return this._parents[this._depth - 1];
  }
  get _ref() {
    return this._currentParent.ref;
  }
  _closeParent() {
    var t = this._parents.pop();
    if (t.length > 0) throw new Error(`Missing ${t.length} elements`);
    switch (t.type) {
      case It.PARENT.TAG:
        this._push(this.createTag(t.ref[0], t.ref[1]));
        break;
      case It.PARENT.BYTE_STRING:
        this._push(this.createByteString(t.ref, t.length));
        break;
      case It.PARENT.UTF8_STRING:
        this._push(this.createUtf8String(t.ref, t.length));
        break;
      case It.PARENT.MAP:
        if (t.values % 2 > 0)
          throw new Error("Odd number of elements in the map");
        this._push(this.createMap(t.ref, t.length));
        break;
      case It.PARENT.OBJECT:
        if (t.values % 2 > 0)
          throw new Error("Odd number of elements in the map");
        this._push(this.createObject(t.ref, t.length));
        break;
      case It.PARENT.ARRAY:
        this._push(this.createArray(t.ref, t.length));
        break;
    }
    this._currentParent &&
      this._currentParent.type === It.PARENT.TAG &&
      this._dec();
  }
  _dec() {
    const t = this._currentParent;
    t.length < 0 || (t.length--, t.length === 0 && this._closeParent());
  }
  _push(t, r) {
    const o = this._currentParent;
    switch ((o.values++, o.type)) {
      case It.PARENT.ARRAY:
      case It.PARENT.BYTE_STRING:
      case It.PARENT.UTF8_STRING:
        o.length > -1
          ? (this._ref[this._ref.length - o.length] = t)
          : this._ref.push(t),
          this._dec();
        break;
      case It.PARENT.OBJECT:
        o.tmpKey != null
          ? ((this._ref[o.tmpKey] = t), (o.tmpKey = null), this._dec())
          : ((o.tmpKey = t),
            typeof o.tmpKey != "string" &&
              ((o.type = It.PARENT.MAP), (o.ref = Mt.buildMap(o.ref))));
        break;
      case It.PARENT.MAP:
        o.tmpKey != null
          ? (this._ref.set(o.tmpKey, t), (o.tmpKey = null), this._dec())
          : (o.tmpKey = t);
        break;
      case It.PARENT.TAG:
        this._ref.push(t), r || this._dec();
        break;
      default:
        throw new Error("Unknown parent type");
    }
  }
  _createParent(t, r, o) {
    this._parents[this._depth] = {
      type: r,
      length: o,
      ref: t,
      values: 0,
      tmpKey: null,
    };
  }
  _reset() {
    (this._res = []),
      (this._parents = [
        {
          type: It.PARENT.ARRAY,
          length: -1,
          ref: this._res,
          values: 0,
          tmpKey: null,
        },
      ]);
  }
  createTag(t, r) {
    const o = this._knownTags[t];
    return o ? o(r) : new co(t, r);
  }
  createMap(t, r) {
    return t;
  }
  createObject(t, r) {
    return t;
  }
  createArray(t, r) {
    return t;
  }
  createByteString(t, r) {
    return ye.concat(t);
  }
  createByteStringFromHeap(t, r) {
    return t === r ? ye.alloc(0) : ye.from(this._heap.slice(t, r));
  }
  createInt(t) {
    return t;
  }
  createInt32(t, r) {
    return Mt.buildInt32(t, r);
  }
  createInt64(t, r, o, u) {
    return Mt.buildInt64(t, r, o, u);
  }
  createFloat(t) {
    return t;
  }
  createFloatSingle(t, r, o, u) {
    return ln.read([t, r, o, u], 0, !1, 23, 4);
  }
  createFloatDouble(t, r, o, u, d, g, c, b) {
    return ln.read([t, r, o, u, d, g, c, b], 0, !1, 52, 8);
  }
  createInt32Neg(t, r) {
    return -1 - Mt.buildInt32(t, r);
  }
  createInt64Neg(t, r, o, u) {
    const d = Mt.buildInt32(t, r),
      g = Mt.buildInt32(o, u);
    return d > It.MAX_SAFE_HIGH
      ? It.NEG_ONE.minus(new oo(d).times(It.SHIFT32).plus(g))
      : -1 - (d * It.SHIFT32 + g);
  }
  createTrue() {
    return !0;
  }
  createFalse() {
    return !1;
  }
  createNull() {
    return null;
  }
  createUndefined() {}
  createInfinity() {
    return 1 / 0;
  }
  createInfinityNeg() {
    return -1 / 0;
  }
  createNaN() {
    return NaN;
  }
  createNaNNeg() {
    return NaN;
  }
  createUtf8String(t, r) {
    return t.join("");
  }
  createUtf8StringFromHeap(t, r) {
    return t === r ? "" : this._buffer.toString("utf8", t, r);
  }
  createSimpleUnassigned(t) {
    return new uo(t);
  }
  pushInt(t) {
    this._push(this.createInt(t));
  }
  pushInt32(t, r) {
    this._push(this.createInt32(t, r));
  }
  pushInt64(t, r, o, u) {
    this._push(this.createInt64(t, r, o, u));
  }
  pushFloat(t) {
    this._push(this.createFloat(t));
  }
  pushFloatSingle(t, r, o, u) {
    this._push(this.createFloatSingle(t, r, o, u));
  }
  pushFloatDouble(t, r, o, u, d, g, c, b) {
    this._push(this.createFloatDouble(t, r, o, u, d, g, c, b));
  }
  pushInt32Neg(t, r) {
    this._push(this.createInt32Neg(t, r));
  }
  pushInt64Neg(t, r, o, u) {
    this._push(this.createInt64Neg(t, r, o, u));
  }
  pushTrue() {
    this._push(this.createTrue());
  }
  pushFalse() {
    this._push(this.createFalse());
  }
  pushNull() {
    this._push(this.createNull());
  }
  pushUndefined() {
    this._push(this.createUndefined());
  }
  pushInfinity() {
    this._push(this.createInfinity());
  }
  pushInfinityNeg() {
    this._push(this.createInfinityNeg());
  }
  pushNaN() {
    this._push(this.createNaN());
  }
  pushNaNNeg() {
    this._push(this.createNaNNeg());
  }
  pushArrayStart() {
    this._createParent([], It.PARENT.ARRAY, -1);
  }
  pushArrayStartFixed(t) {
    this._createArrayStartFixed(t);
  }
  pushArrayStartFixed32(t, r) {
    const o = Mt.buildInt32(t, r);
    this._createArrayStartFixed(o);
  }
  pushArrayStartFixed64(t, r, o, u) {
    const d = Mt.buildInt64(t, r, o, u);
    this._createArrayStartFixed(d);
  }
  pushObjectStart() {
    this._createObjectStartFixed(-1);
  }
  pushObjectStartFixed(t) {
    this._createObjectStartFixed(t);
  }
  pushObjectStartFixed32(t, r) {
    const o = Mt.buildInt32(t, r);
    this._createObjectStartFixed(o);
  }
  pushObjectStartFixed64(t, r, o, u) {
    const d = Mt.buildInt64(t, r, o, u);
    this._createObjectStartFixed(d);
  }
  pushByteStringStart() {
    this._parents[this._depth] = {
      type: It.PARENT.BYTE_STRING,
      length: -1,
      ref: [],
      values: 0,
      tmpKey: null,
    };
  }
  pushByteString(t, r) {
    this._push(this.createByteStringFromHeap(t, r));
  }
  pushUtf8StringStart() {
    this._parents[this._depth] = {
      type: It.PARENT.UTF8_STRING,
      length: -1,
      ref: [],
      values: 0,
      tmpKey: null,
    };
  }
  pushUtf8String(t, r) {
    this._push(this.createUtf8StringFromHeap(t, r));
  }
  pushSimpleUnassigned(t) {
    this._push(this.createSimpleUnassigned(t));
  }
  pushTagStart(t) {
    this._parents[this._depth] = { type: It.PARENT.TAG, length: 1, ref: [t] };
  }
  pushTagStart4(t, r) {
    this.pushTagStart(Mt.buildInt32(t, r));
  }
  pushTagStart8(t, r, o, u) {
    this.pushTagStart(Mt.buildInt64(t, r, o, u));
  }
  pushTagUnassigned(t) {
    this._push(this.createTag(t));
  }
  pushBreak() {
    if (this._currentParent.length > -1) throw new Error("Unexpected break");
    this._closeParent();
  }
  _createObjectStartFixed(t) {
    if (t === 0) {
      this._push(this.createObject({}));
      return;
    }
    this._createParent({}, It.PARENT.OBJECT, t);
  }
  _createArrayStartFixed(t) {
    if (t === 0) {
      this._push(this.createArray([]));
      return;
    }
    this._createParent(new Array(t), It.PARENT.ARRAY, t);
  }
  _decode(t) {
    if (t.byteLength === 0) throw new Error("Input too short");
    this._reset(), this._heap8.set(t);
    const r = this.parser.parse(t.byteLength);
    if (this._depth > 1) {
      for (; this._currentParent.length === 0; ) this._closeParent();
      if (this._depth > 1) throw new Error("Undeterminated nesting");
    }
    if (r > 0) throw new Error("Failed to parse");
    if (this._res.length === 0) throw new Error("No valid result");
  }
  decodeFirst(t) {
    return this._decode(t), this._res[0];
  }
  decodeAll(t) {
    return this._decode(t), this._res;
  }
  static decode(t, r) {
    return (
      typeof t == "string" && (t = ye.from(t, r || "hex")),
      new Nr({ size: t.length }).decodeFirst(t)
    );
  }
  static decodeAll(t, r) {
    return (
      typeof t == "string" && (t = ye.from(t, r || "hex")),
      new Nr({ size: t.length }).decodeAll(t)
    );
  }
};
Ur.decodeFirst = Ur.decode;
var ci = Ur;
const { Buffer: fr } = Oe,
  ho = ci,
  lo = ir;
class Kr extends ho {
  createTag(t, r) {
    return `${t}(${r})`;
  }
  createInt(t) {
    return super.createInt(t).toString();
  }
  createInt32(t, r) {
    return super.createInt32(t, r).toString();
  }
  createInt64(t, r, o, u) {
    return super.createInt64(t, r, o, u).toString();
  }
  createInt32Neg(t, r) {
    return super.createInt32Neg(t, r).toString();
  }
  createInt64Neg(t, r, o, u) {
    return super.createInt64Neg(t, r, o, u).toString();
  }
  createTrue() {
    return "true";
  }
  createFalse() {
    return "false";
  }
  createFloat(t) {
    const r = super.createFloat(t);
    return lo.isNegativeZero(t) ? "-0_1" : `${r}_1`;
  }
  createFloatSingle(t, r, o, u) {
    return `${super.createFloatSingle(t, r, o, u)}_2`;
  }
  createFloatDouble(t, r, o, u, d, g, c, b) {
    return `${super.createFloatDouble(t, r, o, u, d, g, c, b)}_3`;
  }
  createByteString(t, r) {
    const o = t.join(", ");
    return r === -1 ? `(_ ${o})` : `h'${o}`;
  }
  createByteStringFromHeap(t, r) {
    return `h'${fr.from(super.createByteStringFromHeap(t, r)).toString("hex")}'`;
  }
  createInfinity() {
    return "Infinity_1";
  }
  createInfinityNeg() {
    return "-Infinity_1";
  }
  createNaN() {
    return "NaN_1";
  }
  createNaNNeg() {
    return "-NaN_1";
  }
  createNull() {
    return "null";
  }
  createUndefined() {
    return "undefined";
  }
  createSimpleUnassigned(t) {
    return `simple(${t})`;
  }
  createArray(t, r) {
    const o = super.createArray(t, r);
    return r === -1 ? `[_ ${o.join(", ")}]` : `[${o.join(", ")}]`;
  }
  createMap(t, r) {
    const o = super.createMap(t),
      u = Array.from(o.keys()).reduce(dn(o), "");
    return r === -1 ? `{_ ${u}}` : `{${u}}`;
  }
  createObject(t, r) {
    const o = super.createObject(t),
      u = Object.keys(o).reduce(dn(o), "");
    return r === -1 ? `{_ ${u}}` : `{${u}}`;
  }
  createUtf8String(t, r) {
    const o = t.join(", ");
    return r === -1 ? `(_ ${o})` : `"${o}"`;
  }
  createUtf8StringFromHeap(t, r) {
    return `"${fr.from(super.createUtf8StringFromHeap(t, r)).toString("utf8")}"`;
  }
  static diagnose(t, r) {
    return (
      typeof t == "string" && (t = fr.from(t, r || "hex")),
      new Kr().decodeFirst(t)
    );
  }
}
var po = Kr;
function dn(e) {
  return (t, r) => (t ? `${t}, ${r}: ${e[r]}` : `${r}: ${e[r]}`);
}
const { Buffer: Vt } = Oe,
  { URL: wo } = ui,
  Fr = nr.BigNumber,
  hr = ir,
  Lt = Pt,
  Gt = Lt.MT,
  $e = Lt.NUMBYTES,
  pn = Lt.SHIFT32,
  wn = Lt.SYMS,
  ge = Lt.TAG,
  yo = (Lt.MT.SIMPLE_FLOAT << 5) | Lt.NUMBYTES.TWO,
  go = (Lt.MT.SIMPLE_FLOAT << 5) | Lt.NUMBYTES.FOUR,
  xo = (Lt.MT.SIMPLE_FLOAT << 5) | Lt.NUMBYTES.EIGHT,
  mo = (Lt.MT.SIMPLE_FLOAT << 5) | Lt.SIMPLE.TRUE,
  bo = (Lt.MT.SIMPLE_FLOAT << 5) | Lt.SIMPLE.FALSE,
  Eo = (Lt.MT.SIMPLE_FLOAT << 5) | Lt.SIMPLE.UNDEFINED,
  yn = (Lt.MT.SIMPLE_FLOAT << 5) | Lt.SIMPLE.NULL,
  _o = new Fr("0x20000000000000"),
  Io = Vt.from("f97e00", "hex"),
  Ao = Vt.from("f9fc00", "hex"),
  Bo = Vt.from("f97c00", "hex");
function So(e) {
  return {}.toString.call(e).slice(8, -1);
}
class Xe {
  constructor(t) {
    (t = t || {}),
      (this.streaming = typeof t.stream == "function"),
      (this.onData = t.stream),
      (this.semanticTypes = [
        [wo, this._pushUrl],
        [Fr, this._pushBigNumber],
      ]);
    const r = t.genTypes || [],
      o = r.length;
    for (let u = 0; u < o; u++) this.addSemanticType(r[u][0], r[u][1]);
    this._reset();
  }
  addSemanticType(t, r) {
    const o = this.semanticTypes.length;
    for (let u = 0; u < o; u++)
      if (this.semanticTypes[u][0] === t) {
        const g = this.semanticTypes[u][1];
        return (this.semanticTypes[u][1] = r), g;
      }
    return this.semanticTypes.push([t, r]), null;
  }
  push(t) {
    return (
      t &&
        ((this.result[this.offset] = t),
        (this.resultMethod[this.offset] = 0),
        (this.resultLength[this.offset] = t.length),
        this.offset++,
        this.streaming && this.onData(this.finalize())),
      !0
    );
  }
  pushWrite(t, r, o) {
    return (
      (this.result[this.offset] = t),
      (this.resultMethod[this.offset] = r),
      (this.resultLength[this.offset] = o),
      this.offset++,
      this.streaming && this.onData(this.finalize()),
      !0
    );
  }
  _pushUInt8(t) {
    return this.pushWrite(t, 1, 1);
  }
  _pushUInt16BE(t) {
    return this.pushWrite(t, 2, 2);
  }
  _pushUInt32BE(t) {
    return this.pushWrite(t, 3, 4);
  }
  _pushDoubleBE(t) {
    return this.pushWrite(t, 4, 8);
  }
  _pushNaN() {
    return this.push(Io);
  }
  _pushInfinity(t) {
    const r = t < 0 ? Ao : Bo;
    return this.push(r);
  }
  _pushFloat(t) {
    const r = Vt.allocUnsafe(2);
    if (hr.writeHalf(r, t) && hr.parseHalf(r) === t)
      return this._pushUInt8(yo) && this.push(r);
    const o = Vt.allocUnsafe(4);
    return (
      o.writeFloatBE(t, 0),
      o.readFloatBE(0) === t
        ? this._pushUInt8(go) && this.push(o)
        : this._pushUInt8(xo) && this._pushDoubleBE(t)
    );
  }
  _pushInt(t, r, o) {
    const u = r << 5;
    return t < 24
      ? this._pushUInt8(u | t)
      : t <= 255
        ? this._pushUInt8(u | $e.ONE) && this._pushUInt8(t)
        : t <= 65535
          ? this._pushUInt8(u | $e.TWO) && this._pushUInt16BE(t)
          : t <= 4294967295
            ? this._pushUInt8(u | $e.FOUR) && this._pushUInt32BE(t)
            : t <= Number.MAX_SAFE_INTEGER
              ? this._pushUInt8(u | $e.EIGHT) &&
                this._pushUInt32BE(Math.floor(t / pn)) &&
                this._pushUInt32BE(t % pn)
              : r === Gt.NEG_INT
                ? this._pushFloat(o)
                : this._pushFloat(t);
  }
  _pushIntNum(t) {
    return t < 0
      ? this._pushInt(-t - 1, Gt.NEG_INT, t)
      : this._pushInt(t, Gt.POS_INT);
  }
  _pushNumber(t) {
    switch (!1) {
      case t === t:
        return this._pushNaN(t);
      case isFinite(t):
        return this._pushInfinity(t);
      case t % 1 !== 0:
        return this._pushIntNum(t);
      default:
        return this._pushFloat(t);
    }
  }
  _pushString(t) {
    const r = Vt.byteLength(t, "utf8");
    return this._pushInt(r, Gt.UTF8_STRING) && this.pushWrite(t, 5, r);
  }
  _pushBoolean(t) {
    return this._pushUInt8(t ? mo : bo);
  }
  _pushUndefined(t) {
    return this._pushUInt8(Eo);
  }
  _pushArray(t, r) {
    const o = r.length;
    if (!t._pushInt(o, Gt.ARRAY)) return !1;
    for (let u = 0; u < o; u++) if (!t.pushAny(r[u])) return !1;
    return !0;
  }
  _pushTag(t) {
    return this._pushInt(t, Gt.TAG);
  }
  _pushDate(t, r) {
    return t._pushTag(ge.DATE_EPOCH) && t.pushAny(Math.round(r / 1e3));
  }
  _pushBuffer(t, r) {
    return t._pushInt(r.length, Gt.BYTE_STRING) && t.push(r);
  }
  _pushNoFilter(t, r) {
    return t._pushBuffer(t, r.slice());
  }
  _pushRegexp(t, r) {
    return t._pushTag(ge.REGEXP) && t.pushAny(r.source);
  }
  _pushSet(t, r) {
    if (!t._pushInt(r.size, Gt.ARRAY)) return !1;
    for (const o of r) if (!t.pushAny(o)) return !1;
    return !0;
  }
  _pushUrl(t, r) {
    return t._pushTag(ge.URI) && t.pushAny(r.format());
  }
  _pushBigint(t) {
    let r = ge.POS_BIGINT;
    t.isNegative() && ((t = t.negated().minus(1)), (r = ge.NEG_BIGINT));
    let o = t.toString(16);
    o.length % 2 && (o = "0" + o);
    const u = Vt.from(o, "hex");
    return this._pushTag(r) && this._pushBuffer(this, u);
  }
  _pushBigNumber(t, r) {
    if (r.isNaN()) return t._pushNaN();
    if (!r.isFinite()) return t._pushInfinity(r.isNegative() ? -1 / 0 : 1 / 0);
    if (r.isInteger()) return t._pushBigint(r);
    if (!(t._pushTag(ge.DECIMAL_FRAC) && t._pushInt(2, Gt.ARRAY))) return !1;
    const o = r.decimalPlaces(),
      u = r.multipliedBy(new Fr(10).pow(o));
    return t._pushIntNum(-o)
      ? u.abs().isLessThan(_o)
        ? t._pushIntNum(u.toNumber())
        : t._pushBigint(u)
      : !1;
  }
  _pushMap(t, r) {
    return t._pushInt(r.size, Gt.MAP)
      ? this._pushRawMap(r.size, Array.from(r))
      : !1;
  }
  _pushObject(t) {
    if (!t) return this._pushUInt8(yn);
    for (var r = this.semanticTypes.length, o = 0; o < r; o++)
      if (t instanceof this.semanticTypes[o][0])
        return this.semanticTypes[o][1].call(t, this, t);
    var u = t.encodeCBOR;
    if (typeof u == "function") return u.call(t, this);
    var d = Object.keys(t),
      g = d.length;
    return this._pushInt(g, Gt.MAP)
      ? this._pushRawMap(
          g,
          d.map((c) => [c, t[c]]),
        )
      : !1;
  }
  _pushRawMap(t, r) {
    r = r
      .map(function (u) {
        return (u[0] = Xe.encode(u[0])), u;
      })
      .sort(hr.keySorter);
    for (var o = 0; o < t; o++)
      if (!this.push(r[o][0]) || !this.pushAny(r[o][1])) return !1;
    return !0;
  }
  write(t) {
    return this.pushAny(t);
  }
  pushAny(t) {
    var r = So(t);
    switch (r) {
      case "Number":
        return this._pushNumber(t);
      case "String":
        return this._pushString(t);
      case "Boolean":
        return this._pushBoolean(t);
      case "Object":
        return this._pushObject(t);
      case "Array":
        return this._pushArray(this, t);
      case "Uint8Array":
        return this._pushBuffer(this, Vt.isBuffer(t) ? t : Vt.from(t));
      case "Null":
        return this._pushUInt8(yn);
      case "Undefined":
        return this._pushUndefined(t);
      case "Map":
        return this._pushMap(this, t);
      case "Set":
        return this._pushSet(this, t);
      case "URL":
        return this._pushUrl(this, t);
      case "BigNumber":
        return this._pushBigNumber(this, t);
      case "Date":
        return this._pushDate(this, t);
      case "RegExp":
        return this._pushRegexp(this, t);
      case "Symbol":
        switch (t) {
          case wn.NULL:
            return this._pushObject(null);
          case wn.UNDEFINED:
            return this._pushUndefined(void 0);
          default:
            throw new Error("Unknown symbol: " + t.toString());
        }
      default:
        throw new Error(
          "Unknown type: " + typeof t + ", " + (t ? t.toString() : ""),
        );
    }
  }
  finalize() {
    if (this.offset === 0) return null;
    for (
      var t = this.result,
        r = this.resultLength,
        o = this.resultMethod,
        u = this.offset,
        d = 0,
        g = 0;
      g < u;
      g++
    )
      d += r[g];
    var c = Vt.allocUnsafe(d),
      b = 0,
      A = 0;
    for (g = 0; g < u; g++) {
      switch (((A = r[g]), o[g])) {
        case 0:
          t[g].copy(c, b);
          break;
        case 1:
          c.writeUInt8(t[g], b, !0);
          break;
        case 2:
          c.writeUInt16BE(t[g], b, !0);
          break;
        case 3:
          c.writeUInt32BE(t[g], b, !0);
          break;
        case 4:
          c.writeDoubleBE(t[g], b, !0);
          break;
        case 5:
          c.write(t[g], b, A, "utf8");
          break;
        default:
          throw new Error("unkown method");
      }
      b += A;
    }
    var U = c;
    return this._reset(), U;
  }
  _reset() {
    (this.result = []),
      (this.resultMethod = []),
      (this.resultLength = []),
      (this.offset = 0);
  }
  static encode(t) {
    const r = new Xe();
    if (!r.pushAny(t)) throw new Error("Failed to encode input");
    return r.finalize();
  }
}
var To = Xe;
(function (e) {
  (e.Diagnose = po),
    (e.Decoder = ci),
    (e.Encoder = To),
    (e.Simple = ii),
    (e.Tagged = si),
    (e.decodeAll = e.Decoder.decodeAll),
    (e.decodeFirst = e.Decoder.decodeFirst),
    (e.diagnose = e.Diagnose.diagnose),
    (e.encode = e.Encoder.encode),
    (e.decode = e.Decoder.decode),
    (e.leveldb = {
      decode: e.Decoder.decodeAll,
      encode: e.Encoder.encode,
      buffer: !0,
      name: "cbor",
    });
})(ri);
var fi = ls(ri);
function Ne(...e) {
  const t = new Uint8Array(e.reduce((o, u) => o + u.byteLength, 0));
  let r = 0;
  for (const o of e) t.set(new Uint8Array(o), r), (r += o.byteLength);
  return t.buffer;
}
function be(e) {
  return [...new Uint8Array(e)]
    .map((t) => t.toString(16).padStart(2, "0"))
    .join("");
}
const Uo = new RegExp(/^[0-9a-fA-F]+$/);
function ce(e) {
  if (!Uo.test(e)) throw new Error("Invalid hexadecimal string.");
  const t = [...e]
    .reduce((r, o, u) => ((r[(u / 2) | 0] = (r[(u / 2) | 0] || "") + o), r), [])
    .map((r) => Number.parseInt(r, 16));
  return new Uint8Array(t).buffer;
}
function hi(e, t) {
  if (e.byteLength !== t.byteLength) return e.byteLength - t.byteLength;
  const r = new Uint8Array(e),
    o = new Uint8Array(t);
  for (let u = 0; u < r.length; u++) if (r[u] !== o[u]) return r[u] - o[u];
  return 0;
}
function li(e, t) {
  return hi(e, t) === 0;
}
function Ue(e) {
  return new DataView(e.buffer, e.byteOffset, e.byteLength).buffer;
}
function di(e) {
  return e instanceof Uint8Array
    ? Ue(e)
    : e instanceof ArrayBuffer
      ? e
      : Array.isArray(e)
        ? Ue(new Uint8Array(e))
        : "buffer" in e
          ? di(e.buffer)
          : Ue(new Uint8Array(e));
}
function he(e) {
  return Ue(Ps.create().update(new Uint8Array(e)).digest());
}
function He(e) {
  if (e instanceof fi.Tagged) return He(e.value);
  if (typeof e == "string") return pi(e);
  if (typeof e == "number") return he(cn(e));
  if (e instanceof ArrayBuffer || ArrayBuffer.isView(e)) return he(e);
  if (Array.isArray(e)) {
    const t = e.map(He);
    return he(Ne(...t));
  } else {
    if (e && typeof e == "object" && e._isPrincipal)
      return he(e.toUint8Array());
    if (typeof e == "object" && e !== null && typeof e.toHash == "function")
      return He(e.toHash());
    if (typeof e == "object") return wi(e);
    if (typeof e == "bigint") return he(cn(e));
  }
  throw Object.assign(
    new Error(`Attempt to hash a value of unsupported type: ${e}`),
    { value: e },
  );
}
const pi = (e) => {
  const t = new TextEncoder().encode(e);
  return he(t);
};
function zr(e) {
  return wi(e);
}
function wi(e) {
  const o = Object.entries(e)
      .filter(([, g]) => g !== void 0)
      .map(([g, c]) => {
        const b = pi(g),
          A = He(c);
        return [b, A];
      })
      .sort(([g], [c]) => hi(g, c)),
    u = Ne(...o.map((g) => Ne(...g)));
  return he(u);
}
var No = function (e, t) {
  var r = {};
  for (var o in e)
    Object.prototype.hasOwnProperty.call(e, o) &&
      t.indexOf(o) < 0 &&
      (r[o] = e[o]);
  if (e != null && typeof Object.getOwnPropertySymbols == "function")
    for (var u = 0, o = Object.getOwnPropertySymbols(e); u < o.length; u++)
      t.indexOf(o[u]) < 0 &&
        Object.prototype.propertyIsEnumerable.call(e, o[u]) &&
        (r[o[u]] = e[o[u]]);
  return r;
};
const Fo = new TextEncoder().encode(`
ic-request`);
class Yr {
  getPrincipal() {
    return (
      this._principal ||
        (this._principal = ue.selfAuthenticating(
          new Uint8Array(this.getPublicKey().toDer()),
        )),
      this._principal
    );
  }
  async transformRequest(t) {
    const { body: r } = t,
      o = No(t, ["body"]),
      u = await zr(r);
    return Object.assign(Object.assign({}, o), {
      body: {
        content: r,
        sender_pubkey: this.getPublicKey().toDer(),
        sender_sig: await this.sign(Ne(Fo, u)),
      },
    });
  }
}
class gn {
  getPrincipal() {
    return ue.anonymous();
  }
  async transformRequest(t) {
    return Object.assign(Object.assign({}, t), { body: { content: t.body } });
  }
}
var $t = {},
  Ie = {},
  St = {};
Object.defineProperty(St, "__esModule", { value: !0 });
const vo = 9007199254740992;
function Zt(e, ...t) {
  const r = new Uint8Array(
    e.byteLength + t.reduce((u, d) => u + d.byteLength, 0),
  );
  r.set(new Uint8Array(e), 0);
  let o = e.byteLength;
  for (const u of t) r.set(new Uint8Array(u), o), (o += u.byteLength);
  return r.buffer;
}
function zt(e, t, r) {
  r = r.replace(/[^0-9a-fA-F]/g, "");
  const o = 2 ** (t - 24);
  r = r.slice(-o * 2).padStart(o * 2, "0");
  const u = [(e << 5) + t].concat(r.match(/../g).map((d) => parseInt(d, 16)));
  return new Uint8Array(u).buffer;
}
function sr(e, t) {
  if (t < 24) return new Uint8Array([(e << 5) + t]).buffer;
  {
    const r = t <= 255 ? 24 : t <= 65535 ? 25 : t <= 4294967295 ? 26 : 27;
    return zt(e, r, t.toString(16));
  }
}
function yi(e) {
  const t = [];
  for (let r = 0; r < e.length; r++) {
    let o = e.charCodeAt(r);
    o < 128
      ? t.push(o)
      : o < 2048
        ? t.push(192 | (o >> 6), 128 | (o & 63))
        : o < 55296 || o >= 57344
          ? t.push(224 | (o >> 12), 128 | ((o >> 6) & 63), 128 | (o & 63))
          : (r++,
            (o = ((o & 1023) << 10) | (e.charCodeAt(r) & 1023)),
            t.push(
              240 | (o >> 18),
              128 | ((o >> 12) & 63),
              128 | ((o >> 6) & 63),
              128 | (o & 63),
            ));
  }
  return Zt(new Uint8Array(sr(3, e.length)), new Uint8Array(t));
}
function Ro(e, t) {
  if (e == 14277111) return Zt(new Uint8Array([217, 217, 247]), t);
  if (e < 24) return Zt(new Uint8Array([192 + e]), t);
  {
    const r = e <= 255 ? 24 : e <= 65535 ? 25 : e <= 4294967295 ? 26 : 27,
      o = 2 ** (r - 24),
      u = e
        .toString(16)
        .slice(-o * 2)
        .padStart(o * 2, "0"),
      d = [192 + r].concat(u.match(/../g).map((g) => parseInt(g, 16)));
    return new Uint8Array(d).buffer;
  }
}
St.tagged = Ro;
function De(e) {
  return new Uint8Array(e).buffer;
}
St.raw = De;
function Wr(e) {
  if (isNaN(e)) throw new RangeError("Invalid number.");
  e = Math.min(Math.max(0, e), 23);
  const t = [0 + e];
  return new Uint8Array(t).buffer;
}
St.uSmall = Wr;
function gi(e, t) {
  if (((e = parseInt("" + e, t)), isNaN(e)))
    throw new RangeError("Invalid number.");
  return (
    (e = Math.min(Math.max(0, e), 255)), (e = e.toString(16)), zt(0, 24, e)
  );
}
St.u8 = gi;
function xi(e, t) {
  if (((e = parseInt("" + e, t)), isNaN(e)))
    throw new RangeError("Invalid number.");
  return (
    (e = Math.min(Math.max(0, e), 65535)), (e = e.toString(16)), zt(0, 25, e)
  );
}
St.u16 = xi;
function mi(e, t) {
  if (((e = parseInt("" + e, t)), isNaN(e)))
    throw new RangeError("Invalid number.");
  return (
    (e = Math.min(Math.max(0, e), 4294967295)),
    (e = e.toString(16)),
    zt(0, 26, e)
  );
}
St.u32 = mi;
function Vr(e, t) {
  if (typeof e == "string" && t == 16) {
    if (e.match(/[^0-9a-fA-F]/)) throw new RangeError("Invalid number.");
    return zt(0, 27, e);
  }
  if (((e = parseInt("" + e, t)), isNaN(e)))
    throw new RangeError("Invalid number.");
  return (e = Math.min(Math.max(0, e), vo)), (e = e.toString(16)), zt(0, 27, e);
}
St.u64 = Vr;
function bi(e) {
  if (isNaN(e)) throw new RangeError("Invalid number.");
  if (e === 0) return Wr(0);
  e = Math.min(Math.max(0, -e), 24) - 1;
  const t = [32 + e];
  return new Uint8Array(t).buffer;
}
St.iSmall = bi;
function Ei(e, t) {
  if (((e = parseInt("" + e, t)), isNaN(e)))
    throw new RangeError("Invalid number.");
  return (
    (e = Math.min(Math.max(0, -e - 1), 255)), (e = e.toString(16)), zt(1, 24, e)
  );
}
St.i8 = Ei;
function _i(e, t) {
  if (((e = parseInt("" + e, t)), isNaN(e)))
    throw new RangeError("Invalid number.");
  return (
    (e = Math.min(Math.max(0, -e - 1), 65535)),
    (e = e.toString(16)),
    zt(1, 25, e)
  );
}
St.i16 = _i;
function Ii(e, t) {
  if (((e = parseInt("" + e, t)), isNaN(e)))
    throw new RangeError("Invalid number.");
  return (
    (e = Math.min(Math.max(0, -e - 1), 4294967295)),
    (e = e.toString(16)),
    zt(1, 26, e)
  );
}
St.i32 = Ii;
function Ai(e, t) {
  if (typeof e == "string" && t == 16) {
    if (
      (e.startsWith("-") ? (e = e.slice(1)) : (e = "0"),
      e.match(/[^0-9a-fA-F]/) || e.length > 16)
    )
      throw new RangeError("Invalid number.");
    let r = !1,
      o = e.split("").reduceRight((u, d) => {
        if (r) return d + u;
        let g = parseInt(d, 16) - 1;
        return g >= 0 ? ((r = !0), g.toString(16) + u) : "f" + u;
      }, "");
    return r ? zt(1, 27, o) : Vr(0);
  }
  if (((e = parseInt("" + e, t)), isNaN(e)))
    throw new RangeError("Invalid number.");
  return (
    (e = Math.min(Math.max(0, -e - 1), 9007199254740992)),
    (e = e.toString(16)),
    zt(1, 27, e)
  );
}
St.i64 = Ai;
function Lo(e) {
  return e >= 0
    ? e < 24
      ? Wr(e)
      : e <= 255
        ? gi(e)
        : e <= 65535
          ? xi(e)
          : e <= 4294967295
            ? mi(e)
            : Vr(e)
    : e >= -24
      ? bi(e)
      : e >= -255
        ? Ei(e)
        : e >= -65535
          ? _i(e)
          : e >= -4294967295
            ? Ii(e)
            : Ai(e);
}
St.number = Lo;
function Oo(e) {
  return Zt(sr(2, e.byteLength), e);
}
St.bytes = Oo;
function Do(e) {
  return yi(e);
}
St.string = Do;
function Po(e) {
  return Zt(sr(4, e.length), ...e);
}
St.array = Po;
function Mo(e, t = !1) {
  e instanceof Map || (e = new Map(Object.entries(e)));
  let r = Array.from(e.entries());
  return (
    t && (r = r.sort(([o], [u]) => o.localeCompare(u))),
    Zt(sr(5, e.size), ...r.map(([o, u]) => Zt(yi(o), u)))
  );
}
St.map = Mo;
function Co(e) {
  const t = new Float32Array([e]);
  return Zt(new Uint8Array([250]), new Uint8Array(t.buffer));
}
St.singleFloat = Co;
function $o(e) {
  const t = new Float64Array([e]);
  return Zt(new Uint8Array([251]), new Uint8Array(t.buffer));
}
St.doubleFloat = $o;
function ko(e) {
  return e ? Bi() : Si();
}
St.bool = ko;
function Bi() {
  return De(new Uint8Array([245]));
}
St.true_ = Bi;
function Si() {
  return De(new Uint8Array([244]));
}
St.false_ = Si;
function Go() {
  return De(new Uint8Array([246]));
}
St.null_ = Go;
function Ho() {
  return De(new Uint8Array([247]));
}
St.undefined_ = Ho;
var Ko =
  (Ee && Ee.__importStar) ||
  function (e) {
    if (e && e.__esModule) return e;
    var t = {};
    if (e != null)
      for (var r in e) Object.hasOwnProperty.call(e, r) && (t[r] = e[r]);
    return (t.default = e), t;
  };
Object.defineProperty(Ie, "__esModule", { value: !0 });
const Kt = Ko(St),
  zo = [
    ArrayBuffer,
    Uint8Array,
    Uint16Array,
    Uint32Array,
    Int8Array,
    Int16Array,
    Int32Array,
    Float32Array,
    Float64Array,
  ];
class Ti {
  constructor(t, r = !1) {
    (this._serializer = t),
      (this._stable = r),
      (this.name = "jsonDefault"),
      (this.priority = -100);
  }
  match(t) {
    return (
      ["undefined", "boolean", "number", "string", "object"].indexOf(
        typeof t,
      ) != -1
    );
  }
  encode(t) {
    switch (typeof t) {
      case "undefined":
        return Kt.undefined_();
      case "boolean":
        return Kt.bool(t);
      case "number":
        return Math.floor(t) === t ? Kt.number(t) : Kt.doubleFloat(t);
      case "string":
        return Kt.string(t);
      case "object":
        if (t === null) return Kt.null_();
        if (Array.isArray(t))
          return Kt.array(t.map((r) => this._serializer.serializeValue(r)));
        if (zo.find((r) => t instanceof r)) return Kt.bytes(t.buffer);
        if (Object.getOwnPropertyNames(t).indexOf("toJSON") !== -1)
          return this.encode(t.toJSON());
        if (t instanceof Map) {
          const r = new Map();
          for (const [o, u] of t.entries())
            r.set(o, this._serializer.serializeValue(u));
          return Kt.map(r, this._stable);
        } else {
          const r = new Map();
          for (const [o, u] of Object.entries(t))
            r.set(o, this._serializer.serializeValue(u));
          return Kt.map(r, this._stable);
        }
      default:
        throw new Error("Invalid value.");
    }
  }
}
Ie.JsonDefaultCborEncoder = Ti;
class Ui {
  constructor() {
    (this.name = "cborEncoder"), (this.priority = -90);
  }
  match(t) {
    return typeof t == "object" && typeof t.toCBOR == "function";
  }
  encode(t) {
    return t.toCBOR();
  }
}
Ie.ToCborEncoder = Ui;
class Ni {
  constructor() {
    this._encoders = new Set();
  }
  static withDefaultEncoders(t = !1) {
    const r = new this();
    return r.addEncoder(new Ti(r, t)), r.addEncoder(new Ui()), r;
  }
  removeEncoder(t) {
    for (const r of this._encoders.values())
      r.name == t && this._encoders.delete(r);
  }
  addEncoder(t) {
    this._encoders.add(t);
  }
  getEncoderFor(t) {
    let r = null;
    for (const o of this._encoders)
      (!r || o.priority > r.priority) && o.match(t) && (r = o);
    if (r === null) throw new Error("Could not find an encoder for value.");
    return r;
  }
  serializeValue(t) {
    return this.getEncoderFor(t).encode(t);
  }
  serialize(t) {
    return this.serializeValue(t);
  }
}
Ie.CborSerializer = Ni;
class Yo extends Ni {
  serialize(t) {
    return Kt.raw(
      new Uint8Array([
        ...new Uint8Array([217, 217, 247]),
        ...new Uint8Array(super.serializeValue(t)),
      ]),
    );
  }
}
Ie.SelfDescribeCborSerializer = Yo;
(function (e) {
  function t(u) {
    for (var d in u) e.hasOwnProperty(d) || (e[d] = u[d]);
  }
  var r =
    (Ee && Ee.__importStar) ||
    function (u) {
      if (u && u.__esModule) return u;
      var d = {};
      if (u != null)
        for (var g in u) Object.hasOwnProperty.call(u, g) && (d[g] = u[g]);
      return (d.default = u), d;
    };
  Object.defineProperty(e, "__esModule", { value: !0 }), t(Ie);
  const o = r(St);
  e.value = o;
})($t);
class Wo {
  get name() {
    return "Principal";
  }
  get priority() {
    return 0;
  }
  match(t) {
    return t && t._isPrincipal === !0;
  }
  encode(t) {
    return $t.value.bytes(t.toUint8Array());
  }
}
class Vo {
  get name() {
    return "Buffer";
  }
  get priority() {
    return 1;
  }
  match(t) {
    return t instanceof ArrayBuffer || ArrayBuffer.isView(t);
  }
  encode(t) {
    return $t.value.bytes(new Uint8Array(t));
  }
}
class qo {
  get name() {
    return "BigInt";
  }
  get priority() {
    return 1;
  }
  match(t) {
    return typeof t == "bigint";
  }
  encode(t) {
    return t > BigInt(0)
      ? $t.value.tagged(2, $t.value.bytes(ce(t.toString(16))))
      : $t.value.tagged(3, $t.value.bytes(ce((BigInt("-1") * t).toString(16))));
  }
}
const qr = $t.SelfDescribeCborSerializer.withDefaultEncoders(!0);
qr.addEncoder(new Wo());
qr.addEncoder(new Vo());
qr.addEncoder(new qo());
var xn;
(function (e) {
  (e[(e.Uint64LittleEndian = 71)] = "Uint64LittleEndian"),
    (e[(e.Semantic = 55799)] = "Semantic");
})(xn || (xn = {}));
class j0 extends fi.Decoder {
  createByteString(t) {
    return Ne(...t);
  }
  createByteStringFromHeap(t, r) {
    return t === r
      ? new ArrayBuffer(0)
      : new Uint8Array(this._heap.slice(t, r));
  }
}
var mn;
(function (e) {
  e.Call = "call";
})(mn || (mn = {}));
BigInt(1e6);
/*! noble-curves - MIT License (c) 2022 Paul Miller (paulmillr.com) */ const Fi =
    BigInt(0),
  vi = BigInt(1),
  Jo = BigInt(2);
function Jr(e) {
  return (
    e instanceof Uint8Array ||
    (e != null && typeof e == "object" && e.constructor.name === "Uint8Array")
  );
}
function Xr(e) {
  if (!Jr(e)) throw new Error("Uint8Array expected");
}
function lr(e, t) {
  if (typeof t != "boolean")
    throw new Error(`${e} must be valid boolean, got "${t}".`);
}
const Xo = Array.from({ length: 256 }, (e, t) =>
  t.toString(16).padStart(2, "0"),
);
function jr(e) {
  Xr(e);
  let t = "";
  for (let r = 0; r < e.length; r++) t += Xo[e[r]];
  return t;
}
function Ri(e) {
  if (typeof e != "string")
    throw new Error("hex string expected, got " + typeof e);
  return BigInt(e === "" ? "0" : `0x${e}`);
}
const Jt = { _0: 48, _9: 57, _A: 65, _F: 70, _a: 97, _f: 102 };
function bn(e) {
  if (e >= Jt._0 && e <= Jt._9) return e - Jt._0;
  if (e >= Jt._A && e <= Jt._F) return e - (Jt._A - 10);
  if (e >= Jt._a && e <= Jt._f) return e - (Jt._a - 10);
}
function Li(e) {
  if (typeof e != "string")
    throw new Error("hex string expected, got " + typeof e);
  const t = e.length,
    r = t / 2;
  if (t % 2)
    throw new Error(
      "padded hex string expected, got unpadded hex of length " + t,
    );
  const o = new Uint8Array(r);
  for (let u = 0, d = 0; u < r; u++, d += 2) {
    const g = bn(e.charCodeAt(d)),
      c = bn(e.charCodeAt(d + 1));
    if (g === void 0 || c === void 0) {
      const b = e[d] + e[d + 1];
      throw new Error(
        'hex string expected, got non-hex character "' + b + '" at index ' + d,
      );
    }
    o[u] = g * 16 + c;
  }
  return o;
}
function jo(e) {
  return Ri(jr(e));
}
function Ke(e) {
  return Xr(e), Ri(jr(Uint8Array.from(e).reverse()));
}
function Oi(e, t) {
  return Li(e.toString(16).padStart(t * 2, "0"));
}
function vr(e, t) {
  return Oi(e, t).reverse();
}
function ee(e, t, r) {
  let o;
  if (typeof t == "string")
    try {
      o = Li(t);
    } catch (d) {
      throw new Error(`${e} must be valid hex string, got "${t}". Cause: ${d}`);
    }
  else if (Jr(t)) o = Uint8Array.from(t);
  else throw new Error(`${e} must be hex string or Uint8Array`);
  const u = o.length;
  if (typeof r == "number" && u !== r)
    throw new Error(`${e} expected ${r} bytes, got ${u}`);
  return o;
}
function En(...e) {
  let t = 0;
  for (let o = 0; o < e.length; o++) {
    const u = e[o];
    Xr(u), (t += u.length);
  }
  const r = new Uint8Array(t);
  for (let o = 0, u = 0; o < e.length; o++) {
    const d = e[o];
    r.set(d, u), (u += d.length);
  }
  return r;
}
const dr = (e) => typeof e == "bigint" && Fi <= e;
function Zo(e, t, r) {
  return dr(e) && dr(t) && dr(r) && t <= e && e < r;
}
function Be(e, t, r, o) {
  if (!Zo(t, r, o))
    throw new Error(
      `expected valid ${e}: ${r} <= n < ${o}, got ${typeof t} ${t}`,
    );
}
function Qo(e) {
  let t;
  for (t = 0; e > Fi; e >>= vi, t += 1);
  return t;
}
const ta = (e) => (Jo << BigInt(e - 1)) - vi,
  ea = {
    bigint: (e) => typeof e == "bigint",
    function: (e) => typeof e == "function",
    boolean: (e) => typeof e == "boolean",
    string: (e) => typeof e == "string",
    stringOrUint8Array: (e) => typeof e == "string" || Jr(e),
    isSafeInteger: (e) => Number.isSafeInteger(e),
    array: (e) => Array.isArray(e),
    field: (e, t) => t.Fp.isValid(e),
    hash: (e) => typeof e == "function" && Number.isSafeInteger(e.outputLen),
  };
function Zr(e, t, r = {}) {
  const o = (u, d, g) => {
    const c = ea[d];
    if (typeof c != "function")
      throw new Error(`Invalid validator "${d}", expected function`);
    const b = e[u];
    if (!(g && b === void 0) && !c(b, e))
      throw new Error(
        `Invalid param ${String(u)}=${b} (${typeof b}), expected ${d}`,
      );
  };
  for (const [u, d] of Object.entries(t)) o(u, d, !1);
  for (const [u, d] of Object.entries(r)) o(u, d, !0);
  return e;
}
function _n(e) {
  const t = new WeakMap();
  return (r, ...o) => {
    const u = t.get(r);
    if (u !== void 0) return u;
    const d = e(r, ...o);
    return t.set(r, d), d;
  };
}
/*! noble-curves - MIT License (c) 2022 Paul Miller (paulmillr.com) */ const Dt =
    BigInt(0),
  Ft = BigInt(1),
  le = BigInt(2),
  ra = BigInt(3),
  Rr = BigInt(4),
  In = BigInt(5),
  An = BigInt(8);
BigInt(9);
BigInt(16);
function Rt(e, t) {
  const r = e % t;
  return r >= Dt ? r : t + r;
}
function na(e, t, r) {
  if (r <= Dt || t < Dt) throw new Error("Expected power/modulo > 0");
  if (r === Ft) return Dt;
  let o = Ft;
  for (; t > Dt; ) t & Ft && (o = (o * e) % r), (e = (e * e) % r), (t >>= Ft);
  return o;
}
function Wt(e, t, r) {
  let o = e;
  for (; t-- > Dt; ) (o *= o), (o %= r);
  return o;
}
function Bn(e, t) {
  if (e === Dt || t <= Dt)
    throw new Error(`invert: expected positive integers, got n=${e} mod=${t}`);
  let r = Rt(e, t),
    o = t,
    u = Dt,
    d = Ft;
  for (; r !== Dt; ) {
    const c = o / r,
      b = o % r,
      A = u - d * c;
    (o = r), (r = b), (u = d), (d = A);
  }
  if (o !== Ft) throw new Error("invert: does not exist");
  return Rt(u, t);
}
function ia(e) {
  const t = (e - Ft) / le;
  let r, o, u;
  for (r = e - Ft, o = 0; r % le === Dt; r /= le, o++);
  for (u = le; u < e && na(u, t, e) !== e - Ft; u++);
  if (o === 1) {
    const g = (e + Ft) / Rr;
    return function (b, A) {
      const U = b.pow(A, g);
      if (!b.eql(b.sqr(U), A)) throw new Error("Cannot find square root");
      return U;
    };
  }
  const d = (r + Ft) / le;
  return function (c, b) {
    if (c.pow(b, t) === c.neg(c.ONE))
      throw new Error("Cannot find square root");
    let A = o,
      U = c.pow(c.mul(c.ONE, u), r),
      L = c.pow(b, d),
      O = c.pow(b, r);
    for (; !c.eql(O, c.ONE); ) {
      if (c.eql(O, c.ZERO)) return c.ZERO;
      let M = 1;
      for (let W = c.sqr(O); M < A && !c.eql(W, c.ONE); M++) W = c.sqr(W);
      const Z = c.pow(U, Ft << BigInt(A - M - 1));
      (U = c.sqr(Z)), (L = c.mul(L, Z)), (O = c.mul(O, U)), (A = M);
    }
    return L;
  };
}
function sa(e) {
  if (e % Rr === ra) {
    const t = (e + Ft) / Rr;
    return function (o, u) {
      const d = o.pow(u, t);
      if (!o.eql(o.sqr(d), u)) throw new Error("Cannot find square root");
      return d;
    };
  }
  if (e % An === In) {
    const t = (e - In) / An;
    return function (o, u) {
      const d = o.mul(u, le),
        g = o.pow(d, t),
        c = o.mul(u, g),
        b = o.mul(o.mul(c, le), g),
        A = o.mul(c, o.sub(b, o.ONE));
      if (!o.eql(o.sqr(A), u)) throw new Error("Cannot find square root");
      return A;
    };
  }
  return ia(e);
}
const oa = (e, t) => (Rt(e, t) & Ft) === Ft,
  aa = [
    "create",
    "isValid",
    "is0",
    "neg",
    "inv",
    "sqrt",
    "sqr",
    "eql",
    "add",
    "sub",
    "mul",
    "pow",
    "div",
    "addN",
    "subN",
    "mulN",
    "sqrN",
  ];
function ua(e) {
  const t = {
      ORDER: "bigint",
      MASK: "bigint",
      BYTES: "isSafeInteger",
      BITS: "isSafeInteger",
    },
    r = aa.reduce((o, u) => ((o[u] = "function"), o), t);
  return Zr(e, r);
}
function ca(e, t, r) {
  if (r < Dt) throw new Error("Expected power > 0");
  if (r === Dt) return e.ONE;
  if (r === Ft) return t;
  let o = e.ONE,
    u = t;
  for (; r > Dt; ) r & Ft && (o = e.mul(o, u)), (u = e.sqr(u)), (r >>= Ft);
  return o;
}
function fa(e, t) {
  const r = new Array(t.length),
    o = t.reduce(
      (d, g, c) => (e.is0(g) ? d : ((r[c] = d), e.mul(d, g))),
      e.ONE,
    ),
    u = e.inv(o);
  return (
    t.reduceRight(
      (d, g, c) => (e.is0(g) ? d : ((r[c] = e.mul(d, r[c])), e.mul(d, g))),
      u,
    ),
    r
  );
}
function Di(e, t) {
  const r = t !== void 0 ? t : e.toString(2).length,
    o = Math.ceil(r / 8);
  return { nBitLength: r, nByteLength: o };
}
function Pi(e, t, r = !1, o = {}) {
  if (e <= Dt) throw new Error(`Expected Field ORDER > 0, got ${e}`);
  const { nBitLength: u, nByteLength: d } = Di(e, t);
  if (d > 2048)
    throw new Error("Field lengths over 2048 bytes are not supported");
  const g = sa(e),
    c = Object.freeze({
      ORDER: e,
      BITS: u,
      BYTES: d,
      MASK: ta(u),
      ZERO: Dt,
      ONE: Ft,
      create: (b) => Rt(b, e),
      isValid: (b) => {
        if (typeof b != "bigint")
          throw new Error(
            `Invalid field element: expected bigint, got ${typeof b}`,
          );
        return Dt <= b && b < e;
      },
      is0: (b) => b === Dt,
      isOdd: (b) => (b & Ft) === Ft,
      neg: (b) => Rt(-b, e),
      eql: (b, A) => b === A,
      sqr: (b) => Rt(b * b, e),
      add: (b, A) => Rt(b + A, e),
      sub: (b, A) => Rt(b - A, e),
      mul: (b, A) => Rt(b * A, e),
      pow: (b, A) => ca(c, b, A),
      div: (b, A) => Rt(b * Bn(A, e), e),
      sqrN: (b) => b * b,
      addN: (b, A) => b + A,
      subN: (b, A) => b - A,
      mulN: (b, A) => b * A,
      inv: (b) => Bn(b, e),
      sqrt: o.sqrt || ((b) => g(c, b)),
      invertBatch: (b) => fa(c, b),
      cmov: (b, A, U) => (U ? A : b),
      toBytes: (b) => (r ? vr(b, d) : Oi(b, d)),
      fromBytes: (b) => {
        if (b.length !== d)
          throw new Error(`Fp.fromBytes: expected ${d}, got ${b.length}`);
        return r ? Ke(b) : jo(b);
      },
    });
  return Object.freeze(c);
}
/*! noble-curves - MIT License (c) 2022 Paul Miller (paulmillr.com) */ const ha =
    BigInt(0),
  pr = BigInt(1),
  wr = new WeakMap(),
  Sn = new WeakMap();
function la(e, t) {
  const r = (d, g) => {
      const c = g.negate();
      return d ? c : g;
    },
    o = (d) => {
      if (!Number.isSafeInteger(d) || d <= 0 || d > t)
        throw new Error(`Wrong window size=${d}, should be [1..${t}]`);
    },
    u = (d) => {
      o(d);
      const g = Math.ceil(t / d) + 1,
        c = 2 ** (d - 1);
      return { windows: g, windowSize: c };
    };
  return {
    constTimeNegate: r,
    unsafeLadder(d, g) {
      let c = e.ZERO,
        b = d;
      for (; g > ha; ) g & pr && (c = c.add(b)), (b = b.double()), (g >>= pr);
      return c;
    },
    precomputeWindow(d, g) {
      const { windows: c, windowSize: b } = u(g),
        A = [];
      let U = d,
        L = U;
      for (let O = 0; O < c; O++) {
        (L = U), A.push(L);
        for (let M = 1; M < b; M++) (L = L.add(U)), A.push(L);
        U = L.double();
      }
      return A;
    },
    wNAF(d, g, c) {
      const { windows: b, windowSize: A } = u(d);
      let U = e.ZERO,
        L = e.BASE;
      const O = BigInt(2 ** d - 1),
        M = 2 ** d,
        Z = BigInt(d);
      for (let W = 0; W < b; W++) {
        const ct = W * A;
        let mt = Number(c & O);
        (c >>= Z), mt > A && ((mt -= M), (c += pr));
        const ut = ct,
          z = ct + Math.abs(mt) - 1,
          At = W % 2 !== 0,
          ot = mt < 0;
        mt === 0 ? (L = L.add(r(At, g[ut]))) : (U = U.add(r(ot, g[z])));
      }
      return { p: U, f: L };
    },
    wNAFCached(d, g, c) {
      const b = Sn.get(d) || 1;
      let A = wr.get(d);
      return (
        A || ((A = this.precomputeWindow(d, b)), b !== 1 && wr.set(d, c(A))),
        this.wNAF(b, A, g)
      );
    },
    setWindowSize(d, g) {
      o(g), Sn.set(d, g), wr.delete(d);
    },
  };
}
function da(e, t, r, o) {
  if (!Array.isArray(r) || !Array.isArray(o) || o.length !== r.length)
    throw new Error("arrays of points and scalars must have equal length");
  o.forEach((U, L) => {
    if (!t.isValid(U)) throw new Error(`wrong scalar at index ${L}`);
  }),
    r.forEach((U, L) => {
      if (!(U instanceof e)) throw new Error(`wrong point at index ${L}`);
    });
  const u = Qo(BigInt(r.length)),
    d = u > 12 ? u - 3 : u > 4 ? u - 2 : u ? 2 : 1,
    g = (1 << d) - 1,
    c = new Array(g + 1).fill(e.ZERO),
    b = Math.floor((t.BITS - 1) / d) * d;
  let A = e.ZERO;
  for (let U = b; U >= 0; U -= d) {
    c.fill(e.ZERO);
    for (let O = 0; O < o.length; O++) {
      const M = o[O],
        Z = Number((M >> BigInt(U)) & BigInt(g));
      c[Z] = c[Z].add(r[O]);
    }
    let L = e.ZERO;
    for (let O = c.length - 1, M = e.ZERO; O > 0; O--)
      (M = M.add(c[O])), (L = L.add(M));
    if (((A = A.add(L)), U !== 0)) for (let O = 0; O < d; O++) A = A.double();
  }
  return A;
}
function pa(e) {
  return (
    ua(e.Fp),
    Zr(
      e,
      { n: "bigint", h: "bigint", Gx: "field", Gy: "field" },
      { nBitLength: "isSafeInteger", nByteLength: "isSafeInteger" },
    ),
    Object.freeze({ ...Di(e.n, e.nBitLength), ...e, p: e.Fp.ORDER })
  );
}
var Tn;
(function (e) {
  (e[(e.Empty = 0)] = "Empty"),
    (e[(e.Fork = 1)] = "Fork"),
    (e[(e.Labeled = 2)] = "Labeled"),
    (e[(e.Leaf = 3)] = "Leaf"),
    (e[(e.Pruned = 4)] = "Pruned");
})(Tn || (Tn = {}));
ce(
  "308182301d060d2b0601040182dc7c0503010201060c2b0601040182dc7c05030201036100",
);
var Un;
(function (e) {
  (e.Unknown = "unknown"), (e.Absent = "absent"), (e.Found = "found");
})(Un || (Un = {}));
var Nn;
(function (e) {
  (e.Less = "less"), (e.Greater = "greater");
})(Nn || (Nn = {}));
const ke = BigInt(2 ** 32 - 1),
  Lr = BigInt(32);
function Mi(e, t = !1) {
  return t
    ? { h: Number(e & ke), l: Number((e >> Lr) & ke) }
    : { h: Number((e >> Lr) & ke) | 0, l: Number(e & ke) | 0 };
}
function wa(e, t = !1) {
  let r = new Uint32Array(e.length),
    o = new Uint32Array(e.length);
  for (let u = 0; u < e.length; u++) {
    const { h: d, l: g } = Mi(e[u], t);
    [r[u], o[u]] = [d, g];
  }
  return [r, o];
}
const ya = (e, t) => (BigInt(e >>> 0) << Lr) | BigInt(t >>> 0),
  ga = (e, t, r) => e >>> r,
  xa = (e, t, r) => (e << (32 - r)) | (t >>> r),
  ma = (e, t, r) => (e >>> r) | (t << (32 - r)),
  ba = (e, t, r) => (e << (32 - r)) | (t >>> r),
  Ea = (e, t, r) => (e << (64 - r)) | (t >>> (r - 32)),
  _a = (e, t, r) => (e >>> (r - 32)) | (t << (64 - r)),
  Ia = (e, t) => t,
  Aa = (e, t) => e,
  Ba = (e, t, r) => (e << r) | (t >>> (32 - r)),
  Sa = (e, t, r) => (t << r) | (e >>> (32 - r)),
  Ta = (e, t, r) => (t << (r - 32)) | (e >>> (64 - r)),
  Ua = (e, t, r) => (e << (r - 32)) | (t >>> (64 - r));
function Na(e, t, r, o) {
  const u = (t >>> 0) + (o >>> 0);
  return { h: (e + r + ((u / 2 ** 32) | 0)) | 0, l: u | 0 };
}
const Fa = (e, t, r) => (e >>> 0) + (t >>> 0) + (r >>> 0),
  va = (e, t, r, o) => (t + r + o + ((e / 2 ** 32) | 0)) | 0,
  Ra = (e, t, r, o) => (e >>> 0) + (t >>> 0) + (r >>> 0) + (o >>> 0),
  La = (e, t, r, o, u) => (t + r + o + u + ((e / 2 ** 32) | 0)) | 0,
  Oa = (e, t, r, o, u) =>
    (e >>> 0) + (t >>> 0) + (r >>> 0) + (o >>> 0) + (u >>> 0),
  Da = (e, t, r, o, u, d) => (t + r + o + u + d + ((e / 2 ** 32) | 0)) | 0,
  at = {
    fromBig: Mi,
    split: wa,
    toBig: ya,
    shrSH: ga,
    shrSL: xa,
    rotrSH: ma,
    rotrSL: ba,
    rotrBH: Ea,
    rotrBL: _a,
    rotr32H: Ia,
    rotr32L: Aa,
    rotlSH: Ba,
    rotlSL: Sa,
    rotlBH: Ta,
    rotlBL: Ua,
    add: Na,
    add3L: Fa,
    add3H: va,
    add4L: Ra,
    add4H: La,
    add5H: Da,
    add5L: Oa,
  },
  [Pa, Ma] = at.split(
    [
      "0x428a2f98d728ae22",
      "0x7137449123ef65cd",
      "0xb5c0fbcfec4d3b2f",
      "0xe9b5dba58189dbbc",
      "0x3956c25bf348b538",
      "0x59f111f1b605d019",
      "0x923f82a4af194f9b",
      "0xab1c5ed5da6d8118",
      "0xd807aa98a3030242",
      "0x12835b0145706fbe",
      "0x243185be4ee4b28c",
      "0x550c7dc3d5ffb4e2",
      "0x72be5d74f27b896f",
      "0x80deb1fe3b1696b1",
      "0x9bdc06a725c71235",
      "0xc19bf174cf692694",
      "0xe49b69c19ef14ad2",
      "0xefbe4786384f25e3",
      "0x0fc19dc68b8cd5b5",
      "0x240ca1cc77ac9c65",
      "0x2de92c6f592b0275",
      "0x4a7484aa6ea6e483",
      "0x5cb0a9dcbd41fbd4",
      "0x76f988da831153b5",
      "0x983e5152ee66dfab",
      "0xa831c66d2db43210",
      "0xb00327c898fb213f",
      "0xbf597fc7beef0ee4",
      "0xc6e00bf33da88fc2",
      "0xd5a79147930aa725",
      "0x06ca6351e003826f",
      "0x142929670a0e6e70",
      "0x27b70a8546d22ffc",
      "0x2e1b21385c26c926",
      "0x4d2c6dfc5ac42aed",
      "0x53380d139d95b3df",
      "0x650a73548baf63de",
      "0x766a0abb3c77b2a8",
      "0x81c2c92e47edaee6",
      "0x92722c851482353b",
      "0xa2bfe8a14cf10364",
      "0xa81a664bbc423001",
      "0xc24b8b70d0f89791",
      "0xc76c51a30654be30",
      "0xd192e819d6ef5218",
      "0xd69906245565a910",
      "0xf40e35855771202a",
      "0x106aa07032bbd1b8",
      "0x19a4c116b8d2d0c8",
      "0x1e376c085141ab53",
      "0x2748774cdf8eeb99",
      "0x34b0bcb5e19b48a8",
      "0x391c0cb3c5c95a63",
      "0x4ed8aa4ae3418acb",
      "0x5b9cca4f7763e373",
      "0x682e6ff3d6b2b8a3",
      "0x748f82ee5defb2fc",
      "0x78a5636f43172f60",
      "0x84c87814a1f0ab72",
      "0x8cc702081a6439ec",
      "0x90befffa23631e28",
      "0xa4506cebde82bde9",
      "0xbef9a3f7b2c67915",
      "0xc67178f2e372532b",
      "0xca273eceea26619c",
      "0xd186b8c721c0c207",
      "0xeada7dd6cde0eb1e",
      "0xf57d4f7fee6ed178",
      "0x06f067aa72176fba",
      "0x0a637dc5a2c898a6",
      "0x113f9804bef90dae",
      "0x1b710b35131c471b",
      "0x28db77f523047d84",
      "0x32caab7b40c72493",
      "0x3c9ebe0a15c9bebc",
      "0x431d67c49c100d4c",
      "0x4cc5d4becb3e42b6",
      "0x597f299cfc657e2a",
      "0x5fcb6fab3ad6faec",
      "0x6c44198c4a475817",
    ].map((e) => BigInt(e)),
  ),
  re = new Uint32Array(80),
  ne = new Uint32Array(80);
class Ca extends Jn {
  constructor() {
    super(128, 64, 16, !1),
      (this.Ah = 1779033703),
      (this.Al = -205731576),
      (this.Bh = -1150833019),
      (this.Bl = -2067093701),
      (this.Ch = 1013904242),
      (this.Cl = -23791573),
      (this.Dh = -1521486534),
      (this.Dl = 1595750129),
      (this.Eh = 1359893119),
      (this.El = -1377402159),
      (this.Fh = -1694144372),
      (this.Fl = 725511199),
      (this.Gh = 528734635),
      (this.Gl = -79577749),
      (this.Hh = 1541459225),
      (this.Hl = 327033209);
  }
  get() {
    const {
      Ah: t,
      Al: r,
      Bh: o,
      Bl: u,
      Ch: d,
      Cl: g,
      Dh: c,
      Dl: b,
      Eh: A,
      El: U,
      Fh: L,
      Fl: O,
      Gh: M,
      Gl: Z,
      Hh: W,
      Hl: ct,
    } = this;
    return [t, r, o, u, d, g, c, b, A, U, L, O, M, Z, W, ct];
  }
  set(t, r, o, u, d, g, c, b, A, U, L, O, M, Z, W, ct) {
    (this.Ah = t | 0),
      (this.Al = r | 0),
      (this.Bh = o | 0),
      (this.Bl = u | 0),
      (this.Ch = d | 0),
      (this.Cl = g | 0),
      (this.Dh = c | 0),
      (this.Dl = b | 0),
      (this.Eh = A | 0),
      (this.El = U | 0),
      (this.Fh = L | 0),
      (this.Fl = O | 0),
      (this.Gh = M | 0),
      (this.Gl = Z | 0),
      (this.Hh = W | 0),
      (this.Hl = ct | 0);
  }
  process(t, r) {
    for (let z = 0; z < 16; z++, r += 4)
      (re[z] = t.getUint32(r)), (ne[z] = t.getUint32((r += 4)));
    for (let z = 16; z < 80; z++) {
      const At = re[z - 15] | 0,
        ot = ne[z - 15] | 0,
        q = at.rotrSH(At, ot, 1) ^ at.rotrSH(At, ot, 8) ^ at.shrSH(At, ot, 7),
        J = at.rotrSL(At, ot, 1) ^ at.rotrSL(At, ot, 8) ^ at.shrSL(At, ot, 7),
        nt = re[z - 2] | 0,
        it = ne[z - 2] | 0,
        C = at.rotrSH(nt, it, 19) ^ at.rotrBH(nt, it, 61) ^ at.shrSH(nt, it, 6),
        xt =
          at.rotrSL(nt, it, 19) ^ at.rotrBL(nt, it, 61) ^ at.shrSL(nt, it, 6),
        ft = at.add4L(J, xt, ne[z - 7], ne[z - 16]),
        ht = at.add4H(ft, q, C, re[z - 7], re[z - 16]);
      (re[z] = ht | 0), (ne[z] = ft | 0);
    }
    let {
      Ah: o,
      Al: u,
      Bh: d,
      Bl: g,
      Ch: c,
      Cl: b,
      Dh: A,
      Dl: U,
      Eh: L,
      El: O,
      Fh: M,
      Fl: Z,
      Gh: W,
      Gl: ct,
      Hh: mt,
      Hl: ut,
    } = this;
    for (let z = 0; z < 80; z++) {
      const At =
          at.rotrSH(L, O, 14) ^ at.rotrSH(L, O, 18) ^ at.rotrBH(L, O, 41),
        ot = at.rotrSL(L, O, 14) ^ at.rotrSL(L, O, 18) ^ at.rotrBL(L, O, 41),
        q = (L & M) ^ (~L & W),
        J = (O & Z) ^ (~O & ct),
        nt = at.add5L(ut, ot, J, Ma[z], ne[z]),
        it = at.add5H(nt, mt, At, q, Pa[z], re[z]),
        C = nt | 0,
        xt = at.rotrSH(o, u, 28) ^ at.rotrBH(o, u, 34) ^ at.rotrBH(o, u, 39),
        ft = at.rotrSL(o, u, 28) ^ at.rotrBL(o, u, 34) ^ at.rotrBL(o, u, 39),
        ht = (o & d) ^ (o & c) ^ (d & c),
        Tt = (u & g) ^ (u & b) ^ (g & b);
      (mt = W | 0),
        (ut = ct | 0),
        (W = M | 0),
        (ct = Z | 0),
        (M = L | 0),
        (Z = O | 0),
        ({ h: L, l: O } = at.add(A | 0, U | 0, it | 0, C | 0)),
        (A = c | 0),
        (U = b | 0),
        (c = d | 0),
        (b = g | 0),
        (d = o | 0),
        (g = u | 0);
      const _t = at.add3L(C, ft, Tt);
      (o = at.add3H(_t, it, xt, ht)), (u = _t | 0);
    }
    ({ h: o, l: u } = at.add(this.Ah | 0, this.Al | 0, o | 0, u | 0)),
      ({ h: d, l: g } = at.add(this.Bh | 0, this.Bl | 0, d | 0, g | 0)),
      ({ h: c, l: b } = at.add(this.Ch | 0, this.Cl | 0, c | 0, b | 0)),
      ({ h: A, l: U } = at.add(this.Dh | 0, this.Dl | 0, A | 0, U | 0)),
      ({ h: L, l: O } = at.add(this.Eh | 0, this.El | 0, L | 0, O | 0)),
      ({ h: M, l: Z } = at.add(this.Fh | 0, this.Fl | 0, M | 0, Z | 0)),
      ({ h: W, l: ct } = at.add(this.Gh | 0, this.Gl | 0, W | 0, ct | 0)),
      ({ h: mt, l: ut } = at.add(this.Hh | 0, this.Hl | 0, mt | 0, ut | 0)),
      this.set(o, u, d, g, c, b, A, U, L, O, M, Z, W, ct, mt, ut);
  }
  roundClean() {
    re.fill(0), ne.fill(0);
  }
  destroy() {
    this.buffer.fill(0),
      this.set(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  }
}
const $a = Mr(() => new Ca());
/*! noble-curves - MIT License (c) 2022 Paul Miller (paulmillr.com) */ const Ht =
    BigInt(0),
  Ct = BigInt(1),
  Ge = BigInt(2),
  ka = BigInt(8),
  Ga = { zip215: !0 };
function Ha(e) {
  const t = pa(e);
  return (
    Zr(
      e,
      { hash: "function", a: "bigint", d: "bigint", randomBytes: "function" },
      {
        adjustScalarBytes: "function",
        domain: "function",
        uvRatio: "function",
        mapToCurve: "function",
      },
    ),
    Object.freeze({ ...t })
  );
}
function Ka(e) {
  const t = Ha(e),
    {
      Fp: r,
      n: o,
      prehash: u,
      hash: d,
      randomBytes: g,
      nByteLength: c,
      h: b,
    } = t,
    A = Ge << (BigInt(c * 8) - Ct),
    U = r.create,
    L = Pi(t.n, t.nBitLength),
    O =
      t.uvRatio ||
      ((X, P) => {
        try {
          return { isValid: !0, value: r.sqrt(X * r.inv(P)) };
        } catch {
          return { isValid: !1, value: Ht };
        }
      }),
    M = t.adjustScalarBytes || ((X) => X),
    Z =
      t.domain ||
      ((X, P, $) => {
        if ((lr("phflag", $), P.length || $))
          throw new Error("Contexts/pre-hash are not supported");
        return X;
      });
  function W(X, P) {
    Be("coordinate " + X, P, Ht, A);
  }
  function ct(X) {
    if (!(X instanceof z)) throw new Error("ExtendedPoint expected");
  }
  const mt = _n((X, P) => {
      const { ex: $, ey: j, ez: Q } = X,
        k = X.is0();
      P == null && (P = k ? ka : r.inv(Q));
      const K = U($ * P),
        yt = U(j * P),
        y = U(Q * P);
      if (k) return { x: Ht, y: Ct };
      if (y !== Ct) throw new Error("invZ was invalid");
      return { x: K, y: yt };
    }),
    ut = _n((X) => {
      const { a: P, d: $ } = t;
      if (X.is0()) throw new Error("bad point: ZERO");
      const { ex: j, ey: Q, ez: k, et: K } = X,
        yt = U(j * j),
        y = U(Q * Q),
        dt = U(k * k),
        bt = U(dt * dt),
        Ut = U(yt * P),
        G = U(dt * U(Ut + y)),
        Y = U(bt + U($ * U(yt * y)));
      if (G !== Y) throw new Error("bad point: equation left != right (1)");
      const w = U(j * Q),
        x = U(k * K);
      if (w !== x) throw new Error("bad point: equation left != right (2)");
      return !0;
    });
  class z {
    constructor(P, $, j, Q) {
      (this.ex = P),
        (this.ey = $),
        (this.ez = j),
        (this.et = Q),
        W("x", P),
        W("y", $),
        W("z", j),
        W("t", Q),
        Object.freeze(this);
    }
    get x() {
      return this.toAffine().x;
    }
    get y() {
      return this.toAffine().y;
    }
    static fromAffine(P) {
      if (P instanceof z) throw new Error("extended point not allowed");
      const { x: $, y: j } = P || {};
      return W("x", $), W("y", j), new z($, j, Ct, U($ * j));
    }
    static normalizeZ(P) {
      const $ = r.invertBatch(P.map((j) => j.ez));
      return P.map((j, Q) => j.toAffine($[Q])).map(z.fromAffine);
    }
    static msm(P, $) {
      return da(z, L, P, $);
    }
    _setWindowSize(P) {
      q.setWindowSize(this, P);
    }
    assertValidity() {
      ut(this);
    }
    equals(P) {
      ct(P);
      const { ex: $, ey: j, ez: Q } = this,
        { ex: k, ey: K, ez: yt } = P,
        y = U($ * yt),
        dt = U(k * Q),
        bt = U(j * yt),
        Ut = U(K * Q);
      return y === dt && bt === Ut;
    }
    is0() {
      return this.equals(z.ZERO);
    }
    negate() {
      return new z(U(-this.ex), this.ey, this.ez, U(-this.et));
    }
    double() {
      const { a: P } = t,
        { ex: $, ey: j, ez: Q } = this,
        k = U($ * $),
        K = U(j * j),
        yt = U(Ge * U(Q * Q)),
        y = U(P * k),
        dt = $ + j,
        bt = U(U(dt * dt) - k - K),
        Ut = y + K,
        G = Ut - yt,
        Y = y - K,
        w = U(bt * G),
        x = U(Ut * Y),
        _ = U(bt * Y),
        T = U(G * Ut);
      return new z(w, x, T, _);
    }
    add(P) {
      ct(P);
      const { a: $, d: j } = t,
        { ex: Q, ey: k, ez: K, et: yt } = this,
        { ex: y, ey: dt, ez: bt, et: Ut } = P;
      if ($ === BigInt(-1)) {
        const p = U((k - Q) * (dt + y)),
          E = U((k + Q) * (dt - y)),
          F = U(E - p);
        if (F === Ht) return this.double();
        const D = U(K * Ge * Ut),
          H = U(yt * Ge * bt),
          V = H + D,
          rt = E + p,
          h = H - D,
          s = U(V * F),
          a = U(rt * h),
          m = U(V * h),
          B = U(F * rt);
        return new z(s, a, B, m);
      }
      const G = U(Q * y),
        Y = U(k * dt),
        w = U(yt * j * Ut),
        x = U(K * bt),
        _ = U((Q + k) * (y + dt) - G - Y),
        T = x - w,
        S = x + w,
        N = U(Y - $ * G),
        f = U(_ * T),
        n = U(S * N),
        i = U(_ * N),
        l = U(T * S);
      return new z(f, n, l, i);
    }
    subtract(P) {
      return this.add(P.negate());
    }
    wNAF(P) {
      return q.wNAFCached(this, P, z.normalizeZ);
    }
    multiply(P) {
      const $ = P;
      Be("scalar", $, Ct, o);
      const { p: j, f: Q } = this.wNAF($);
      return z.normalizeZ([j, Q])[0];
    }
    multiplyUnsafe(P) {
      const $ = P;
      return (
        Be("scalar", $, Ht, o),
        $ === Ht
          ? ot
          : this.equals(ot) || $ === Ct
            ? this
            : this.equals(At)
              ? this.wNAF($).p
              : q.unsafeLadder(this, $)
      );
    }
    isSmallOrder() {
      return this.multiplyUnsafe(b).is0();
    }
    isTorsionFree() {
      return q.unsafeLadder(this, o).is0();
    }
    toAffine(P) {
      return mt(this, P);
    }
    clearCofactor() {
      const { h: P } = t;
      return P === Ct ? this : this.multiplyUnsafe(P);
    }
    static fromHex(P, $ = !1) {
      const { d: j, a: Q } = t,
        k = r.BYTES;
      (P = ee("pointHex", P, k)), lr("zip215", $);
      const K = P.slice(),
        yt = P[k - 1];
      K[k - 1] = yt & -129;
      const y = Ke(K),
        dt = $ ? A : r.ORDER;
      Be("pointHex.y", y, Ht, dt);
      const bt = U(y * y),
        Ut = U(bt - Ct),
        G = U(j * bt - Q);
      let { isValid: Y, value: w } = O(Ut, G);
      if (!Y) throw new Error("Point.fromHex: invalid y coordinate");
      const x = (w & Ct) === Ct,
        _ = (yt & 128) !== 0;
      if (!$ && w === Ht && _) throw new Error("Point.fromHex: x=0 and x_0=1");
      return _ !== x && (w = U(-w)), z.fromAffine({ x: w, y });
    }
    static fromPrivateKey(P) {
      return it(P).point;
    }
    toRawBytes() {
      const { x: P, y: $ } = this.toAffine(),
        j = vr($, r.BYTES);
      return (j[j.length - 1] |= P & Ct ? 128 : 0), j;
    }
    toHex() {
      return jr(this.toRawBytes());
    }
  }
  (z.BASE = new z(t.Gx, t.Gy, Ct, U(t.Gx * t.Gy))),
    (z.ZERO = new z(Ht, Ct, Ct, Ht));
  const { BASE: At, ZERO: ot } = z,
    q = la(z, c * 8);
  function J(X) {
    return Rt(X, o);
  }
  function nt(X) {
    return J(Ke(X));
  }
  function it(X) {
    const P = c;
    X = ee("private key", X, P);
    const $ = ee("hashed private key", d(X), 2 * P),
      j = M($.slice(0, P)),
      Q = $.slice(P, 2 * P),
      k = nt(j),
      K = At.multiply(k),
      yt = K.toRawBytes();
    return { head: j, prefix: Q, scalar: k, point: K, pointBytes: yt };
  }
  function C(X) {
    return it(X).pointBytes;
  }
  function xt(X = new Uint8Array(), ...P) {
    const $ = En(...P);
    return nt(d(Z($, ee("context", X), !!u)));
  }
  function ft(X, P, $ = {}) {
    (X = ee("message", X)), u && (X = u(X));
    const { prefix: j, scalar: Q, pointBytes: k } = it(P),
      K = xt($.context, j, X),
      yt = At.multiply(K).toRawBytes(),
      y = xt($.context, yt, k, X),
      dt = J(K + y * Q);
    Be("signature.s", dt, Ht, o);
    const bt = En(yt, vr(dt, r.BYTES));
    return ee("result", bt, c * 2);
  }
  const ht = Ga;
  function Tt(X, P, $, j = ht) {
    const { context: Q, zip215: k } = j,
      K = r.BYTES;
    (X = ee("signature", X, 2 * K)),
      (P = ee("message", P)),
      k !== void 0 && lr("zip215", k),
      u && (P = u(P));
    const yt = Ke(X.slice(K, 2 * K));
    let y, dt, bt;
    try {
      (y = z.fromHex($, k)),
        (dt = z.fromHex(X.slice(0, K), k)),
        (bt = At.multiplyUnsafe(yt));
    } catch {
      return !1;
    }
    if (!k && y.isSmallOrder()) return !1;
    const Ut = xt(Q, dt.toRawBytes(), y.toRawBytes(), P);
    return dt
      .add(y.multiplyUnsafe(Ut))
      .subtract(bt)
      .clearCofactor()
      .equals(z.ZERO);
  }
  return (
    At._setWindowSize(8),
    {
      CURVE: t,
      getPublicKey: C,
      sign: ft,
      verify: Tt,
      ExtendedPoint: z,
      utils: {
        getExtendedPublicKey: it,
        randomPrivateKey: () => g(r.BYTES),
        precompute(X = 8, P = z.BASE) {
          return P._setWindowSize(X), P.multiply(BigInt(3)), P;
        },
      },
    }
  );
}
/*! noble-curves - MIT License (c) 2022 Paul Miller (paulmillr.com) */ const Qr =
    BigInt(
      "57896044618658097711785492504343953926634992332820282019728792003956564819949",
    ),
  Fn = BigInt(
    "19681161376707505956807079304988542015446066515923890162744021073123829784752",
  );
BigInt(0);
const za = BigInt(1),
  vn = BigInt(2);
BigInt(3);
const Ya = BigInt(5),
  Wa = BigInt(8);
function Va(e) {
  const t = BigInt(10),
    r = BigInt(20),
    o = BigInt(40),
    u = BigInt(80),
    d = Qr,
    c = (((e * e) % d) * e) % d,
    b = (Wt(c, vn, d) * c) % d,
    A = (Wt(b, za, d) * e) % d,
    U = (Wt(A, Ya, d) * A) % d,
    L = (Wt(U, t, d) * U) % d,
    O = (Wt(L, r, d) * L) % d,
    M = (Wt(O, o, d) * O) % d,
    Z = (Wt(M, u, d) * M) % d,
    W = (Wt(Z, u, d) * M) % d,
    ct = (Wt(W, t, d) * U) % d;
  return { pow_p_5_8: (Wt(ct, vn, d) * e) % d, b2: c };
}
function qa(e) {
  return (e[0] &= 248), (e[31] &= 127), (e[31] |= 64), e;
}
function Ja(e, t) {
  const r = Qr,
    o = Rt(t * t * t, r),
    u = Rt(o * o * t, r),
    d = Va(e * u).pow_p_5_8;
  let g = Rt(e * o * d, r);
  const c = Rt(t * g * g, r),
    b = g,
    A = Rt(g * Fn, r),
    U = c === e,
    L = c === Rt(-e, r),
    O = c === Rt(-e * Fn, r);
  return (
    U && (g = b),
    (L || O) && (g = A),
    oa(g, r) && (g = Rt(-g, r)),
    { isValid: U || L, value: g }
  );
}
const Xa = Pi(Qr, void 0, !0),
  ja = {
    a: BigInt(-1),
    d: BigInt(
      "37095705934669439343138083508754565189542113879843219016388785533085940283555",
    ),
    Fp: Xa,
    n: BigInt(
      "7237005577332262213973186563042994240857116359379907606001950938285454250989",
    ),
    h: Wa,
    Gx: BigInt(
      "15112221349535400772501151409588531511454012693041857206046113283949847762202",
    ),
    Gy: BigInt(
      "46316835694926478169428394003475163141307993866256225615783033603165251855960",
    ),
    hash: $a,
    randomBytes: Fs,
    adjustScalarBytes: qa,
    uvRatio: Ja,
  },
  Se = Ka(ja),
  Rn = (e) => {
    if (e <= 127) return 1;
    if (e <= 255) return 2;
    if (e <= 65535) return 3;
    if (e <= 16777215) return 4;
    throw new Error("Length too long (> 4 bytes)");
  },
  Ln = (e, t, r) => {
    if (r <= 127) return (e[t] = r), 1;
    if (r <= 255) return (e[t] = 129), (e[t + 1] = r), 2;
    if (r <= 65535) return (e[t] = 130), (e[t + 1] = r >> 8), (e[t + 2] = r), 3;
    if (r <= 16777215)
      return (
        (e[t] = 131),
        (e[t + 1] = r >> 16),
        (e[t + 2] = r >> 8),
        (e[t + 3] = r),
        4
      );
    throw new Error("Length too long (> 4 bytes)");
  },
  Or = (e, t) => {
    if (e[t] < 128) return 1;
    if (e[t] === 128) throw new Error("Invalid length 0");
    if (e[t] === 129) return 2;
    if (e[t] === 130) return 3;
    if (e[t] === 131) return 4;
    throw new Error("Length too long (> 4 bytes)");
  },
  Za = (e, t) => {
    const r = Or(e, t);
    if (r === 1) return e[t];
    if (r === 2) return e[t + 1];
    if (r === 3) return (e[t + 1] << 8) + e[t + 2];
    if (r === 4) return (e[t + 1] << 16) + (e[t + 2] << 8) + e[t + 3];
    throw new Error("Length too long (> 4 bytes)");
  };
Uint8Array.from([48, 12, 6, 10, 43, 6, 1, 4, 1, 131, 184, 67, 1, 1]);
const On = Uint8Array.from([48, 5, 6, 3, 43, 101, 112]);
Uint8Array.from([
  48, 16, 6, 7, 42, 134, 72, 206, 61, 2, 1, 6, 5, 43, 129, 4, 0, 10,
]);
function Qa(e, t) {
  const r = 2 + Rn(e.byteLength + 1),
    o = t.byteLength + r + e.byteLength;
  let u = 0;
  const d = new Uint8Array(1 + Rn(o) + o);
  return (
    (d[u++] = 48),
    (u += Ln(d, u, o)),
    d.set(t, u),
    (u += t.byteLength),
    (d[u++] = 3),
    (u += Ln(d, u, e.byteLength + 1)),
    (d[u++] = 0),
    d.set(new Uint8Array(e), u),
    d
  );
}
const t0 = (e, t) => {
  let r = 0;
  const o = (c, b) => {
      if (u[r++] !== c) throw new Error("Expected: " + b);
    },
    u = new Uint8Array(e);
  if (
    (o(48, "sequence"), (r += Or(u, r)), !li(u.slice(r, r + t.byteLength), t))
  )
    throw new Error("Not the expected OID.");
  (r += t.byteLength), o(3, "bit string");
  const d = Za(u, r) - 1;
  (r += Or(u, r)), o(0, "0 padding");
  const g = u.slice(r);
  if (d !== g.length)
    throw new Error(
      `DER payload mismatch: Expected length ${d} actual length ${g.length}`,
    );
  return g;
};
var Dn;
(function (e) {
  (e.Received = "received"),
    (e.Processing = "processing"),
    (e.Replied = "replied"),
    (e.Rejected = "rejected"),
    (e.Unknown = "unknown"),
    (e.Done = "done");
})(Dn || (Dn = {}));
var Pn;
(function (e) {
  (e.Error = "err"),
    (e.GetPrincipal = "gp"),
    (e.GetPrincipalResponse = "gpr"),
    (e.Query = "q"),
    (e.QueryResponse = "qr"),
    (e.Call = "c"),
    (e.CallResponse = "cr"),
    (e.ReadState = "rs"),
    (e.ReadStateResponse = "rsr"),
    (e.Status = "s"),
    (e.StatusResponse = "sr");
})(Pn || (Pn = {}));
var je = function (e, t, r, o, u) {
    if (o === "m") throw new TypeError("Private method is not writable");
    if (o === "a" && !u)
      throw new TypeError("Private accessor was defined without a setter");
    if (typeof t == "function" ? e !== t || !u : !t.has(e))
      throw new TypeError(
        "Cannot write private member to an object whose class did not declare it",
      );
    return o === "a" ? u.call(e, r) : u ? (u.value = r) : t.set(e, r), r;
  },
  se = function (e, t, r, o) {
    if (r === "a" && !o)
      throw new TypeError("Private accessor was defined without a getter");
    if (typeof t == "function" ? e !== t || !o : !t.has(e))
      throw new TypeError(
        "Cannot read private member from an object whose class did not declare it",
      );
    return r === "m" ? o : r === "a" ? o.call(e) : o ? o.value : t.get(e);
  },
  ze,
  Ye,
  xe,
  me;
function Mn(e) {
  return e !== null && typeof e == "object";
}
class jt {
  constructor(t) {
    if (
      (ze.set(this, void 0),
      Ye.set(this, void 0),
      t.byteLength !== jt.RAW_KEY_LENGTH)
    )
      throw new Error("An Ed25519 public key must be exactly 32bytes long");
    je(this, ze, t, "f"), je(this, Ye, jt.derEncode(t), "f");
  }
  static from(t) {
    if (typeof t == "string") {
      const r = ce(t);
      return this.fromRaw(r);
    } else if (Mn(t)) {
      const r = t;
      if (Mn(r) && Object.hasOwnProperty.call(r, "__derEncodedPublicKey__"))
        return this.fromDer(r);
      if (ArrayBuffer.isView(r)) {
        const o = r;
        return this.fromRaw(di(o.buffer));
      } else {
        if (r instanceof ArrayBuffer) return this.fromRaw(r);
        if ("rawKey" in r) return this.fromRaw(r.rawKey);
        if ("derKey" in r) return this.fromDer(r.derKey);
        if ("toDer" in r) return this.fromDer(r.toDer());
      }
    }
    throw new Error("Cannot construct Ed25519PublicKey from the provided key.");
  }
  static fromRaw(t) {
    return new jt(t);
  }
  static fromDer(t) {
    return new jt(this.derDecode(t));
  }
  static derEncode(t) {
    const r = Qa(t, On).buffer;
    return (r.__derEncodedPublicKey__ = void 0), r;
  }
  static derDecode(t) {
    const r = t0(t, On);
    if (r.length !== this.RAW_KEY_LENGTH)
      throw new Error("An Ed25519 public key must be exactly 32bytes long");
    return r;
  }
  get rawKey() {
    return se(this, ze, "f");
  }
  get derKey() {
    return se(this, Ye, "f");
  }
  toDer() {
    return this.derKey;
  }
  toRaw() {
    return this.rawKey;
  }
}
(ze = new WeakMap()), (Ye = new WeakMap());
jt.RAW_KEY_LENGTH = 32;
class ae extends Yr {
  constructor(t, r) {
    super(),
      xe.set(this, void 0),
      me.set(this, void 0),
      je(this, xe, jt.from(t), "f"),
      je(this, me, new Uint8Array(r), "f");
  }
  static generate(t) {
    if (t && t.length !== 32)
      throw new Error("Ed25519 Seed needs to be 32 bytes long.");
    t || (t = Se.utils.randomPrivateKey()),
      li(t, new Uint8Array(new Array(32).fill(0))) &&
        console.warn(
          "Seed is all zeros. This is not a secure seed. Please provide a seed with sufficient entropy if this is a production environment.",
        );
    const r = new Uint8Array(32);
    for (let u = 0; u < 32; u++) r[u] = new Uint8Array(t)[u];
    const o = Se.getPublicKey(r);
    return ae.fromKeyPair(o, r);
  }
  static fromParsedJson(t) {
    const [r, o] = t;
    return new ae(jt.fromDer(ce(r)), ce(o));
  }
  static fromJSON(t) {
    const r = JSON.parse(t);
    if (Array.isArray(r)) {
      if (typeof r[0] == "string" && typeof r[1] == "string")
        return this.fromParsedJson([r[0], r[1]]);
      throw new Error(
        "Deserialization error: JSON must have at least 2 items.",
      );
    }
    throw new Error(
      `Deserialization error: Invalid JSON type for string: ${JSON.stringify(t)}`,
    );
  }
  static fromKeyPair(t, r) {
    return new ae(jt.fromRaw(t), r);
  }
  static fromSecretKey(t) {
    const r = Se.getPublicKey(new Uint8Array(t));
    return ae.fromKeyPair(r, t);
  }
  toJSON() {
    return [be(se(this, xe, "f").toDer()), be(se(this, me, "f"))];
  }
  getKeyPair() {
    return { secretKey: se(this, me, "f"), publicKey: se(this, xe, "f") };
  }
  getPublicKey() {
    return se(this, xe, "f");
  }
  async sign(t) {
    const r = new Uint8Array(t),
      o = Ue(Se.sign(r, se(this, me, "f").slice(0, 32)));
    return (
      Object.defineProperty(o, "__signature__", {
        enumerable: !1,
        value: void 0,
      }),
      o
    );
  }
  static verify(t, r, o) {
    const [u, d, g] = [t, r, o].map(
      (c) => (
        typeof c == "string" && (c = ce(c)),
        c instanceof Uint8Array && (c = c.buffer),
        new Uint8Array(c)
      ),
    );
    return Se.verify(d, u, g);
  }
}
(xe = new WeakMap()), (me = new WeakMap());
class tn extends Error {
  constructor(t) {
    super(t), (this.message = t), Object.setPrototypeOf(this, tn.prototype);
  }
}
function Cn(e) {
  if (typeof global < "u" && global.crypto && global.crypto.subtle)
    return global.crypto.subtle;
  if (e) return e;
  if (typeof crypto < "u" && crypto.subtle) return crypto.subtle;
  throw new tn(
    "Global crypto was not available and none was provided. Please inlcude a SubtleCrypto implementation. See https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto",
  );
}
class Ze extends Yr {
  constructor(t, r, o) {
    super(), (this._keyPair = t), (this._derKey = r), (this._subtleCrypto = o);
  }
  static async generate(t) {
    const {
        extractable: r = !1,
        keyUsages: o = ["sign", "verify"],
        subtleCrypto: u,
      } = t ?? {},
      d = Cn(u),
      g = await d.generateKey({ name: "ECDSA", namedCurve: "P-256" }, r, o),
      c = await d.exportKey("spki", g.publicKey);
    return new this(g, c, d);
  }
  static async fromKeyPair(t, r) {
    const o = Cn(r),
      u = await o.exportKey("spki", t.publicKey);
    return new Ze(t, u, o);
  }
  getKeyPair() {
    return this._keyPair;
  }
  getPublicKey() {
    const t = this._derKey,
      r = Object.create(this._keyPair.publicKey);
    return (
      (r.toDer = function () {
        return t;
      }),
      r
    );
  }
  async sign(t) {
    const r = { name: "ECDSA", hash: { name: "SHA-256" } };
    return await this._subtleCrypto.sign(r, this._keyPair.privateKey, t);
  }
}
var e0 = function (e, t, r, o, u) {
    if (o === "m") throw new TypeError("Private method is not writable");
    if (o === "a" && !u)
      throw new TypeError("Private accessor was defined without a setter");
    if (typeof t == "function" ? e !== t || !u : !t.has(e))
      throw new TypeError(
        "Cannot write private member to an object whose class did not declare it",
      );
    return o === "a" ? u.call(e, r) : u ? (u.value = r) : t.set(e, r), r;
  },
  Te = function (e, t, r, o) {
    if (r === "a" && !o)
      throw new TypeError("Private accessor was defined without a getter");
    if (typeof t == "function" ? e !== t || !o : !t.has(e))
      throw new TypeError(
        "Cannot read private member from an object whose class did not declare it",
      );
    return r === "m" ? o : r === "a" ? o.call(e) : o ? o.value : t.get(e);
  },
  ie;
class r0 {
  constructor(t) {
    ie.set(this, void 0), e0(this, ie, t, "f");
  }
  get rawKey() {
    return Te(this, ie, "f").rawKey;
  }
  get derKey() {
    return Te(this, ie, "f").derKey;
  }
  toDer() {
    return Te(this, ie, "f").toDer();
  }
  getPublicKey() {
    return Te(this, ie, "f");
  }
  getPrincipal() {
    return ue.from(Te(this, ie, "f").rawKey);
  }
  transformRequest() {
    return Promise.reject(
      "Not implemented. You are attempting to use a partial identity to sign calls, but this identity only has access to the public key.To sign calls, use a DelegationIdentity instead.",
    );
  }
}
ie = new WeakMap();
var n0 = function (e, t, r, o, u) {
    if (o === "m") throw new TypeError("Private method is not writable");
    if (o === "a" && !u)
      throw new TypeError("Private accessor was defined without a setter");
    if (typeof t == "function" ? e !== t || !u : !t.has(e))
      throw new TypeError(
        "Cannot write private member to an object whose class did not declare it",
      );
    return o === "a" ? u.call(e, r) : u ? (u.value = r) : t.set(e, r), r;
  },
  i0 = function (e, t, r, o) {
    if (r === "a" && !o)
      throw new TypeError("Private accessor was defined without a getter");
    if (typeof t == "function" ? e !== t || !o : !t.has(e))
      throw new TypeError(
        "Cannot read private member from an object whose class did not declare it",
      );
    return r === "m" ? o : r === "a" ? o.call(e) : o ? o.value : t.get(e);
  },
  s0 = function (e, t) {
    var r = {};
    for (var o in e)
      Object.prototype.hasOwnProperty.call(e, o) &&
        t.indexOf(o) < 0 &&
        (r[o] = e[o]);
    if (e != null && typeof Object.getOwnPropertySymbols == "function")
      for (var u = 0, o = Object.getOwnPropertySymbols(e); u < o.length; u++)
        t.indexOf(o[u]) < 0 &&
          Object.prototype.propertyIsEnumerable.call(e, o[u]) &&
          (r[o[u]] = e[o[u]]);
    return r;
  },
  We;
const o0 = new TextEncoder().encode("ic-request-auth-delegation"),
  a0 = new TextEncoder().encode(`
ic-request`);
function yr(e) {
  if (typeof e != "string" || e.length < 64)
    throw new Error("Invalid public key.");
  return ce(e);
}
class en {
  constructor(t, r, o) {
    (this.pubkey = t), (this.expiration = r), (this.targets = o);
  }
  toCBOR() {
    return $t.value.map(
      Object.assign(
        {
          pubkey: $t.value.bytes(this.pubkey),
          expiration: $t.value.u64(this.expiration.toString(16), 16),
        },
        this.targets && {
          targets: $t.value.array(
            this.targets.map((t) => $t.value.bytes(t.toUint8Array())),
          ),
        },
      ),
    );
  }
  toJSON() {
    return Object.assign(
      { expiration: this.expiration.toString(16), pubkey: be(this.pubkey) },
      this.targets && { targets: this.targets.map((t) => t.toHex()) },
    );
  }
}
async function u0(e, t, r, o) {
  const u = new en(t.toDer(), BigInt(+r) * BigInt(1e6), o),
    d = new Uint8Array([...o0, ...new Uint8Array(zr(u))]),
    g = await e.sign(d);
  return { delegation: u, signature: g };
}
class Fe {
  constructor(t, r) {
    (this.delegations = t), (this.publicKey = r);
  }
  static async create(t, r, o = new Date(Date.now() + 15 * 60 * 1e3), u = {}) {
    var d, g;
    const c = await u0(t, r, o, u.targets);
    return new Fe(
      [
        ...(((d = u.previous) === null || d === void 0
          ? void 0
          : d.delegations) || []),
        c,
      ],
      ((g = u.previous) === null || g === void 0 ? void 0 : g.publicKey) ||
        t.getPublicKey().toDer(),
    );
  }
  static fromJSON(t) {
    const { publicKey: r, delegations: o } =
      typeof t == "string" ? JSON.parse(t) : t;
    if (!Array.isArray(o)) throw new Error("Invalid delegations.");
    const u = o.map((d) => {
      const { delegation: g, signature: c } = d,
        { pubkey: b, expiration: A, targets: U } = g;
      if (U !== void 0 && !Array.isArray(U))
        throw new Error("Invalid targets.");
      return {
        delegation: new en(
          yr(b),
          BigInt("0x" + A),
          U &&
            U.map((L) => {
              if (typeof L != "string") throw new Error("Invalid target.");
              return ue.fromHex(L);
            }),
        ),
        signature: yr(c),
      };
    });
    return new this(u, yr(r));
  }
  static fromDelegations(t, r) {
    return new this(t, r);
  }
  toJSON() {
    return {
      delegations: this.delegations.map((t) => {
        const { delegation: r, signature: o } = t,
          { targets: u } = r;
        return {
          delegation: Object.assign(
            { expiration: r.expiration.toString(16), pubkey: be(r.pubkey) },
            u && { targets: u.map((d) => d.toHex()) },
          ),
          signature: be(o),
        };
      }),
      publicKey: be(this.publicKey),
    };
  }
}
class $n extends Yr {
  constructor(t, r) {
    super(), (this._inner = t), (this._delegation = r);
  }
  static fromDelegation(t, r) {
    return new this(t, r);
  }
  getDelegation() {
    return this._delegation;
  }
  getPublicKey() {
    return {
      derKey: this._delegation.publicKey,
      toDer: () => this._delegation.publicKey,
    };
  }
  sign(t) {
    return this._inner.sign(t);
  }
  async transformRequest(t) {
    const { body: r } = t,
      o = s0(t, ["body"]),
      u = await zr(r);
    return Object.assign(Object.assign({}, o), {
      body: {
        content: r,
        sender_sig: await this.sign(
          new Uint8Array([...a0, ...new Uint8Array(u)]),
        ),
        sender_delegation: this._delegation.delegations,
        sender_pubkey: this._delegation.publicKey,
      },
    });
  }
}
class Qe extends r0 {
  constructor(t, r) {
    super(t), We.set(this, void 0), n0(this, We, r, "f");
  }
  get delegation() {
    return i0(this, We, "f");
  }
  static fromDelegation(t, r) {
    return new Qe(t, r);
  }
}
We = new WeakMap();
function Ci(e, t) {
  for (const { delegation: o } of e.delegations)
    if (+new Date(Number(o.expiration / BigInt(1e6))) <= +Date.now()) return !1;
  const r = [];
  for (const o of r) {
    const u = o.toText();
    for (const { delegation: d } of e.delegations) {
      if (d.targets === void 0) continue;
      let g = !0;
      for (const c of d.targets)
        if (c.toText() === u) {
          g = !1;
          break;
        }
      if (g) return !1;
    }
  }
  return !0;
}
var kn;
(function (e) {
  e[(e.ECDSA_WITH_SHA256 = -7)] = "ECDSA_WITH_SHA256";
})(kn || (kn = {}));
const Gn = ["mousedown", "mousemove", "keydown", "touchstart", "wheel"];
class Hn {
  constructor(t = {}) {
    var r;
    (this.callbacks = []),
      (this.idleTimeout = 10 * 60 * 1e3),
      (this.timeoutID = void 0);
    const { onIdle: o, idleTimeout: u = 10 * 60 * 1e3 } = t || {};
    (this.callbacks = o ? [o] : []), (this.idleTimeout = u);
    const d = this._resetTimer.bind(this);
    window.addEventListener("load", d, !0),
      Gn.forEach(function (c) {
        document.addEventListener(c, d, !0);
      });
    const g = (c, b) => {
      let A;
      return (...U) => {
        const L = this,
          O = function () {
            (A = void 0), c.apply(L, U);
          };
        clearTimeout(A), (A = window.setTimeout(O, b));
      };
    };
    if (t?.captureScroll) {
      const c = g(
        d,
        (r = t?.scrollDebounce) !== null && r !== void 0 ? r : 100,
      );
      window.addEventListener("scroll", c, !0);
    }
    d();
  }
  static create(t = {}) {
    return new this(t);
  }
  registerCallback(t) {
    this.callbacks.push(t);
  }
  exit() {
    clearTimeout(this.timeoutID),
      window.removeEventListener("load", this._resetTimer, !0);
    const t = this._resetTimer.bind(this);
    Gn.forEach(function (r) {
      document.removeEventListener(r, t, !0);
    }),
      this.callbacks.forEach((r) => r());
  }
  _resetTimer() {
    const t = this.exit.bind(this);
    window.clearTimeout(this.timeoutID),
      (this.timeoutID = window.setTimeout(t, this.idleTimeout));
  }
}
const c0 = (e, t) => t.some((r) => e instanceof r);
let Kn, zn;
function f0() {
  return (
    Kn ||
    (Kn = [IDBDatabase, IDBObjectStore, IDBIndex, IDBCursor, IDBTransaction])
  );
}
function h0() {
  return (
    zn ||
    (zn = [
      IDBCursor.prototype.advance,
      IDBCursor.prototype.continue,
      IDBCursor.prototype.continuePrimaryKey,
    ])
  );
}
const $i = new WeakMap(),
  Dr = new WeakMap(),
  ki = new WeakMap(),
  gr = new WeakMap(),
  rn = new WeakMap();
function l0(e) {
  const t = new Promise((r, o) => {
    const u = () => {
        e.removeEventListener("success", d), e.removeEventListener("error", g);
      },
      d = () => {
        r(fe(e.result)), u();
      },
      g = () => {
        o(e.error), u();
      };
    e.addEventListener("success", d), e.addEventListener("error", g);
  });
  return (
    t
      .then((r) => {
        r instanceof IDBCursor && $i.set(r, e);
      })
      .catch(() => {}),
    rn.set(t, e),
    t
  );
}
function d0(e) {
  if (Dr.has(e)) return;
  const t = new Promise((r, o) => {
    const u = () => {
        e.removeEventListener("complete", d),
          e.removeEventListener("error", g),
          e.removeEventListener("abort", g);
      },
      d = () => {
        r(), u();
      },
      g = () => {
        o(e.error || new DOMException("AbortError", "AbortError")), u();
      };
    e.addEventListener("complete", d),
      e.addEventListener("error", g),
      e.addEventListener("abort", g);
  });
  Dr.set(e, t);
}
let Pr = {
  get(e, t, r) {
    if (e instanceof IDBTransaction) {
      if (t === "done") return Dr.get(e);
      if (t === "objectStoreNames") return e.objectStoreNames || ki.get(e);
      if (t === "store")
        return r.objectStoreNames[1]
          ? void 0
          : r.objectStore(r.objectStoreNames[0]);
    }
    return fe(e[t]);
  },
  set(e, t, r) {
    return (e[t] = r), !0;
  },
  has(e, t) {
    return e instanceof IDBTransaction && (t === "done" || t === "store")
      ? !0
      : t in e;
  },
};
function p0(e) {
  Pr = e(Pr);
}
function w0(e) {
  return e === IDBDatabase.prototype.transaction &&
    !("objectStoreNames" in IDBTransaction.prototype)
    ? function (t, ...r) {
        const o = e.call(xr(this), t, ...r);
        return ki.set(o, t.sort ? t.sort() : [t]), fe(o);
      }
    : h0().includes(e)
      ? function (...t) {
          return e.apply(xr(this), t), fe($i.get(this));
        }
      : function (...t) {
          return fe(e.apply(xr(this), t));
        };
}
function y0(e) {
  return typeof e == "function"
    ? w0(e)
    : (e instanceof IDBTransaction && d0(e),
      c0(e, f0()) ? new Proxy(e, Pr) : e);
}
function fe(e) {
  if (e instanceof IDBRequest) return l0(e);
  if (gr.has(e)) return gr.get(e);
  const t = y0(e);
  return t !== e && (gr.set(e, t), rn.set(t, e)), t;
}
const xr = (e) => rn.get(e);
function g0(e, t, { blocked: r, upgrade: o, blocking: u, terminated: d } = {}) {
  const g = indexedDB.open(e, t),
    c = fe(g);
  return (
    o &&
      g.addEventListener("upgradeneeded", (b) => {
        o(fe(g.result), b.oldVersion, b.newVersion, fe(g.transaction), b);
      }),
    r && g.addEventListener("blocked", (b) => r(b.oldVersion, b.newVersion, b)),
    c
      .then((b) => {
        d && b.addEventListener("close", () => d()),
          u &&
            b.addEventListener("versionchange", (A) =>
              u(A.oldVersion, A.newVersion, A),
            );
      })
      .catch(() => {}),
    c
  );
}
const x0 = ["get", "getKey", "getAll", "getAllKeys", "count"],
  m0 = ["put", "add", "delete", "clear"],
  mr = new Map();
function Yn(e, t) {
  if (!(e instanceof IDBDatabase && !(t in e) && typeof t == "string")) return;
  if (mr.get(t)) return mr.get(t);
  const r = t.replace(/FromIndex$/, ""),
    o = t !== r,
    u = m0.includes(r);
  if (
    !(r in (o ? IDBIndex : IDBObjectStore).prototype) ||
    !(u || x0.includes(r))
  )
    return;
  const d = async function (g, ...c) {
    const b = this.transaction(g, u ? "readwrite" : "readonly");
    let A = b.store;
    return (
      o && (A = A.index(c.shift())),
      (await Promise.all([A[r](...c), u && b.done]))[0]
    );
  };
  return mr.set(t, d), d;
}
p0((e) => ({
  ...e,
  get: (t, r, o) => Yn(t, r) || e.get(t, r, o),
  has: (t, r) => !!Yn(t, r) || e.has(t, r),
}));
const Gi = "auth-client-db",
  Hi = "ic-keyval",
  b0 = async (e = Gi, t = Hi, r) => (
    Ki &&
      localStorage != null &&
      localStorage.getItem(Xt) &&
      (localStorage.removeItem(Xt), localStorage.removeItem(oe)),
    await g0(e, r, {
      upgrade: (o) => {
        o.objectStoreNames.contains(t) && o.clear(t), o.createObjectStore(t);
      },
    })
  );
async function E0(e, t, r) {
  return await e.get(t, r);
}
async function _0(e, t, r, o) {
  return await e.put(t, o, r);
}
async function I0(e, t, r) {
  return await e.delete(t, r);
}
class nn {
  constructor(t, r) {
    (this._db = t), (this._storeName = r);
  }
  static async create(t) {
    const { dbName: r = Gi, storeName: o = Hi, version: u = T0 } = t ?? {},
      d = await b0(r, o, u);
    return new nn(d, o);
  }
  async set(t, r) {
    return await _0(this._db, this._storeName, t, r);
  }
  async get(t) {
    var r;
    return (r = await E0(this._db, this._storeName, t)) !== null && r !== void 0
      ? r
      : null;
  }
  async remove(t) {
    return await I0(this._db, this._storeName, t);
  }
}
var A0 = function (e, t, r, o, u) {
    if (o === "m") throw new TypeError("Private method is not writable");
    if (o === "a" && !u)
      throw new TypeError("Private accessor was defined without a setter");
    if (typeof t == "function" ? e !== t || !u : !t.has(e))
      throw new TypeError(
        "Cannot write private member to an object whose class did not declare it",
      );
    return o === "a" ? u.call(e, r) : u ? (u.value = r) : t.set(e, r), r;
  },
  B0 = function (e, t, r, o) {
    if (r === "a" && !o)
      throw new TypeError("Private accessor was defined without a getter");
    if (typeof t == "function" ? e !== t || !o : !t.has(e))
      throw new TypeError(
        "Cannot read private member from an object whose class did not declare it",
      );
    return r === "m" ? o : r === "a" ? o.call(e) : o ? o.value : t.get(e);
  },
  Ve;
const oe = "identity",
  Xt = "delegation",
  S0 = "iv",
  T0 = 1,
  Ki = typeof window < "u";
class U0 {
  constructor(t = "ic-", r) {
    (this.prefix = t), (this._localStorage = r);
  }
  get(t) {
    return Promise.resolve(this._getLocalStorage().getItem(this.prefix + t));
  }
  set(t, r) {
    return (
      this._getLocalStorage().setItem(this.prefix + t, r), Promise.resolve()
    );
  }
  remove(t) {
    return (
      this._getLocalStorage().removeItem(this.prefix + t), Promise.resolve()
    );
  }
  _getLocalStorage() {
    if (this._localStorage) return this._localStorage;
    const t =
      typeof window > "u"
        ? typeof global > "u"
          ? typeof self > "u"
            ? void 0
            : self.localStorage
          : global.localStorage
        : window.localStorage;
    if (!t) throw new Error("Could not find local storage.");
    return t;
  }
}
class zi {
  constructor(t) {
    Ve.set(this, void 0), A0(this, Ve, t ?? {}, "f");
  }
  get _db() {
    return new Promise((t) => {
      if (this.initializedDb) {
        t(this.initializedDb);
        return;
      }
      nn.create(B0(this, Ve, "f")).then((r) => {
        (this.initializedDb = r), t(r);
      });
    });
  }
  async get(t) {
    return await (await this._db).get(t);
  }
  async set(t, r) {
    await (await this._db).set(t, r);
  }
  async remove(t) {
    await (await this._db).remove(t);
  }
}
Ve = new WeakMap();
const N0 = "https://identity.ic0.app",
  F0 = "#authorize",
  br = "ECDSA",
  Er = "Ed25519",
  v0 = 500,
  R0 = "UserInterrupt";
class L0 {
  constructor(t, r, o, u, d, g, c, b) {
    (this._identity = t),
      (this._key = r),
      (this._chain = o),
      (this._storage = u),
      (this.idleManager = d),
      (this._createOptions = g),
      (this._idpWindow = c),
      (this._eventHandler = b),
      this._registerDefaultIdleCallback();
  }
  static async create(t = {}) {
    var r, o, u;
    const d = (r = t.storage) !== null && r !== void 0 ? r : new zi(),
      g = (o = t.keyType) !== null && o !== void 0 ? o : br;
    let c = null;
    if (t.identity) c = t.identity;
    else {
      let L = await d.get(oe);
      if (!L && Ki)
        try {
          const O = new U0(),
            M = await O.get(Xt),
            Z = await O.get(oe);
          M &&
            Z &&
            g === br &&
            (console.log(
              "Discovered an identity stored in localstorage. Migrating to IndexedDB",
            ),
            await d.set(Xt, M),
            await d.set(oe, Z),
            (L = M),
            await O.remove(Xt),
            await O.remove(oe));
        } catch (O) {
          console.error("error while attempting to recover localstorage: " + O);
        }
      if (L)
        try {
          typeof L == "object"
            ? g === Er && typeof L == "string"
              ? (c = await ae.fromJSON(L))
              : (c = await Ze.fromKeyPair(L))
            : typeof L == "string" && (c = ae.fromJSON(L));
        } catch {}
    }
    let b = new gn(),
      A = null;
    if (c)
      try {
        const L = await d.get(Xt);
        if (typeof L == "object" && L !== null)
          throw new Error(
            "Delegation chain is incorrectly stored. A delegation chain should be stored as a string.",
          );
        t.identity
          ? (b = t.identity)
          : L &&
            ((A = Fe.fromJSON(L)),
            Ci(A)
              ? "toDer" in c
                ? (b = Qe.fromDelegation(c, A))
                : (b = $n.fromDelegation(c, A))
              : (await _r(d), (c = null)));
      } catch (L) {
        console.error(L), await _r(d), (c = null);
      }
    let U;
    return (
      !((u = t.idleOptions) === null || u === void 0) && u.disableIdle
        ? (U = void 0)
        : (A || t.identity) && (U = Hn.create(t.idleOptions)),
      c ||
        (g === Er
          ? ((c = await ae.generate()),
            await d.set(oe, JSON.stringify(c.toJSON())))
          : (t.storage &&
              g === br &&
              console.warn(
                `You are using a custom storage provider that may not support CryptoKey storage. If you are using a custom storage provider that does not support CryptoKey storage, you should use '${Er}' as the key type, as it can serialize to a string`,
              ),
            (c = await Ze.generate()),
            await d.set(oe, c.getKeyPair()))),
      new this(b, c, A, d, U, t)
    );
  }
  _registerDefaultIdleCallback() {
    var t, r;
    const o =
      (t = this._createOptions) === null || t === void 0
        ? void 0
        : t.idleOptions;
    !o?.onIdle &&
      !o?.disableDefaultIdleCallback &&
      ((r = this.idleManager) === null ||
        r === void 0 ||
        r.registerCallback(() => {
          this.logout(), location.reload();
        }));
  }
  async _handleSuccess(t, r) {
    var o, u;
    const d = t.delegations.map((A) => ({
        delegation: new en(
          A.delegation.pubkey,
          A.delegation.expiration,
          A.delegation.targets,
        ),
        signature: A.signature.buffer,
      })),
      g = Fe.fromDelegations(d, t.userPublicKey.buffer),
      c = this._key;
    if (!c) return;
    (this._chain = g),
      "toDer" in c
        ? (this._identity = Qe.fromDelegation(c, this._chain))
        : (this._identity = $n.fromDelegation(c, this._chain)),
      (o = this._idpWindow) === null || o === void 0 || o.close();
    const b =
      (u = this._createOptions) === null || u === void 0
        ? void 0
        : u.idleOptions;
    !this.idleManager &&
      !b?.disableIdle &&
      ((this.idleManager = Hn.create(b)), this._registerDefaultIdleCallback()),
      this._removeEventListener(),
      delete this._idpWindow,
      this._chain &&
        (await this._storage.set(Xt, JSON.stringify(this._chain.toJSON()))),
      r?.(t);
  }
  getIdentity() {
    return this._identity;
  }
  async isAuthenticated() {
    return (
      !this.getIdentity().getPrincipal().isAnonymous() && this._chain !== null
    );
  }
  async login(t) {
    var r, o, u, d;
    const g = BigInt(8) * BigInt(36e11),
      c = new URL(
        ((r = t?.identityProvider) === null || r === void 0
          ? void 0
          : r.toString()) || N0,
      );
    (c.hash = F0),
      (o = this._idpWindow) === null || o === void 0 || o.close(),
      this._removeEventListener(),
      (this._eventHandler = this._getEventHandler(
        c,
        Object.assign(
          {
            maxTimeToLive:
              (u = t?.maxTimeToLive) !== null && u !== void 0 ? u : g,
          },
          t,
        ),
      )),
      window.addEventListener("message", this._eventHandler),
      (this._idpWindow =
        (d = window.open(
          c.toString(),
          "idpWindow",
          t?.windowOpenerFeatures,
        )) !== null && d !== void 0
          ? d
          : void 0);
    const b = () => {
      this._idpWindow &&
        (this._idpWindow.closed
          ? this._handleFailure(R0, t?.onError)
          : setTimeout(b, v0));
    };
    b();
  }
  _getEventHandler(t, r) {
    return async (o) => {
      var u, d, g;
      if (o.origin !== t.origin) {
        console.warn(
          `WARNING: expected origin '${t.origin}', got '${o.origin}' (ignoring)`,
        );
        return;
      }
      const c = o.data;
      switch (c.kind) {
        case "authorize-ready": {
          const b = Object.assign(
            {
              kind: "authorize-client",
              sessionPublicKey: new Uint8Array(
                (u = this._key) === null || u === void 0
                  ? void 0
                  : u.getPublicKey().toDer(),
              ),
              maxTimeToLive: r?.maxTimeToLive,
              allowPinAuthentication: r?.allowPinAuthentication,
              derivationOrigin:
                (d = r?.derivationOrigin) === null || d === void 0
                  ? void 0
                  : d.toString(),
            },
            r?.customValues,
          );
          (g = this._idpWindow) === null ||
            g === void 0 ||
            g.postMessage(b, t.origin);
          break;
        }
        case "authorize-client-success":
          try {
            await this._handleSuccess(c, r?.onSuccess);
          } catch (b) {
            this._handleFailure(b.message, r?.onError);
          }
          break;
        case "authorize-client-failure":
          this._handleFailure(c.text, r?.onError);
          break;
      }
    };
  }
  _handleFailure(t, r) {
    var o;
    (o = this._idpWindow) === null || o === void 0 || o.close(),
      r?.(t),
      this._removeEventListener(),
      delete this._idpWindow;
  }
  _removeEventListener() {
    this._eventHandler &&
      window.removeEventListener("message", this._eventHandler),
      (this._eventHandler = void 0);
  }
  async logout(t = {}) {
    if (
      (await _r(this._storage),
      (this._identity = new gn()),
      (this._chain = null),
      t.returnTo)
    )
      try {
        window.history.pushState({}, "", t.returnTo);
      } catch {
        window.location.href = t.returnTo;
      }
  }
}
async function _r(e) {
  await e.remove(oe), await e.remove(Xt), await e.remove(S0);
}
const O0 = () =>
  L0.create({
    idleOptions: { disableIdle: !0, disableDefaultIdleCallback: !0 },
  });
onmessage = ({ data: e }) => {
  const { msg: t } = e;
  switch (t) {
    case "startIdleTimer":
      D0();
      return;
    case "stopIdleTimer":
      Yi();
      return;
  }
};
let qe;
const D0 = () => (qe = setInterval(async () => await P0(), hs)),
  Yi = () => {
    qe && (clearInterval(qe), (qe = void 0));
  },
  P0 = async () => {
    const [e, t] = await Promise.all([M0(), C0()]);
    if (e && t.valid && t.delegation !== null) {
      k0(t.delegation);
      return;
    }
    $0();
  },
  M0 = async () => (await O0()).isAuthenticated(),
  C0 = async () => {
    const t = await new zi().get(Xt),
      r = t !== null ? Fe.fromJSON(t) : null;
    return { valid: r !== null && Ci(r), delegation: r };
  },
  $0 = () => {
    Yi(), postMessage({ msg: "signOutIdleTimer" });
  },
  k0 = (e) => {
    const t = e.delegations[0]?.delegation.expiration;
    if (t === void 0) return;
    const r = new Date(Number(t / BigInt(1e6))).getTime() - Date.now();
    postMessage({
      msg: "delegationRemainingTime",
      data: { authRemainingTime: r },
    });
  };
