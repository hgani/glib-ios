public struct GCustomError: Error {
    let message: String

    public var errorDescription: String? {
        return NSLocalizedString(message, comment: "")
    }
}
