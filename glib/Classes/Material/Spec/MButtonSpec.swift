#if INCLUDE_MDLIBS

public class MButtonSpec {
    private var decorator: ((MButton) -> Void)

    public init(_ decorator: @escaping ((MButton) -> Void)) {
        self.decorator = decorator
    }

    func decorate(_ view: MButton) {
        decorator(view)
    }

    static let link = MButtonSpec { button in
        button.color(bg: .clear, text: UIColor(hex: "#1976d2"))
    }

    static let icon = MButtonSpec { button in
        button.paddings(top: 0, left: 0, bottom: 0, right: 0)
            .icon(button.title, size: CGFloat(24))
//            .font(nil, size: 34)
        
        let size = CGFloat(50)
        
        button.snp.makeConstraints { make in
            make.width.equalTo(size)
            make.height.equalTo(size)
        }
        button.layer.cornerRadius = size / 2
    }
}

#endif
