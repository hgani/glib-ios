class JsonView_Fields_FileV1: JsonView, SubmittableField {
    private let panel = GHorizontalPanel()

    var name: String?
    var value: String = ""

    override func initView() -> UIView {
        name = spec["name"].string

        return GVerticalPanel()
            .append(GLabel().text(spec["label"].stringValue))
            .append(
                panel
                    .append(GAligner().align(.left).withView(GLabel().text("No file choosen")))
                    .append(GAligner().align(.right).withView(MButton().title("Choose file")))
        )
    }
}
