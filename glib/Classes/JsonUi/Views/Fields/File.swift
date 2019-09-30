#if INCLUDE_UILIBS

import Photos
import CommonCrypto
import Alamofire

class JsonView_Fields_FileV1: JsonView, SubmittableFileField, ImagePickerDelegate {
    private let panel = GHorizontalPanel()
    private let imageView = GImageView()
    private let progressView = MProgressView()
    private var imagePicker: ImagePicker!

    private var selectedImage: UIImage!
    private var imageFileName: String!
    private var imageByteSize: Int!
    private var directUploadData: Json!

    var name: String?
    var value: String = ""
    var fileInput: Bool? = true
    var completed: Bool? = true

    override func initView() -> UIView {
        name = spec["name"].stringValue

        self.imagePicker = ImagePicker(self.screen, delegate: self)

        return GVerticalPanel()
            .append(GLabel().text(spec["label"].stringValue))
            .append(initialViews())
    }

    func didSelect(image: UIImage?, fileName: String) {
        if let selectedImage = image {
            self.imageFileName = fileName
            self.selectedImage = selectedImage

            if valid() {
                updateUploadProgressViews()
                upload()
            }
        }
    }

    func validate() -> Bool {
        return true
    }

    private func valid() -> Bool {
        let imageData = NSData(data: selectedImage.jpegData(compressionQuality: 1)!)
        imageByteSize = imageData.length / 1024

        if (imageByteSize > spec["file_size_limit"].intValue) {
            screen.launch.alert(spec["file_size_limit_alert_text"].stringValue)
            return false
        }

        return true
    }

    private func initialViews() -> GHorizontalPanel {
        panel.clearViews()

        if let fileUrl = spec["file_url"].string {
            value = spec["value"].stringValue
            imageFileName = spec["file_name"].stringValue
            imageView.source(url: fileUrl)
            selectedImage = imageView.image
            updateUploadCompletedViews()
        }
        else {
            uploadViews()
        }

        return panel
    }

    private func uploadViews() {
        panel.clearViews()
        panel.append(GAligner().align(.left).withView(GLabel().text("No file chosen")))
            .append(GAligner().align(.right).withView(
                MButton().title("Choose file").onClick({ (button) in
                    self.imagePicker.present()
                })
            ))
    }

    private func updateUploadProgressViews() {
        panel.clearViews()
        imageView.source(image: selectedImage).width(80)

        panel.append(GAligner().align(.left).withView(imageView))
            .append(progressView.hidden(false).progress(0.0).width(.wrapContent).height(5), left: 5)
        imageView.adjustHeight()
    }

    private func updateUploadCompletedViews() {
        panel.clearViews()
        imageView.source(image: selectedImage).width(80)

        panel.append(GAligner().align(.left).withView(imageView))
            .append(GLabel().text(imageFileName), left: 5)
            .append(GAligner().align(.right).withView(
                MButton().color(bg: .red).title("X").onClick({ button in
                    self.value = ""
                    self.uploadViews()
                })
            ), left: 5)
        imageView.adjustHeight()
    }

    private func upload() {
        self.completed = false

        let blobRecord: GParams = [
            "blob[byte_size]": imageByteSize!,
            "blob[checksum]": checksum(),
            "blob[content_type]": "image/jpeg",
            "blob[filename]": imageFileName!,
        ]

        let headers: HttpHeaders = [
            "X-CSRF-Token": DbJson.instance.object(forKey: GKeys.Db.csrfToken).stringValue
        ]

        GLog.d(headers.debugDescription)

        Rest.post(url: spec["s3_direct_upload_url"].stringValue, params: blobRecord, headers: headers).execute { response in
            self.directUploadData = response.content

            var uploadHeaders: HttpHeaders = [:]
            for (key, header) in self.directUploadData["direct_upload"]["headers"].dictionaryValue {
                uploadHeaders[key] = header.stringValue
            }

            Alamofire.upload(self.selectedImage.jpegData(compressionQuality: 1.0)!,
                             to: URL(string: self.directUploadData["direct_upload"]["url"].stringValue)!,
                             method: .put, headers: uploadHeaders)
                .uploadProgress { progress in
                    self.progressView.progress(Float(progress.fractionCompleted))

                    if progress.fractionCompleted == 1.0 {
                        self.value = self.directUploadData["signed_id"].stringValue
                        self.updateUploadCompletedViews()
                        self.completed = true
                    }
                }

            return true
        }
    }

    private func checksum() -> String {
        let imageData = selectedImage.jpegData(compressionQuality: 1)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

        digestData.withUnsafeMutableBytes { digestBytes in
            imageData.withUnsafeBytes { imageBytes in
                CC_MD5(imageBytes, CC_LONG(imageData.count), digestBytes)
            }
        }

        return digestData.base64EncodedString()
    }
}

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?, fileName: String)
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

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?, fileName: String) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image, fileName: fileName)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil, fileName: "")
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var fileName = ""
        if #available(iOS 11.0, *) {
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                let assetResources = PHAssetResource.assetResources(for: asset)
                fileName = assetResources.first!.originalFilename
            }
        }

        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil, fileName: "")
        }

        self.pickerController(picker, didSelect: image, fileName: fileName)
    }
}

#endif
