import UIKit

public class GLabelSpec {
    private var decorator: ((GLabel) -> Void)

    public init(_ decorator: @escaping ((GLabel) -> Void)) {
        self.decorator = decorator
    }

    func decorate(_ view: GLabel) {
        decorator(view)
    }
    
    static let link = GLabelSpec { label in
        label.color(UIColor(hex: "#1976d2"))
    }
}
