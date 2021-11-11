//class JsonView_P: JsonView {
//    fileprivate let label = GLabel().width(.matchParent)
//
//    override func initView() -> UIView {
//        if let text = spec["text"].string {
//            _ = label.text(text)
//        }
//        label.font(RobotoFonts.Style.regular.font, size: 14)
//        return label
//    }
//}


class JsonView_P: JsonView_AbstractLabel {
    override func initView() -> UIView {
        let view = super.initView()
        applyStyleClass("p")
        return view
    }
}
