class JsonView_Panels_Web: JsonView {
    override func initView() -> UIView {
        let url = spec["url"].stringValue
        return GWebView().load(url: url)
    }
}
