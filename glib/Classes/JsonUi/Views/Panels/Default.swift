class JsonViewDefaultPanel: JsonView, ParentPanel {
//    let panel: GVerticalPanel
    let panel: IVerticalPanel & UIView

//    private let panel = GVerticalPanel().width(.matchParent)

    required convenience init(_ spec: Json, _ screen: GScreen) {
        if let styleClasses = spec["styleClasses"].array, styleClasses.contains("card") {
            #if INCLUDE_MDLIBS
            let panel = MCard().applyStyles(spec)
            self.init(panel, spec, screen)
            #else
            self.init(GVerticalPanel(), spec, screen)
            #endif
        } else {
            self.init(GVerticalPanel(), spec, screen)
        }
    }

    init(_ view: IVerticalPanel & UIView, _ spec: Json, _ screen: GScreen) {
        panel = view
        super.init(spec, screen)
    }

    override func initView() -> UIView {
        // NOTE: subviews property is deprecated
        let childViews = spec["subviews"].array ?? spec["childViews"].arrayValue
        var fabView: JsonView?
        var views = [UIView]()
        for viewSpec in childViews {
            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                if let fabJsonView = jsonView as? JsonView_FabV1 {
                    fabView = fabJsonView
                } else {
                    addView(jsonView, to: panel)

//                    views.append(jsonView.createView())
                }
            }
        }

        for view in views {
            panel.addView(view, top: 0)
        }

        // Need to be added last
        if let fabJsonView = fabView {
//            let view = fabJsonView.createView()
//            panel.addView(view, top: 0, skipConstraint: true)
//            fabJsonView.afterViewAdded(parentView: panel)
//            ScrollableView.register(fab: view)

            let view = addConstraintlessView(fabJsonView, to: panel)
            ScrollableView.register(fab: view)
        }

        return panel
    }

    static func createPanel(spec: Json, screen: GScreen) -> IVerticalPanel & UIView {
        let component = JsonViewDefaultPanel(spec, screen)
        component.createView()
        return component.panel
    }
}
