#if INCLUDE_MDLIBS

class JsonView_ChipV1: JsonView {
    private let view = MChip()

    override func initView() -> UIView {
        view.text(spec["text"].stringValue)
        return view
    }
}

#endif
