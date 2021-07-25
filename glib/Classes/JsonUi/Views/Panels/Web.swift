class JsonView_Panels_Web: JsonView {
    override func initView() -> UIView {
        let url = spec["url"].stringValue
        // Don't show indicator because this messes up top position when viewing a pdf file.
        return GWebView().load(url: url, indicator: false)
    }
}
