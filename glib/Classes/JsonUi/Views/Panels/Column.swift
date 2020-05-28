class JsonView_Panels_ColumnV1: JsonViewDefaultPanel {
//    private let panel = GVerticalPanel().width(.matchParent)
//
//    override func initView() -> UIView {
//        let childViews: [UIView] = spec["childViews"].arrayValue.compactMap { viewSpec -> UIView? in
//            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
//                return jsonView.createView()
//            }
//            return nil
//        }
//
//        for view in childViews {
//            panel.addView(view)
//        }
//        return panel
//    }

    override func initView() -> UIView {
        super.initView()
        return panel.width(.matchParent) as! UIView
    }
}
