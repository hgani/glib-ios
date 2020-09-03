class MCollectionHeaderView: UICollectionReusableView {
    private let panel = GVerticalPanel()
    private var viewLoaded = false

    func createView(spec: Json, screen: GScreen) {
        let border = CALayer()
        border.backgroundColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        self.layer.addSublayer(border)

        if !viewLoaded {
            backgroundColor = .white
            addSubview(panel)
            panel.paddings(top: 10, left: 10, bottom: 10, right: 10)

            let childViews = spec["childViews"].arrayValue
            let subviews: [UIView] = childViews.compactMap { viewSpec -> UIView? in
                if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                    return jsonView.createView()
                }
                return nil
            }

            for view in subviews {
                panel.addView(view)
            }

            viewLoaded = true
        }
    }
}
