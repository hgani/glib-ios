#if INCLUDE_UILIBS

open class MCollectionView: UICollectionView, IContainer {
    private var helper: ViewHelper!

    public var size: CGSize {
        return helper.size
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        helper = ViewHelper(self)
        backgroundColor = .white
    }

    public func delegate(_ delegate: UICollectionViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    public func source(_ source: UICollectionViewDataSource) -> Self {
        dataSource = source
        return self
    }

    public func color(bg: UIColor) -> Self {
        backgroundColor = bg
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

    public func paddings(top: Float? = nil, left: Float? = nil, bottom: Float? = nil, right: Float? = nil) -> Self {
        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
    }

    public func register(cellType: MCollectionViewCell.Type) -> Self {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier())
        return self
    }

    public func cellInstance<T: MCollectionViewCell>(of type: T.Type, for indexPath: IndexPath) -> T {
        if let cell = self.dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier(), for: indexPath) as? T {
            return cell
        }
        return type.init()
    }
}

#endif
