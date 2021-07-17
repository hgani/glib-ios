class JsonView_Fields_Datetime: JsonView_AbstractDate {
//    private var textField: MTextField!
////    private var textField = UITextField()
//    private lazy var dateFormatter : DateFormatter = {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm a"
//        dateFormatter.amSymbol = "AM"
//        dateFormatter.pmSymbol = "PM"
//        return dateFormatter
//    }()

    override func initView() -> UIView {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm a"

        let textField = super.initTextField()
        setInputViewDatePicker(field: textField, mode: .dateAndTime, onSelected: {
//            self.commitSelection()
        })

//        let isoDateFormatter = DateFormatter()
//        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
//
//        let dateStr = String(spec["value"].stringValue.prefix(16))
//        if let date = isoDateFormatter.date(from: dateStr) {
//            fatalError("D \(date) -- \(dateStr) -- \(spec["value"].iso8601)")
//            textField.text = dateFormatter.string(from: date)
//        }



//        textField.text = spec["value"].iso8601

        return textField
    }

//    private func commitSelection() {
//        if let datePicker = textField.inputView as? UIDatePicker {
//            fatalError("P: \(datePicker.date) -- \(dateFormatter.string(from: datePicker.date))")
//            textField.text = dateFormatter.string(from: datePicker.date)
//        }
//        textField.resignFirstResponder()
//    }

//    @objc func tapDone() {
//        if let datePicker = textField.inputView as? UIDatePicker {
//            textField.text = dateFormatter.string(from: datePicker.date)
//        }
//        textField.resignFirstResponder()
//    }
}
