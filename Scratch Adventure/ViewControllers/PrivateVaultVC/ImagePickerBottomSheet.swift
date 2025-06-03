//
//  ImagePickerBottomSheet.swift
//  Scratch Adventure
//
//  Created by USER on 26/05/25.
//


import UIKit
import MobileCoreServices
import AVFoundation
import Photos


class ImagePickerBottomSheet: UIViewController {
    
    let dragIndicator: UIView = {
          let view = UIView()
          view.backgroundColor = UIColor.init(hexString: "#D9D9D9")
          view.layer.cornerRadius = 4
          view.translatesAutoresizingMaskIntoConstraints = false
          return view
      }()

    let addFromGalleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add from gallery", for: .normal)
        button.setImage(UIImage(named: "ic_addPrivate_gallery"), for: .normal)
        button.setTitleColor(UIColor(named: "Color1"), for: .normal)
        button.backgroundColor = UIColor.init(hexString: "#F4F4F4")
        button.layer.cornerRadius = 10
        button.tintColor = UIColor(named: "Color1")
        button.titleLabel?.font = UIFont.mymediumSystemFont(ofSize: 15)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -5)
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    
    }()

    let openCameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open camera", for: .normal)
        button.setImage(UIImage(named: "ic_addPrivate_Camera"), for: .normal)
        button.setTitleColor(UIColor(named: "Color1"), for: .normal)
        button.backgroundColor = UIColor.init(hexString: "#F4F4F4")
        button.layer.cornerRadius = 10
        button.tintColor = UIColor(named: "Color1")
        button.titleLabel?.font = UIFont.mymediumSystemFont(ofSize: 15)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -5)
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        addFromGalleryButton.addTarget(self, action: #selector(addFromGallery), for: .touchUpInside)
        openCameraButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)


        view.addSubview(dragIndicator)
        view.addSubview(addFromGalleryButton)
        view.addSubview(openCameraButton)

        NSLayoutConstraint.activate([
            
            dragIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
                    dragIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    dragIndicator.widthAnchor.constraint(equalToConstant: 40),
                    dragIndicator.heightAnchor.constraint(equalToConstant: 6),
            
            addFromGalleryButton.topAnchor.constraint(equalTo: dragIndicator.bottomAnchor, constant: 20),
            addFromGalleryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addFromGalleryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addFromGalleryButton.heightAnchor.constraint(equalToConstant: 50),

            openCameraButton.topAnchor.constraint(equalTo: addFromGalleryButton.bottomAnchor, constant: 15),
            openCameraButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            openCameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            openCameraButton.heightAnchor.constraint(equalToConstant: 50),
//            openCameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    @objc func addFromGallery() {
          print("Gallery selected")
        presentMediaPicker(sourceType: .photoLibrary)
      }

      @objc func openCamera() {
          print("Camera selected")
          presentMediaPicker(sourceType: .camera)
      }
}


extension ImagePickerBottomSheet: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Present Picker
    func presentMediaPicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            print("Source not available: \(sourceType)")
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.mediaTypes = ["public.image", "public.movie"]
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }

    // MARK: - Handle Picked Media
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage,
           let imageData = image.jpegData(compressionQuality: 1.0) {
            VaultDataManager.shared.saveMedia(type: "image", data: imageData)
        }

        if let videoURL = info[.mediaURL] as? URL {
            do {
                let videoData = try Data(contentsOf: videoURL)
                VaultDataManager.shared.saveMedia(type: "video", data: videoData)
            } catch {
                print("❌ Failed to load video data: \(error)")
            }
        }

        picker.dismiss(animated: true)
        self.dismiss(animated: true)
        NotificationCenter.default.post(name: .mediaUpdated, object: nil)

    }


    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
