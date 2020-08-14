class JsonView_Fields_Hidden: JsonView_AbstractText {
    override func initView() -> UITextField {
        return super.initTextField().width(0).height(0)
    }
}
