class JsonView_Fields_Hidden: JsonView_AbstractField {
//    var name: String?
//    var value = ""
//
//    func validate() -> Bool {
//        return true
//    }

    override var value: String {
        return spec["value"].stringValue
    }

    override func initView() -> UIView {
//        name = spec["name"].string
//        value = spec["value"].stringValue
        return GView()
    }
}
