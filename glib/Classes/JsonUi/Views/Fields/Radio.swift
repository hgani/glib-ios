import MBRadioButton

class JsonView_Fields_RadioV1: JsonView, RadioButtonDelegate {
    private let radio = MRadio()
    private var onClick: ((JsonView_Fields_RadioV1) -> Void)?
    
    var value: String {
        return radio.isOn ? spec["value"].stringValue : ""
    }

    override func initView() -> UIView {
        return radio.delegate(self)
            .width(.matchParent)
            .title(spec["label"].stringValue)
    }

    public func checked(_ checked: Bool) {
        radio.isOn = checked
    }

    public func onClick(_ command: @escaping (JsonView_Fields_RadioV1) -> Void) {
        onClick = command
    }

    func radioButtonDidSelect(_ button: RadioButton) {
        if let callback = self.onClick {
            callback(self)
        }
    }

    func radioButtonDidDeselect(_ button: RadioButton) {}
}

class MRadio: RadioButton {
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
        titleLabel?.font = RobotoFonts.Style.regular.font
        return self
    }

    func delegate(_ delegate: RadioButtonDelegate) -> Self {
        self.delegate = delegate
        return self
    }
}

//class JsonView_Fields_RadioV1: JsonView {
//    private let panel = GHorizontalPanel()
//    private let gSwitch = GSwitch()
//
//    var value: String? = nil
//
//    override func initView() -> UIView {
//        value = spec["value"].stringValue
//
//        return panel
//            .append(gSwitch)
//            .append(GLabel().text(spec["label"].stringValue), left: 10)
//    }
//
//    public func checked(_ checked: Bool) {
//        gSwitch.checked(checked)
//    }
//
//    public func onClick(_ command: @escaping (GSwitch) -> Void) {
//        gSwitch.onClick(command)
//    }
//}
