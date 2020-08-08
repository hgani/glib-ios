import SwiftIconFont

class JsonView_Fields_Password: JsonView_AbstractText {
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
