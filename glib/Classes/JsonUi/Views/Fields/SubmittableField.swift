protocol SubmittableField {
    var name: String? { get }
    var value: String { get }
    func validate() -> Bool
}

protocol SubmittableFileField: SubmittableField {
    var fileInput: Bool? { get }
    var completed: Bool? { get }
}

extension SubmittableField {
}
