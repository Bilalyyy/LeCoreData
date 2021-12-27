//
//  DetailController.swift
//  LeCoreData
//
//  Created by bilal on 26/12/2021.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var prLblName: UILabel!
    @IBOutlet weak var prLblRace: UILabel!
    @IBOutlet weak var prLblAge: UILabel!
    @IBOutlet weak var prImage: UIImageView!
    
    var animal: Animal!
    
    var image : UIImage? {
        if let image = animal.image {
            return UIImage(data: image)
        } else {
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        prLblName.text = animal.name
        prImage.image = image
        prLblRace.text = "Je suis un \(animal.race?.name ?? "...")"
        prLblAge.text = "Age: \(animal.age) ans"
    }
}
