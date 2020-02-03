class JsonView_Panels_SplitV1: JsonView {
    // It makes no sense to use split panel with `wrapContent`, so `wrapContent` is not supported in iOS.
    // Use either `matchParent` (default in iOS) or specific width.
    private let panel = GSplitPanel().width(.matchParent)

    override func initView() -> UIView {
        if let center = spec["center"].presence {
            return panel.withViews(
                createSubview(spec["left"], center: false),
                createSubview(center, center: true),
                createSubview(spec["right"], center: false)
            )
        } else {
            return panel.withViews(
                left: createSubview(spec["left"], center: false),
                right: createSubview(spec["right"], center: false)
            )
        }
    }

    private func createSubview(_ subviewSpec: Json, center: Bool) -> UIView {
        if subviewSpec.isNull {
            return GView().width(0)
        }

        return JsonViewDefaultPanel.createPanel(spec: subviewSpec, screen: screen)
    }
}
