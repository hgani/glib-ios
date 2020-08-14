import UIKit

open class GTableViewCustomCell: GTableViewCell {
    private let container = GVerticalPanel()

//    public convenience init() {
//        self.init(style: .default)
//    }

    public required init(style: UITableViewCell.CellStyle) {
        super.init(style: style)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
            // Snap the panel's vertical edges so that the tableView can determine the dynamic height of each row
            // See https://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights
            //
            // For some reason contentView's leftMargin and rightMargin are always non-zero, so for predictability,
            // it's better to stick everything to the non-margin borders and set paddings on `container` instead.
            make.top.equalTo(self.contentView.snp.top)
            make.bottom.equalTo(self.contentView.snp.bottom)

            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
        }
    }

    @discardableResult
    public override func paddings(top: Float? = nil, left: Float? = nil, bottom: Float? = nil, right: Float? = nil) -> Self {
        _ = container.paddings(top: top, left: left, bottom: bottom, right: right)
        return self
    }

    public func addView(_ view: UIView, top: Float = 0) {
        container.addView(view, top: top)
    }

    @discardableResult
    public func append(_ view: UIView, top: Float = 0) -> Self {
        container.addView(view, top: top)
        return self
    }

    @discardableResult
    public func color(bg: UIColor) -> Self {
        contentView.backgroundColor = bg
        return self
    }
}
