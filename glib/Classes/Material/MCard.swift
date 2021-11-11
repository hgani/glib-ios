#if INCLUDE_MDLIBS
import UIKit
import MaterialComponents.MaterialCards
import MaterialComponents.MaterialCards_Theming

open class MCard: MDCCard {
    private(set) var helper: ViewHelper!
    
//    private var previousViewElement: UIView!
//    private var previousConstraint: NSLayoutConstraint!
    private var event: EventHelper<MCard>!
    
//    private var totalGap = Float(0.0)

    private var paddings: Paddings {
        return helper.paddings
    }
    
    public init() {
        super.init(frame: .zero)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        helper = ViewHelper(self)
        event = EventHelper(self)
        
        _ = paddings(top: 0, left: 0, bottom: 0, right: 0)
        
//        addInitialBottomConstraint()

        ripple(false)

        initContent()
    }
    
    open func initContent() {
        // To be overridden
    }

    @discardableResult
    public func withView(_ child: UIView) -> Self {
        // The hope is this makes things more predictable
        child.translatesAutoresizingMaskIntoConstraints = false

        addSubview(child)

        snp.makeConstraints { make in
            make.topMargin.equalTo(child.snp.top)
            make.bottomMargin.equalTo(child.snp.bottom)
            make.leftMargin.equalTo(child.snp.left)
            make.rightMargin.equalTo(child.snp.right)
        }
        return self
    }

    func disableCardStyle() {
        // See https://github.com/material-components/material-components-ios/issues/4332
        border(color: .clear, width: 0, corner: 0)
            .color(bg: .clear)
    }

//    private func addInitialBottomConstraint() {
//        previousConstraint = NSLayoutConstraint(item: self,
//                                                attribute: .bottom,
//                                                relatedBy: .equal,
//                                                toItem: self,
//                                                attribute: .top,
//                                                multiplier: 1.0,
//                                                constant: 0.0)
//        previousConstraint.priority = UILayoutPriority(rawValue: 900) // Lower priority than fixed height
//        addConstraint(previousConstraint)
//    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        helper.didMoveToSuperview()
    }
    
    public func clearViews() {
//        // Remove it explicitly because it's not necessarily related to a  child view, thus won't be removed
//        // as part of view.removeFromSuperview()
//        removeConstraint(previousConstraint)
//        addInitialBottomConstraint()
        
//        previousViewElement = nil
        
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
//    public func addConstraintlessView(_ child: UIView) {
//        super.addSubview(child)
//    }
    
    @discardableResult
    public func clear() -> Self {
        clearViews()
        return self
    }

    @discardableResult
    public func width(weight: Float) -> Self {
        helper.width(weight: weight)
        return self
    }

//    @discardableResult
//    public func padding(_ padding: GPadding) -> Self {
//        helper.padding(padding)
//        return self
//    }

    public func border(color: UIColor?, width: Float = 1, corner: Float = 6) -> Self {
        helper.border(color: color, width: width, corner: corner)
        return self
    }
    
    public func hidden(_ hidden: Bool) -> Self {
        isHidden = hidden
        return self
    }

    @discardableResult
    private func ripple(_ enabled: Bool) -> Self {
        // https://github.com/material-components/material-components-ios/issues/4332
        self.inkView.isHidden = !enabled
        return self
    }
    
    public func onClick(_ command: @escaping (MCard) -> Void) -> Self {
        event.onClick(command)
        return ripple(true)
    }
    
    public func tap(_ command: (MCard) -> Void) -> Self {
        command(self)
        return self
    }
    
    @discardableResult
    public func bg(image: UIImage?, repeatTexture: Bool) -> Self {
        helper.bg(image: image, repeatTexture: repeatTexture)
        return self
    }

    public func applyStyles(_ spec: Json) -> Self {
        if spec["styleClasses"].arrayValue.contains("outlined") {
            let containerScheme = MDCContainerScheme()
            self.applyOutlinedTheme(withScheme: containerScheme)
        }

        return self
    }
}

extension MCard: IView {
    public var sizingHelper: SizingHelper {
        return helper
    }

    public var size: CGSize {
        return helper.size
    }

    @discardableResult
    public func paddings(top: Float? = nil, left: Float? = nil, bottom: Float? = nil, right: Float? = nil) -> Self {
        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
    }

    @discardableResult
    public func color(bg: UIColor) -> Self {
        backgroundColor = bg
        return self
    }

    @discardableResult
    public func width(_ width: Int) -> Self {
        helper.width(width)
        return self
    }

    @discardableResult
    public func width(_ width: LayoutSize) -> Self {
        helper.width(width)
        return self
    }

    @discardableResult
    public func height(_ height: Int) -> Self {
        helper.height(height)
        return self
    }

    @discardableResult
    public func height(_ height: LayoutSize) -> Self {
        helper.height(height)
        return self
    }
}

#endif
