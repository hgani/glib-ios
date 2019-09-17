class JsonView_Fields_NumberV1: JsonView_AbstractTextV1 {
    override func initView() -> UITextField {
        return super.initTextField().keyboardType(.numberPad)
    }
}
