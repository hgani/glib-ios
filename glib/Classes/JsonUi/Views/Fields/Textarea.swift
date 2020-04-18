#if INCLUDE_MDLIBS

class JsonView_Fields_TextareaV1: JsonView_AbstractField, SubmittableField {
    private var delegate: Delegate?
    private let view = MTextArea()

    var name: String?
    var value: String {
        return view.text ?? ""
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
        view.becomeFirstResponder()
        return view.resignFirstResponder()
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
            field.errors(nil)

            if let validation = field.spec["validation"].dictionary {
                if let required = validation["required"]?.presence {
                    if UInt(textView.text.count) <= 0 {
                        field.errors(required["message"].stringValue)
                        return false
                    }
                }
            }
            
            if let text = textView.text {
                if UInt(text.count) > field.spec["maxLength"].uIntValue {
                    field.errors("Maximum \(field.spec["maxLength"].uIntValue) characters")
                    return false
                }
            }
            
            return true
        }
    }
}

#endif
