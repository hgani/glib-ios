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
//    func closest<T: UIView>(_ type: T.Type, from: UIView) -> T? {
//        if let superview = from.superview {
//            if let found = superview as? T {
//                return found
//            } else {
//                return closest(type, from: superview)
//            }
//        }
//        return nil
//    }
//
//    func registerToClosestForm(field: UIView) {
////        // TODO: Consider calling this from afterViewAdded() once the lifecycle has been properly implemented
////        DispatchQueue.main.async {
////            if let form = self.closest(JsonView_Panels_FormV1.FormPanel.self, from: field) {
////                form.addField(self)
////            }
////        }
//
//        if let form = self.closest(JsonView_Panels_FormV1.FormPanel.self, from: field) {
//            form.addField(self)
//        }
//    }
//
//    override func didAttach(to _: UIView) {
//        self.registerToClosestForm(field: view)
//    }
}
