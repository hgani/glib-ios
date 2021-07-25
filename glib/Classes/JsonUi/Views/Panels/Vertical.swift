class JsonView_Panels_Vertical: JsonView_AbstractPanel {
    private var panel: GVerticalPanel!

    override func initView() -> UIView {
        panel = GVerticalPanel(containerHelper: container.helper)

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

        if let onClick = self.spec["onClick"].presence {
            panel.onClick({ _ in
                JsonAction.execute(spec: onClick, screen: self.screen, creator: self.panel)
            })
        }

        return initContainer(content: panel)
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
            // This manual implementation works for buttons, but not for panels
//            for view in childViews {
//                panel.addView(view, top: 0)
//            }
//            panel.split()

            let wrappedViews = childViews.map { view -> UIView in
                if let iview = view as? IView {
                    iview.height(.matchParent)
                } else {
                    fatalError("Non IView child is not supported")
                }
                return GAligner().align(.top).withView(view)
            }

            // https://makeapppie.com/2015/11/11/how-to-add-stack-views-programmatically-and-almost-avoid-autolayout/
            let stacker = GStackView()
                .width(.matchParent)
                .axis(.vertical)
                .distribution(.fillEqually)
                .withViews(wrappedViews)
            panel.addView(stacker, top: 0)
        case "spaceEqually":
            for view in childViews {
                panel.addView(GAligner().align(.left).withView(view), top: 0)
            }
            panel.split()
        default:
            for view in childViews {
                panel.addView(view, top: 0)
            }
        }
    }
}
