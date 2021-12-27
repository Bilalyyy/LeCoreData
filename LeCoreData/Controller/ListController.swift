//
//  ListController.swift
//  LeCoreData
//
//  Created by bilal on 26/12/2021.
//

import UIKit

class ListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var races: [Race] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRaces()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetail" {
            if let next = segue.destination as? DetailController {
                next.animal = sender as? Animal
            }
        }
        
    }
            
}




extension ListController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getRaces() {
        CoreDataHelper.shared.getRaces { races in
            self.races = races
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return races.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let race = races[section]
        return Sorter().animalsByAlphabetical(race).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()

        let race = races[indexPath.section]
        let animals = Sorter().animalsByAlphabetical(race)
        let animal = animals[indexPath.row]
            
            config.text = animal.name
            config.textProperties.font = .boldSystemFont(ofSize: 20)
            
            config.secondaryText = "Age: \(animal.age)"
            
        if let image = animal.image {
            config.image = UIImage(data: image)
            config.imageProperties.maximumSize.height = 60
            config.imageProperties.maximumSize.width = 60

            config.imageProperties.cornerRadius = 30
        }
        
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let animal = Sorter().animalsByAlphabetical(races[indexPath.section])[indexPath.row]
            performSegue(withIdentifier: "ToDetail", sender: animal)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  races[section].name
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
