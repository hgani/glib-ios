import MBCheckboxButton

class JsonView_Fields_CheckV1: JsonView, SubmittableField {
    private let checkbox = MCheckBox()

    var name: String?
    var value: String {
        return checkbox.isOn ? spec["value"].stringValue : (spec["uncheckValue"].string ?? "")
    }

    override func initView() -> UIView {
        self.name = spec["name"].string

        return checkbox
            .width(.matchParent)
            .title(spec["label"].stringValue)
    }
}

class MCheckBox: CheckboxButton {
    fileprivate var helper: ViewHelper!

    init() {
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        helper = ViewHelper(self)
    }

    public func width(_ width: Int) -> Self {
        helper.width(width)
        return self
    }

    public func width(_ width: LayoutSize) -> Self {
        helper.width(width)
        return self
    }

    public func height(_ height: Int) -> Self {
        helper.height(height)
        return self
    }

    public func height(_ height: LayoutSize) -> Self {
        helper.height(height)
        return self
    }

    func title(_ str: String) -> Self {
        setTitle(str, for: [])
        setTitleColor(.black, for: [])
        return self
    }
}

//class JsonView_Fields_CheckV1: JsonView, SubmittableField {
//    private let panel = GSplitPanel().width(.matchParent)
//    private let switchView = GSwitch()
//
//    var name: String?
//    var value: String {
//        return switchView.isOn ? "1" : "0"
//    }
//
//    override func initView() -> UIView {
//        name = spec["name"].string
//
//        return panel.withViews(
//            left: GLabel().text(spec["label"].stringValue),
//            right: switchView.checked(spec["value"].stringValue == "1")
//        )
//    }
//}
