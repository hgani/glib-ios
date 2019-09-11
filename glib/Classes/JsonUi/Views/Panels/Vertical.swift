class JsonView_Panels_VerticalV1: JsonView {
    private let panel: GVerticalPanel

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
        var subviews = [UIView]()

        for viewSpec in childViews {
            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                if let fabJsonView = jsonView as? JsonView_FabV1 {
                    fabView = fabJsonView
                } else {
                    subviews.append(jsonView.createView())
                }
            }
        }

        switch spec["distribution"].stringValue {
        case "fillEqually":
            for view in subviews {
                panel.addView(view)
            }
            panel.split()
        case "spaceEqually":
            for view in subviews {
                panel.addView(GAligner().align(.left).withView(view))
            }
            panel.split()
        default:
            for view in subviews {
                panel.addView(view)
            }
        }

        if let fabJsonView = fabView {
            let view = fabJsonView.createView()
            panel.addView(view, top: 0, skipConstraint: true)
            fabJsonView.afterViewAdded(parentView: panel)
            ScrollableView.items.append(view)
        }

//        let subviews: [UIView] = childViews.compactMap { viewSpec -> UIView? in
//            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
//                return jsonView.createView()
//            }
//            return nil
//        }
//
//        switch spec["distribution"].stringValue {
//        case "fillEqually":
//            for view in subviews {
//                panel.addView(view)
//            }
//            panel.split()
//        case "spaceEqually":
//            for view in subviews {
//                panel.addView(GAligner().align(.left).withView(view))
//            }
//            panel.split()
//        default:
//            for view in subviews {
//                panel.addView(view)
//            }
//        }

        return panel
    }
}
