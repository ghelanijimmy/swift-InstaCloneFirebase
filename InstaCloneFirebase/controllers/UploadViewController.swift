//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Jimmy Ghelani on 2023-09-19.
//

import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images

        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
           
           for result in results {
              result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                 if let image = object as? UIImage {
                    DispatchQueue.main.async {
                       // Use UIImage
                        self.imageView.image = image
                    }
                 }
              })
           }
    }
    

    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(alertButton)
        
        present(alert, animated: true)
    }

    @IBAction func actionButtonClicked(_ sender: UIButton) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let imageRef = mediaFolder.child("image-\(UUID().uuidString).jpg")
            
            imageRef.putData(data, metadata: nil) { metaData, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    imageRef.downloadURL { url, error in
                        if error != nil {
                            self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                        } else {
                            let imageUrl = url?.absoluteString
                            print(imageUrl ?? "image")
                            
                            //MARK: - Add Image to DB
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference: DocumentReference? = nil
                            
                            let firestorePost = [
                                "imageUrl": imageUrl!,
                                "postedBy" : Auth.auth().currentUser!.email!,
                                "postComment": self.commentText.text!,
                                "date": FieldValue.serverTimestamp(),
                                "likes" : 0
                            ] as [String: Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                } else {
                                    self.imageView.image = UIImage(named: "taptoselect.png")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let controller = storyboard.instantiateViewController(withIdentifier: "uploadVC") as! UploadViewController
    return controller
}
