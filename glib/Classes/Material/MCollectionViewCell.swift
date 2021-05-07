#if INCLUDE_MDLIBS

import MaterialComponents.MaterialList

// See how we can use composition: https://github.com/material-components/material-components-ios-codelabs/blob/master/MDC-104/ObjectiveC/Starter/Shrine/Pods/MaterialComponents/components/List/src/MDCSelfSizingStereoCell.m
//open class MCollectionViewCell: MDCSelfSizingStereoCell {
open class MCollectionViewCell: MDCBaseCell {
    private var swipeOpened = false
    private let editButtonsPanel = GHorizontalPanel()
    private let backend = MDCSelfSizingStereoCell()

    var titleLabel: UILabel {
        return backend.titleLabel
    }

    var detailLabel: UILabel {
        return backend.detailLabel
    }

    var leadingImageView: UIImageView {
        return backend.leadingImageView
    }

    var hasEditButtons = false

    static func reuseIdentifier() -> String {
        return String(describing: self)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        setupConstraint()

        self.addSubview(editButtonsPanel)
        editButtonsPanel.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(self.contentView)
            make.right.equalTo(0)
        }

        self.contentView.backgroundColor = .white
        self.bringSubviewToFront(self.contentView)
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
        leftSwipe.direction = .left
        addGestureRecognizer(leftSwipe)

        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
        rightSwipe.direction = .right
        addGestureRecognizer(rightSwipe)
    }

    private func setupConstraint() {
//        TODO: no effect
//        contentView.snp.makeConstraints { (make) in
//            make.margins.equalTo(0)
//            make.top.equalTo(0)
//        }

        backend.detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backend.titleLabel.snp.bottom)
        }
    }

    func appendEditButton(spec: Json, screen: GScreen) {
        var buttonSpec = spec
        // TODO: Need to be able to support non-v1 as well
        buttonSpec["view"] = "button-v1"
        if let jsonView = JsonView.create(spec: buttonSpec, screen: screen) {
            editButtonsPanel.append(jsonView.createView())
        }
    }

    @objc func handleLeftSwipe(gesture: UISwipeGestureRecognizer) {
        if !hasEditButtons {
            return
        }

        if !swipeOpened {
            UIView.animate(withDuration: 0.5) {
                self.contentView.transform = CGAffineTransform(translationX: -200, y: 0)
                self.swipeOpened = true
            }
        }
    }

    @objc func handleRightSwipe(gesture: UISwipeGestureRecognizer) {
        if !hasEditButtons {
            return
        }

        if swipeOpened {
            UIView.animate(withDuration: 0.5) {
                self.contentView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.swipeOpened = false
            }
        }
    }
}

#endif
