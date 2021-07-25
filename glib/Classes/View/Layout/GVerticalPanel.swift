import SnapKit
import UIKit

open class GVerticalPanel: UIView, IView {
    private var helper: ViewHelper!
    fileprivate var containerHelper: ViewHelper?

    private var previousView: UIView?
    private var previousConstraint: NSLayoutConstraint!
    private var bottomConstraint: Constraint?
    private var wrapContentConstraint: Constraint?

    private var event: EventHelper<GVerticalPanel>!

    private var totalGap = Float(0.0)

    public var size: CGSize {
        return helper.size
    }

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
        self.containerHelper = containerHelper
        containerHelper?.delegate = self
        
        helper = ViewHelper(self)
        event = EventHelper(self)

        _ = paddings(top: 0, left: 0, bottom: 0, right: 0)

//        // TODO: Implement similar to horizontal panel's updateHeightTendency
//        self.snp.makeConstraints { (make) -> Void in
//            // Increase hugging so that it tends to wrap content by default
//            make.width.equalTo(0).priorityLow()
//        }

        addInitialBottomConstraint()

        initContent()

        updateWidthTendency()
    }

    private func updateWidthTendency() {
        if shouldWidthMatchParent() {
            wrapContentConstraint?.deactivate()
        } else {
            snp.makeConstraints { make in
                // Increase hugging so that it tends to wrap content by default
                wrapContentConstraint = make.width.equalTo(0).priorityLow().constraint
            }
        }
    }

    private func shouldWidthMatchParent() -> Bool {
        return containerHelper?.shouldWidthMatchParent() ?? helper.shouldWidthMatchParent()
    }

    private func shouldHeightMatchParent() -> Bool {
        return containerHelper?.shouldHeightMatchParent() ?? helper.shouldHeightMatchParent()
    }

    open func initContent() {
        // To be overridden
    }

    private func addInitialBottomConstraint() {
        self.snp.makeConstraints { (make) -> Void in
            bottomConstraint = make.height.equalTo(0).priorityLow().constraint
        }
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        helper.didMoveToSuperview()
    }

    public func clearViews() {
        // Remove it explicitly because it's not necessarily related to a  child view, thus won't be removed
        // as part of view.removeFromSuperview()
        bottomConstraint = nil
//        removeConstraint(previousConstraint)
        addInitialBottomConstraint()

        previousView = nil


        for view in subviews {
            view.removeFromSuperview()
        }
    }

    public func addView(_ child: UIView, top: Float = 0) {
        totalGap += top

        // The hope is this makes things more predictable
        child.translatesAutoresizingMaskIntoConstraints = false

        super.addSubview(child)
        initChildConstraints(child: child, top: top)
        adjustSelfConstraints(child: child)

        previousView = child
    }

    public func addConstraintlessView(_ child: UIView) {
        super.addSubview(child)
    }

    @discardableResult
    public func clear() -> Self {
        clearViews()
        return self
    }

    @discardableResult
    public func append(_ child: UIView, top: Float = 0) -> Self {
        addView(child, top: top)
        return self
    }

    // See https://github.com/zaxonus/AutoLayScroll/blob/master/AutoLayScroll/ViewController.swift
    private func initChildConstraints(child: UIView, top: Float) {
        child.snp.makeConstraints { make in
//            if previousViewElement == nil {
//                make.top.equalTo(self.snp.topMargin).offset(top)
//            } else {
//                make.top.equalTo(previousViewElement.snp.bottom).offset(top)
//            }

            if let view = previousView {
                make.top.equalTo(view.snp.bottom).offset(top)
            } else {
                make.top.equalTo(self.snp.topMargin).offset(top)
            }

            switch horizontalAlign {
            case .center: make.centerX.equalTo(self)
            case .right: make.right.equalTo(self.snp.rightMargin)
            case .left: make.left.equalTo(self.snp.leftMargin)
            }
        }
    }

    private func adjustSelfConstraints(child: UIView) {
        snp.makeConstraints { (make) -> Void in
//            make.rightMargin.equalTo(child.snp.right).priorityLow()
            make.rightMargin.greaterThanOrEqualTo(child.snp.right)
        }

        if !shouldHeightMatchParent() {
            bottomConstraint?.deactivate()

            child.snp.makeConstraints { make in
                bottomConstraint = make.bottom.equalTo(self.snp.bottomMargin).constraint
            }
        }
    }

    @discardableResult
    public func width(_ width: Int) -> Self {
        helper.width(width)
        return self
    }

    @discardableResult
    public func width(_ width: LayoutSize) -> Self {
        helper.width(width)
        updateWidthTendency()
        return self
    }

    @discardableResult
    public func width(weight: Float) -> Self {
        helper.width(weight: weight)
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

    @discardableResult
    public func padding(_ padding: GPadding) -> Self {
        helper.padding(padding)
        return self
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

    open override func addSubview(_: UIView) {
        fatalError("Use addView() instead")
    }

    public func border(color: UIColor?, width: Float = 1, corner: Float = 6) -> Self {
        helper.border(color: color, width: width, corner: corner)
        return self
    }

    public func hidden(_ hidden: Bool) -> Self {
        isHidden = hidden
        return self
    }

    public func onClick(_ command: @escaping (GVerticalPanel) -> Void) -> Self {
        event.onClick(command)
        return self
    }

    public func tap(_ command: (GVerticalPanel) -> Void) -> Self {
        command(self)
        return self
    }

    @discardableResult
    public func bg(image: UIImage?, repeatTexture: Bool) -> Self {
        helper.bg(image: image, repeatTexture: repeatTexture)
        return self
    }

    public func split() -> Self {
        let count = subviews.count
        GLog.i("Splitting \(count) views ...")
        let weight = 1.0 / Float(count)
        let offset = -(totalGap + paddings.top + paddings.bottom) / Float(count)
        for view in subviews {
            if let weightable = view as? GWeightable {
                _ = weightable.height(weight: weight, offset: offset)
            } else {
                GLog.e("Invalid child view: \(view)")
            }
        }

        return self
    }

    // MARK: - Alignment

    private var horizontalAlign: GAligner.GAlignerHorizontalGravity = .left

    public func align(_ align: GAligner.GAlignerHorizontalGravity) -> Self {
        horizontalAlign = align
        return self
    }
}

extension GVerticalPanel: SizingDelegate {
    // This may get called by the container's helper. See init(ViewHelper)
    func onWidthUpdated() {
        updateWidthTendency()
    }

    func onHeightUpdated() {
        // Do nothing
    }
}
