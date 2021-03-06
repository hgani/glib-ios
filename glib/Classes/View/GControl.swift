import UIKit

open class GControl: UIControl {
    private var helper: ControlHelper<GControl>!

    public init() {
        super.init(frame: .zero)
        initialize()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        helper = ControlHelper(self)
    }

    // Needed for helper.width() and helper.height()
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        helper.didMoveToSuperview()
    }

    open func onClick(_ command: @escaping (GControl) -> Void) -> Self {
        helper.onClick(command)
        return self
    }

//    public func withView(_ child: UIView) -> Self {
//        // The hope is this makes things more predictable
//        child.translatesAutoresizingMaskIntoConstraints = false
//
//        addSubview(child)
//
//        snp.makeConstraints { make in
//            make.left.equalTo(child)
//            make.top.equalTo(child)
//
//            // TODO
////            make.width.greaterThanOrEqualTo(child)
////            make.height.greaterThanOrEqualTo(child)
//            make.width.equalTo(child)
//            make.height.equalTo(child)
//        }
//        return self
//    }

    public func withView(_ child: UIView, matchParent: Bool) -> Self {
        // The hope is this makes things more predictable
        child.translatesAutoresizingMaskIntoConstraints = false

        addSubview(child)

        snp.makeConstraints { make in
            make.left.equalTo(child)
            make.top.equalTo(child)

            if matchParent {
                make.width.equalTo(child)
                make.height.equalTo(child)
            } else {
                make.width.greaterThanOrEqualTo(child)
                make.height.greaterThanOrEqualTo(child)
            }
        }
        return self
    }
}

extension GControl: IView {
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
    public func paddings(top: Float?, left: Float?, bottom: Float?, right: Float?) -> Self {
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
        return self
    }
}
