open class JsonView_AbstractField: JsonView {
//    override func didAttach(to _: UIView) {
////        self.registerToClosestForm(field: view())
//    }

    open override func onAfterInitView(_ view: UIView) {
        self.registerToClosestForm(field: view)
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

    func processJsonLogic(view: UIView, value: String) {
         if let fieldName = spec["name"].string, let form = closest(JsonView_Panels_Form.FormPanel.self, from: view) {
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
