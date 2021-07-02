class JsonView_Fields_Hidden: JsonView_AbstractField, SubmittableField {
    var name: String?
    var value = ""

    func validate() -> Bool {
        return true
    }

    override func initView() -> UIView {
        name = spec["name"].string
        value = spec["value"].stringValue
        return GView()
    }
}
