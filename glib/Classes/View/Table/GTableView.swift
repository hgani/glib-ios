import UIKit

open class GTableView: UITableView, IView {
    private var helper: ViewHelper!

    // Useful for making sure an unattached delegate object sticks around.
    private var retainedRef: UITableViewDelegate?

    public var size: CGSize {
        return helper.size
    }

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        // https://stackoverflow.com/questions/18880341/why-is-there-extra-padding-at-the-top-of-my-uitableview-with-style-uitableviewst
//        if style == .grouped {
//            contentInsetAdjustmentBehavior = .never
//        }
//        self.edgesForExtendedLayout = .none
        
        // https://stackoverflow.com/questions/20305943/why-extra-space-is-at-top-of-uitableview-simple/20306058
        if style == .grouped {
            self.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0);
        }

        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        helper = ViewHelper(self)
        // Allow background to be set by the parent views.
        color(bg: .clear)
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        helper.didMoveToSuperview()
    }

    public func color(bg: UIColor) -> Self {
        backgroundColor = bg
        return self
    }

    public func delegate(_ delegate: UITableViewDelegate, retain: Bool = false) -> Self {
        self.delegate = delegate
        if retain {
            retainedRef = delegate
        }
        return self
    }

    public func source(_ source: UITableViewDataSource) -> Self {
        dataSource = source
        return self
    }

    public func register(nibType: GTableViewCell.Type) -> Self {
        register(nibType.nib(), forCellReuseIdentifier: nibType.reuseIdentifier())
        return self
    }

    public func reload() -> Self {
        reloadData()
        return self
    }

    public func width(_ width: Int) -> Self {
        helper.width(width)
        return self
    }

    public func width(_ width: LayoutSize) -> Self {
        helper.width(width)
        return self
    }

    public func height(_ height: Int) -> Self {
        helper.height(height)
        return self
    }

    public func height(_ height: LayoutSize) -> Self {
        helper.height(height)
        return self
    }

    public func autoRowHeight(estimate: Float) -> Self {
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = CGFloat(estimate)
        return self
    }

    public func autoHeaderHeight(estimate: Float) -> Self {
        sectionHeaderHeight = UITableView.automaticDimension
        estimatedSectionHeaderHeight = CGFloat(estimate)
        return self
    }

    public func cellInstance<T: GTableViewCell>(of type: T.Type, style: UITableViewCell.CellStyle = .default, onCreate: ((T) -> (Void))? = nil) -> T {
        var cell: T
        if let safeCell = self.dequeueReusableCell(withIdentifier: type.reuseIdentifier()) as? T {
            cell = safeCell
        } else {
            cell = type.init(style: style)
            if let block = onCreate {
                block(cell)
            }
        }
        cell.tableView = self
        return cell
    }

    public func paddings(top: Float? = nil, left: Float? = nil, bottom: Float? = nil, right: Float? = nil) -> Self {
        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
    }

    public func separator(_ style: UITableViewCell.SeparatorStyle) -> Self {
        separatorStyle = style
        return self
    }

    public func withRefresher(_ refresher: GRefreshControl) -> Self {
        addSubview(refresher)
        return self
    }

    public var screen: GScreen? {
        return helper.screen
    }

    public func done() {
        // Ends chaining
    }
}
