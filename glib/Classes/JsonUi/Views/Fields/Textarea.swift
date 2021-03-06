#if INCLUDE_MDLIBS

class JsonView_Fields_Textarea: JsonView_AbstractField {
    private var view: MTextArea!

//    var name: String?
    override var value: String {
        return view.text ?? ""
    }

    override func initView() -> UIView {
        view = MTextArea(outlined: spec["styleClasses"].arrayValue.contains("outlined"))

//        name = spec["name"].string

        view
            .label(spec["label"].stringValue)
            .placeholder(spec["placeholder"].stringValue)
            .text(spec["value"].stringValue)
            .readOnly(spec["readOnly"].boolValue)
            .onEdit { _ in
//                self.updateJsonLogic()
                self.processJsonLogic(view: self.view)
            }

        //
        //        view.width(.matchParent)
        //            .placeholder(spec["label"].stringValue)
        //            .text(spec["value"].stringValue)
        //            .maxLength(spec["maxLength"].uIntValue)
        //            .styleClasses(spec["styleClasses"].arrayValue)
        //
        //        delegate = Delegate(self)
        //        view.textView?.delegate = delegate
        //
        //        NotificationCenter.default.addObserver(self, selector: #selector(updateJsonLogic), name: UITextView.textDidChangeNotification, object: nil)
        //
        ////        self.registerToClosestForm(field: view)
        //

//        let field = super.initTextField()
//        return field
        return view
    }

//    func updateJsonLogic() {
//        if let fieldName = spec["name"].string, let form = closest(JsonView_Panels_Form.FormPanel.self, from: view) {
//            updateFormData(form, fieldName, value)
//        }
//    }

//    func validate() -> Bool {
////        if let textView = view.textView {
////            textView.becomeFirstResponder()
////            return textView.resignFirstResponder()
////        }
//        return true
//    }
}

//class JsonView_Fields_Textarea: JsonView_AbstractField, SubmittableField {
//    private var delegate: Delegate?
//    private let view = MTextArea()
//
//    var name: String?
//    var value: String {
//        return view.textView?.text ?? ""
//    }
//
//    override func initView() -> UIView {
//        name = spec["name"].string
//
//        view.width(.matchParent)
//            .placeholder(spec["label"].stringValue)
//            .text(spec["value"].stringValue)
//            .maxLength(spec["maxLength"].uIntValue)
//            .styleClasses(spec["styleClasses"].arrayValue)
//
//        delegate = Delegate(self)
//        view.textView?.delegate = delegate
//
//        NotificationCenter.default.addObserver(self, selector: #selector(updateJsonLogic), name: UITextView.textDidChangeNotification, object: nil)
//
////        self.registerToClosestForm(field: view)
//
//        return view
//    }
//
//    @objc func updateJsonLogic() {
//        if let fieldName = spec["name"].string,
//            let form = closest(JsonView_Panels_Form.FormPanel.self, from: view),
//            let value = view.text {
//            updateFormData(form, fieldName, value)
//        }
//    }
//
//    func validate() -> Bool {
//        if let textView = view.textView {
//            textView.becomeFirstResponder()
//            return textView.resignFirstResponder()
//        }
//        return true
//    }
//
//    func errors(_ text: String?) {
//        #if INCLUDE_MDLIBS
//
//        view.errors(text)
//
//        #endif
//    }
//
//    class Delegate: NSObject, UITextViewDelegate {
//        private var field: JsonView_Fields_Textarea
//
//        init(_ field: JsonView_Fields_Textarea) {
//            self.field = field
//        }
//
//        @objc func updateJsonLogic() {
//            do {
//                if let fieldName = self.field.spec["name"].string {
//                    try Generic.sharedInstance.formData.value.merge(with: Json(parseJSON:
//                        """
//                        { "\(fieldName)" : "\(self.field.value)" }
//                        """
//                    ))
//                }
//            } catch {
//                GLog.d("Invalid json")
//            }
//        }
//
//        func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//            field.errors(nil)
//
//            if let validation = field.spec["validation"].presence {
//                if let required = validation["required"].presence {
//                    if UInt(textView.text.count) <= 0 {
//                        field.errors(required["message"].stringValue)
//                    }
//                }
//            }
//
//            if let text = textView.text {
//                if let maxLength = field.spec["maxLength"].presence, maxLength.uIntValue > 0, UInt(text.count) > maxLength.uIntValue {
//                    field.errors("Maximum \(field.spec["maxLength"].uIntValue) characters")
//                }
//            }
//
//            return true
//        }
//    }
//}

#endif
