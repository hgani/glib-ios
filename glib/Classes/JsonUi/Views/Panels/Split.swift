//class JsonView_Panels_Split: JsonView {
class JsonView_Panels_Split: JsonView_AbstractPanel {

    // It makes no sense to use split panel with `wrapContent`, so `wrapContent` is not supported in iOS.
    // Use either `matchParent` (default in iOS) or specific width.
//    private let panel: ISplitPanel & UIView
    
//    private var panel: GSplitPanel!
    private let panel = GSplitPanel()

//    public required init(_ spec: Json, _ screen: GScreen) {
//        if let styleClasses = spec["styleClasses"].array, styleClasses.contains("card") {
//            // TODO
////            #if INCLUDE_MDLIBS
////            panel = MSplitCard().applyStyles(spec).width(.matchParent)
////            #else
////            panel = GSplitPanel().width(.matchParent)
////            #endif
//
//            panel = GSplitPanel().width(.matchParent)
//        } else {
//            panel = GSplitPanel().width(.matchParent)
//        }
//        super.init(spec, screen)
//    }

    override func initView() -> UIView {
        if let center = spec["center"].presence {
            panel.withViews(
                createSubview(spec["left"], center: false),
                createSubview(center, center: true),
                createSubview(spec["right"], center: false)
            )
        } else {
            panel.withViews(
                left: createSubview(spec["left"], center: false),
                right: createSubview(spec["right"], center: false)
            )
        }

        return initContainer(content: panel)
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
