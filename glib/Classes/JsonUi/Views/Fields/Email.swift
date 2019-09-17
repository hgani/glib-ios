class JsonView_Fields_EmailV1: JsonView_AbstractTextV1 {
    override func initView() -> UITextField {
        return super.initTextField().keyboardType(.emailAddress)
    }

    override func validate() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)

        errors(nil)
        if let enteredEmail = text() {
            if !emailPredicate.evaluate(with: enteredEmail) {
                errors("E-mail must be valid")
                return false
            }
        }

        return true
    }
}
