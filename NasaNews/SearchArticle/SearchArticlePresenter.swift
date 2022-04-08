//
//  SearchArticlePresenter.swift
//  NasaNews
//
//  Created by Tzy on 01.04.2022.
//

import Foundation
import UIKit

struct SearchArticleModel {
    var ratingModels: [RatingEntity] = []
    var ratingTopModels: [RatingEntity] = []
}

final class SearchArticlePresenter {
    
    weak var view: SearchArticleViewType?
    
    private var model = SearchArticleModel()
    
    func getAllModels(searchString: String = String()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = RatingEntity.fetchRequest()
        if !searchString.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS %@", searchString)
        }
        
        do {
            model.ratingModels = try managedContext.fetch(fetchRequest)
            view?.reloadTable()
        } catch {
            print("here::", error.localizedDescription)
        }
    }
    
    func getTopModels() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = RatingEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "rating = %i", 5)
        
        do {
            model.ratingTopModels = try managedContext.fetch(fetchRequest)
            view?.reloadCollectionView()
        } catch {
            print("here::", error.localizedDescription)
        }
    }
    
    func deleteItemAt(index: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let deletItem = model.ratingModels[index.row]
        model.ratingModels.remove(at: index.row)
        managedContext.delete(deletItem)
        
        do {
            try managedContext.save()
            print("here::did delete item", deletItem)
        } catch {
            print("here::", error.localizedDescription)
        }
        
    }
}

// MARK: Intercator
extension SearchArticlePresenter {
    func getModelsEntities() -> [RatingEntity] {
        return model.ratingModels
    }
    
    func getTopModelsEntities() -> [RatingEntity] {
        return model.ratingTopModels
    }
    
    func getModel(for index: IndexPath) -> RatingEntity {
        return model.ratingModels[index.row]
    }
    
    func getTopModel(for index: IndexPath) -> RatingEntity {
        return model.ratingTopModels[index.row]
    }
}
