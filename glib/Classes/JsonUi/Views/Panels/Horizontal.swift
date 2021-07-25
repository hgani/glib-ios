class JsonView_Panels_Horizontal: JsonView_AbstractPanel {
    private var panel: GHorizontalPanel!
    
    override func initView() -> UIView {
        panel = GHorizontalPanel(containerHelper: container.helper)

        // NOTE: subviews property is deprecated
        let childViews = spec["subviews"].array ?? spec["childViews"].arrayValue
        let views: [UIView] = childViews.compactMap { viewSpec -> UIView? in
            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                return jsonView.view()
            }
            return nil
        }

        setAlign()  // Needs to be called before adding child views
        setDistribution(childViews: views)

        return initContainer(content: panel)
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
            // This manual implementation works for buttons, but not for panels
//            for view in childViews {
//                panel.addView(view, left: 0)
//            }
//            panel.split()

            let wrappedViews = childViews.map { view -> UIView in
                if let iview = view as? IView {
                    iview.width(.matchParent)
                } else {
                    fatalError("Non IView child is not supported")
                }
                return GAligner().align(.top).withView(view)
            }
            let stacker = GStackView()
                .height(.matchParent)
                .axis(.horizontal)
                .distribution(.fillEqually)
                .withViews(wrappedViews)
            panel.addView(stacker, left: 0)
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

    override func applyStyleClass(_ styleClass: String) {
        if let cardSpec = JsonUiStyling.panels[styleClass] {
            cardSpec.decorate(container)
        }
    }
}
