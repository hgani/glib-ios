class JsonView_AbstractField: JsonView {
    override func didAttach(to _: UIView) {
        self.registerToClosestForm(field: view())
    }

    func registerToClosestForm(field: UIView) {
        if let form = closest(JsonView_Panels_FormV1.FormPanel.self, from: field) {
            if let jsonField = self as? SubmittableField {
                form.addField(jsonField)
            } else {
                fatalError("Not a JSON field")
            }
        }
    }
}
