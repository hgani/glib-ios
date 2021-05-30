#if INCLUDE_MDLIBS

class JsonView_AbstractPanel: JsonView {
    let container = MCard()

    public required init(_ spec: Json, _ screen: GScreen) {
        super.init(spec, screen)
    }

    func initContainer(content: UIView) -> MCard {
        if let styleClasses = spec["styleClasses"].array, styleClasses.contains("card") {
           // Do nothing
        } else {
            container.disableCardStyle()
        }
        return container.withView(content)
    }
}

#endif
