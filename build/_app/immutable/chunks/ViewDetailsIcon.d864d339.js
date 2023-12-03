import {
  m as C,
  H as c,
  s as f,
  S as h,
  a1 as i,
  n as l,
  i as m,
  a2 as o,
  h as r,
  b as u,
  G as v,
} from "./index.a8c54947.js";
function d(n) {
  let s, t;
  return {
    c() {
      (s = i("svg")), (t = i("path")), this.h();
    },
    l(e) {
      s = o(e, "svg", { xmlns: !0, class: !0, fill: !0, viewBox: !0 });
      var a = C(s);
      (t = o(a, "path", { d: !0, fill: !0 })),
        C(t).forEach(r),
        a.forEach(r),
        this.h();
    },
    h() {
      l(
        t,
        "d",
        "M11.998 5C7.92 5 4.256 8.093 2.145 11.483C2.049 11.642 2 11.821 2 12C2 12.179 2.048 12.358 2.144 12.517C4.256 15.907 7.92 19 11.998 19C16.141 19 19.794 15.91 21.862 12.507C21.954 12.351 22 12.175 22 12C22 11.825 21.954 11.649 21.862 11.493C19.794 8.09 16.141 5 11.998 5ZM20.411 12C18.574 14.878 15.514 17.5 11.998 17.5C8.533 17.5 5.466 14.868 3.594 12C5.465 9.132 8.533 6.5 11.998 6.5C15.516 6.5 18.577 9.124 20.411 12ZM12 8C14.208 8 16 9.792 16 12C16 14.208 14.208 16 12 16C9.792 16 8 14.208 8 12C8 9.792 9.792 8 12 8ZM12 9.5C10.62 9.5 9.5 10.62 9.5 12C9.5 13.38 10.62 14.5 12 14.5C13.38 14.5 14.5 13.38 14.5 12C14.5 10.62 13.38 9.5 12 9.5Z"
      ),
        l(t, "fill", "#2CE3A6"),
        l(s, "xmlns", "http://www.w3.org/2000/svg"),
        l(s, "class", n[0]),
        l(s, "fill", "currentColor"),
        l(s, "viewBox", "0 0 24 24");
    },
    m(e, a) {
      u(e, s, a), v(s, t);
    },
    p(e, [a]) {
      a & 1 && l(s, "class", e[0]);
    },
    i: c,
    o: c,
    d(e) {
      e && r(s);
    },
  };
}
function p(n, s, t) {
  let { className: e = "" } = s;
  return (
    (n.$$set = (a) => {
      "className" in a && t(0, (e = a.className));
    }),
    [e]
  );
}
class _ extends h {
  constructor(s) {
    super(), m(this, s, p, d, f, { className: 0 });
  }
}
export { _ as V };
