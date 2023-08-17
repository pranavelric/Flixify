//
//  StorageManager.swift
//  Flixify
//
//  Created by Pranav Choudhary on 06/08/23.
//

import Foundation
import UIKit
import CoreData

class StorageManager {
    
    //MARK: Properties
    static let shared = StorageManager()
    private let context: NSManagedObjectContext?
    
    //MARK: - Initialization

    init() {
        context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    //MARK: - Methods
    
    func save(_ title: Movie) {
        let entityDescription = NSEntityDescription.entity(
            forEntityName: "MovieStorageModel",
            in: self.context!
        )
        let item =  NSManagedObject(entity: entityDescription!, insertInto: context) as! MovieStorageModel
//        guard
//            let context = self.context,
//            let entityDescription = NSEntityDescription.entity(
//                forEntityName: "MovieStorageModel",
//                in: context
//            ),
//            let item = NSManagedObject(entity: entityDescription, insertInto: context)
//        else { return }
        item.setValue(Int64(title.id), forKey: "id")
        item.setValue(title.title ?? "", forKey: "title")
        item.setValue(title.backdrop_path ?? "", forKey: "backdropPath")
        item.setValue(title.poster_path ?? "", forKey: "posterPath")
        item.setValue(title.original_title ?? "", forKey: "originalTitle")
        item.setValue(title.original_language ?? "" , forKey: "originalLanguage")
        item.setValue(title.overview ?? "", forKey: "overview")
        item.setValue(title.vote_average ?? 0, forKey: "voteAverage")
        item.setValue(Int64(title.vote_count ?? 0), forKey: "voteCount")
        item.setValue(title.adult ?? false, forKey: "adult")
        item.setValue(title.video ?? false, forKey: "video")
        item.setValue(title.genre_ids, forKey: "genre_ids")
        item.setValue(title.popularity, forKey: "popularity")
        item.setValue(title.release_date, forKey: "releaseDate")

        
//        item.id = Int64(title.id)
//        item.title = title.title
//        item.backdropPath = title.backdrop_path
//        item.posterPath = title.poster_path
//        item.originalTitle = title.original_title
//        item.originalLanguage = title.original_language
//        item.overview = title.overview
//        item.voteAverage = title.vote_average ?? 0
//        item.voteCount = Int64(title.vote_count ?? 0)
//        item.popularity = title.popularity ?? 0
//        item.adult = title.adult
//        item.genre_ids = title.genre_ids
//        item.releaseDate = title.release_date
//        item.video = title.video
        
        
        

        if self.context!.hasChanges {
            do {
                try self.context!.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchData(_ completion: @escaping ([MovieStorageModel]?) -> Void) {
        guard let context = self.context else { return }
        let request: NSFetchRequest<MovieStorageModel> = MovieStorageModel.fetchRequest()
        do {
            let fetchedTitles = try context.fetch(request)
            completion(fetchedTitles)
        } catch let error {
            completion(nil)
            print(error.localizedDescription)
        }
    }

    func delete(_ title: MovieStorageModel) {
        guard let context = context else { return }
        context.delete(title)
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func delete(_ title: Movie) {
        guard let context = context else { return }
        findObjectInStorage(title) { storageTitle in
            guard let storageTitle = storageTitle else { return }
            context.delete(storageTitle)
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteAll() {
        guard let context = context else { return }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieStorageModel")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func isInStorage(_ title: Movie) -> Bool {
        var titleModel: MovieStorageModel?
        findObjectInStorage(title) { storageTitle in
            titleModel = storageTitle
        }
        return titleModel != nil ? true : false
    }
//
//    //MARK: - Private methods
//
    private func findObjectInStorage(_ title: Movie, completion: @escaping (MovieStorageModel?) -> Void) {
        guard let context = context else { return }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieStorageModel")
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(title.id)")

        do {
            guard let results = try context.fetch(fetchRequest) as? [NSManagedObject] else { return }
            if !results.isEmpty {
                for result in results {
                    guard let storedTitle = result as? MovieStorageModel else { return }
                    completion(storedTitle)
                    return
                }
                completion(nil)
            } else {
                completion(nil)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}




struct Storage{
    static let shared = Storage()
    func isTitleInStorage(title: Movie) -> Bool {
        StorageManager.shared.isInStorage(title)
  
    }

    func deleteBookmark(title: Movie) {
        
        StorageManager.shared.delete(title)
    }

    func addBookmarkForTitle(title: Movie) {
        
        StorageManager.shared.save(title)
    }

    func learnMoreAboutTitle(title: Movie) {
//        router.present(module: .titlePage, animated: true, context: title, completion: nil)
    }
}
