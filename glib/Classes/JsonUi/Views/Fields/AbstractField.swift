open class JsonView_AbstractField: JsonView {
//    override func didAttach(to _: UIView) {
////        self.registerToClosestForm(field: view())
//    }

    // TODO: Why not put name and value here?
    // TODO: Restrict writer

    public var name: String?
//    public var value = ""

    // To be overridden
    open var value: String {
        fatalError("Need to be overridden")
//        return ""
    }

    open override func onAfterInitView(_ view: UIView) {
        name = spec["name"].string
        
        self.registerToClosestForm(field: view)

        // TODO: Make JsonView_AbstractField a SubmittableField so we can access value
//        processJsonLogic(view: view, value: value)
    }

    func registerToClosestForm(field: UIView) {
        if let form = closest(JsonView_Panels_Form.FormPanel.self, from: field) {
            if let jsonField = self as? SubmittableField {
                form.addField(jsonField)
            } else {
                fatalError("Not a JSON field")
            }
        }
    }
//
//    func processJsonLogic(view: UIView, value: String) {
//         if let fieldName = spec["name"].string, let form = closest(JsonView_Panels_Form.FormPanel.self, from: view) {
//             updateFormData(form, fieldName, value)
//         }
//     }

    func processJsonLogic(view: UIView) {
         if let fieldName = name, let form = closest(JsonView_Panels_Form.FormPanel.self, from: view) {
             updateFormData(form, fieldName, value)
         }
    }

    private func updateFormData(_ form: JsonView_Panels_Form.FormPanel, _ fieldName: String, _ value: String) {
        do {
            try form.formData.value.merge(with: Json(parseJSON:
                """
                { "\(fieldName)" : "\(value)" }
                """
            ))
        } catch {
            GLog.d("Invalid json")
        }
    }
}

extension JsonView_AbstractField: SubmittableField {
    @objc // Overriddable
    public func validate() -> Bool {
        return true
    }
}
