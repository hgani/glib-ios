//class JsonView_AbstractDate: JsonView_AbstractField, SubmittableField {
class JsonView_AbstractDate: JsonView_AbstractText {

    func setInputViewDatePicker(field: MTextField, mode: UIDatePicker.Mode, onSelected: @escaping () -> Void) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
//        let datePicker = GDatePicker()

        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        }

        datePicker.datePickerMode = mode
//        datePicker.sizeToFit()

        field.inputView = datePicker
//
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
//        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 24.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: #selector(tapCancel))
        let cancel = GBarButtonItem().title("Cancel").onClick {
            field.resignFirstResponder()
        }
        let done = GBarButtonItem().title("Done").onClick(onSelected)
//        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, done], animated: false)
        field.inputAccessoryView = toolBar
    }

//    #if INCLUDE_MDLIBS
//        private let view = MTextField()
//    #else
//        private let view = GTextField()
//    #endif
//
//    var name: String?
//    var value: String {
//        return view.text ?? ""
//    }
//
//    func validate() -> Bool {
//        return true
//    }
//
//    func initTextField() -> UITextField & ITextField {
//        name = spec["name"].string
//        #if INCLUDE_MDLIBS
//        view.styleClasses(spec["styleClasses"].arrayValue)
//        #endif
//        view.placeholder = spec["label"].string
//        view.text = spec["value"].string
//
//        return view
//    }
}
