import SnapKit
import UIKit
import FlexLayout

open class GFlowPanel: UIView {
    fileprivate var helper: ViewHelper!

    // Only the owner of the helper can keep a strong reference to it (see `ViewHelper.view`).
    fileprivate weak var containerHelper: ViewHelper?

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
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    public init(containerHelper: ViewHelper) {
        super.init(frame: .zero)
        initialize(containerHelper: containerHelper)
    }

    private func initialize(containerHelper: ViewHelper? = nil) {
//        self.containerHelper = containerHelper
//        containerHelper?.delegate = self
        
        flex.direction(.row)
            .wrap(.wrap)
            .backgroundColor(.red)
//            .width(100%)

        helper = ViewHelper(self)

        paddings(top: 0, left: 0, bottom: 0, right: 0)

        updateHeightTendency()
    }

    private func updateHeightTendency() {
        if shouldHeightMatchParent() {
            wrapContentConstraint?.deactivate()
        } else {
            snp.makeConstraints { make in
                // NOTE: Prevent the panel from getting stretched to be larger than necessary. For example, when used
                // in HamburgerPanel's header, it will squash the middle section.
                // See https://stackoverflow.com/questions/17117799/autolayout-height-equal-to-maxmultiple-view-heights
                //
                // Increase hugging so that it tends to wrap content by default
                wrapContentConstraint = make.height.equalTo(0).priorityLow().constraint
            }
        }
    }

    private func shouldWidthMatchParent() -> Bool {
        return containerHelper?.shouldWidthMatchParent() ?? helper.shouldWidthMatchParent()
    }

    private func shouldHeightMatchParent() -> Bool {
        return containerHelper?.shouldHeightMatchParent() ?? helper.shouldHeightMatchParent()
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        helper.didMoveToSuperview()
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

//    public func addView(_ child: UIView, left: Float = 0) {
//        totalGap += left
//
//        // The hope is this makes things more predictable
//        child.translatesAutoresizingMaskIntoConstraints = false
//
//        super.addSubview(child)
//        initChildConstraints(child: child, left: left)
//        adjustSelfConstraints(child: child)
//
//        previousView = child
//    }

    @discardableResult
    public func append(_ child: UIView) -> Self {
//        addView(child, left: left)
        flex.addItem(child)
        flex.layout(mode: .adjustHeight)
        adjustBottomConstraint(child: child)
        return self
    }
    
    private func adjustBottomConstraint(child: UIView) {
        snp.makeConstraints { make in
            make.bottomMargin.greaterThanOrEqualTo(child.snp.bottom)
        }
    }

//    // See https://github.com/zaxonus/AutoLayScroll/blob/master/AutoLayScroll/ViewController.swift
//    private func initChildConstraints(child: UIView, left: Float) {
//        child.snp.makeConstraints { make in
//
//            if let view = previousView {
//                make.left.equalTo(view.snp.right).offset(left)
//            } else {
//                make.left.equalTo(self.snp.leftMargin).offset(left)
//            }
//
////            switch verticalAlign {
////            case .middle:
////                make.centerY.equalTo(self)
////            case .top:
////                make.top.equalTo(self.snp.topMargin)
////            case .bottom:
////                make.top.greaterThanOrEqualTo(self.snp.topMargin)
////                make.bottom.equalTo(self.snp.bottomMargin)
////            }
//        }
//    }
//
//    private func adjustSelfConstraints(child: UIView) {
//        snp.makeConstraints { make in
//            make.bottomMargin.greaterThanOrEqualTo(child.snp.bottom)
//        }
//
//        if shouldWidthMatchParent() {
//            rightConstraint?.deactivate()
//
//            child.snp.makeConstraints { make in
//                rightConstraint = make.right.lessThanOrEqualTo(self.snp.rightMargin).constraint
//            }
//
//            // Decrease resistance of the last view to avoid squashing the previous views which
//            // would happen if the last view is longer than the available space.
//            if let view = previousView, let priority = previousLayoutPriority {
//                ViewHelper.setResistance(view: view, axis: .horizontal, priority: priority)
//            }
//            previousLayoutPriority = ViewHelper.decreaseResistance(view: child, axis: .horizontal)
//
//        } else {
//            rightConstraint?.deactivate()
//
//            child.snp.makeConstraints { make in
//                rightConstraint = make.right.equalTo(self.snp.rightMargin).constraint
//            }
//        }
//    }

//    open override func addSubview(_: UIView) {
//        fatalError("Use addView() instead")
//    }

//    // MARK: - Alignment
//
//    private var verticalAlign: GAligner.GAlignerVerticalGravity = .top
//
//    public func align(_ align: GAligner.GAlignerVerticalGravity) -> Self {
//        verticalAlign = align
//        return self
//    }
}

extension GFlowPanel: IView {
    public var sizingHelper: SizingHelper {
        return helper
    }

    public var size: CGSize {
        return helper.size
    }

    @discardableResult
    public func color(bg: UIColor) -> Self {
        backgroundColor = bg
        return self
    }

    @discardableResult
    public func paddings(top: Float? = nil, left: Float? = nil, bottom: Float? = nil, right: Float? = nil) -> Self {
        helper.paddings(t: top, l: left, b: bottom, r: right)
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
        updateHeightTendency()
        return self
    }
}

//extension GHorizontalPanel: SizingDelegate {
//    func onWidthUpdated() {
//        // Do nothing
//    }
//
//    // This may get called by the container's helper. See init(ViewHelper)
//    func onHeightUpdated() {
//        updateHeightTendency()
//    }
//}
