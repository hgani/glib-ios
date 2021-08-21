import SnapKit
import UIKit

public class ViewHelper: SizingHelper {
    // This only works if helper is only ever referenced by the owner View (not shared)
    private unowned let view: UIView

    var paddings = Paddings(top: 0, left: 0, bottom: 0, right: 0)

    private var backgroundView: GImageView?

    public var screen: GScreen? {
        var nextResponder = view.next
        while let responder = nextResponder {
            if let screen = responder as? GScreen {
                return screen
            }
            nextResponder = responder.next
        }
        return nil
    }

    public override init(_ view: UIView) {
        self.view = view
        super.init(view)

        view.layoutMargins = paddings.toEdgeInsets()
    }

    public func border(color: UIColor?, width: Float, corner: Float) {
        if let colorValue = color {
            view.layer.borderColor = colorValue.cgColor
        }
        view.layer.borderWidth = CGFloat(width)
        view.layer.cornerRadius = CGFloat(corner)
        view.layer.masksToBounds = true
    }

    public func paddings(t top: Float?, l left: Float?, b bottom: Float?, r right: Float?, updateMargins: Bool = true) -> Paddings {
        // Use our own variable to store the definitive values just in case layoutMargins gets changed directly,
        // which can get confusing.
        paddings = paddings.to(top: top, left: left, bottom: bottom, right: right)
        
        if updateMargins {
            view.layoutMargins = paddings.toEdgeInsets()
        }
        
        return paddings
    }

    public func padding(_ padding: GPadding) {
        paddings = paddings.to(top: padding.top, left: padding.left, bottom: padding.bottom, right: padding.right)
        view.layoutMargins = paddings.toEdgeInsets()
    }

    public static func setResistance(view: UIView, axis: NSLayoutConstraint.Axis, priority: UILayoutPriority) {
        view.setContentCompressionResistancePriority(priority, for: axis)

        for subview in view.subviews {
            setResistance(view: subview, axis: axis, priority: priority)
        }
    }

    public static func decreaseResistance(view: UIView, axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
        let previousResistance = view.contentCompressionResistancePriority(for: axis)
        setResistance(view: view, axis: axis, priority: .defaultLow)
        return previousResistance
    }

    public static func minimumResistance(view: UIView, axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
        let previousResistance = view.contentCompressionResistancePriority(for: axis)
        setResistance(view: view, axis: axis, priority: UILayoutPriority(rawValue: 1))
        return previousResistance
    }

    public static func maximumResistance(view: UIView, axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
        let previousResistance = view.contentCompressionResistancePriority(for: axis)
        setResistance(view: view, axis: axis, priority: UILayoutPriority(rawValue: 1000))
        return previousResistance
    }

    public static func setHugging(view: UIView, axis: NSLayoutConstraint.Axis, priority: UILayoutPriority) {
        view.setContentHuggingPriority(priority, for: axis)

        for subview in view.subviews {
            setHugging(view: subview, axis: axis, priority: priority)
        }
    }

    public static func increaseHugging(view: UIView, axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
        let previousHugging = view.contentHuggingPriority(for: axis)
        setHugging(view: view, axis: axis, priority: .defaultHigh)
        return previousHugging
    }

    public static func decreaseHugging(view: UIView, axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
        let previousHugging = view.contentHuggingPriority(for: axis)
        setHugging(view: view, axis: axis, priority: .defaultLow)
        return previousHugging
    }

    public static func minimumHugging(view: UIView, axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
        let previousHugging = view.contentHuggingPriority(for: axis)
        setHugging(view: view, axis: axis, priority: UILayoutPriority(rawValue: 1))
        return previousHugging
    }

    public static func maximumHugging(view: UIView, axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
        let previousHugging = view.contentHuggingPriority(for: axis)
        setHugging(view: view, axis: axis, priority: UILayoutPriority(rawValue: 1000))
        return previousHugging
    }

    public func bg(color: UIColor) {
        backgroundView?.removeFromSuperview()
        view.backgroundColor = color
    }

    public func bg(image: UIImage?, repeatTexture: Bool) {
        view.backgroundColor = nil
        backgroundView?.removeFromSuperview()

        if repeatTexture {
            if let img = image {
                view.backgroundColor = UIColor(patternImage: img)
            }
        } else {
            let imageView = GImageView().source(image: image)

            ViewHelper.minimumResistance(view: imageView, axis: .vertical)
            ViewHelper.minimumHugging(view: imageView, axis: .vertical)

            view.insertSubview(imageView, at: 0)
            imageView.snp.makeConstraints { make in
                make.left.equalTo(view.snp.left)
                make.right.equalTo(view.snp.right)
                make.top.equalTo(view.snp.top)
                make.bottom.equalTo(view.snp.bottom)
            }
            backgroundView = imageView
        }
    }
}

// TODO: Deprecate in favour of GPadding
public struct Paddings {
    public let top: Float
    public let left: Float
    public let bottom: Float
    public let right: Float

    public func toEdgeInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: CGFloat(top), left: CGFloat(left), bottom: CGFloat(bottom), right: CGFloat(right))
    }

//    static func from(top: Float?, left: Float?, bottom: Float?, right: Float?, orig: Paddings) -> Paddings {
//        let top = top ?? orig.top
//        let left = left ?? orig.left
//        let bottom = bottom ?? orig.bottom
//        let right = right ?? orig.right
//
//        return Paddings(top: top, left: left, bottom: bottom, right: right)
//    }

    func to(top: Float?, left: Float?, bottom: Float?, right: Float?) -> Paddings {
        let top = top ?? self.top
        let left = left ?? self.left
        let bottom = bottom ?? self.bottom
        let right = right ?? self.right

        return Paddings(top: top, left: left, bottom: bottom, right: right)
    }

//    func to(top: Float?, left: Float?, bottom: Float?, right: Float?) -> Paddings {
//        let top = top ?? self.top
//        let left = left ?? self.left
//        let bottom = bottom ?? self.bottom
//        let right = right ?? self.right
//
//        return Paddings(top: top, left: left, bottom: bottom, right: right)
//    }

}

public struct GPadding {
    public let top: Float?
    public let right: Float?
    public let bottom: Float?
    public let left: Float?

    public init(top: Float?, right: Float?, bottom: Float?, left: Float?) {
        self.top = top
        self.right = right
        self.bottom = bottom
        self.left = left
    }

    func to(top: Float?, right: Float?, bottom: Float?, left: Float?) -> GPadding {
        let top = top ?? self.top
        let left = left ?? self.left
        let bottom = bottom ?? self.bottom
        let right = right ?? self.right

        return GPadding(top: top, right: right, bottom: bottom, left: left)
    }

    public func toEdgeInsets() -> UIEdgeInsets {
        let top = self.top ?? 0
        let left = self.left ?? 0
        let bottom = self.bottom ?? 0
        let right = self.right ?? 0

        return UIEdgeInsets(top: CGFloat(top), left: CGFloat(left), bottom: CGFloat(bottom), right: CGFloat(right))
    }
}
