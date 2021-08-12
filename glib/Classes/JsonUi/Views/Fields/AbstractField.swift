open class JsonView_AbstractField: JsonView {
//    override func didAttach(to _: UIView) {
////        self.registerToClosestForm(field: view())
//    }

    public private(set) var name: String?

    // To be overridden
    open var value: String {
        fatalError("Need to be overridden")
    }

    open override func onAfterInitView(_ view: UIView) {
        name = spec["name"].string
        
        registerToClosestForm(field: view)

        processJsonLogic(view: view)
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
