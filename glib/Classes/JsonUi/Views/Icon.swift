class JsonView_IconV1: JsonView {
    private let view = GLabel()
//        .width(24).height(24)

    override func initView() -> UIView {
        type(of: self).update(view: view, spec: spec["spec"])
        return view
    }

    static func update(view: GLabel, spec: Json) {
        view.icon(GIcon(font: .materialIcon, code: spec["material"]["name"].stringValue), size: 24)
        if let badgeSpec = spec["badge"].presence {
            view.badge(text: badgeSpec["text"].stringValue, bgColor: UIColor(unsafeHex: badgeSpec["backgroundColor"].stringValue) ?? .red)
        }
    }
}
