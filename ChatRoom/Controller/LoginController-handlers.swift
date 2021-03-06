//
//  LoginController-handlers.swift
//  ChatRoom
//
//  Created by Erman Sahin Tatar on 8/12/18.
//  Copyright © 2018 Erman Sahin Tatar. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   

    

    @objc func handleRegister() {

        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }


        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in

            if let error = error {
                print(error)
                return
            }

            //guard let user = authResult?.user else { return }

            guard let uid = authResult?.user.uid else {
                return
            }

            //successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            //
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                
                
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    
                    
                    storageRef.downloadURL { (url, error) in
                        guard let profileImageUrl = url?.absoluteString else {
                            return
                        }
                        
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                        
                        
                        
                    }
                })
            }
            //
            
            
            
        }
    }

    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            
            //self.messagesController?.fetchUserAndSetupNavBarTitle()
            //self.messagesController?.navigationItem.title = values["name"] as? String
            let user = User(dictionary: values)
            self.messagesController?.setupNavBarWithUser(user)
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
}
