class JsonView_Button: JsonView_AbstractButton {
    override func initView() -> UIView {
        let view = super.initView()
        applyStyleClass("button")
        return view
    }
}
