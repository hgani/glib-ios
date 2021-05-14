class JsonView_Fields_Date: JsonView_AbstractDate {
//    private var textField = UITextField()
    private var textField: MTextField!

    private lazy var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    override func initView() -> UIView {
        textField = super.initTextField()
        setInputViewDatePicker(field: textField, mode: .date, onSelected: {
            self.commitSelection()
        })

        return textField
    }

    private func commitSelection() {
        if let datePicker = textField.inputView as? UIDatePicker {
            textField.text = dateFormatter.string(from: datePicker.date)
        }
        textField.resignFirstResponder()
    }

//    @objc func tapDone() {
//        if let datePicker = textField.inputView as? UIDatePicker {
//            textField.text = dateFormatter.string(from: datePicker.date)
//        }
//        textField.resignFirstResponder()
//    }

    func setInputViewDatePicker(field: MTextField, mode: UIDatePicker.Mode, onSelected: @escaping () -> Void) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
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

//    @objc func tapCancel() {
//        textField.resignFirstResponder()
//    }

}
