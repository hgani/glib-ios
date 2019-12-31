#if INCLUDE_MDLIBS

class JsonView_Fields_TextareaV1: JsonView, SubmittableField {
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

//        self.registerToClosestForm(field: view)

        return view
    }

    func validate() -> Bool {
        if let text = view.text {
            if UInt(text.count) > view.maxLength() {
                return false
            }
        }

        return true
    }
}

#endif
