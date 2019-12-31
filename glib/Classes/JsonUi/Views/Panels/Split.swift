class JsonView_Panels_SplitV1: JsonView {
    private let panel = GSplitPanel().width(.matchParent)

    override func initView() -> UIView {
//        if let center = spec["centerViews"].presence {
//            return panel.withViews(
//                createSubview(spec["leftViews"], center: false),
//                createSubview(center, center: true),
//                createSubview(spec["rightViews"], center: false)
//            )
//        } else {
//            return panel.withViews(
//                left: createSubview(spec["leftViews"], center: false),
//                right: createSubview(spec["rightViews"], center: false)
//            )
//        }

        if let center = spec["center"].presence {
            return panel.withViews(
                createSubview(spec["left"], center: false),
                createSubview(center, center: true),
                createSubview(spec["right"], center: false)
            )
        } else {
            return panel.withViews(
                left: createSubview(spec["left"], center: false),
                right: createSubview(spec["right"], center: false)
            )
        }
    }

    private func createSubview(_ subviewSpec: Json, center: Bool) -> UIView {
        if subviewSpec.isNull {
            return GView().width(0)
        }

//        let panel = GVerticalPanel()
//        let childViews = subviewSpec.arrayValue
//        let subviews: [UIView] = childViews.compactMap { viewSpec -> UIView? in
//            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
//                return jsonView.createView()
//            }
//            return nil
//        }
//
//        for view in subviews {
//            panel.addView(view)
//        }
//
//        return panel

        return JsonViewDefaultPanel.createPanel(spec: subviewSpec, screen: screen)
    }
}
