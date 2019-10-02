#if INCLUDE_UILIBS

class JsonView_Panels_CardV1: JsonView {
    private let card = MCard()

    override func initView() -> UIView {
        let paddings = spec["padding"]
        card.width(LayoutSize(rawValue: spec["width"].stringValue)!)
            .height(.wrapContent)
            .paddings(top: paddings["top"].floatValue,
                      left: paddings["left"].floatValue,
                      bottom: paddings["bottom"].floatValue,
                      right: paddings["right"].floatValue)

        let childViews = spec["childViews"].arrayValue
        for viewSpec in childViews {
            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                card.append(jsonView.createView())
            }
        }

        return card
    }
}

#endif
