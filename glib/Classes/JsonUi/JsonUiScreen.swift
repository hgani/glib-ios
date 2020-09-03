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

    open override func onRefresh() {
        update(url: url, onLoad: {
            // Nothing to do
        })
    }

    open override func viewWillDetach() {
        super.viewWillDetach()

        self.request?.cancel()
    }

    private func update(response: Rest.Response) {
        if self.contentOnly {
            JsonUi.parseScreenContent(response.content, screen: self)
        } else {
            JsonUi.parseEntireScreen(response.content, screen: self)
        }
    }

    func update(url: String, onLoad: @escaping () -> (Void)) {
        self.url = url

        self.request = Rest.get(url: url).execute { response in
            self.update(response: response)
            onLoad()
            return true
        }
    }
}

open class JsonScreen: GScreen {
    private let spec: Json
    
    public init(spec: Json) {
        self.spec = spec
        super.init()
    }
    
    public required init?(coder _: NSCoder) {
        fatalError("Unsupported")
    }
    
    open override func viewDidLoad() {
        super.initOnDidLoad()
        JsonUi.parseScreenContent(spec, screen: self)
    }
}
