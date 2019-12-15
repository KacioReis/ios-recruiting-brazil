//
//  CoreDataFuncs.swift
//  DesafioIos
//
//  Created by Kacio on 14/12/19.
//  Copyright © 2019 Kacio Henrique Couto Batista. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let EntityName = "FavoriteMovie"
//MARK: saved Object
func save(movie: Movie) {
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return
    }
    let managedContext =
        appDelegate.persistentContainer.viewContext
    let entity =
        NSEntityDescription.entity(forEntityName: EntityName ,
                                   in: managedContext)!
    
    let manager = NSManagedObject(entity: entity,
                                  insertInto: managedContext)
    let savedMovies = fetch()
    for movieObject in savedMovies {
        if (movieObject.value(forKey:"id") as! Int) == movie.id{
            erase(object: movieObject)
        }
    }
    manager.setValue(movie.id, forKeyPath: "id")
    manager.setValue(movie.title, forKey: "title")
    manager.setValue(movie.backdropPath, forKey: "backdropPath")
    manager.setValue(movie.genreIDS, forKey: "genreIDS")
    manager.setValue(movie.overview, forKey: "overview")
    do {
        try managedContext.save()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}
// MARK: Erase a Object
func erase(object:NSManagedObject){
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return
    }
    
    let managedContext =
        appDelegate.persistentContainer.viewContext
    
    managedContext.delete(object)
    do {
        try managedContext.save()
    } catch let error as NSError{
        print("Error While Deleting Movie: \(error.userInfo)")
    }
}
// MARK: Fetch Core Data
func fetch() -> [NSManagedObject]{
    var movies: [NSManagedObject] = []
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return []
    }
    let managedContext =
        appDelegate.persistentContainer.viewContext
    let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: EntityName)
    do {
        movies = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    return movies
}
func movieIsfavorite(by id:Int) -> Bool{
    let movies = fetch()
    for movie in movies{
        if id == (movie.value(forKey: "id") as! Int){
            return true
        }
    }
    return false
}
func showALLMovies(){
    let movies = fetch()
    for movie in movies {
        print((movie.value(forKey:"title") as! String))
        print(movie.value(forKey: "overview") as! String)
        if let genres = movie.value(forKey: "genreIDS") as? [Int]{
            for genre in genres{
                print(genre)
            }
        }
    }
}
