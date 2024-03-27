module {
    public class Random(
        _next: () -> [Nat8]
    ) {
        public let next = _next;
    };
}