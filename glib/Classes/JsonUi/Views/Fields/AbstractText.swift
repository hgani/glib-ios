class JsonView_AbstractText: JsonView_AbstractField, SubmittableField {
    // NOTE: Library clients can register their own style classes here
    public static var styleSpecs: [String: MTextFieldSpec] = [
        "outlined": .outlined,
        "filled": .filled,
        "rounded": .rounded
    ]

    #if INCLUDE_MDLIBS
        private let view = MTextField()
    #else
        private let view = GTextField()
    #endif

    var name: String?
    var value: String {
        return view.text ?? ""
    }

    func initTextField() -> UITextField & ITextField {
        name = spec["name"].string

        view.placeholder = spec["label"].string
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

        view.errors(text)

        #endif
    }

    func validate() -> Bool {
        return true
    }

    override func applyStyleClass(_ styleClass: String) {
        if let buttonSpec = type(of: self).styleSpecs[styleClass] {
            buttonSpec.decorate(view)
        }

        // TODO: Support custom classes
//            if let klass = JsonUi.loadClass(name: styleClass, type: MTextFieldSpec.self) as? MTextFieldSpec.Type {
//                klass.init().decorate(view)
//            } else {
//                switch styleClass {
//                case "outlined":
//                    view.controller(MDCTextInputControllerOutlined(textInput: view), padding: .zero)
//                case "filled":
//                    view.controller(MDCTextInputControllerFilled(textInput: view), padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
//                case "rounded":
//                    // Not supported yet, so use "outlined" instead
//                    view.controller(MDCTextInputControllerOutlined(textInput: view), padding: .zero)
//                default:
//                    GLog.i("Invalid style class: \(styleClass)")
//
//                }
//            }

    }
}
