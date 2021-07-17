class JsonView_Fields_Datetime: JsonView_AbstractDate {
    override func initView() -> UIView {
//        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
//
//        let textField = super.initTextField()
//        setInputViewDatePicker(field: textField, mode: .dateAndTime)
//
//        return textField

        return initFieldWithPicker(format: "yyyy-MM-dd hh:mm a", mode: .dateAndTime)
    }
}
