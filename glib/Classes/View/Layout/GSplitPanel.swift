import UIKit

open class GSplitPanel: UIView, IView {
    private var helper: ViewHelper!
    private var event: EventHelper<GSplitPanel>!

    public var size: CGSize {
        return helper.size
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
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        helper.didMoveToSuperview()
    }

    public func withViews(left: UIView, right: UIView) -> Self {
        // The hope is this makes things more predictable
        left.translatesAutoresizingMaskIntoConstraints = false
        right.translatesAutoresizingMaskIntoConstraints = false

        addSubview(left)
        addSubview(right)

        initConstraints(left: left, center: nil, right: right)

        return self
    }

    public func withViews(_ left: UIView, _ center: UIView, _ right: UIView) -> Self {
        // The hope is this makes things more predictable
        left.translatesAutoresizingMaskIntoConstraints = false
        center.translatesAutoresizingMaskIntoConstraints = false
        right.translatesAutoresizingMaskIntoConstraints = false

        // Avoid squashing the right view
        ViewHelper.decreaseResistance(view: center, axis: .horizontal)

        // Stretch the center view
        ViewHelper.minimumHugging(view: center, axis: .horizontal)

        addSubview(left)
        addSubview(center)
        addSubview(right)

        initConstraints(left: left, center: center, right: right)

        return self
    }

    private func initConstraints(left: UIView, center: UIView?, right: UIView) {
        left.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)
            make.left.equalTo(self.snp.leftMargin)

        }
        center?.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)

            make.left.equalTo(left.snp.right)
            make.right.equalTo(right.snp.left)
        }
        right.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)
            make.right.equalTo(self.snp.rightMargin)
        }

        snp.makeConstraints { make in
            make.bottomMargin.greaterThanOrEqualTo(left.snp.bottom)
            if let centerView = center {
                make.bottomMargin.greaterThanOrEqualTo(centerView.snp.bottom)
            }
            make.bottomMargin.greaterThanOrEqualTo(right.snp.bottom)

            // See https://stackoverflow.com/questions/17117799/autolayout-height-equal-to-maxmultiple-view-heights
            make.height.equalTo(0).priorityLow()
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

    public func paddings(top: Float? = nil, left: Float? = nil, bottom: Float? = nil, right: Float? = nil) -> Self {
        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
    }

    @discardableResult
    public func color(bg: UIColor) -> Self {
        backgroundColor = bg
        return self
    }

    public func onClick(_ command: @escaping (GSplitPanel) -> Void) -> Self {
        event.onClick(command)
        return self
    }

    public func interaction(_ enabled: Bool) -> Self {
        isUserInteractionEnabled = enabled
        return self
    }
}
