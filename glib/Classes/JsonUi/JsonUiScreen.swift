open class JsonUiScreen: GScreen {
    private(set) var url: String
    private let contentOnly: Bool
    private var request: Rest?

    let collectionView = GCollectionView()
        .layout(GCollectionViewFlowLayout().horizontal())
        .width(.matchParent)
        .height(300)
        .color(bg: .red)

    public init(url: String, contentOnly: Bool = false) {
        self.url = url
        self.contentOnly = contentOnly
        super.init()
    }

    public convenience init(path: String) {
        self.init(url: "\(GHttp.instance.host())/\(path)")
    }

    public required init?(coder _: NSCoder) {
        fatalError("Unsupported")
    }

    open override func viewDidLoad() {
        super.initOnDidLoad()

        onRefresh()
    }

    public override func onRefresh() {
        update(url: url)

//        self.request = Rest.get(url: url).execute { response in
//            self.update(response: response)
//            self.refresher.endRefreshing()
//            return true
//        }
    }

    public override func viewWillDetach() {
        super.viewWillDetach()

        self.request?.cancel()
    }

    private func update(response: Rest.Response) {
        if self.contentOnly {
            JsonUi.parseContentScreen(response.content, screen: self)
        } else {
            JsonUi.parseEntireScreen(response.content, screen: self)
        }
    }

    func update(url: String) {
        self.url = url

        self.request = Rest.get(url: url).execute { response in
            self.refresher.endRefreshing()
            self.refresher.removeFromSuperview()

            self.container.header.clearViews()
            self.container.content.clearViews()
            self.container.footer.clearViews()

            self.update(response: response)
            return true
        }
    }
}
