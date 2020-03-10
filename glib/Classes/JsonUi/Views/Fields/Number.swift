class JsonView_Fields_NumberV1: JsonView_AbstractTextV1 {
    private var delegate: Delegate?
    
    override func initView() -> UITextField {
        delegate = Delegate()
        
        let numberField = super.initTextField()
        numberField.delegate = delegate
        return numberField.keyboardType(.numberPad)
    }
    
    class Delegate: NSObject, UITextFieldDelegate {
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
    }
}
