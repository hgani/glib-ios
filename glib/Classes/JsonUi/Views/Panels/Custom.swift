class JsonView_Panels_CustomV1: JsonView {
    override func initView() -> UIView {

        if let template = JsonTemplate.create(tableView: nil, spec: spec, screen: screen) {
            return template.createPanel()
        }

        return UIView()
    }
}
