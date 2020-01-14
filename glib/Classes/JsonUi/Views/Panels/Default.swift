class JsonViewDefaultPanel: JsonView, ParentPanel {
    let panel: GVerticalPanel

//    private let panel = GVerticalPanel().width(.matchParent)

    required convenience init(_ spec: Json, _ screen: GScreen) {
        self.init(GVerticalPanel(), spec, screen)
    }

    init(_ view: GVerticalPanel, _ spec: Json, _ screen: GScreen) {
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
            panel.addView(view)
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

    static func createPanel(spec: Json, screen: GScreen) -> GVerticalPanel {
        let component = JsonViewDefaultPanel(spec, screen)
        component.createView()
        return component.panel
    }
}
