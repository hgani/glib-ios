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
        textField.setInputViewDatePicker(mode: .date, target: self, selector: #selector(tapDone))

        return textField
    }

    @objc func tapDone() {
        if let datePicker = textField.inputView as? UIDatePicker {
            textField.text = dateFormatter.string(from: datePicker.date)
        }
        textField.resignFirstResponder()
    }
}
