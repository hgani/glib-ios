class JsonView_AbstractText: JsonView_AbstractField, SubmittableField {
    #if INCLUDE_MDLIBS
        private let view = MTextField()
    #else
        private let view = GTextField()
    #endif

    var name: String?
    var value: String {
        return view.text ?? ""
    }

    func initTextField() -> UIView & ITextField {
        name = spec["name"].string

        view.labelView.text = spec["label"].string
        view.placeholder = spec["placeholder"].string
        view.text = spec["value"].string
        view.addTarget(self, action: #selector(updateJsonLogic), for: .editingChanged)

        initBottomBorderIfApplicable()

//        self.registerToClosestForm(field: view)

        return view
    }
    
    @objc func updateJsonLogic() {
        if let fieldName = spec["name"].string, let form = closest(JsonView_Panels_Form.FormPanel.self, from: view) {
            updateFormData(form, fieldName, value)
        }
    }

    private func initBottomBorderIfApplicable() {
        #if !INCLUDE_UILIBS
            view.borderStyle = .none
            view.layer.backgroundColor = UIColor.white.cgColor

            view.layer.masksToBounds = false
            view.layer.shadowColor = UIColor.lightGray.cgColor
            view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            view.layer.shadowOpacity = 1.0
            view.layer.shadowRadius = 0.0
        #endif
    }

    func text() -> String? {
        return view.text
    }

    func errors(_ text: String?) {
        #if INCLUDE_MDLIBS

        view.hintView.text = text

        #endif
    }

    func validate() -> Bool {
        return true
    }

    override func applyStyleClass(_ styleClass: String) {
        #if INCLUDE_MDLIBS

        if let buttonSpec = JsonUiStyling.textFields[styleClass] {
            buttonSpec.decorate(view)
        }
        
        #endif
    }
}
