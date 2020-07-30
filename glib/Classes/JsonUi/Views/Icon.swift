class JsonView_IconV1: JsonView {
    private let view = GLabel().width(24).height(24)

    override func initView() -> UIView {
        type(of: self).update(view: view, spec: spec["spec"])

//        view.icon(GIcon(font: .materialIcon, code: spec["spec"]["material"]["name"].stringValue).string)
//            .width(24).height(24)
//
////        let sampleBadgeJson = Json(parseJSON: "{\"badge\":{\"text\":\"2\",\"backgroundColor\":\"#ff0000\"}}")
////        GLog.d(sampleBadgeJson)
//
//        if let badge = spec["badge"].presence {
//            let badgeLabel = UILabel(frame: CGRect(x: 8, y: -4, width: 20, height: 20))
//            let bgColor = UIColor(hex: badge["backgroundColor"].string ?? "#1976d2")
//            badgeLabel.backgroundColor = .clear
//            badgeLabel.layer.backgroundColor = bgColor.cgColor
//            badgeLabel.layer.cornerRadius = 10
//            badgeLabel.text = badge["text"].stringValue
//            badgeLabel.font = RobotoFonts.Style.regular.fontWithSize(10)
//            badgeLabel.textAlignment = .center
//            view.addSubview(badgeLabel)
//        }

        return view
    }

    static func update(view: GLabel, spec: Json) {
        view.icon(GIcon(font: .materialIcon, code: spec["material"]["name"].stringValue), size: 24)
        if let badgeSpec = spec["badge"].presence {
            view.badge(text: badgeSpec["text"].stringValue, bgColor: UIColor(unsafeHex: badgeSpec["backgroundColor"].stringValue) ?? .red)
        }
    }
}
