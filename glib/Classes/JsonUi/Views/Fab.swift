import MaterialComponents.MaterialButtons

class JsonView_FabV1: JsonView {
    private let fab = MFab()

    override func initView() -> UIView {
        fab.icon(spec["icon"]["name"].stringValue)
            .onClick { (_) in JsonAction.execute(spec: self.spec["onClick"], screen: self.screen, creator: self.fab) }
        
        return fab
    }

    override func afterViewAdded(parentView: UIView) {
        GLog.d(fab.debugDescription)
        fab.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(-20)
        }
    }
}

class MFab: MDCFloatingButton {
    private var onClick: ((MFab) -> Void)?
    
    init() {
        super.init(frame: .zero, shape: .default)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero, shape: .default)
        initialize()
    }

    private func initialize() {}

    func icon(_ name: String) -> Self {
        let image = UIImage(from: .materialIcon,
                            code: name,
                            textColor: .white,
                            backgroundColor: .clear,
                            size: CGSize(width: 24, height: 24))
        setImage(image, for: .normal)

        return self
    }

    @discardableResult
    open func onClick(_ command: @escaping (MFab) -> Void) -> Self {
        onClick = command
        addTarget(self, action: #selector(performClick), for: .touchUpInside)
        return self
    }

    @objc open func performClick() {
        if let callback = self.onClick {
            callback(self)
        }
    }
}
