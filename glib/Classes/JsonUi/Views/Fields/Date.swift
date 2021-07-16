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
}
