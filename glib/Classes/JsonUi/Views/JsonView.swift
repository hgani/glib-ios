import jsonlogic

open class JsonView {
    private var backend: UIView?
    public let spec: Json
    public unowned let screen: GScreen

    // This constructor allows dynamic instantiation of child classes.
    public required init(_ spec: Json, _ screen: GScreen) {
        self.spec = spec
        self.screen = screen
    }

//    // TODO: Remove. Replaced with onAfterInitView
//    public func didAttach(to parent: UIView) {
//        // To be overridden
//    }

    private func initGenericAttributes(backend: UIView) {
        if let view = backend as? UIView & IView {
            initBackgroundColor(view)
            initWidth(view)
            initHeight(view)
            initPadding(view)
            applyStyleClasses(spec["styleClasses"].arrayValue.map({ $0.stringValue }))
        } else {
            fatalError("Not a valid view: \(type(of: backend)) in \(spec["view"])")
        }
    }

    private func color(from str: String) -> UIColor {
        switch str {
        case "transparent":
            return UIColor.clear
        default:
            return UIColor(hex: str)
        }
    }

    func ifColor(code: String?, handler: (UIColor) -> Void) {
        if let str = code {
            handler(color(from: str))
        }
    }

    private func initBackgroundColor(_ view: IView) {
        if let str = spec["backgroundColor"].string {
            view.color(bg: color(from: str))
        }
    }

    private func initWidth(_ view: IView) {
        if let width = spec["width"].presence {
            if let val = width.string {
                switch val {
                case "wrapContent":
                    view.width(.wrapContent)
                case "matchParent":
                    view.width(.matchParent)
                default:
                    view.width(width.intValue)
                }
            } else if let val = width.int {
                view.width(width.intValue)
            }
        }
    }

    private func initHeight(_ view: UIView & IView) {
        if let height = spec["height"].presence {
            if let val = height.string {
                switch val {
                case "wrapContent":
                    view.height(.wrapContent)
                case "matchParent":
                    view.height(.matchParent)
                    // Needed for high hugging views (e.g. UILabel, UIButton) in a stretchable panel, e.g.
                    // the middle part of a hamburger panel.
                    ViewHelper.minimumHugging(view: view, axis: .vertical)
                default:
                    view.height(height.intValue)
                }
            } else if let val = height.int {
                view.height(height.intValue)
            }
        }
    }

    private func initPadding(_ view: IView) {
        let padding = spec["padding"]
        view.paddings(top: padding["top"].float, left: padding["left"].float, bottom: padding["bottom"].float, right: padding["right"].float)
    }

    open func initView() -> UIView {
        fatalError("Need implementation")
    }

    open func onAfterInitView(_ view: UIView) {
        // To be overridden
    }

    private func applyStyleClasses(_ styleClasses: [String]) {
        for styleClass in styleClasses {
            applyStyleClass(styleClass)
        }
    }

    open func applyStyleClass(_ styleClass: String) {
        // To be overridden
    }

    // TODO: Consider using this instead of view() now that we use it for creation everywhere
    func createView() -> UIView {
//        let view = initView()
//        initGenericAttributes(backend: view)
//        return view
        return view()
    }

    func view() -> UIView {
        if let backend = self.backend {
            return backend
        }

        let view = initView()
        self.backend = view
        initGenericAttributes(backend: view)
        hideInitially(view: view)

        // This might look hacky but it's much less error prone than the alternative, where we need to
        // explicitly execute the callback for every parent component, which will get very complex
        // when it involves nested parents because we won't know at which point the whole nesting has
        // been fully connected.
        DispatchQueue.main.async {
            // This is supposed to execute after the view has been added to parent.
            self.onAfterInitView(view)
            self.registerJsonLogic(view: view)
        }

        return view
    }

    private func hideInitially(view: UIView) {
        if let showIf = self.spec["showIf"].presence {
            if let iview = view as? IView {
                iview.show(false)
            } else {
                fatalError("Not a valid view: \(type(of: view))")
            }
        }
    }

    private func registerJsonLogic(view: UIView) {
        guard let form = closest(JsonView_Panels_Form.FormPanel.self, from: view) else {
            return
        }
        guard let showIf = self.spec["showIf"].rawString() else {
            return
        }

        form.formData.asObservable().subscribe { _ in
            do {
                let jsonlogic = try JsonLogic(showIf)
                let result: Bool = try jsonlogic.applyRule(to: form.formData.value.rawString())

                if let iview = view as? IView {
                    iview.show(result)
                } else {
                    fatalError("Not a valid view: \(type(of: view))")
                }
            } catch {
                GLog.d("Invalid rule")
            }
        }

    }

    func closest<T: UIView>(_ instanceType: T.Type, from: UIView) -> T? {
        if let superview = from.superview {
            if let found = superview as? T {
                return found
            } else {
                return closest(instanceType, from: superview)
            }
        }
        return nil
    }

    static func create(spec: Json, screen: GScreen) -> JsonView? {
        let viewName = spec["view"].stringValue
        if let klass = JsonUi.loadClass(name: viewName, type: JsonView.self) as? JsonView.Type {
            return klass.init(spec, screen)
        }
        GLog.w("Failed loading view: \(viewName)")
        return nil
    }
}
