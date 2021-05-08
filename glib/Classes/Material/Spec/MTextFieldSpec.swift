#if INCLUDE_MDLIBS

public class MTextFieldSpec {
    private var decorator: ((MTextField) -> Void)

    public init(_ decorator: @escaping ((MTextField) -> Void)) {
        self.decorator = decorator
    }

    func decorate(_ view: MTextField) {
        decorator(view)
    }

//    static let outlined = MTextFieldSpec { textField in
//        textField.outlined()
//    }
//
//    static let filled = MTextFieldSpec { textField in
//        // Nothing to do. This is the default.
//    }

    static let rounded = MTextFieldSpec { textField in
        textField.rounded()
    }
}

#endif
