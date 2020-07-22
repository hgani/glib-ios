#if INCLUDE_MDLIBS

class JsonView_Fields_TextareaV1: JsonView_AbstractField, SubmittableField {
    private var delegate: Delegate?
    private let view = MTextArea()

    var name: String?
    var value: String {
        return view.textView?.text ?? ""
    }

    override func initView() -> UIView {
        name = spec["name"].string

        view.width(.matchParent)
            .placeholder(spec["label"].stringValue)
            .text(spec["value"].stringValue)
            .maxLength(spec["maxLength"].uIntValue)
        
        delegate = Delegate(self)
        view.textView?.delegate = delegate
        
//        self.registerToClosestForm(field: view)

        return view
    }

    func validate() -> Bool {
        if let textView = view.textView {
            textView.becomeFirstResponder()
            return textView.resignFirstResponder()
        }
        return true
    }
    
    func errors(_ text: String?) {
        #if INCLUDE_MDLIBS
        
        view.errors(text)
        
        #endif
    }
    
    class Delegate: NSObject, UITextViewDelegate {
        private var field: JsonView_Fields_TextareaV1
        
        init(_ field: JsonView_Fields_TextareaV1) {
            self.field = field
        }
        
        func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
            do {
                if let fieldName = self.field.spec["name"].string, let text = textView.text {
                    try Generic.sharedInstance.formData.value.merge(with: Json(parseJSON:
                        """
                            { "\(fieldName)" : "\(text)" }
                        """
                    ))
                }
            } catch {
                GLog.d("Invalid json")
            }
            
            field.errors(nil)

            if let validation = field.spec["validation"].presence {
                if let required = validation["required"].presence {
                    if UInt(textView.text.count) <= 0 {
                        field.errors(required["message"].stringValue)
                        return false
                    }
                }
            }
            
            if let text = textView.text {
                if let maxLength = field.spec["maxLength"].presence, maxLength.uIntValue > 0, UInt(text.count) > maxLength.uIntValue {
                    field.errors("Maximum \(field.spec["maxLength"].uIntValue) characters")
                    return false
                }
            }
            
            return true
        }
    }
}

#endif
