import UIKit

open class GHeaderFooterView: UIView {
    private let container = GVerticalPanel()

    public init() {
        super.init(frame: .zero)
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    public func initialize() {
        addSubview(container)

        container.snp.makeConstraints { make in
            // Snap the panel's vertical edges so that the tableView can determine the dynamic height of each row
            // See https://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights
            make.top.equalTo(self)
            make.bottom.equalTo(self)

            make.left.equalTo(self)
            make.right.equalTo(self)
        }

        backgroundColor = .white
    }

    public func clearViews() {
        container.clearViews()
    }

    public func addView(_ view: UIView, top: Float = 0) {
        container.addView(view, top: top)
    }

    public func clear() -> Self {
        clearViews()
        return self
    }

    public func append(_ view: UIView, top: Float = 0) -> Self {
        addView(view, top: top)
        return self
    }

    public func paddings(top: Float? = nil, left: Float? = nil, bottom: Float? = nil, right: Float? = nil) -> Self {
        _ = container.paddings(top: top, left: left, bottom: bottom, right: right)
        return self
    }

    public func color(bg: UIColor) -> Self {
        _ = container.color(bg: bg)
        return self
    }
}
