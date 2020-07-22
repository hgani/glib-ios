class JsonView_AbstractTextV1: JsonView_AbstractField, SubmittableField {
    private var delegate: AbstractTextDelegate?
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
        #if INCLUDE_MDLIBS
        view.styleClasses(spec["styleClasses"].arrayValue)
        #endif
        view.placeholder = spec["label"].string
        view.text = spec["value"].string
        
        delegate = AbstractTextDelegate(self)
        view.delegate = delegate

        initBottomBorderIfApplicable()

//        self.registerToClosestForm(field: view)

        return view
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
    
    class AbstractTextDelegate: NSObject, UITextFieldDelegate {
        private var field: JsonView_AbstractField
        
        init(_ field: JsonView_AbstractField) {
            self.field = field
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            do {
                if let fieldName = self.field.spec["name"].string, let text = textField.text {
                    try Generic.sharedInstance.formData.value.merge(with: Json(parseJSON:
                        """
                            { "\(fieldName)" : "\(text)" }
                        """
                    ))
                }
            } catch {
                GLog.d("Invalid json")
            }
        }
    }
}
