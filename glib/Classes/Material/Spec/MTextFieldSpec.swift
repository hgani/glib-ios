#if INCLUDE_MDLIBS

public class MTextFieldSpec {
    private var decorator: ((MTextField) -> Void)

    public init(_ decorator: @escaping ((MTextField) -> Void)) {
        self.decorator = decorator
    }

    func decorate(_ view: MTextField) {
        decorator(view)
    }

    static let outlined = MTextFieldSpec { textField in
        // TODO
//        textField.controller(MDCTextInputControllerOutlined(textInput: textField),
//                             padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
    }

    static let filled = MTextFieldSpec { textField in
        // TODO
//        textField.controller(MDCTextInputControllerFilled(textInput: textField),
//                             padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
    }

    static let rounded = MTextFieldSpec { textField in
        // TODO
//        // Not supported yet, so use "outlined" instead
//        textField.controller(MDCTextInputControllerOutlined(textInput: textField),
//                             padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
    }
}

#endif
