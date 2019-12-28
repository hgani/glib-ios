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
                #if INCLUDE_MDLIBS

                if let fabJsonView = jsonView as? JsonView_FabV1 {
                    let view = fabJsonView.createView()
                    panel.addView(view, top: 0, skipConstraint: true)
                    jsonView.afterViewAdded(parentView: panel)
                    ScrollableView.items.append(view)
                } else {
                    panel.addView(jsonView.createView())
                }

                // NOTE: Currently we assume all fields are direct children.

                if let field = jsonView as? SubmittableField {
                    panel.addField(field)
                }

                #endif
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
            var errorsCount = 0

            for field in fields {
                if let fileField = field as? SubmittableFileField, let completed = fileField.completed {
                    if !completed {
                        jsonView.screen.launch.alert("Please wait...")
                        return
                    }
                }

                if !field.validate() {
                    errorsCount += 1
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

            if errorsCount > 0 {
                return
            }

            #if INCLUDE_MDLIBS

            Generic.sharedInstance.genericIsBusy.value = true

            #endif

            let spec = jsonView.spec
            let screen = jsonView.screen
//            _ = Rest.from(method: spec["method"].stringValue, url: spec["url"].stringValue, params: params)

            _ = Rest.from(method: spec["method"].stringValue, url: spec["url"].stringValue, params: params)?.execute { response in
                #if INCLUDE_MDLIBS

                Generic.sharedInstance.genericIsBusy.value = false

                #endif
                JsonAction.execute(spec: response.content["onResponse"], screen: screen, creator: self)
                return true
            }
        }
    }
}
