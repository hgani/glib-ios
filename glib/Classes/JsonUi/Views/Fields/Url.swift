class JsonView_Fields_UrlV1: JsonView_AbstractTextV1 {
    override func initView() -> UITextField {
        return super.initTextField().keyboardType(.URL)
    }

    override func validate() -> Bool {
        let urlFormat = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlPredicate = NSPredicate(format:"SELF MATCHES %@", urlFormat)

        errors(nil)
        if let enteredUrl = text() {
            if !urlPredicate.evaluate(with: enteredUrl) {
                errors("must be valid URL")
                return false
            }
        }

        return true
    }
}
