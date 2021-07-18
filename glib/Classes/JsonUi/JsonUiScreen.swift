import SwiftPhoenixClient

open class JsonUiScreen: GScreen {
    private(set) var url: String
    private let contentOnly: Bool
    private let hideBackButton: Bool
    private var request: Rest?
    private var socket: Socket?
    private var channel: Channel?

    let collectionView = GCollectionView()
        .layout(GCollectionViewFlowLayout().horizontal())
        .width(.matchParent)
        .height(300)

    public init(url: String, hideBackButton: Bool = false, contentOnly: Bool = false) {
        self.url = url
        self.contentOnly = contentOnly
        self.hideBackButton = hideBackButton
        super.init()
    }

    public convenience init(path: String, hideBackButton: Bool = false) {
        self.init(url: "\(GHttp.instance.host())/\(path)", hideBackButton: hideBackButton)
    }

    public required init?(coder _: NSCoder) {
        fatalError("Unsupported")
    }

    open override func viewDidLoad() {
        if self.contentOnly {
            // Dialog only
            self.preferredContentSize = CGSize(width: self.view.bounds.width, height: 300)
        }
        
        super.initOnDidLoad()

        if hideBackButton {
            nav.hideBackButton()
        }

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
        if let wsSpec = response.content["ws"].presence {
            let socketSpec = wsSpec["socket"]
            let url = "ws://localhost:4019\(socketSpec["endpoint"].stringValue)"
            var params = socketSpec["params"].dictionaryValue

            // Remove this because version 2.0.0 is still not supported by this client library
            params.removeValue(forKey: "vsn")

//            socket = Socket("wss://phoenix-websocket-demo.herokuapp.com\(ws["socket"]["endpoint"].stringValue)", params: ws["socket"]["params"].dictionaryObject)

            let safeSocket = Socket(url, params: params)
            socket = safeSocket
            initSocket(safeSocket, wsSpec: wsSpec)
        }
        
        if self.contentOnly {
            JsonUi.parseScreenContent(response.content, screen: self)
        } else {
            JsonUi.parseEntireScreen(response.content, screen: self)
        }
    }

    func initSocket(_ socket: Socket, wsSpec: Json) {
        socket.delegateOnOpen(to: self) { (self) in
            GLog.d("Socket Connected")
            if let topic = wsSpec["topic"].string, let events = wsSpec["events"].array {
                let safeChannel = socket.channel(topic)
                self.channel = safeChannel
                self.initChannel(safeChannel, topic: topic, events: events)
            }
        }
        socket.delegateOnClose(to: self) { (self) in
            GLog.d("Socket Disconnected")
        }
        socket.delegateOnError(to: self) { (self, error) in
            GLog.d("Socket Error: \(error.localizedDescription)")
        }
        socket.connect()
    }

    func initChannel(_ channel: Channel, topic: String, events: [Json]) {
        channel.delegateOn("join", to: self) { (self, _) in
            GLog.d("Joined")
        }
        events.forEach({ (event) in
            GLog.d("Registering event \(event.stringValue)")
            channel.delegateOn(event.stringValue, to: self) { (self, message) in
                GLog.d(message.payload.debugDescription)
            }
        })
        channel
            .join()
            .delegateReceive("ok", to: self) { (self, _) in
                GLog.d("Joined channel: \(topic)")
            }
            .delegateReceive("error", to: self) { (self, message) in
                GLog.d("Failed to join channel \(message.payload)")
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
