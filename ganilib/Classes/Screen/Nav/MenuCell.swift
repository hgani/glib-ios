public protocol MenuCellType {
    func update(item: MenuItem)
}

open class MenuCell: GTableViewCustomCell, MenuCellType {
    public let icon = GLabel()
    public let title = GLabel()

    public required init(style: UITableViewCellStyle) {
        super.init(style: style)
        populate()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        populate()
    }

    open func populate() {
        paddings(top: 8, left: 14, bottom: 8, right: 14)
            .append(GHorizontalPanel().paddings(t: 5, l: 10, b: 5, r: 10).append(icon).append(title, left: 5))
            .done()
    }

    open func update(item: MenuItem) {
        if let iconText = item.icon {
            _ = icon.icon(iconText)
        }
        _ = title.text(item.title)

        isUserInteractionEnabled = item.hasAction()

        setNeedsLayout()
    }
}

// class MenuCell: UITableViewCell {
//    var titleLabel: UILabel!
//    var iconLabel: UILabel!
//
//    var menu: MenuItem? {
//        didSet {
//            if let m = menu {
//                titleLabel.text = m.title
//                iconLabel.text = m.icon
//                iconLabel.parseIcon()
//                setNeedsLayout()
//            }
//        }
//    }
//
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        titleLabel = UILabel(frame: .zero)
//        titleLabel.textColor = UIColor.black
//        contentView.addSubview(titleLabel)
//
//        iconLabel = UILabel(frame: .zero)
//        contentView.addSubview(iconLabel)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        titleLabel.sizeToFit()
//        iconLabel.font = iconLabel.font.withSize(20)
//        iconLabel.sizeToFit()
//
//        iconLabel.snp.makeConstraints { (make) -> Void in
//            make.topMargin.equalTo(8)
//            make.leftMargin.equalTo(8)
//        }
//        titleLabel.snp.makeConstraints { (make) -> Void in
//            make.topMargin.equalTo(8)
//            make.left.equalTo(iconLabel.snp.right).offset(8)
//        }
//
//    }
// }
