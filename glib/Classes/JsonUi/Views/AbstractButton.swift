class JsonView_AbstractButton: JsonView {
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
            view.title(text)
        }
        view.onClick { _ in
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
        if let buttonSpec = JsonUiStyling.buttons[styleClass] {
            buttonSpec.decorate(view)
        }
    }
}
