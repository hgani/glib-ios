import FlexLayout

class JsonView_Panels_FlowV1: JsonView {
    private let panel: UIView
    
    public required init(_ spec: Json, _ screen: GScreen) {
        panel = UIView()
        super.init(spec, screen)
    }
    
    override func initView() -> UIView {
        // NOTE: subviews property is deprecated
        let childViews = spec["subviews"].array ?? spec["childViews"].arrayValue
        let views: [UIView] = childViews.compactMap { viewSpec -> UIView? in
            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                return jsonView.createView()
            }
            return nil
        }
        
        panel.flex
            .backgroundColor(UIColor(hex: spec["backgroundColor"].stringValue))
            .direction(.row)
            .wrap(.wrap)
            .width(CGFloat(spec["width"].intValue))
        
        for (index, view) in views.enumerated() {
            // TODO: seem spacer view doesn't work with FlexLayout
            if let childSpec = childViews[index].presence, childSpec["view"].stringValue == "spacer-v1" {
                panel.flex.addItem().width(CGFloat(childSpec["width"].intValue))
            } else {
                panel.flex.addItem(view)
            }
        }
        
        panel.flex.layout(mode: .adjustHeight)
        panel.snp.makeConstraints { (make) in
            guard let lastChild = views.last else { return }
            make.bottomMargin.greaterThanOrEqualTo(lastChild.snp.bottom)
            make.width.equalTo(spec["width"].intValue)
        }
        
        return panel
    }
}
