public struct GCustomError: Error {
    let message: String
}

// See https://stackoverflow.com/questions/44547486/custom-error-type-initializer
extension GCustomError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(message, comment: "")
    }
}
