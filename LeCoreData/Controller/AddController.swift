//
//  AddController.swift
//  LeCoreData
//
//  Created by bilal on 26/12/2021.
//

import UIKit
import PhotosUI

class AddController: UIViewController {

    @IBOutlet weak var prNameTF: UITextField!
    @IBOutlet weak var prPicker: UIPickerView!
    @IBOutlet weak var prBtnAddType: UIButton!
    @IBOutlet weak var prBtnCam: UIButton!
    @IBOutlet weak var prBtnLibrary: UIButton!
    @IBOutlet weak var prBtnAddAnimal: UIButton!
    @IBOutlet weak var prImage: UIImageView!
    @IBOutlet weak var prLblAge: UILabel!
    @IBOutlet weak var prStepper: UIStepper!


    var races : [Race] = []
    var imagePicker = UIImagePickerController()
    var libraryPicker: PHPickerViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
        updatePicker()
        checkCamera()
        setupLibrary()
        setupTextField()
    }
    
    @IBAction func btnAddType(_ sender: Any) {
        AlertHelper().alertAddRace(self) { value in
            if let newRace = value {
                CoreDataHelper.shared.addRace(newRace) { success in
                    if success {
                        self.updatePicker()
                    }
                }
            }
        }
    }
    
    @IBAction func btnCam(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
     
    
    @IBAction func btnLibrary(_ sender: Any) {
        present(libraryPicker!, animated: true, completion: nil)
    }
    
    @IBAction func btnAddAnimal(_ sender: Any) {
        prNameTF.resignFirstResponder()
        if let name = prNameTF.text, name != "" {
            if let image = self.prImage.image {
                let age = Int16(prStepper.value)
                let race = races[prPicker.selectedRow(inComponent: 0)]
                CoreDataHelper.shared.addAnimal(name, age, image, race) { success in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        prLblAge.text = " Age: \(Int(prStepper.value))"
    }
    
}




extension AddController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setupPicker() {
        prPicker.delegate = self
        prPicker.dataSource = self
    }
    
    func updatePicker() {
        CoreDataHelper.shared.getRaces { races in
            self.races = races
            self.prPicker.reloadAllComponents()
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return races.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return races[row].name
    }
}


extension AddController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setupCamera() {
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }
    
    func checkCamera() {
        prBtnCam.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            setupCamera()
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage]as? UIImage {
            self.prImage.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}


extension AddController: PHPickerViewControllerDelegate {
    
    func setupLibrary() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .automatic
        libraryPicker = PHPickerViewController(configuration: config)
        libraryPicker!.delegate = self
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        if let first = results.first {
            let newItem = first.itemProvider
            if newItem.canLoadObject(ofClass: UIImage.self) {
                newItem.loadObject(ofClass: UIImage.self) { image, error in
                    if let newImage = image as? UIImage {
                        DispatchQueue.main.async {
                            self.prImage.image = newImage
                        }
                    }
                }
            }
        }
    }
    
    
}



extension AddController: UITextFieldDelegate {
    
    func setupTextField(){
        prNameTF.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
