import UIKit

open class GCollectionViewCell: UICollectionViewCell {
    private let container = GVerticalPanel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        contentView.addSubview(container)
        initContent()
    }

    open func initContent() {
        // To be overridden
    }

    open override func didMoveToSuperview() {
        container.snp.makeConstraints { (make) -> Void in
            // See GTableViewCustomCell
            make.top.equalTo(self.contentView.snp.top)
            make.bottom.equalTo(self.contentView.snp.bottom)

            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
        }
    }

    public func paddings(t top: Float? = nil, l left: Float? = nil, b bottom: Float? = nil, r right: Float? = nil) -> Self {
        _ = container.paddings(top: top, left: left, bottom: bottom, right: right)
        return self
    }

    public func addView(_ view: UIView, top: Float = 0) {
        container.addView(view, top: top)
    }

    public func clear() -> Self {
        container.clear()
        return self
    }

    @discardableResult
    public func append(_ view: UIView, top: Float = 0) -> Self {
        container.addView(view, top: top)
        return self
    }

    public func color(bg: UIColor) -> Self {
        contentView.backgroundColor = bg
        return self
    }

//    public func done() {
//        // End call chaining
//    }

    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
}
