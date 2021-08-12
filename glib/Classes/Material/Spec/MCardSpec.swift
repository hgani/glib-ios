#if INCLUDE_MDLIBS

public class MCardSpec {
    private var decorator: ((MCard, UIView) -> Void)

    public init(_ decorator: @escaping ((MCard, UIView) -> Void)) {
        self.decorator = decorator
    }

    func decorate(container: MCard, contentPanel: UIView) {
        decorator(container, contentPanel)
    }
}

#endif
