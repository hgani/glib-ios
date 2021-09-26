class JsonView_Icon: JsonView {
    private let view = GLabel()
//        .width(24).height(24)

    override func initView() -> UIView {
        if let nestedSpec = spec["spec"].presence { // Deprecated
            type(of: self).update(view: view, spec: nestedSpec)
        } else {
            type(of: self).update(view: view, spec: spec)
        }
        return view
    }

    static func update(view: GLabel, spec: Json) {
//        view.icon(GIcon(font: .materialIcon, code: spec["material"]["name"].stringValue), size: 24)
//        view.icon(icon(spec: spec), size: 24)

        if let (icon, size) = icon(spec: spec) {
            view.icon(icon, size: size)
////            view.icon(icon, size: 24)
//            let icon = GIcon(font: .materialIcon, code: iconSpec["name"].stringValue)
//            if let size = iconSpec["size"].int {
//                NSLog("**** SIZE: \(size)")
//                view.icon(icon, size: CGFloat(size))
//            } else {
//                view.icon(icon, size: nil)
//            }
        }

        if let badgeSpec = spec["badge"].presence {
            view.badge(text: badgeSpec["text"].stringValue, bgColor: UIColor(unsafeHex: badgeSpec["backgroundColor"].stringValue) ?? .red)
        }
    }

    static func icon(spec: Json) -> (GIcon, CGFloat?)? {
//        if let name = spec["material"]["name"].string {
        if let iconSpec = spec["material"].presence {
            let cgSize: CGFloat?
            if let size = iconSpec["size"].int {
                cgSize = CGFloat(size)
            } else {
                cgSize = nil
            }

            return (GIcon(font: .materialIcon, code: iconSpec["name"].stringValue), cgSize)
        }
        return nil
    }
    
//    static func material(spec: Json) -> Json? {
//        if let materialSpec = spec["material"].presence {
//            return materialSpec
//        }
//        return nil
//    }
}
