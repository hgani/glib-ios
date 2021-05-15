#if INCLUDE_MDLIBS

public class ThumbnailTemplateSpec {
    private var decorator: ((ThumbnailTemplatePanel) -> Void)

    public init(_ decorator: @escaping ((ThumbnailTemplatePanel) -> Void)) {
        self.decorator = decorator
    }

    func decorate(_ view: ThumbnailTemplatePanel) {
        decorator(view)
    }
}

#endif
