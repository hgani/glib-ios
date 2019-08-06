class JsonView_Fields_FileV1: JsonView, SubmittableField, ImagePickerDelegate {
    private let panel = GHorizontalPanel()
    private let imageView = GImageView()
    private let progressView = MProgressView()
    private var imagePicker: ImagePicker!

    var name: String?
    var value: String = ""

    override func initView() -> UIView {
        name = spec["name"].string

        self.imagePicker = ImagePicker(self.screen, delegate: self)

        return GVerticalPanel()
            .append(GLabel().text(spec["label"].stringValue))
            .append(panel
                .append(GAligner().align(.left).withView(GLabel().text("No file choosen")))
                .append(GAligner().align(.right).withView(
                    MButton().title("Choose file").onClick({ (button) in
                        self.imagePicker.present()
                    })
                )))
    }

    func didSelect(image: UIImage?) {
        if let selectedImage = image {
            updateViews(image: selectedImage)
            uploadImage(image: selectedImage)
        }
    }

    private func updateViews(image: UIImage) {
        panel.clearViews()

        imageView.source(image: image).width(80)
        panel.append(GAligner().align(.left).withView(imageView))
        imageView.adjustHeight()

        panel.append(progressView.hidden(false).progress(0.0).width(.wrapContent).height(5), left: 5)
    }

    private func uploadImage(image: UIImage) {

    }
}

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(_ presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController

        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }

        self.pickerController(picker, didSelect: image)
    }
}
