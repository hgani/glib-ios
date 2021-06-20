open class JsonAction {
    public let spec: Json
//    public let screen: GScreen
//    public var targetView: UIView? = nil

    public let screen: UIViewController
    public var targetView: UIView?

    public var launch: LaunchHelper {
        return LaunchHelper(screen)
    }

    public var nav: NavHelper {
        return NavHelper(navController: GApp.instance.navigationController)
    }

    public var indicator: IndicatorHelper {
        return IndicatorHelper(screen)
    }

    public required init(_ spec: Json, _ screen: UIViewController) {
        self.spec = spec
        self.screen = screen
    }

    public final func execute() {
        if !silentExecute() {
            GLog.w("Invalid action spec: \(spec)")
        }
    }

    open func silentExecute() -> Bool {
        fatalError("Need implementation")
    }

    private static func create(spec: Json, screen: UIViewController) -> JsonAction? {
        if spec.isNull {
            return nil
        }
        if let klass = JsonUi.loadClass(name: spec["action"].stringValue, type: JsonAction.self) as? JsonAction.Type {
            return klass.init(spec, screen)
        }
        GLog.w("Failed loading action: \(spec)")
        return nil
    }

    public static func execute(spec: Json, screen: UIViewController, creator: UIView?) {
        if let instance = create(spec: spec, screen: screen) {
            instance.targetView = creator
            instance.execute()
        }
    }

    public static func execute(spec: Json, screen: UIViewController, creator: JsonAction) {
        execute(spec: spec, screen: screen, creator: creator.targetView)
    }

//    public static func execute(spec: Json, screen: UIViewController, creator: JsonAction) {
//        if let instance = create(spec: spec, screen: screen) {
//            instance.targetView = creator.targetView
//            instance.execute()
//        }
//    }
}
