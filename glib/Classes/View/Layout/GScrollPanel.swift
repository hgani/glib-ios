import UIKit

open class GScrollPanel: UIScrollView {
    private var helper: ViewHelper!
    let contentView = GVerticalPanel()
    private weak var keyboardScreen: GScreen?
    
    public var size: CGSize {
        return helper.size
    }

    public init() {
        super.init(frame: .zero)
        initialize()
    }

    public required init?(coder _: NSCoder) {
        fatalError("Not supported")
    }

    private func initialize() {
        helper = ViewHelper(self)

        // See https://github.com/zaxonus/AutoLayScroll
//        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo(self)

            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }

        self.delegate = self
    }

    func autoResizeForKeyboard(screen: GScreen) {
        self.keyboardScreen = screen

        NotificationCenter.default.addObserver(self, selector: #selector(resizeForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resizeForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func resizeForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue

        if let view = keyboardScreen?.view {
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)

            if notification.name == UIResponder.keyboardWillHideNotification {
                self.contentInset = UIEdgeInsets.zero
            } else {
                self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            }

            self.scrollIndicatorInsets = self.contentInset
        }
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        helper.didMoveToSuperview()
    }

    public func width(_ width: Int) -> Self {
        helper.width(width)
        return self
    }

    public func width(_ width: LayoutSize) -> Self {
        helper.width(width)
        return self
    }

    public func width(weight: Float) -> Self {
        helper.width(weight: weight)
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

    public func clearViews() {
        contentView.clearViews()
    }

    public func addView(_ view: UIView, top: Float = 0) {
        contentView.addView(view, top: top)
    }

    @discardableResult
    public func append(_ view: UIView, top: Float = 0) -> Self {
        _ = contentView.append(view, top: top)
        return self
    }

//    open override func addSubview(_: UIView) {
//        fatalError("Use addView() instead")
//    }

    public func withRefresher(_ refresher: GRefreshControl) -> Self {
        super.addSubview(refresher)
        return self
    }

    public func paddings(top: Float? = nil, left: Float? = nil, bottom: Float? = nil, right: Float? = nil) -> Self {
        _ = contentView.paddings(top: top, left: left, bottom: bottom, right: right)
        return self
    }

    // UIScrollView delays touch event handling by default.
    public func delayTouch(_ delay: Bool) -> Self {
        delaysContentTouches = delay
        return self
    }

    public func color(bg: UIColor) -> Self {
        backgroundColor = bg
        return self
    }

    public func align(_ align: GAligner.GAlignerHorizontalGravity) -> Self {
        contentView.align(align)
        return self
    }
}

extension GScrollPanel: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ScrollableView.delegateCall(scrollView: scrollView, useContentOffset: true)
    }
}
