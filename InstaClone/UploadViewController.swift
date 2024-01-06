import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!

    var loadingViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecognizer)
    }

    @objc func selectImage() {
        print("Worked")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }

    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }

    func showLoadingView() {
        loadingViewController = UIViewController()
        loadingViewController?.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor.white
        activityIndicator.center = loadingViewController!.view.center
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        loadingViewController?.view.addSubview(activityIndicator)

        loadingViewController?.modalPresentationStyle = .overFullScreen

        activityIndicator.startAnimating()

        UIView.animate(withDuration: 0.3) {
            self.present(self.loadingViewController!, animated: false, completion: nil)
        }
    }

    func hideLoadingView() {
        UIView.animate(withDuration: 0.3) {
            self.loadingViewController?.dismiss(animated: false, completion: nil)
        }
    }

    @IBAction func uploadClicked(_ sender: Any) {
        showLoadingView()

        let storage = Storage.storage()
        let storageReference = storage.reference()

        let mediaFolder = storageReference.child("media")

        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    self.hideLoadingView()
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString

                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference: DocumentReference? = nil

                            let firestorePost = ["imageUrl": imageUrl!,
                                                 "postedBy": Auth.auth().currentUser!.email as Any,
                                                 "postComment": self.commentText.text!,
                                                 "date": FieldValue.serverTimestamp(),
                                                 "likes": 0] as [String: Any]

                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost) { error in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    self.hideLoadingView()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
