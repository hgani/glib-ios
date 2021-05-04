class JsonView_Panels_Horizontal: JsonView {
    private let panel: IHorizontalPanel & UIView
    
    public required init(_ spec: Json, _ screen: GScreen) {
        if let styleClasses = spec["styleClasses"].array, styleClasses.contains("card") {
            #if INCLUDE_MDLIBS
            panel = MHorizontalCard().applyStyles(spec)
            #else
            panel = GHorizontalPanel()
            #endif
        } else {
            panel = GHorizontalPanel()
        }
        super.init(spec, screen)
    }
    
    override func initView() -> UIView {
        // NOTE: subviews property is deprecated
        let childViews: [UIView] = (spec["subviews"].array ?? spec["childViews"].arrayValue).compactMap { viewSpec -> UIView? in
            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                return jsonView.view()
            }
            return nil
        }
        
        setAlign()  // Needs to be called before adding child views
        setDistribution(childViews: childViews)

        return panel
    }

    private func setAlign() {
        panel.align(getGravity())
    }

    private func getGravity() -> GAligner.GAlignerVerticalGravity {
        switch spec["align"].stringValue {
        case "middle":
            return .middle
        case "bottom":
            return .bottom
        default:
            return .top
        }
    }

    private func setDistribution(childViews: [UIView]) {
        switch spec["distribution"].stringValue {
        case "fillEqually":
            for view in childViews {
                panel.addView(view, left: 0)
            }
            panel.split()
        case "spaceEqually":
            for view in childViews {
                panel.addView(GAligner().align(.top).withView(view), left: 0)
            }
            panel.split()
        default:
            for view in childViews {
                panel.addView(view, left: 0)
            }
        }
    }
}

protocol IHorizontalPanel {
    func addView(_ child: UIView, left: Float)
    func split() -> Self
    func align(_ align: GAligner.GAlignerVerticalGravity) -> Self
}
