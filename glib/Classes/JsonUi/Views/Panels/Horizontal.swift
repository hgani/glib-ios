class JsonView_Panels_Horizontal: JsonView_AbstractPanel {
    private var panel: GHorizontalPanel!

//    public required init(_ spec: Json, _ screen: GScreen) {
////        if let styleClasses = spec["styleClasses"].array, styleClasses.contains("card") {
////            #if INCLUDE_MDLIBS
////            panel = MHorizontalCard().applyStyles(spec)
////            #else
////            panel = GHorizontalPanel()
////            #endif
////        } else {
////            panel = GHorizontalPanel()
////        }
//        super.init(spec, screen)
////        panel = GHorizontalPanel(helper: container.helper)
//    }
    
    override func initView() -> UIView {
        panel = GHorizontalPanel(wrapperHelper: container.helper)

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

//            let wrappedViews = childViews.map { view -> UIView in
//                if let iview = view as? IView {
//                    iview.height(.matchParent)
//                } else {
//                    fatalError("Non IView child is not supported")
//                }
//                return GAligner().align(.top).withView(view)
//            }
//
//            let stacker = GStackView()
//                .width(.matchParent)
//                .axis(.vertical)
//                .distribution(.fillEqually)
//                .withViews(wrappedViews)
////            panel.addTestView(stacker, top: 0)
////            panel.height(.matchParent).addView(stacker, left: 0)
//            panel.addView(stacker, left: 0)

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
