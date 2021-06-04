#if INCLUDE_MDLIBS

public class MButtonSpec {
    private var decorator: ((MButton) -> Void)

    public init(_ decorator: @escaping ((MButton) -> Void)) {
        self.decorator = decorator
    }

    func decorate(_ view: MButton) {
        decorator(view)
    }

    static let link = MButtonSpec { button in
        button.color(bg: .clear, text: UIColor(hex: "#1976d2"))
    }

    static let icon = MButtonSpec { button in
        button.layer.cornerRadius = 18
    }
}

#endif
