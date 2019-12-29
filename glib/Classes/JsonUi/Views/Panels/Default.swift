class JsonViewDefaultPanel: JsonView {
    private let panel = GVerticalPanel().width(.matchParent)

    override func initView() -> UIView {
        let childViews: [UIView] = spec["childViews"].arrayValue.compactMap { viewSpec -> UIView? in
            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                return jsonView.createView()
            }
            return nil
        }

        for view in childViews {
            panel.addView(view)
        }
        return panel
    }

    static func createPanel(spec: Json, screen: GScreen) -> GVerticalPanel {
        let component = JsonViewDefaultPanel(spec, screen)
        component.createView()
        return component.panel

//        if let wrapper = JsonViewDefaultPanel(spec, screen).createView() as? GVerticalPanel {
//            panel.addView(wrapper.width(.matchParent))
//        }
    }
}
