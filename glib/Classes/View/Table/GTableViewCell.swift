import UIKit

open class GTableViewCell: UITableViewCell {
    public internal(set) weak var tableView: GTableView?
    private var helper: ViewHelper!

    public convenience init() {
        self.init(style: .default)
    }

    public required init(style: UITableViewCell.CellStyle) {
        super.init(style: style, reuseIdentifier: type(of: self).nibName())

        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }

    private func initialize() {
        helper = ViewHelper(contentView)

        // Allow background to be set by the parent views.
        backgroundColor = .clear
        
        // Enable this by default to minimize surprises, e.g buttons not clickabled.
        isUserInteractionEnabled = true

    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Already looks good without this.
//        if selected {
//            contentView.backgroundColor = .libCellHighlight
//        } else {
//            contentView.backgroundColor = .clear
//        }
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        // Already looks good without this.
//        if highlighted {
//            contentView.backgroundColor = .lightGray
//        } else {
//            contentView.backgroundColor = .clear
//        }
    }

    public func paddings(top: Float? = nil, left: Float? = nil, bottom: Float? = nil, right: Float? = nil) -> Self {
        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
    }

    public func done() {
        // End call chaining
    }

    static func nibName() -> String {
        return String(describing: self)
    }

    static func reuseIdentifier() -> String {
        return String(reflecting: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: nibName(), bundle: nil)
    }

    public func interactive(_ value: Bool) -> Self {
        if value {
            selectionStyle = .default
        } else {
            selectionStyle = .none
        }
        return self
    }

    public func selectionStyle(_ value: UITableViewCell.SelectionStyle) -> Self {
        selectionStyle = value
        return self
    }
}
