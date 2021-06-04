#if INCLUDE_MDLIBS

public class MChipSpec {
    private var decorator: ((MChip) -> Void)

    public init(_ decorator: @escaping ((MChip) -> Void)) {
        self.decorator = decorator
    }

    func decorate(_ view: MChip) {
        decorator(view)
    }

    static let success = MChipSpec { chip in
        chip.color(bg: .libSuccess, text: .white)
    }

    static let error = MChipSpec { chip in
        chip.color(bg: .libError, text: .white)
    }

    static let warning = MChipSpec { chip in
        chip.color(bg: .libWarning, text: .white)
    }

    static let info = MChipSpec { chip in
        chip.color(bg: .libInfo, text: .white)
    }
}

#endif
