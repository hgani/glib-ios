class JsonView_PV1: JsonView {
    fileprivate let label = GLabel().width(.matchParent)
    
    override func initView() -> UIView {
        if let text = spec["text"].string {
            _ = label.text(text)
        }
        label.font(RobotoFonts.Style.regular.font, size: 14)
        return label
    }
}
