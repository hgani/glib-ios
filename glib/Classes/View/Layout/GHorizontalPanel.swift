import SnapKit
import UIKit

// TODO: Remove IHorizontalPanel
open class GHorizontalPanel: UIView, IHorizontalPanel {
//    fileprivate var outerHelper: ViewHelper?
    fileprivate var helper: ViewHelper!
    fileprivate var sizer: ViewHelper!

    private var previousView: UIView?
    private var previousLayoutPriority: UILayoutPriority?
    private var rightConstraint: Constraint?
    private var wrapContentConstraint: Constraint?

    private var totalGap = Float(0.0)

    private var paddings: Paddings {
        return helper.paddings
    }

    public init() {
        super.init(frame: .zero)
        initialize(sizer: ViewHelper(self))
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize(sizer: ViewHelper(self))
    }

    public init(wrapperHelper: ViewHelper) {
        super.init(frame: .zero)
        initialize(sizer: wrapperHelper)
    }

    private func initialize(sizer: ViewHelper) {
        self.sizer = sizer
        sizer.delegate = self

        helper = ViewHelper(self)

        _ = paddings(top: 0, left: 0, bottom: 0, right: 0)

        updateHeightTendency()
    }

    private func updateHeightTendency() {
        if sizer.shouldHeightMatchParent() {
            GLog.t("updateHeightTendency1")
            wrapContentConstraint?.deactivate()
        } else {
            GLog.t("updateHeightTendency2")
            snp.makeConstraints { make in
                // NOTE: Prevent the panel from getting stretched to be larger than necessary. For example, when used
                // in HamburgerPanel's header, it will squash the middle section.
                // See https://stackoverflow.com/questions/17117799/autolayout-height-equal-to-maxmultiple-view-heights

                // Increase hugging so that it tends to wrap content by default
                wrapContentConstraint = make.height.equalTo(0).priorityLow().constraint
            }
        }
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        sizer.didMoveToSuperview()
    }

    public func clearViews() {
        // Remove it explicitly because it's not necessarily related to a  child view, thus won't be removed
        // as part of view.removeFromSuperview()
        rightConstraint = nil
        
        previousView = nil

        for view in subviews {
            view.removeFromSuperview()
        }
    }

    public func addView(_ child: UIView, left: Float = 0) {
        totalGap += left

        // The hope is this makes things more predictable
        child.translatesAutoresizingMaskIntoConstraints = false

        super.addSubview(child)
        initChildConstraints(child: child, left: left)
        adjustParentBottomConstraint(child: child)

        previousView = child
    }

    @discardableResult
    public func append(_ child: UIView, left: Float = 0) -> Self {
        addView(child, left: left)
        return self
    }

    // See https://github.com/zaxonus/AutoLayScroll/blob/master/AutoLayScroll/ViewController.swift
    private func initChildConstraints(child: UIView, left: Float) {
        child.snp.makeConstraints { make in

            if let view = previousView {
                make.left.equalTo(view.snp.right).offset(left)
            } else {
                make.left.equalTo(self.snp.leftMargin).offset(left)
            }

            switch verticalAlign {
            case .middle:
                make.centerY.equalTo(self)
            case .top:
                make.top.equalTo(self.snp.topMargin)
            case .bottom:
                make.top.greaterThanOrEqualTo(self.snp.topMargin)
                make.bottom.equalTo(self.snp.bottomMargin)
            }
        }
    }

//        // See https://github.com/zaxonus/AutoLayScroll/blob/master/AutoLayScroll/ViewController.swift
//        private func initChildConstraints(child: UIView, top: Float) {
//            child.snp.makeConstraints { make in
//                if previousViewElement == nil {
//                    make.top.equalTo(self.snp.topMargin).offset(top)
//                } else {
//                    make.top.equalTo(previousViewElement.snp.bottom).offset(top)
//                }
//
//    //            make.left.equalTo(self.snp.leftMargin)
//
//                switch horizontalAlign {
//                case .center: make.centerX.equalTo(self)
//                case .right: make.right.equalTo(self.snp.rightMargin)
//                case .left: make.left.equalTo(self.snp.leftMargin)
//                }
//            }
//        }

    private func adjustParentBottomConstraint(child: UIView) {
        snp.makeConstraints { make in
            make.bottomMargin.greaterThanOrEqualTo(child.snp.bottom)
        }

        if sizer.shouldWidthMatchParent() {
            rightConstraint?.deactivate()

            child.snp.makeConstraints { make in
                rightConstraint = make.right.lessThanOrEqualTo(self.snp.rightMargin).constraint
            }

            // Decrease resistance of the last view to avoid squashing the previous views which
            // would happen if the last view is longer than the available space.
            if let view = previousView, let priority = previousLayoutPriority {
                ViewHelper.setResistance(view: view, axis: .horizontal, priority: priority)
            }
            previousLayoutPriority = ViewHelper.decreaseResistance(view: child, axis: .horizontal)

        } else {
            rightConstraint?.deactivate()

            child.snp.makeConstraints { make in
                rightConstraint = make.right.equalTo(self.snp.rightMargin).constraint
            }
        }
    }

    public func split() -> Self {
        let count = subviews.count
        GLog.i("Splitting \(count) views ...")
        let weight = 1.0 / Float(count)
        let offset = -(totalGap + paddings.left + paddings.right) / Float(count)
        for view in subviews {
            if let weightable = view as? GWeightable {
                _ = weightable.width(weight: weight, offset: offset)
            } else {
                GLog.e("Invalid child view: \(view)")
            }
        }

        return self
    }

    open override func addSubview(_: UIView) {
        fatalError("Use addView() instead")
    }

    public func done() {
        // Ends chaining
    }

    // MARK: - Alignment

    private var verticalAlign: GAligner.GAlignerVerticalGravity = .top

    public func align(_ align: GAligner.GAlignerVerticalGravity) -> Self {
        verticalAlign = align
        return self
    }
}

extension GHorizontalPanel: IView {
    public var size: CGSize {
        return sizer.size
    }

    @discardableResult
    public func color(bg: UIColor) -> Self {
        backgroundColor = bg
        return self
    }

    @discardableResult
    public func width(_ width: Int) -> Self {
        sizer.width(width)
        return self
    }

    @discardableResult
    public func width(_ width: LayoutSize) -> Self {
        sizer.width(width)
        return self
    }

    @discardableResult
    public func height(_ height: Int) -> Self {
        sizer.height(height)
        return self
    }

    @discardableResult
    public func height(_ height: LayoutSize) -> Self {
        sizer.height(height)
//        updateHeightTendency()

//        fatalError("TEST3: \(helper.shouldHeightMatchParent())")
        return self
    }

    @discardableResult
    public func paddings(top: Float? = nil, left: Float? = nil, bottom: Float? = nil, right: Float? = nil) -> Self {
        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
    }
}

extension GHorizontalPanel: SizingDelegate {
    // This may get called by the wrapper's helper. See init(ViewHelper)
    func onHeightUpdated() {
        GLog.t("Height: onHeightUpdated2")
        updateHeightTendency()
    }
}
