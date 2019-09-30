import MaterialComponents.MaterialChips

class MChip: MDCChipView {
    public init() {
        super.init(frame: .zero)
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        setTitleColor(.black, for: [])
    }

    public func text(_ str: String) -> Self {
        titleLabel.text = str
        sizeToFit()
        return self
    }
}
