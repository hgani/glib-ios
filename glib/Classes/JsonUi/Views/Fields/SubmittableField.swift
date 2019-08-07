protocol SubmittableField {
    var name: String? { get }
    var value: String { get }
}

protocol SubmittableFileField: SubmittableField {
    var fileInput: Bool? { get }
    var completed: Bool? { get }
}
