class JsonView_Panels_Ul: JsonView_AbstractPanel {
    private var panel: GVerticalPanel!

    override func initView() -> UIView {
        panel = GVerticalPanel(containerHelper: container.helper)

        let childViews = spec["childViews"].arrayValue
        let views: [UIView] = childViews.compactMap { viewSpec -> UIView? in
            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                return jsonView.view()
            }
            return nil
        }
        
        for view in views {
            let horizontal = GHorizontalPanel().align(.middle)
//            let bullet = GLabel().icon(GIcon(font: .materialIcon, code: "circle"))
            let bullet = GLabel().icon(GIcon(font: .materialIcon, code: "chevron_right"))
            horizontal.append(bullet).append(view, left: 4)
            
            // Fixate the width so it doesn't push the second column.
            // TODO: Move this logic to JsonView_Label
            bullet.width(Int(bullet.intrinsicContentSize.width))

            panel.addView(horizontal, top: 4)            
        }
    
//        // NOTE: subviews property is deprecated
//        let childViews = spec["subviews"].array ?? spec["childViews"].arrayValue
//        let views: [UIView] = childViews.compactMap { viewSpec -> UIView? in
//            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
//                return jsonView.view()
//            }
//            return nil
//        }
//
//        if let onClick = self.spec["onClick"].presence {
//            panel.onClick({ _ in
//                JsonAction.execute(spec: onClick, screen: self.screen, creator: self.panel)
//            })
//        }

        return initContainer(content: panel)
    }
    
//    private func setAlign() {
//        panel.align(getGravity())
//    }
//
//    private func getGravity() -> GAligner.GAlignerHorizontalGravity {
//        switch spec["align"].stringValue {
//        case "center":
//            return .center
//        case "right":
//            return .right
//        default:
//            return .left
//        }
//    }
    
}
