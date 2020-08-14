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
        backgroundColor = .libDefaultBackground
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            contentView.backgroundColor = .libCellHighlight
        } else {
            contentView.backgroundColor = .clear
        }
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        if highlighted {
            contentView.backgroundColor = .lightGray
        } else {
            contentView.backgroundColor = .clear
        }
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
        isUserInteractionEnabled = value
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
