class JsonView_BrV1: JsonView {
    private let view = GView()
    
    override func initView() -> UIView {
        view.height(spec["height"].intValue)
        return view
    }
}

class JsonView_SpacerV1: JsonView {
    private let view = GView()

    override func initView() -> UIView {
        view.height(spec["height"].intValue)
        return view
    }
}
