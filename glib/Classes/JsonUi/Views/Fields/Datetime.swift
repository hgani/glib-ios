class JsonView_Fields_Datetime: JsonView_AbstractDate {
    override func initView() -> UIView {
        return initFieldWithPicker(date: spec["value"].iso8601Value, mode: .dateAndTime, format: "dd MMM yyyy hh:mm a")
    }
}
