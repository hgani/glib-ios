class JsonView_Panels_SplitV1: JsonView {
    private let panel = GSplitPanel().width(.matchParent)

    override func initView() -> UIView {
//        GLog.d("======")
//        GLog.d(spec.debugDescription)
//        GLog.d("======")
//        let content = spec["content"]
        if let center = spec["centerViews"].presence {
            return panel.withViews(
                createSubview(spec["leftViews"], center: false),
                createSubview(center, center: true),
                createSubview(spec["rightViews"], center: false)
            )
        } else {
            return panel.withViews(
                left: createSubview(spec["leftViews"], center: false),
                right: createSubview(spec["rightViews"], center: false)
            )
        }
    }

    private func createSubview(_ subviewSpec: Json, center: Bool) -> UIView {
        if subviewSpec.isNull {
            return GView().width(0)
        }

//        let view = JsonView.create(spec: subviewSpec, screen: screen)?.createView() ?? UIView()
//        if center, let iview = view as? IView {
//            // Make sure the center view doesn't stretch up until the right of the container.
//            // Let the split view stretch it only up until the left of the right component.
//            iview.width(.wrapContent)
//        }
//        return view

        let panel = GVerticalPanel()
        let childViews = subviewSpec.arrayValue
        let subviews: [UIView] = childViews.compactMap { viewSpec -> UIView? in
            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                return jsonView.createView()
            }
            return nil
        }

        for view in subviews {
            panel.addView(view)
        }

        return panel
    }
}
