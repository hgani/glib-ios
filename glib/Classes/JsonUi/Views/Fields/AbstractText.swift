class JsonView_AbstractTextV1: JsonView_AbstractField, SubmittableField {
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
        view.addTarget(self, action: #selector(updateJsonLogic), for: .editingChanged)

        initBottomBorderIfApplicable()

//        self.registerToClosestForm(field: view)

        return view
    }
    
    @objc func updateJsonLogic() {
        do {
            if let fieldName = spec["name"].string {
                try Generic.sharedInstance.formData.value.merge(with: Json(parseJSON:
                    """
                    { "\(fieldName)" : "\(value)" }
                    """
                ))
            }
        } catch {
            GLog.d("Invalid json")
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
}
