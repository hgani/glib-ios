class JsonView_AbstractDate: JsonView_AbstractText {
    private weak var textField: MTextField?

    private let utcTimeZone = TimeZone(abbreviation: "UTC")

    private lazy var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"

        // Don't adjust date/time to the device's time zone
        dateFormatter.timeZone = utcTimeZone
        return dateFormatter
    }()

    // From https://stackoverflow.com/questions/58779202/convert-datetime-from-one-timezone-to-another-timezone-swift
    func changeTimeZone(_ date: Date, from: TimeZone, to: TimeZone) -> Date {
        let sourceOffset = from.secondsFromGMT(for: date)
        let destinationOffset = to.secondsFromGMT(for: date)
        let timeInterval = TimeInterval(destinationOffset - sourceOffset)

        return Date(timeInterval: timeInterval, since: date)
    }

    func initFieldWithPicker(format: String, mode: UIDatePicker.Mode) -> MTextField {
        let textField = super.initTextField()

        if let utcDate = self.spec["value"].iso8601 {
            dateFormatter.dateFormat = format
            textField.text = dateFormatter.string(from: utcDate)
        }

        initDatePicker(field: textField, mode: .dateAndTime)
        return textField
    }

    private func initDatePicker(field: MTextField, mode: UIDatePicker.Mode) {
        textField = field

        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))

        // Don't adjust date/time to the device's time zone
        datePicker.timeZone = utcTimeZone

        if let utcDate = self.spec["value"].iso8601 {
            datePicker.setDate(utcDate, animated: false)
        }

        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        datePicker.datePickerMode = mode
//        datePicker.sizeToFit()

        field.inputView = datePicker
//
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
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
            return
        }

        if let datePicker = field.inputView as? UIDatePicker {
            field.text = dateFormatter.string(from: datePicker.date)
        }
        field.resignFirstResponder()
    }
}
