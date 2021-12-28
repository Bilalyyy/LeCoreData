//
//  CoreDataHelper.swift
//  LeCoreData
//
//  Created by bilal on 26/12/2021.
//

import UIKit
import CoreData

class CoreDataHelper {
    static let shared = CoreDataHelper()
    var successCompletion: ((Bool)-> Void)?
    
    
    //Acceder au container
    //1. aller jusqu'au delegate
    private var _appDelegate = UIApplication.shared.delegate as! AppDelegate
    //2. let persistentContainer
    var container: NSPersistentContainer {
        return _appDelegate.persistentContainer
    }
    //3. ViewContext
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    //Save data
    func addRace (_ name: String,_ completion: ((Bool)-> Void)?) {
        self.successCompletion = completion
        let newRace = Race(context: context)
        newRace.name = name
        context.insert(newRace)
        saveContext()
    }
    
    func addAnimal(_ name: String,_ age: Int16,_ image: UIImage,_ race: Race, completion: ((Bool)-> Void)?) {
        self.successCompletion = completion
        let newAnimal = Animal(context: context)
        newAnimal.name = name
        newAnimal.age = age
        newAnimal.image = compressImage(image)
        newAnimal.race = race
        context.insert(newAnimal)
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
            successCompletion?(true)
        } catch {
            successCompletion?(false)
        }
    }
    
    
    func deleteAnimal(_ animal: Animal, completion: ((Bool)-> Void)?) {
        self.successCompletion = completion
        context.delete(animal)
        saveContext()
    }
    
    /*
    func deleteRace(_ race: Race, completion: ((Bool)-> Void)?){
        self.successCompletion = completion
        let animals = Sorter().animalsByAlphabetical(race)
        animals.forEach { animal in
            context.delete(animal)
        }
        context.delete(race)
        saveContext()
    }
    */
    
    //Obtenir les données
    func getRaces(_ completion: (([Race])-> Void)?) {
        let request: NSFetchRequest<Race> = Race.fetchRequest()
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        do {
            let races = try context.fetch(request)
            completion?(races)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func compressImage(_ image: UIImage)-> Data? {
        return image.jpegData(compressionQuality: 0.5)
    }
    
}
