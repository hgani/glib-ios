class JsonView_Panels_CustomV1: JsonView {
    override func initView() -> UIView {
        var data = spec["data"]
        data["template"] = spec["template"]

        if let template = JsonTemplate.create(spec: data, screen: screen) {
            return template.createPanel()
        }

        return UIView()
    }
}
