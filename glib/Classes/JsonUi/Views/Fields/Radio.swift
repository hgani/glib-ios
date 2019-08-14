class JsonView_Fields_RadioV1: JsonView {
    private let panel = GHorizontalPanel()
    private let gSwitch = GSwitch()

    var value: String? = nil

    override func initView() -> UIView {
        value = spec["value"].stringValue

        return panel
            .append(GAligner().align(.left).withView(gSwitch))
            .append(GLabel().text(spec["label"].stringValue), left: 10)
    }

    public func checked(_ checked: Bool) {
        gSwitch.checked(checked)
    }

    public func onClick(_ command: @escaping (GSwitch) -> Void) {
        gSwitch.onClick(command)
    }
}
