
open class GObject {
    func mustBeOverridden() -> Never {
        fatalError("Must be overridden by \(type(of: self))")
    }
}

extension UIViewController {
    func mustBeOverridden() -> Never {
        fatalError("Must be overridden by \(type(of: self))")
    }
}

extension UIView {
    func mustBeOverridden() -> Never {
        fatalError("Must be overridden by \(type(of: self))")
    }
}
