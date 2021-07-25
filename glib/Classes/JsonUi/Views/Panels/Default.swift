class JsonViewDefaultPanel: JsonView_AbstractPanel {
    // TODO: Initialize right away
    let panel: GVerticalPanel
//    let panel: UIView

//    private let panel = GVerticalPanel().width(.matchParent)

    required convenience init(_ spec: Json, _ screen: GScreen) {
        // TODO: Use MCard. See GVerticalPanel
//        if let styleClasses = spec["styleClasses"].array, styleClasses.contains("card") {
//            #if INCLUDE_MDLIBS
//            let panel = MCard().applyStyles(spec)
//            self.init(panel, spec, screen)
//            #else
//            self.init(GVerticalPanel(), spec, screen)
//            #endif
//        } else {
//            self.init(GVerticalPanel(), spec, screen)
//        }
        self.init(GVerticalPanel(), spec, screen)
    }

    private init(_ view: GVerticalPanel, _ spec: Json, _ screen: GScreen) {
        panel = view
        super.init(spec, screen)
    }

    override func initView() -> UIView {
        // NOTE: subviews property is deprecated
        let childViews = spec["subviews"].array ?? spec["childViews"].arrayValue
        var fabView: JsonView?
//        var views = [UIView]()
        for viewSpec in childViews {
            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                if let fabJsonView = jsonView as? JsonView_Fab {
                    fabView = fabJsonView
                } else {
//                    panel.addView(view, top: 0)
//                    parent.addView(view, top: 0)
//                    addView(jsonView, to: panel)

                    // TODO
                    panel.addView(jsonView.createView(), top: 0)
                }
            }
        }

//        for view in views {
//            panel.addView(view, top: 0)
//        }

        // Need to be added last
        if let fabJsonView = fabView {
//            let view = fabJsonView.createView()
//            panel.addView(view, top: 0, skipConstraint: true)
//            fabJsonView.afterViewAdded(parentView: panel)
//            ScrollableView.register(fab: view)

//            let view = addConstraintlessView(fabJsonView, to: panel)

            let view = fabJsonView.createView()
            panel.addConstraintlessView(view)
            ScrollableView.register(fab: view)
        }

        return initContainer(content: panel)
//        return panel
    }

//    static func createPanel(spec: Json, screen: GScreen) -> IVerticalPanel & UIView {
    static func createPanel(spec: Json, screen: GScreen) -> UIView {
        let component = JsonViewDefaultPanel(spec, screen)
        component.view()
        return component.container
    }
}
