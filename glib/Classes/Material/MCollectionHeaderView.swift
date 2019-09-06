class MCollectionHeaderView: UICollectionReusableView {
    private let panel = GVerticalPanel()
    private var viewLoaded = false

    func createView(spec: Json, screen: GScreen) {
        if !viewLoaded {
            backgroundColor = .white
            addSubview(panel)
            panel.paddings(top: 10, left: 10, bottom: 10, right: 10)

            let childViews = spec["childViews"].arrayValue
            for viewSpec in childViews {
                if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                    if let fabJsonView = jsonView as? JsonView_FabV1 {
                        let view = fabJsonView.createView()
                        panel.addView(view, top: 0, skipConstraint: true)
                        jsonView.afterViewAdded(parentView: panel)
                    } else {
                        panel.addView(jsonView.createView())
                    }
                }
            }

//            let subviews: [UIView] = childViews.compactMap { viewSpec -> UIView? in
//                if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
//                    return jsonView.createView()
//                }
//                return nil
//            }
//
//            for view in subviews {
//                panel.addView(view)
//            }
            
            viewLoaded = true
        }
    }
}
