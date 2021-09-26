class JsonView_AbstractDate: JsonView_AbstractText {
    private static let screenWidth = UIScreen.main.bounds.width
    private let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
    private weak var textField: MTextField?
    
    override var value: String {
        return Formatter.iso8601.string(from: datePicker.date)
    }
    
//    private let utcTimeZone = TimeZone(abbreviation: "UTC")

    private lazy var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"

        // Don't adjust date/time to the device's time zone
//        dateFormatter.timeZone = utcTimeZone

        return dateFormatter
    }()

    // From https://stackoverflow.com/questions/58779202/convert-datetime-from-one-timezone-to-another-timezone-swift
//    func changeTimeZone(_ date: Date, from: TimeZone, to: TimeZone) -> Date {
//        let sourceOffset = from.secondsFromGMT(for: date)
//        let destinationOffset = to.secondsFromGMT(for: date)
//        let timeInterval = TimeInterval(destinationOffset - sourceOffset)
//
//        return Date(timeInterval: timeInterval, since: date)
//    }

    func initFieldWithPicker(date: Date, mode: UIDatePicker.Mode, format: String) -> MTextField {
        let textField = super.initTextField()

        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: spec["displayTimeZone"].string ?? "Australia/Perth")

        textField.text = dateFormatter.string(from: date)

        initDatePicker(date: date, mode: mode, field: textField)
        return textField
    }

    private func initDatePicker(date: Date, mode: UIDatePicker.Mode, field: MTextField) {
        textField = field

        // Don't adjust date/time to the device's time zone
//        datePicker.timeZone = utcTimeZone

        datePicker.setDate(date, animated: false)

        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        datePicker.datePickerMode = mode

        field.inputView = datePicker

        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: type(of: self).screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: #selector(tapCancel))
        let cancel = GBarButtonItem().title("Cancel").onClick {
            field.resignFirstResponder()
        }
        let done = GBarButtonItem().title("Done").onClick {
            self.commitSelection()
        }
//        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, done], animated: false)
        field.backendInputAccessoryView = toolBar
    }

    private func commitSelection() {
        guard let field = textField else {
            GLog.e("Date field doesn't exist")
            return
        }

        if let datePicker = field.inputView as? UIDatePicker {
            field.text = dateFormatter.string(from: datePicker.date)
        }
        field.resignFirstResponder()
    }
}
