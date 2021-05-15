//class JsonView_AbstractDate: JsonView_AbstractField, SubmittableField {
class JsonView_AbstractDate: JsonView_AbstractText {

    func setInputViewDatePicker(field: MTextField, mode: UIDatePicker.Mode, onSelected: @escaping () -> Void) {
        let screenWidth = UIScreen.main.bounds.width
//        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        let datePicker = GDatePicker().onSelect { _ in
            GLog.i("setInputViewDatePicker1")
        }
        datePicker.datePickerMode = mode
        field.inputView = datePicker

        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
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

//extension MTextField {
//    
//    func setInputViewDatePicker(mode: UIDatePicker.Mode, target: Any, selector: Selector) {
//        let screenWidth = UIScreen.main.bounds.width
//        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
//        datePicker.datePickerMode = mode
//        self.inputView = datePicker
//        
//        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
//        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
//        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
//        toolBar.setItems([cancel, flexible, barButton], animated: false)
//        self.inputAccessoryView = toolBar
//    }
//    
//    @objc func tapCancel() {
//        self.resignFirstResponder()
//    }
//    
//}
