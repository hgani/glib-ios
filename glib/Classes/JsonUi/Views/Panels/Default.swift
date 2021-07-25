class JsonViewDefaultPanel: JsonView_AbstractPanel {
    let panel = GVerticalPanel()

    override func initView() -> UIView {
        // NOTE: subviews property is deprecated
        let childViews = spec["subviews"].array ?? spec["childViews"].arrayValue
        var fabView: JsonView?
//        var views = [UIView]()
        for viewSpec in childViews {
            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                if let fabJsonView = jsonView as? JsonView_Fab {
                    fabView = fabJsonView
                } else {
//                    panel.addView(view, top: 0)
//                    parent.addView(view, top: 0)
//                    addView(jsonView, to: panel)

                    panel.addView(jsonView.createView(), top: 0)
                }
            }
        }

//        for view in views {
//            panel.addView(view, top: 0)
//        }

        // Need to be added last
        if let fabJsonView = fabView {
//            let view = fabJsonView.createView()
//            panel.addView(view, top: 0, skipConstraint: true)
//            fabJsonView.afterViewAdded(parentView: panel)
//            ScrollableView.register(fab: view)

//            let view = addConstraintlessView(fabJsonView, to: panel)

            let view = fabJsonView.createView()
            panel.addConstraintlessView(view)
            ScrollableView.register(fab: view)
        }

        return initContainer(content: panel)
    }

    static func createPanel(spec: Json, screen: GScreen) -> UIView {
        let component = JsonViewDefaultPanel(spec, screen)
        component.view()
        return component.container
    }
}
