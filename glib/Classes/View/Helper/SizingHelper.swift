import SnapKit
import UIKit

private let INDEX_WRAP_CONTENT = -1
private let INDEX_MATCH_PARENT = -2

public class SizingHelper {
    private unowned let view: UIView
    private var matchParentWidthMultiplier: Float?
    private var matchParentHeightMultiplier: Float?

    private var widthConstraint: Constraint?
    private var heightConstraint: Constraint?
    
//    private var hiddenWidthLayout: LayoutSize = .wrapContent
//    private var hiddenHeightLayout: LayoutSize = .wrapContent
    
//    private static let wrapContentIndex = -1
//    private static let matchParentIndex = -2
//    private var hiddenWidth: Int = wrapContentIndex
//    private var hiddenHeight: Int = wrapContentIndex
    
    private var hiddenWidth: Int = INDEX_WRAP_CONTENT
    private var hiddenHeight: Int = INDEX_WRAP_CONTENT

    weak var delegate: SizingDelegate?

    public var size: CGSize {
        return view.bounds.size
    }

    public init(_ view: UIView) {
        self.view = view
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
        hiddenWidth = width
        
        setWidthConstraint(width)
    }

    private func setWidthConstraint(_ width: Int) {
        resetWidth()
                
//        matchParentWidthMultiplier = nil
        view.snp.makeConstraints { (make) -> Void in
            widthConstraint = make.width.equalTo(width).constraint
        }

        updateWidthConstraints()
    }

    public func width(_ width: LayoutSize) {
        resetWidth()

        switch width {
        case .matchParent:
            hiddenWidth = INDEX_MATCH_PARENT
            matchParentWidthMultiplier = 1
        case .wrapContent:
            hiddenWidth = INDEX_WRAP_CONTENT
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
        hiddenHeight = height

        setHeightConstraint(height)
    }

    private func setHeightConstraint(_ height: Int) {
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
            hiddenHeight = INDEX_MATCH_PARENT
            matchParentHeightMultiplier = 1
        case .wrapContent:
            hiddenHeight = INDEX_WRAP_CONTENT
            matchParentHeightMultiplier = nil
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
    
    public func show(_ show: Bool) {
//        guard let view = self as? UIView else { return self }
        
        if show {
//            width(.wrapContent)
//            height(.wrapContent)
            
            switch hiddenWidth {
            case INDEX_WRAP_CONTENT:
                width(.wrapContent)
            case INDEX_MATCH_PARENT:
                width(.matchParent)
            default:
                width(hiddenWidth)
            }
            
            switch hiddenHeight {
            case INDEX_WRAP_CONTENT:
                height(.wrapContent)
            case INDEX_MATCH_PARENT:
                height(.matchParent)
            default:
                height(hiddenHeight)
            }

//            if hiddenWidth == -1 {
//                width(.matchParent)
//            } else {
//                width(hiddenWidth)
//            }
//            if hiddenHeight == -1 {
//                height(.matchParent)
//            } else {
//                height(hiddenHeight)
//            }
        } else {
//            width(0)
//            height(0)
            
            setWidthConstraint(0)
            setHeightConstraint(0)
        }
        view.isHidden = !show
        
//        return self
    }

}

public enum LayoutSize: String {
    case matchParent, wrapContent
}

protocol SizingDelegate : AnyObject {
    func onWidthUpdated()
    func onHeightUpdated()
}
