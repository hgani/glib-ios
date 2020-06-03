class JsonView_Fields_DateV1: JsonView_AbstractDateV1 {
    private var textField = UITextField()
    private lazy var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    override func initView() -> UITextField {
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
