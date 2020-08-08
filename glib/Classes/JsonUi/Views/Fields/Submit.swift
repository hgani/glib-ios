class JsonView_Fields_Submit: JsonView_Button {
    override func initView() -> UIView {
        let view = super.initView()
        (view as? MButton)?.onClick { button in
            JsonAction_Forms_Submit.execute(view: button)
        }
        (view as? GButton)?.onClick { button in
            JsonAction_Forms_Submit.execute(view: button)
        }
        return view
    }
}

//class JsonView_Fields_Submit: JsonView, SubmittableField {
//    private let backend: JsonView_Button
//
//    var name: String?
//    var value: String {
//        return spec["text"].stringValue
//    }
//
//    // This constructor allows dynamic instantiation of child classes.
//    public required init(_ spec: Json, _ screen: GScreen) {
//        var newSpec = spec
//        newSpec["onClick"] = ["action": "forms/submit-v1"]
//
//        self.backend = JsonView_Button(newSpec, screen)
//
//        // TODO:
//        // - Implement submit functionaliy when the button is clicked
//        // - If possible, use JsonAction_Forms_Submit
//        // - If not possible, use the code in JsonAction_Forms_Submit.silentExecute()
//
//        super.init(spec, screen)
//    }
//
//    override func initView() -> UIView {
//        return backend.initView()
//    }
//
//    func validate() -> Bool {
//        return true
//    }
//}
