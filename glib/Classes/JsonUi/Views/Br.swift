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
        view.width(spec["width"].intValue)
        view.height(spec["height"].intValue)
        return view
    }
}
