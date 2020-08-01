import UIKit

open class GCollectionView: UICollectionView {
    private var helper: ViewHelper!

    // Useful for making sure an unattached delegate object sticks around.
    private var retainedRef: UICollectionViewDelegate?
    private var retainedDataSource: UICollectionViewDataSource?

    fileprivate var pager: UIPageControl?

    public init() {
        super.init(frame: .zero, collectionViewLayout: GCollectionViewFlowLayout())
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        helper = ViewHelper(self)
        delegate = self
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        helper.didMoveToSuperview()
    }

    public func width(weight: Float, offset: Float = 0) -> Self {
        helper.width(weight: weight, offset: offset)
        return self
    }

//    public func color(bg: UIColor?) -> Self {
//        if let bgColor = bg {
//            backgroundColor = bgColor
//        }
//        return self
//    }

    public func layout(_ layout: GCollectionViewFlowLayout) -> Self {
        collectionViewLayout = layout
        return self
    }

    public func pagingEnabled(_ enabled: Bool) -> Self {
        isPagingEnabled = enabled
        return self
    }

    public func scrollIndicator(horizontal: Bool) -> Self {
        showsHorizontalScrollIndicator = horizontal
        return self
    }

    public func scrollIndicator(vertical: Bool) -> Self {
        showsVerticalScrollIndicator = vertical
        return self
    }

    public func source(_ source: UICollectionViewDataSource, retain: Bool = false) -> Self {
        dataSource = source
        if retain {
            retainedDataSource = source
        }
        return self
    }

    public func delegate(_ delegate: UICollectionViewDelegate, retain: Bool = false) -> Self {
        self.delegate = delegate
        if retain {
            retainedRef = delegate
        }
        return self
    }
    
    public func pager(_ pager: UIPageControl) -> Self {
        self.pager = pager
        return self
    }

    public func register(cellType: GCollectionViewCell.Type) -> Self {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier())
        return self
    }

    public func cellInstance<T: GCollectionViewCell>(of type: T.Type, for indexPath: IndexPath) -> T {
        if let cell = self.dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier(), for: indexPath) as? T {
            return cell
        }
        return type.init()
    }

//    public func done() {
//        // End chaining
//    }
}

extension GCollectionView: IView {
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
        return self
    }

}

public class GCollectionViewFlowLayout: UICollectionViewFlowLayout {
    public func horizontal() -> Self {
        scrollDirection = .horizontal
        return self
    }
}

extension GCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }

    public func scrollViewWillEndDragging(_: UIScrollView, withVelocity _: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let currentPage = targetContentOffset.pointee.x / frame.width
        pager?.currentPage = Int(currentPage)
    }

    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }
}
