public protocol BuildConfig {
    func host() -> String
//    func wsHost() -> String
    func isDebugMode() -> Bool
}

public extension BuildConfig {
    func isDebugMode() -> Bool {
        return true
    }
}
