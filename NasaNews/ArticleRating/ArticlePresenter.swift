//
//  ArticlePresenter.swift
//  NasaNews
//
//  Created by GigiFullSpeed on 08.04.2022.
//

import UIKit
import CoreData

final class ArticlePresenter {
    // MARK: Variables
    var item: Item?
    private var rating: Int = 0
    private var ratingEntity: RatingEntity? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.view?.setStars(rating: Int(self?.ratingEntity?.rating ?? 0))
            }
        }
    }
    
    
    private var managedContext: NSManagedObjectContext
    weak var view: ArticleViewType?
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func shouldLoadData() {
        getModel()
    }
    
    private func getModel() {
        let fetchRequest = RatingEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", item?.title ?? String())
        
        do {
            ratingEntity = try managedContext.fetch(fetchRequest).first
        } catch {
            print("here::", error.localizedDescription)
        }
    }
    
    private func addRating() {
        
        if ratingEntity == nil {
            guard let entity = NSEntityDescription.entity(forEntityName: "RatingEntity", in: managedContext),
            let item = item else { return }
            let ratingEntity = RatingEntity(entity: entity, insertInto: managedContext)
            ratingEntity.rating = Int64(rating)
            ratingEntity.name = item.title
            ratingEntity.body = item.body
            
            self.ratingEntity = ratingEntity
        }

        
        do {
            try managedContext.save()
            print("here:: Saved!")
        } catch {
            print("here::", error.localizedDescription)
        }
    }
}

extension ArticlePresenter: StarCollectionDelegate {
    func didRate(rate: Int) {
        rating = rate
        ratingEntity?.rating = Int64(rate)
        addRating()
    }
}
