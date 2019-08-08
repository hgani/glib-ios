class JsonView_Panels_FormV1: JsonView {
    private let panel = FormPanel()

//    required init(_ spec: Json, _ screen: GScreen) {
//        panel = FormPanel(jsonView: self)
//        super.init(spec, screen)
//    }

    override func initView() -> UIView {
        panel.jsonView = self

        // NOTE: subviews property is deprecated
        let childViews = spec["subviews"].array ?? spec["childViews"].arrayValue
        for viewSpec in childViews {
            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                panel.addView(jsonView.createView())

                // NOTE: Currently we assume all fields are direct children.

                if let field = jsonView as? SubmittableField {
                    panel.addField(field)
                }
            }
        }
        return panel
    }

    class FormPanel: GVerticalPanel {
        fileprivate var jsonView: JsonView_Panels_FormV1!

        private var fields = [SubmittableField]()

//        init(jsonView: JsonView_Panels_FormV1) {
//            self.jsonView = jsonView
//        }
//
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("Unsupported")
//        }

        fileprivate func addField(_ field: SubmittableField) {
            fields.append(field)
        }

        func submit() {
            var params = GParams()
            for field in fields {
                if let fileField = field as? SubmittableFileField, let completed = fileField.completed {
                    if !completed {
                        jsonView.screen.launch.alert("Please wait...")
                        return
                    }
                }
                if let name = field.name {
                    if name.hasSuffix("[]") {
                        if let oldArray = params[name] as? [String] {
                            var newArray = [String](oldArray)
                            newArray.append(field.value)
                            params[name] = newArray
                        } else {
                            params[name] = [field.value]
                        }
                    } else {
                        params[name] = field.value
                    }
                }
            }

            let spec = jsonView.spec
            let screen = jsonView.screen
//            _ = Rest.from(method: spec["method"].stringValue, url: spec["url"].stringValue, params: params)

            _ = Rest.from(method: spec["method"].stringValue, url: spec["url"].stringValue, params: params)?.execute { response in
                JsonAction.execute(spec: response.content["onResponse"], screen: screen, creator: self)
                return true
            }
        }
    }
}
