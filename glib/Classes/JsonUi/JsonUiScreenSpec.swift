public class JsonUiScreenSpec {
    private var decorator: ((JsonUiScreen) -> Void)

    public init(_ decorator: @escaping ((JsonUiScreen) -> Void)) {
        self.decorator = decorator
    }

    func decorate(_ view: JsonUiScreen) {
        decorator(view)
    }
}
