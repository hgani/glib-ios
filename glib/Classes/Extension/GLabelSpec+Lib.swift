extension GLabelSpec {
    static let libCellTitle = GLabelSpec { label in
        _ = label.font(nil, size: 16, traits: .traitBold)
    }

    static let libCellSubtitle = GLabelSpec { label in
        _ = label.font(nil, size: 13)
    }

    static let libMuted = GLabelSpec { label in
        _ = label.color(text: label.textColor.withAlphaComponent(0.6))
    }
}
