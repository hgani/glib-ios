// TODO: Deprecated
class JsonView_Br: JsonView {
    private let view = GView()

    override func initView() -> UIView {
        view.height(spec["height"].intValue)
        return view
    }
}

class JsonView_Spacer: JsonView {
    private let view = GView()

    override func initView() -> UIView {
        // Auto-layout doesn't work in some situations, e.g. within a FlexLayout
//        view.width(spec["width"].intValue)
//        view.height(spec["height"].intValue)

        view.frame.size = CGSize(width: spec["width"].intValue, height: spec["height"].intValue)

        return view
    }
}
