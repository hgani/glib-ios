#if INCLUDE_MDLIBS

class JsonView_AbstractButton: JsonView {
    let button = MButton()
        .font(RobotoFonts.Style.regular.font, size: 15)

//        private let view = GButton()
//            .color(bg: nil, text: .darkGray)
//            .border(color: .darkGray)
//            .font(nil, size: 12)

    override func initView() -> UIView {
        if let icon = JsonView_Icon.icon(spec: spec["icon"]) {
            button.icon(icon)
        }

        ifColor(code: spec["color"].string) {
            button.color(bg: nil, text: $0)
        }

        if let text = spec["text"].string {
            button.title(text)
        }
        button.onClick { _ in
            JsonAction.execute(spec: self.spec["onClick"], screen: self.screen, creator: self.button)
        }

        Generic.sharedInstance.genericIsBusy.asObservable().subscribe { _ in
            self.button.enabled(!Generic.sharedInstance.genericIsBusy.value)
        }

        return button
    }

    override func applyStyleClass(_ styleClass: String) {
        if let buttonSpec = JsonUiStyling.buttons[styleClass] {
            buttonSpec.decorate(button)
        }
    }
}
#endif
