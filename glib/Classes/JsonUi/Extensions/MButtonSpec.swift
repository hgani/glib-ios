extension MButtonSpec {
    static let link = MButtonSpec { button in
        button.color(bg: .clear, text: UIColor(hex: "#1976d2"))
    }

    static func icon(code: String) -> MButtonSpec {
        return MButtonSpec { button in
            button.title("ma:\(code)").iconify()
        }
    }
}
