class JsonView_Icon: JsonView {
    private let view = GLabel()
//        .width(24).height(24)

    override func initView() -> UIView {
        type(of: self).update(view: view, spec: spec["spec"])
        return view
    }

    static func update(view: GLabel, spec: Json) {
//        view.icon(GIcon(font: .materialIcon, code: spec["material"]["name"].stringValue), size: 24)
//        view.icon(icon(spec: spec), size: 24)

        if let icon = icon(spec: spec) {
            view.icon(icon, size: 24)
        }

        if let badgeSpec = spec["badge"].presence {
            view.badge(text: badgeSpec["text"].stringValue, bgColor: UIColor(unsafeHex: badgeSpec["backgroundColor"].stringValue) ?? .red)
        }
    }

    static func icon(spec: Json) -> GIcon? {
        if let name = spec["material"]["name"].string {
            return GIcon(font: .materialIcon, code: name)
        }
        return nil
    }
}
