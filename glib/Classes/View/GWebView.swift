import UIKit
import WebKit

open class GWebView: WKWebView {
    private var helper: ViewHelper!
    private var requestUrl: URL?

    fileprivate lazy var refresher: GRefreshControl = {
        GRefreshControl().onValueChanged { [unowned self] in
            self.refresh()
        }
    }()

    public init() {
        super.init(frame: .zero, configuration: WKWebViewConfiguration())
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        helper = ViewHelper(self)
        navigationDelegate = self

        scrollView.addSubview(refresher)
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        helper.didMoveToSuperview()
    }

    public func load(url: URL, indicator: Bool = true) -> Self {
        requestUrl = url

        GLog.i("Loading \(url) ...")
        if indicator {
            refresher.show()
        }
        load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30))
        return self
    }

    public func load(url: String, indicator: Bool = true) -> Self {
        return load(url: URL(string: url)!, indicator: indicator)
    }

    // Not meant to be used in conjuction with Http and Rest because sessions are not shared
    public func load(path: String) -> Self {
        return load(url: "\(GHttp.instance.host())\(path)")
    }

    public func refresh() {
        // It seems that reload() doesn't do anything when the initial load() failed.
        if let url = self.requestUrl {
            _ = load(url: url)
        }
    }
}

extension GWebView: WKNavigationDelegate {
    public func webView(_: WKWebView, didFinish _: WKNavigation!) {
        refresher.hide()
    }

    public func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        handle(error: error)
    }

    // E.g. SSL error
    public func webView(_: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
        handle(error: error)
    }

    private func handle(error: Error) {
        refresher.hide()

        let alert = UIAlertController(title: nil,
                                      message: error.localizedDescription,
                                      preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [unowned self] (_) -> Void in
            self.refresh()
        })

        GApp.instance.navigationController.present(alert, animated: true, completion: nil)
    }
}

extension GWebView: IView {
    public var sizingHelper: SizingHelper {
        return helper
    }

    public var size: CGSize {
        return helper.size
    }

    @discardableResult
    public func paddings(top: Float?, left: Float?, bottom: Float?, right: Float?) -> Self {
//        paddings = paddings.to(top: top, left: left, bottom: bottom, right: right)
//        contentEdgeInsets = paddings.toEdgeInsets()
        helper.paddings(t: top, l: left, b: bottom, r: right)
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

    @discardableResult
    public func color(bg: UIColor) -> Self {
        backgroundColor = bg
        return self
    }
}
