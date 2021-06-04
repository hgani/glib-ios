#if INCLUDE_MDLIBS

class JsonView_Chip: JsonView {
    private let view = MChip()

    override func initView() -> UIView {
        view.text(spec["text"].stringValue)

        view.onClick { _ in
            JsonAction.execute(spec: self.spec["onClick"], screen: self.screen, creator: self.view)
        }

        return view
    }

    override func applyStyleClass(_ styleClass: String) {
        if let chipSpec = JsonUiStyling.chips[styleClass] {
            chipSpec.decorate(view)
        }
    }
}

#endif
