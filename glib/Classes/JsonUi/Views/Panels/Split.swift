class JsonView_Panels_Split: JsonView_AbstractPanel {
    private let panel = GSplitPanel()

    override func initView() -> UIView {
        if let center = spec["center"].presence {
            panel.withViews(
                createSubview(spec["left"], center: false),
                createSubview(center, center: true),
                createSubview(spec["right"], center: false)
            )
        } else {
            panel.withViews(
                left: createSubview(spec["left"], center: false),
                right: createSubview(spec["right"], center: false)
            )
        }

        return initContainer(content: panel)
    }

    private func createSubview(_ subviewSpec: Json, center: Bool) -> UIView {
        if subviewSpec.isNull {
            return GView().width(0)
        }
        
        return JsonViewDefaultPanel.createPanel(spec: subviewSpec, screen: screen)
    }
}

protocol ISplitPanel {
    func withViews(_ left: UIView, _ center: UIView, _ right: UIView) -> Self
    func withViews(left: UIView, right: UIView) -> Self
}
