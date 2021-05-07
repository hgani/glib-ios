class JsonView_Button: JsonView {
    // NOTE: Library clients can register their own style classes here
    public static var styleSpecs: [String: MButtonSpec] = [
        "link": .link,
        "icon": .icon
    ]

    #if INCLUDE_MDLIBS
        private let view = MButton()
            .font(RobotoFonts.Style.regular.font, size: 15)
    #else
        private let view = GButton()
            .color(bg: nil, text: .darkGray)
            .border(color: .darkGray)
            .font(nil, size: 12)
    #endif

    override func initView() -> UIView {
        if let icon = JsonView_Icon.icon(spec: spec["icon"]) {
            view.icon(icon)
        }

        ifColor(code: spec["color"].string) {
            view.color(bg: nil, text: $0)
        }

        if let text = spec["text"].string {
            _ = view.title(text)
        }
        _ = view.onClick { _ in
            JsonAction.execute(spec: self.spec["onClick"], screen: self.screen, creator: self.view)
        }

        #if INCLUDE_MDLIBS
        Generic.sharedInstance.genericIsBusy.asObservable().subscribe { _ in
            self.view.enabled(!Generic.sharedInstance.genericIsBusy.value)
        }
        #endif

        return view
    }

    override func applyStyleClass(_ styleClass: String) {
        if let buttonSpec = type(of: self).styleSpecs[styleClass] {
            buttonSpec.decorate(view)
        }

//        if let klass = JsonUi.loadClass(name: styleClass, type: MButtonSpecProtocol.self) as? MButtonSpecProtocol.Type {
//            let spec = klass.init()
//            spec.createSpec().decorate(view)
//        } else {
//            switch styleClass {
//            case "link":
//                view.specs(.link)
//            case "icon":
//                view.specs(.icon(JsonView_Icon.icon(spec: spec["icon"])))
////                view.layer.cornerRadius = 18
//            default:
//                GLog.e("Invalid style \(styleClass)")
//            }
//        }
    }
}
