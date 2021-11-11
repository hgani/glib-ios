import UIKit

open class GAligner: UIView {
    fileprivate var helper: ViewHelper!
    private var horizontalAlign: GAlignerHorizontalGravity = .center
    private var verticalAlign: GAlignerVerticalGravity = .middle
    private var event: EventHelper<GAligner>!

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
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        helper.didMoveToSuperview()
    }

    public func align(_ align: GAlignerHorizontalGravity) -> Self {
        horizontalAlign = align
        return self
    }

    public func align(_ align: GAlignerVerticalGravity) -> Self {
        verticalAlign = align
        return self
    }

    @discardableResult
    public func withView(_ child: UIView) -> Self {
        // The hope is this makes things more predictable
        child.translatesAutoresizingMaskIntoConstraints = false

        addSubview(child)

        snp.makeConstraints { make in
            switch horizontalAlign {
            case .center: make.centerX.equalTo(child)
            case .right: make.rightMargin.equalTo(child.snp.right)
            case .left: make.leftMargin.equalTo(child.snp.left)
            }

            switch verticalAlign {
            case .middle: make.centerY.equalTo(child)
            case .top: make.topMargin.equalTo(child.snp.top)
            case .bottom: make.bottomMargin.equalTo(child.snp.bottom)
            }

            // So that it is at least the size of the child
            make.width.greaterThanOrEqualTo(child)
            make.height.greaterThanOrEqualTo(child)
        }
        return self
    }

    public func border(color: UIColor?, width: Float = 1, corner: Float = 6) -> Self {
        helper.border(color: color, width: width, corner: corner)
        return self
    }

    public func onClick(_ command: @escaping (GAligner) -> Void) -> Self {
        event.onClick(command)
        return self
    }

    public func bg(image: UIImage?, repeatTexture: Bool) -> Self {
        helper.bg(image: image, repeatTexture: repeatTexture)
        return self
    }

    public enum GAlignerHorizontalGravity {
        case center
        case left
        case right
    }

    public enum GAlignerVerticalGravity {
        case middle
        case top
        case bottom
    }
}

extension GAligner: GWeightable {
    public func width(weight: Float, offset: Float = 0) -> Self {
        helper.width(weight: weight, offset: offset)
        return self
    }

    public func height(weight: Float, offset: Float = 0) -> Self {
        helper.height(weight: weight, offset: offset)
        return self
    }
}

extension GAligner: IView {
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
