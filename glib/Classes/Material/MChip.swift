#if INCLUDE_MDLIBS

import MaterialComponents.MaterialChips

class MChip: MDCChipView {
    private var onClearClick: ((MChip) -> Void)?
    
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
    
    public func style(_ styleClasses: [Json]) -> Self {
        setTitleColor(.white, for: .normal)
        
        for style in styleClasses {
            switch style.stringValue {
            case "info":
                setBackgroundColor(UIColor(hex: "#2196f3"), for: .normal)
            case "success":
                setBackgroundColor(UIColor(hex: "#4caf50"), for: .normal)
            default:
                setBackgroundColor(UIColor(hex: "#e0e0e0"), for: .normal)
                setTitleColor(.black, for: .normal)
            }
        }
        return self
    }
    
    public func addClearButton() -> Self {
        var clearButton = UIControl()
        let clearButtonWidthAndHeight = 24.0
        clearButton.frame = CGRect(x: 0, y: 0, width: clearButtonWidthAndHeight, height: clearButtonWidthAndHeight)
        clearButton.layer.cornerRadius = CGFloat(clearButtonWidthAndHeight / 2.0)
        
        let clearImageWidthAndHeight = 18.0
        let clearImage = UIImage(from: .materialIcon, code: "clear",
                                 size: CGSize(width: clearImageWidthAndHeight, height: clearImageWidthAndHeight))
        let padding = (clearButtonWidthAndHeight - clearImageWidthAndHeight) / 2
        var clearImageView = UIImageView(image: clearImage)
        clearImageView.frame = CGRect(x: padding, y: padding, width: clearImageWidthAndHeight, height: clearImageWidthAndHeight)
        
        clearButton.addSubview(clearImageView)
        accessoryView = clearButton
        clearButton.addTarget(self, action: #selector(performClick), for: .touchUpInside)
        
        return self
    }
    
    @discardableResult
    open func onClearClick(_ command: @escaping (MChip) -> Void) -> Self {
        onClearClick = command
        return self
    }
    
    @objc open func performClick() {
        if let callback = self.onClearClick {
            callback(self)
        }
    }
}

#endif
