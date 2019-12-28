#if INCLUDE_MDLIBS

import MaterialComponents.MaterialCards

class MCard: MDCCard {
    private var helper: ViewHelper!
    private var previousViewElement: UIView!
    private var previousConstraint: NSLayoutConstraint!

    private var totalGap = Float(0.0)

    private var horizontalAlign: GAligner.GAlignerHorizontalGravity = .left

    public var size: CGSize {
        return helper.size
    }
    
    public init() {
        super.init(frame: .zero)
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        helper = ViewHelper(self)

        addInitialBottomConstraint()
    }

    private func addInitialBottomConstraint() {
        previousConstraint = NSLayoutConstraint(item: self,
                                                attribute: .bottom,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .top,
                                                multiplier: 1.0,
                                                constant: 0.0)
        previousConstraint.priority = UILayoutPriority(rawValue: 900) // Lower priority than fixed height

        addConstraint(previousConstraint)

        snp.makeConstraints { (make) -> Void in
            let screenRect = UIScreen.main.bounds
            let screenWidth = screenRect.size.width
            make.width.equalTo(screenWidth)
        }
    }

    public func addView(_ child: UIView, top: Float = 0) {
        totalGap += top

        // The hope is this makes things more predictable
        child.translatesAutoresizingMaskIntoConstraints = false

        super.addSubview(child)
        initChildConstraints(child: child, top: top)
        adjustSelfConstraints(child: child)

        previousViewElement = child
    }

    private func initChildConstraints(child: UIView, top: Float) {
        child.snp.makeConstraints { make in
            if previousViewElement == nil {
                make.top.equalTo(self.snp.topMargin).offset(top)
            } else {
                make.top.equalTo(previousViewElement.snp.bottom).offset(top)
            }

            //            make.left.equalTo(self.snp.leftMargin)

            switch horizontalAlign {
            case .center: make.centerX.equalTo(self)
            case .right: make.right.equalTo(self.snp.rightMargin)
            case .left: make.left.equalTo(self.snp.leftMargin)
            }
        }
    }

    private func adjustSelfConstraints(child: UIView) {
        snp.makeConstraints { (make) -> Void in
            make.rightMargin.greaterThanOrEqualTo(child.snp.right)
        }

        if !helper.shouldHeightMatchParent() {
            removeConstraint(previousConstraint)

            previousConstraint = NSLayoutConstraint(item: child,
                                                    attribute: .bottom,
                                                    relatedBy: .equal,
                                                    toItem: self,
                                                    attribute: .bottomMargin,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
            previousConstraint.priority = UILayoutPriority(rawValue: 900)

            // At this point previousViewElement refers to the last subview, that is the one at the bottom.
            addConstraint(previousConstraint)
        }
    }

    @discardableResult
    public func append(_ child: UIView, top: Float = 0) -> Self {
        addView(child, top: top)
        return self
    }

    public func width(_ width: Int) -> Self {
        helper.width(width)
        return self
    }

    public func width(_ width: LayoutSize) -> Self {
        helper.width(width)
        return self
    }

    public func height(_ height: Int) -> Self {
        helper.height(height)
        return self
    }

    public func height(_ height: LayoutSize) -> Self {
        helper.height(height)
        return self
    }

    public func paddings(top: Float? = nil, left: Float? = nil, bottom: Float? = nil, right: Float? = nil) -> Self {
        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
    }
}

#endif
