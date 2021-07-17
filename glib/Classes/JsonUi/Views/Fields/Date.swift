class JsonView_Fields_Date: JsonView_AbstractDate {
    override func initView() -> UIView {
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//
//        let textField = super.initTextField()
//
//        setInputViewDatePicker(field: textField, mode: .date)
//
//        return textField

        return initFieldWithPicker(format: "yyyy-MM-dd", mode: .date)
    }
}
