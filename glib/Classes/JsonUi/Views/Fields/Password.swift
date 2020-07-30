import SwiftIconFont

class JsonView_Fields_PasswordV1: JsonView_AbstractTextV1 {
    private var view: UITextField!

    override func initView() -> UITextField {
        view = super.initTextField().secure(true)
        
        #if INCLUDE_MDLIBS
        if let mTextField = view as? MTextField {
            let imageView = GImageView().width(24).height(24).onClick({ (imageView) in
                mTextField.secure(!mTextField.isSecureTextEntry)
                self.updateRightIcon()
            })
            mTextField.rightViewMode = .always
            mTextField.rightView = imageView
            updateRightIcon()
        }
        #endif
        
        return view
    }

    private func updateRightIcon() {
        #if INCLUDE_MDLIBS
        if let mTextField = view as? MTextField, let mImageView = mTextField.rightView as? UIImageView {
            let code = mTextField.isSecureTextEntry ? "visibility" : "visibility.off"
            mImageView.image = UIImage(from: .materialIcon, code: code,
                                       textColor: .blue, backgroundColor: .clear,
                                       size: CGSize(width: 24, height: 24))
        }
        #endif
    }
}

//class JsonView_Fields_PasswordV1: JsonView, SubmittableField {
//    #if INCLUDE_MDLIBS
//        private let view = MTextField()
//    #else
//        private let view = GTextField()
//    #endif
//
//    var name: String?
//    var value: String {
//        return view.text ?? ""
//    }
//
//    override func initView() -> UITextField {
//        name = spec["name"].string
//
//        view.placeholder(spec["label"].stringValue)
//            .text(spec["value"].stringValue)
//            .secure(true)
//
////        TODO: trailingView not show up
////        #if INCLUDE_UILIBS
////            let imageView = GImageView()
////            imageView.image = UIImage(from: .materialIcon, code: "visibility", textColor: .gray, backgroundColor: .white, size: CGSize(width: 24, height: 24))
////            view.trailingViewMode(.always)
////            view.trailingView = imageView
////        #endif
//
//        initBottomBorderIfApplicable()
//
//        return view
//    }
//
//    private func initBottomBorderIfApplicable() {
//        #if !INCLUDE_UILIBS
//            view.borderStyle = .none
//            view.layer.backgroundColor = UIColor.white.cgColor
//
//            view.layer.masksToBounds = false
//            view.layer.shadowColor = UIColor.lightGray.cgColor
//            view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//            view.layer.shadowOpacity = 1.0
//            view.layer.shadowRadius = 0.0
//        #endif
//    }
//
//    func validate() -> Bool {
//        return true
//    }
//}
