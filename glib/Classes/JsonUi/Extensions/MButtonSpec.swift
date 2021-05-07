#if INCLUDE_MDLIBS

extension MButtonSpec {
    static let link = MButtonSpec { button in
        button.color(bg: .clear, text: UIColor(hex: "#1976d2"))
    }

    static let icon = MButtonSpec { button in
        button.layer.cornerRadius = 18
    }

//    static func icon(code: String) -> MButtonSpec {
//        return MButtonSpec { button in
//            button.title("ma:\(code)").iconify()
//        }
//    }

//    static func icon(_ icon: GIcon) -> MButtonSpec {
//        return MButtonSpec { button in
//            button.icon(icon)
//        }
//    }
}

//open class MButtonSpecProtocol {
//    public required init() {}
//
//    open func createSpec() -> MButtonSpec {
//        fatalError()
//    }
//}

#endif
