#if INCLUDE_MDLIBS

class JsonView_AbstractText: JsonView_AbstractField, SubmittableField {
    private var view: MTextField!

    var name: String?
    var value: String {
        return view.text ?? ""
    }

    func initTextField() -> MTextField {
        view = MTextField(outlined: spec["styleClasses"].arrayValue.contains("outlined"))
        
        name = spec["name"].string

//        view.labelView.text = spec["label"].string
//        view.addTarget(self, action: #selector(updateJsonLogic), for: .editingChanged)

        view
            .text(spec["label"].stringValue)
            .placeholder(spec["placeholder"].stringValue)
            .text(spec["value"].stringValue)
            .readOnly(spec["readOnly"].boolValue)
            .onEdit { _ in
                self.updateJsonLogic()
            }

//        initBottomBorderIfApplicable()

//        self.registerToClosestForm(field: view)

        return view
    }
    
   func updateJsonLogic() {
        if let fieldName = spec["name"].string, let form = closest(JsonView_Panels_Form.FormPanel.self, from: view) {
            updateFormData(form, fieldName, value)
        }
    }

//    private func initBottomBorderIfApplicable() {
//        #if !INCLUDE_UILIBS
//            view.borderStyle = .none
//            view.layer.backgroundColor = UIColor.white.cgColor
//
//            view.layer.masksToBounds = false
//            view.layer.shadowColor = UIColor.lightGray.cgColor
//            view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//            view.layer.shadowOpacity = 1.0
//            view.layer.shadowRadius = 0.0
//        #endif
//    }

    func text() -> String? {
        return view.text
    }

    func text(_ value : String) {
        view.text(value)
    }

    func errors(_ text: String?) {
//        view.hintView.text = text
        view.errorView.text = text
    }

    func validate() -> Bool {
        return true
    }

    override func applyStyleClass(_ styleClass: String) {
        if let buttonSpec = JsonUiStyling.textFields[styleClass] {
            buttonSpec.decorate(view)
        }
    }
}

#endif
