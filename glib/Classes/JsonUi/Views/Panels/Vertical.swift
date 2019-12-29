class JsonView_Panels_VerticalV1: JsonView {
    private let panel: GVerticalPanel

    required convenience init(_ spec: Json, _ screen: GScreen) {
        self.init(GVerticalPanel(), spec, screen)
    }

    private init(_ view: GVerticalPanel, _ spec: Json, _ screen: GScreen) {
        panel = view
        super.init(spec, screen)
    }

    override func initView() -> UIView {
        // NOTE: subviews property is deprecated
        let childViews = spec["subviews"].array ?? spec["childViews"].arrayValue
        let views: [UIView] = childViews.compactMap { viewSpec -> UIView? in
            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                return jsonView.createView()
            }
            return nil
        }

        setAlign()  // Needs to be called before adding child views
        setDistribution(childViews: views)

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
