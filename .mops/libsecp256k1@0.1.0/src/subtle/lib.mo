import Nat8 "mo:base/Nat8";

module {
    public class Choice() {
        public var v: Nat8 = 0;

        public func clone(): Choice {
            let ret = Choice();
            ret.v := v;
            ret
        };
        
        public func unwrap_u8(): Nat8 {
            v
        };

        public func bitand(rhs: Choice): Choice {
            into(v & rhs.v)
        };

        public func bitand_assign(rhs: Choice) {
            v := v & rhs.v;
        };

        public func bitor(rhs: Choice): Choice {
            into(v | rhs.v)
        };

        public func bitor_assign(rhs: Choice) {
            v := v | rhs.v;
        };

        public func bitxor(rhs: Choice): Choice {
            into(v ^ rhs.v)
        };

        public func bitxor_assign(rhs: Choice) {
            v := v ^ rhs.v;
        };

        public func no(): Choice {
            into(1 & (^v))
        };
    };   

    public func from(source: Choice): Bool {
        assert((source.v == 0) or (source.v == 1));
        source.v != 0
    };

    public func into(value: Nat8): Choice {
        let ret = Choice();
        ret.v := value;
        ret
    };

};