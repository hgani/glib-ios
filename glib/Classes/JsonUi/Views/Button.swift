class JsonView_ButtonV1: JsonView {
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
        if let text = spec["text"].string {
            _ = view.title(text)
        }
        _ = view.onClick { _ in
            JsonAction.execute(spec: self.spec["onClick"], screen: self.screen, creator: self.view)
        }

        #if INCLUDE_MDLIBS
        if let styleClasses = spec["styleClasses"].array {
            for style in styleClasses {
                switch style {
                case "link":
                    view.specs(.link)
                case "icon":
                    view.specs(.icon(code: spec["icon"]["name"].stringValue))
                default:
                    if let klass = JsonUi.loadClass(name: style.stringValue, type: MButtonSpecProtocol.self) as? MButtonSpecProtocol.Type {
                        let spec = klass.init()
                        spec.createSpec().decorate(view)
                    }
                    else {
                        fatalError("Invalid style \(style)")
                    }
                }
            }
        }

        Generic.sharedInstance.genericIsBusy.asObservable().subscribe { _ in
            self.view.enabled(!Generic.sharedInstance.genericIsBusy.value)
        }
        #endif
        
        return view
    }
}
