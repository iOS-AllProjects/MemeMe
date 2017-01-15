//
//  ViewController.swift
//  MemeMe
//
//  Created by Etjen Ymeraj on 9/18/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField! { didSet { self.bottomText.delegate = self } }
    @IBOutlet weak var memeImage: UIImageView!
    
    var meme: Meme?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setup UI
    func setupUI(){
        if let meme = meme {
            title = "Edit Meme"
            topText.text = meme.topText
            bottomText.text = meme.bottomText
            memeImage.image = meme.originalImage
            print(index)
        }
    }

    
    func keyboardWasShown(_ notification: NSNotification){
        print("ok")
        self.view.frame.origin.y -= getKeyboardHeight(notification: notification)
    }
    
    func keyboardWillHide(){
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func callActionSheet(){
        let actionSheet = UIAlertController(title: "Add a Photo", message: "Upload from the following", preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default){ action in
            self.fromSource(source: .photoLibrary)
        }
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default){ action in
            self.fromSource(source: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(cancelAction)
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func uploadImage(_ sender: AnyObject) {
        callActionSheet()   
    }

    @IBAction func saveMeme(_ sender: AnyObject) {
        if topText.text != nil && bottomText.text != nil && memeImage.image != nil{ //check if everythings is ok before generating meme
            save()
            let alert = UIAlertController(title: "Awesome...", message: "Your new Meme has been succesfully created", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { alertAction in
                alert.dismiss(animated: true, completion: nil)
            })
            present(alert, animated: true, completion: nil)

        }
    }
    
    func save() {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        //create a new Meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage:
            memeImage.image!, newimage: generateMemedImage())
        
        if title == "Edit Meme"{ //Edit an existing meme
        //This will edit the current meme
        appDelegate.memes[index!] = meme
            
        }else{
        // This will add it to the memes array in the Application Delegate
        appDelegate.memes.append(meme)
        }
    }
    
    func clear(){
        topText.text = nil
        bottomText.text = nil
        memeImage.image = nil
    }
    
    func generateMemedImage() -> UIImage
    {
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    @IBAction func shareMeme(_ sender: AnyObject) {
        if topText.text != nil && bottomText.text != nil && memeImage.image != nil{ //check if everythings is ok before generating meme
        let activityViewController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityType.airDrop,
                                                            UIActivityType.message,
                                                            UIActivityType.mail,
                                                            UIActivityType.print,
                                                            UIActivityType.copyToPasteboard]
            
            present(activityViewController, animated: true, completion: nil)
        
            activityViewController.completionWithItemsHandler = { activity, success, items, error in
                if !success {
                    print("cancelled")
                    return
                }
                self.clear()
                }}}
                }

extension ViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.view.endEditing(true)
        return true
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{ //if image choosen do the following
        memeImage.image = image
        }else{ //else no image
            print("error")
        }
            dismiss(animated: true, completion: nil) //dismiss in any case
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func fromSource(source: UIImagePickerControllerSourceType) { //takes source as argument
        if UIImagePickerController.isSourceTypeAvailable(source) { //if phone as a camera
            let picker = UIImagePickerController() //initialize the pcker
            picker.sourceType = source //assign its source to either camera or album
            picker.delegate = self //comfirms to delegate methods
            picker.allowsEditing = false
            present(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Not Available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { alertAction in
                alert.dismiss(animated: true, completion: nil)
            })
            present(alert, animated: true, completion: nil)
        }
    }
    

}

