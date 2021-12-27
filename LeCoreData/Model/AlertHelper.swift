//
//  AlertHelper.swift
//  LeCoreData
//
//  Created by bilal on 26/12/2021.
//

import Foundation
import UIKit

class AlertHelper {
    func alertAddRace(_ controller: UIViewController, completion: ((String?) -> Void)?) {
        let alert = UIAlertController(title: "Ajouter une race", message: "Quel race voulez vous ajouter?", preferredStyle: .alert)

        alert.addTextField { text in
            text.placeholder = "Race"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Valider", style: .default) { action in
            if let newRace = alert.textFields?.first?.text {
                completion?(newRace)
            }
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil)
    }
}
