class JsonView_Fields_Hidden: JsonView_AbstractText {
    override func initView() -> UIView {
        return super.initTextField().width(0).height(0)
    }
}
