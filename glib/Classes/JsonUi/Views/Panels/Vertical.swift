class JsonView_Panels_Vertical: JsonView_AbstractPanel {
//    private let panel: IVerticalPanel & UIView
    private let panel = GVerticalPanel()

    public required init(_ spec: Json, _ screen: GScreen) {
        // TODO: Improve this
        // Move to a reusable parent class
//        if let styleClasses = spec["styleClasses"].array, styleClasses.contains("card") {
//            #if INCLUDE_MDLIBS
//            panel = MCard().applyStyles(spec)
//            #else
//            panel = GVerticalPanel()
//            #endif
//        } else {
//            panel = GVerticalPanel()
//        }
        super.init(spec, screen)
    }

    override func initView() -> UIView {
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

protocol IVerticalPanel {
    func addView(_ view: UIView, top: Float) -> Void
    func align(_ align: GAligner.GAlignerHorizontalGravity) -> Self
    func split() -> Self
    func addConstraintlessView(_ child: UIView) -> Void
    func width(_ width: Int) -> Self
    func width(_ width: LayoutSize) -> Self
}
