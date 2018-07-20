import UIKit

open class GScreen: UIViewController {
    public let scrollPanel = GScrollPanel()
    public var container: GScreenContainer!
    
    private var helper : ScreenHelper!
    public var launch : LaunchHelper!
    public var indicator : IndicatorHelper!
    public var nav : NavHelper!
    
    lazy public var refresher: GRefreshControl = {
        return GRefreshControl().onValueChanged {
            self.onRefresh()
        }
    }()
    
    // Don't make this `convenience` so that child class can delegate to it.
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open func screenContent() -> UIView {
        return scrollPanel
    }
    
    // Useful for when we don't have one global nav controller.
    public func localNavController(_ navController: UINavigationController) {
        self.nav = NavHelper(navController: navController)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.container = GScreenContainer(content: screenContent())
        self.helper = ScreenHelper(self)
        self.launch = LaunchHelper(self)
        self.indicator = IndicatorHelper(self)
        if (nav == nil) {
            self.nav = NavHelper(navController: GApp.instance.navigationController)
        }
        
        if let navController = self.navigationController, !navController.navigationBar.isTranslucent {
            // If nav bar is visible and actually consumes space, we want our view to be start just below the bar.
            // Otherwise, we want the view to start right from the top (i.e. status bar)
            self.edgesForExtendedLayout = []
        }

        self.view.backgroundColor = UIColor.white
        
        setupContainer()
    }
    
    private func setupContainer() {
        container.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(container)
        container.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.width.equalTo(view)
            
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        helper.viewWillAppear()
        nav.viewWillAppear()
    }
    
    public func leftMenu(controller: UIViewController) -> Self {
        helper.leftMenu(controller: controller)
        return self
    }
    
    public func leftBarButton(item: UIBarButtonItem) -> Self {
        self.navigationItem.leftBarButtonItem = item
        return self
    }
    
    public func rightBarButton(item: UIBarButtonItem) -> Self {
        self.navigationItem.rightBarButtonItem = item
        return self
    }
    
    public func title(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    public func done() {
        // Ends chaining
    }
    
    public func color(bg: UIColor) -> Self {
        self.view.backgroundColor = bg
        return self
    }
    
//    public func paddings(t top: Float? = nil, l left: Float? = nil, b bottom: Float? = nil, r right: Float? = nil) -> Self {
//        _ = container.paddings(t: top, l: left, b: bottom, r: right)
//        return self
//    }
    
    // Don't declare this in an extension or else we'll get compile error
    // See https://stackoverflow.com/questions/44616409/declarations-in-extensions-cannot-override-yet-error-in-swift-4
    open func onRefresh() {
        // To be overridden
    }
}



extension GScreen: ScreenProtocol {
    public var controller: UIViewController {
        get {
            return self
        }
    }
}



import XLPagerTabStrip

extension GScreen: IndicatorInfoProvider {
    public func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: title)
    }
}



public class GScreenContainer: GHamburgerPanel {
    public let header = GVerticalPanel().width(.matchParent)
//    private let scrollView: GScrollView?
    private let content: UIView
    public let footer = GVerticalPanel().width(.matchParent)
    
    public init(content: UIView) {
        self.content = content
//        self.scrollView = content as? GScrollView
        
        super.init()
        initialize()
    }

    required public init?(coder: NSCoder) {
        fatalError("Unsupported operation")
    }
    
    private func initialize() {
        _ = self.withViews(
            header,
            content,
            footer
        )
        content.snp.makeConstraints { make in
            make.right.equalTo(self.snp.rightMargin)
        }
    }
    
//    override public func paddings(t top: Float? = nil, l left: Float? = nil, b bottom: Float? = nil, r right: Float? = nil) -> Self {
//        if let view = content as? IContainer {
//            _ = view.paddings(t: top, l: left, b: bottom, r: right)
//        }
//        return self
//    }
//
//    public func clearViews() {
//        scrollView?.clearViews()
//    }
//
//    public func addView(_ view: UIView, top : CGFloat? = nil) {
//        scrollView?.addView(view, top: top)
//    }
//
//    // UIScrollView delays touch event handling by default.
//    public func delayTouch(_ delay: Bool) {
//        scrollView?.delaysContentTouches = delay
//    }
}

