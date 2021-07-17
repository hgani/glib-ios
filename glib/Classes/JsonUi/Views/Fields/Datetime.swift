class JsonView_Fields_Datetime: JsonView_AbstractDate {
    override func initView() -> UIView {
        return initFieldWithPicker(date: spec["value"].iso8601Value, mode: .dateAndTime, format: "yyyy-MM-dd hh:mm a")
    }
}
