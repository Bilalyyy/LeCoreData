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
        if let animals: [Animal] = race.animals?.allObjects as? [Animal] {
            return animals.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()

        let race = races[indexPath.section]
        if let animals = race.animals?.allObjects as? [Animal] {
            let animal = animals[indexPath.row]
            
            config.text = animal.name
            config.textProperties.color = .black
            config.textProperties.font = .boldSystemFont(ofSize: 20)
            
            config.secondaryText = "Age: \(animal.age)"
            
            if let image = animal.image {
                config.image = UIImage(data: image)
                config.imageProperties.cornerRadius = 10
            }
        }
        
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return races[section].name
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}