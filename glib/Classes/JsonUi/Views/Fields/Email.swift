class JsonView_Fields_Email: JsonView_AbstractText {
    override func initView() -> UIView {
        return super.initTextField()
            .keyboardType(.emailAddress)
            .autocapitalizationType(.none)
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
