class JsonView_Panels_Split: JsonView {
    // It makes no sense to use split panel with `wrapContent`, so `wrapContent` is not supported in iOS.
    // Use either `matchParent` (default in iOS) or specific width.
    private let panel: ISplitPanel & UIView
    
    public required init(_ spec: Json, _ screen: GScreen) {
        if let styleClasses = spec["styleClasses"].array, styleClasses.contains("card") {
            #if INCLUDE_MDLIBS
            panel = MSplitCard().applyStyles(spec).width(.matchParent)
            #else
            panel = GSplitPanel().width(.matchParent)
            #endif
        } else {
            panel = GSplitPanel().width(.matchParent)
        }
        super.init(spec, screen)
    }

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

        return panel
    }

    private func createSubview(_ subviewSpec: Json, center: Bool) -> UIView {
        if subviewSpec.isNull {
            return GView().width(0)
        }
        
        return JsonViewDefaultPanel.createPanel(spec: subviewSpec, screen: screen)
    }
}

protocol ISplitPanel {
    func withViews(_ left: UIView, _ center: UIView, _ right: UIView) -> Self
    func withViews(left: UIView, right: UIView) -> Self
}
