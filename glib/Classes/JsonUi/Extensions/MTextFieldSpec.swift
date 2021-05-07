#if INCLUDE_MDLIBS

import MaterialComponents.MaterialTextFields

extension MTextFieldSpec {
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
