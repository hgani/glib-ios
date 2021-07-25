import SnapKit
import UIKit

// TODO: Merge back to ViewHelper? Too complicated to handle both?
public class SizingHelper {
    private unowned let view: UIView
    private var matchParentWidthMultiplier: Float?
    private var matchParentHeightMultiplier: Float?
//    var paddings = Paddings(top: 0, left: 0, bottom: 0, right: 0)

    private var widthConstraint: Constraint?
    private var heightConstraint: Constraint?

//    private var backgroundView: GImageView?

    // TODO: Should we use weak/unowned?
    // TODO: Avoid writing publicly
    var delegate: SizingDelegate?

    public var size: CGSize {
        return view.bounds.size
    }

//    public var screen: GScreen? {
//        var nextResponder = view.next
//        while let responder = nextResponder {
//            if let screen = responder as? GScreen {
//                return screen
//            }
//            nextResponder = responder.next
//        }
//        return nil
//    }

    public init(_ view: UIView) {
        self.view = view
//        view.layoutMargins = paddings.toEdgeInsets()
    }

    func didMoveToSuperview(debug: Bool = false) {
        updateWidthConstraints(debug: debug)
        updateHeightConstraints()
    }

    private func updateWidthConstraints(offset: Float = 0, debug: Bool = false) {
        if let superview = view.superview {
            if let multiplier = matchParentWidthMultiplier {
                view.snp.makeConstraints { make in
                    if debug {
                        GLog.t("updateWidthConstraints() with multiplier \(multiplier)")
                    }

                    if multiplier == 1 {
                        widthConstraint = make.right.equalTo(superview.snp.rightMargin).constraint // Consume remaining space
                    } else {
                        widthConstraint = make.width.equalTo(superview).multipliedBy(multiplier).offset(offset).constraint
                    }
                }
            }
        }
    }

    private func updateHeightConstraints(offset: Float = 0, debug: Bool = false) {
        if let superview = view.superview {
            if let multiplier = matchParentHeightMultiplier {
                view.snp.makeConstraints { make in
                    if debug {
                        GLog.t("updateHeightConstraints() with multiplier \(multiplier)")
                    }

                    if multiplier == 1 {
                        heightConstraint = make.bottom.equalTo(superview.snp.bottomMargin).constraint
                    } else {
                        heightConstraint = make.height.equalTo(superview).multipliedBy(multiplier).offset(offset).constraint
                    }
                }
            }
        }
    }

    func shouldWidthMatchParent() -> Bool {
        return matchParentWidthMultiplier != nil
    }

    func shouldHeightMatchParent() -> Bool {
        return matchParentHeightMultiplier != nil
    }

    private func nothingToDo() {
        // Nothing to do
    }

    private func resetWidth() {
        widthConstraint?.deactivate()
        widthConstraint = nil
        matchParentWidthMultiplier = nil
    }

    public func width(_ width: Int) {
        resetWidth()

        matchParentWidthMultiplier = nil
        view.snp.makeConstraints { (make) -> Void in
            widthConstraint = make.width.equalTo(width).constraint
        }

        updateWidthConstraints()
    }

    public func width(_ width: LayoutSize) {
        resetWidth()

        switch width {
        case .matchParent:
            matchParentWidthMultiplier = 1
        case .wrapContent:
            nothingToDo()
        }

        updateWidthConstraints()
        delegate?.onWidthUpdated()
    }

    public func width(weight: Float, offset: Float = 0) {
        resetWidth()

        matchParentWidthMultiplier = weight
        updateWidthConstraints(offset: offset)
    }

    private func resetHeight() {
        heightConstraint?.deactivate()
        heightConstraint = nil
        matchParentHeightMultiplier = nil
    }

    public func height(_ height: Int) {
        resetHeight()

        view.snp.makeConstraints { (make) -> Void in
            heightConstraint = make.height.equalTo(height).constraint
        }

        updateHeightConstraints()
    }

    public func height(_ height: LayoutSize) {
        resetHeight()

        switch height {
        case .matchParent:
            matchParentHeightMultiplier = 1
        case .wrapContent:
            matchParentHeightMultiplier = nil
//            nothingToDo()
        }

        updateHeightConstraints()
        delegate?.onHeightUpdated()
    }

    public func height(weight: Float, offset: Float = 0) {
        resetHeight()

        matchParentHeightMultiplier = weight
        updateHeightConstraints(offset: offset)
    }

    public func size(width: Int?, height: Int?) {
        if let widthValue = width {
            self.width(widthValue)
        }
        if let heightValue = height {
            self.height(heightValue)
        }
    }
}

public enum LayoutSize: String {
    case matchParent, wrapContent
}

protocol SizingDelegate {
    func onWidthUpdated()
    func onHeightUpdated()
}
