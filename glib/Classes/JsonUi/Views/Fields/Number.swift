class JsonView_Fields_NumberV1: JsonView_AbstractTextV1 {
    private var delegate: Delegate?
    private var field = MTextField()
    
    override func initView() -> UITextField {
        delegate = Delegate(self)

        if let mField = super.initTextField() as? MTextField {
            field = mField
        }
        field.delegate = delegate
        return field.keyboardType(.numberPad)
    }
    
    override func validate() -> Bool {
        field.becomeFirstResponder()
        return field.resignFirstResponder()
    }
    
    class Delegate: NSObject, UITextFieldDelegate {
        private var field: JsonView_Fields_NumberV1
        
        init(_ field: JsonView_Fields_NumberV1) {
            self.field = field
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            field.errors(nil)
            
            if let validation = field.spec["validation"].dictionary {
                if let required = validation["required"]?.presence {
                    if textField.text?.count ?? 0 <= 0 {
                        field.errors(required["message"].stringValue)
                        return false
                    }
                }
            }
            
            return true
        }
    }
}
