class JsonView_Fields_SubmitV1: JsonView, SubmittableField {
    private let backend: JsonView_ButtonV1

    var name: String?
    var value: String {
        return spec["text"].stringValue
    }

    // This constructor allows dynamic instantiation of child classes.
    public required init(_ spec: Json, _ screen: GScreen) {
        self.backend = JsonView_ButtonV1(spec, screen)

        // TODO:
        // - Implement submit functionaliy when the button is clicked
        // - If possible, use JsonAction_Forms_SubmitV1
        // - If not possible, use the code in JsonAction_Forms_SubmitV1.silentExecute()

        super.init(spec, screen)
    }

    override func initView() -> UIView {
        return backend.initView()
    }

    func validate() -> Bool {
        return true
    }
}
