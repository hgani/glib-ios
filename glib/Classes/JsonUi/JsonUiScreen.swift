public class JsonUiScreen: GScreen {
    private let url: String
    private let contentOnly: Bool

    private let collectionView = GCollectionView()
        .layout(GCollectionViewFlowLayout().horizontal())
        .width(.matchParent)
        .height(300)
        .color(bg: .red)

    init(url: String, contentOnly: Bool = false) {
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

    public override func viewDidLoad() {
        super.viewDidLoad()

        onRefresh()
    }

    public override func onRefresh() {
        _ = Rest.get(url: url).execute { response in
            if self.contentOnly {
                JsonUi.parseContentScreen(response.content, screen: self)
            } else {
                JsonUi.parseEntireScreen(response.content, screen: self)
            }
            return true
        }
    }

    public func getUrl() -> String {
        return url
    }
}
