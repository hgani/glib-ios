import UIKit

open class GWrapper: UIView {
    fileprivate var helper: ViewHelper!

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
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        helper.didMoveToSuperview()
    }

    @discardableResult
    public func withView(_ child: UIView) -> Self {
        // The hope is this makes things more predictable
        child.translatesAutoresizingMaskIntoConstraints = false

        addSubview(child)

        snp.makeConstraints { make in
            make.width.equalTo(child)
            make.height.equalTo(child)
            make.centerX.equalTo(child)
            make.centerY.equalTo(child)
        }
        return self
    }
}

extension GWrapper: GWeightable {
    public func width(weight: Float, offset: Float = 0) -> Self {
        helper.width(weight: weight, offset: offset)
        return self
    }

    public func height(weight: Float, offset: Float = 0) -> Self {
        helper.height(weight: weight, offset: offset)
        return self
    }
}

extension GWrapper: IView {
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

    public func width(_ width: Int) -> Self {
        helper.width(width)
        return self
    }

    public func height(_ height: Int) -> Self {
        helper.height(height)
        return self
    }

    public func width(_ width: LayoutSize) -> Self {
        helper.width(width)
        return self
    }

    public func height(_ height: LayoutSize) -> Self {
        helper.width(height)
        return self
    }
}
