#if INCLUDE_MDLIBS

class JsonView_Fields_Number: JsonView_AbstractText {
//    private var delegate: Delegate?
//    private var field: UITextField!

    override func initView() -> UIView {
//        delegate = Delegate(self)

        let field = super.initTextField()
        field.keyboardType(.numberPad)
//        field.delegate = delegate
        return field
    }

//    override func validate() -> Bool {
//        field.becomeFirstResponder()
//        return field.resignFirstResponder()
//    }

//    class Delegate: NSObject, UITextFieldDelegate {
//        private var field: JsonView_Fields_Number
//
//        init(_ field: JsonView_Fields_Number) {
//            self.field = field
//        }
//
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//        {
//            let allowedCharacters = CharacterSet.decimalDigits
//            let characterSet = CharacterSet(charactersIn: string)
//            return allowedCharacters.isSuperset(of: characterSet)
//        }
//
//        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//            field.errors(nil)
//
//            if let validation = field.spec["validation"].dictionary, let text = textField.text {
//                if let required = validation["required"]?.presence {
//                    if text.count ?? 0 <= 0 {
//                        field.errors(required["message"].stringValue)
//                    }
//                }
//            }
//
//            return true
//        }
//    }
}

#endif
