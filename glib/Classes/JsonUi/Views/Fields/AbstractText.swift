#if INCLUDE_MDLIBS

class JsonView_AbstractText: JsonView_AbstractField {
    private var view: MTextField!

    override var value: String {
        return view.text ?? ""
    }

    func initTextField() -> MTextField {
        view = MTextField(outlined: spec["styleClasses"].arrayValue.contains("outlined"))

        view
            .label(spec["label"].stringValue)
            .placeholder(spec["placeholder"].stringValue)
            .text(spec["value"].stringValue)
            .readOnly(spec["readOnly"].boolValue)
            .onEdit { _ in
                self.processJsonLogic(view: self.view)
            }

        return view
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
        view.errorView.text = text
    }

    override func applyStyleClass(_ styleClass: String) {
        if let buttonSpec = JsonUiStyling.textFields[styleClass] {
            buttonSpec.decorate(view)
        }
    }
}

#endif
