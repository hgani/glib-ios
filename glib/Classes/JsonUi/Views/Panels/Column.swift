class JsonView_Panels_Column: JsonViewDefaultPanel {
    override func initView() -> UIView {
        super.initView()
        return panel.width(.matchParent)
    }
}
