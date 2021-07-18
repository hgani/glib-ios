class JsonView_Fields_Date: JsonView_AbstractDate {
    override func initView() -> UIView {
        return initFieldWithPicker(date: spec["value"].dateValue, mode: .date, format: "dd MMM yyyy")
    }
}
