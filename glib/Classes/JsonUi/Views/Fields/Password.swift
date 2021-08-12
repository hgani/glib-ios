import SwiftIconFont

class JsonView_Fields_Password: JsonView_AbstractText {
    override func initView() -> UIView {
        let view = super.initTextField().secure(true)

        let imageView = GImageView().width(24).height(24).onClick({ (imageView) in
            view.secure(!view.isSecureTextEntry)
            self.updateRightIcon(textField: view, imageView: imageView)
        })

        // TODO: Fix this. trailingView doesn't seem to work in this version even though it's been
        // the recommended way. See https://github.com/material-components/material-components-ios/issues/9432
        view.trailingView(imageView)
        updateRightIcon(textField: view, imageView: imageView)

        return view
    }

    private func updateRightIcon(textField: MTextField, imageView: UIImageView) {
        let code = textField.isSecureTextEntry ? "visibility" : "visibility.off"
        imageView.image = UIImage(from: .materialIcon, code: code,
                                   textColor: .blue, backgroundColor: .clear,
                                   size: CGSize(width: 24, height: 24))
    }
}
