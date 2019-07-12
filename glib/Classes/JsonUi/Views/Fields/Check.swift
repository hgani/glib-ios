class JsonView_Fields_CheckV1: JsonView, SubmittableField {
    private let panel = GSplitPanel().width(.matchParent)
    private let switchView = GSwitch()

    var name: String?
    var value: String {
        return switchView.isOn ? "1" : "0"
    }

    override func initView() -> UIView {
        name = spec["name"].string

        return panel.withViews(
            left: GLabel().text(spec["label"].stringValue),
            right: switchView.checked(spec["value"].stringValue == "1")
        )
    }
}
