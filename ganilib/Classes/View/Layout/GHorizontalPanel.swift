
import UIKit

open class GHorizontalPanel : UIView {
    private var helper: ViewHelper!
    private var previousViewElement : UIView!
    private var previousConstraint : NSLayoutConstraint!
    
    private var totalGap = Float(0.0)
    
    private var paddings: Paddings {
        get {
            return helper.paddings
        }
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
        self.helper = ViewHelper(self)
        
        _ = paddings(t: 0, l: 0, b: 0, r: 0)
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        helper.didMoveToSuperview()
    }
    
    public func clearViews() {
        previousViewElement = nil
        previousConstraint = nil
        
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    public func addView(_ child : UIView, left: Float = 0) {
        totalGap += left
        
        // The hope is this makes things more predictable
        child.translatesAutoresizingMaskIntoConstraints = false
        
        super.addSubview(child)
        initChildConstraints(child: child, left: left)
        adjustParentBottomConstraint(child: child)
        
        previousViewElement = child
    }
    
    public func append(_ child : UIView, left: Float = 0) -> Self {
        addView(child, left: left)
        return self
    }
    
    // See https://github.com/zaxonus/AutoLayScroll/blob/master/AutoLayScroll/ViewController.swift
    private func initChildConstraints(child: UIView, left: Float) {
        child.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)
            
            if previousViewElement == nil {
                make.left.equalTo(self.snp.leftMargin).offset(left)
            }
            else {
                make.left.equalTo(previousViewElement.snp.right).offset(left)
            }
        }
    }
    
    private func adjustParentBottomConstraint(child : UIView) {
        self.snp.makeConstraints { make in
            make.bottomMargin.greaterThanOrEqualTo(child.snp.bottom)
        }

        if !helper.shouldWidthMatchParent() {
            if previousConstraint != nil {
                self.removeConstraint(previousConstraint)
            }
            
            previousConstraint = NSLayoutConstraint(item: child,
                                                    attribute: .right,
                                                    relatedBy: .equal,
                                                    toItem: self,
                                                    attribute: .rightMargin,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
            self.addConstraint(previousConstraint)
        }
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
    
    public func paddings(t top: Float? = nil, l left: Float? = nil, b bottom: Float? = nil, r right: Float? = nil) -> Self {
        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
    }
    
    public func color(bg: UIColor) -> Self {
        self.backgroundColor = bg
        return self
    }
    
    open func split() -> Self {
        let count = subviews.count
        GLog.i("Splitting \(count) views ...")
        let weight = 1.0 / Float(count)
        let offset = -(totalGap + paddings.l + paddings.r) / Float(count)
        for view in subviews {
            if let weightable = view as? GWeightable {
                _ = weightable.width(weight: weight, offset: offset)
            }
            else {
                GLog.e("Invalid child view: \(view)")
            }
        }
        
        return self
    }
    
    open override func addSubview(_ view: UIView) {
        fatalError("Use addView() instead")
    }
    
    public func done() {
        // Ends chaining
    }
}
