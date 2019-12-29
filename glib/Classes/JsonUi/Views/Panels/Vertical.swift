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
                #if INCLUDE_MDLIBS

                if let fabJsonView = jsonView as? JsonView_FabV1 {
                    fabView = fabJsonView
                } else {
                    subviews.append(jsonView.createView())
                }

                #endif
            }
        }

        setAlign()  // Needs to be called before adding child views
        setDistribution(childViews: subviews)

        if let fabJsonView = fabView {
            let view = fabJsonView.createView()
            panel.addView(view, top: 0, skipConstraint: true)
            fabJsonView.afterViewAdded(parentView: panel)
            ScrollableView.items.append(view)
        }

        return panel
    }

    private func setAlign() {
        panel.align(getGravity())
    }

    private func getGravity() -> GAligner.GAlignerHorizontalGravity {
        switch spec["align"].stringValue {
        case "center":
            return .center
        case "right":
            return .right
        default:
            return .left
        }
    }
    private func setDistribution(childViews: [UIView]) {
        switch spec["distribution"].stringValue {
        case "fillEqually":
            for view in childViews {
                panel.addView(view)
            }
            panel.split()
        case "spaceEqually":
            for view in childViews {
                panel.addView(GAligner().align(.left).withView(view))
            }
            panel.split()
        default:
            for view in childViews {
                panel.addView(view)
            }
        }
    }
}
