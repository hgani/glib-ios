#if INCLUDE_MDLIBS

public class MCardSpec {
    private var decorator: ((MCard) -> Void)

    public init(_ decorator: @escaping ((MCard) -> Void)) {
        self.decorator = decorator
    }

    func decorate(_ view: MCard) {
        decorator(view)
    }
}

#endif
