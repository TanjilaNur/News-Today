import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let shared = CoreDataManager()
    
    private init(){}
    
    func getMatchedRecords(query: String, category: CategoryList) -> [News]{
        
        let fetchRequest = NSFetchRequest<News>(entityName: "News")
        
        if query.isEmpty {
            let predicate = NSPredicate(format: "category == %@", category.rawValue)
            fetchRequest.predicate = predicate
            
        } else {
            let predicate = NSPredicate(format: "category == %@ AND title CONTAINS[cd] %@", category.rawValue,query)
            fetchRequest.predicate = predicate
        }
        
        do {
            let matchedItems = try context.fetch(fetchRequest)
            print(matchedItems)
            return matchedItems
            
        } catch {
            print(error)
        }
        return []
    }
    
    
    func getMatchedRecords(offset: Int,query: String, category: CategoryList) -> [News]{
        
        let fetchRequest = NSFetchRequest<News>(entityName: "News")
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = 10
        
        if query.isEmpty {
            let predicate = NSPredicate(format: "category == %@", category.rawValue)
            fetchRequest.predicate = predicate
            
        } else {
            let predicate = NSPredicate(format: "category == %@ AND title CONTAINS[cd] %@", category.rawValue,query)
            fetchRequest.predicate = predicate
        }
        
        do {
            let matchedItems = try context.fetch(fetchRequest)
            print(matchedItems)
            return matchedItems
            
        } catch {
            print(error)
        }
        return []
    }
    
    func getMatchedRecordsForBookmarks(query: String, category: CategoryList) -> [Bookmarks]{
        
        let fetchRequest = NSFetchRequest<Bookmarks>(entityName: "Bookmarks")
        
        if query.isEmpty {
            let predicate = NSPredicate(format: "category == %@", category.rawValue)
            
            fetchRequest.predicate = predicate
            
        } else {
            let predicate = NSPredicate(format: "category == %@ AND title CONTAINS[cd] %@", category.rawValue,query)
            fetchRequest.predicate = predicate
        }
        
        do {
            let matchedItems = try context.fetch(fetchRequest)
            print(matchedItems)
            return matchedItems
            
        } catch {
            print(error)
        }
        return []
    }
    
    func addToCoredata(articles: [ArticleModel], category: CategoryList) -> [News] {
        var coreDataResult:[News] = []
        for article in articles {
            let newsItem = News(context: self.context)
            newsItem.title = article.title
            newsItem.category = category.rawValue
            newsItem.content = article.content
            newsItem.isBookmarked = false
            newsItem.author = article.author
            newsItem.sourceName = article.source.name
            newsItem.publishedAt = article.publishedAt
            newsItem.newsDescription = article.description
            newsItem.url = article.url
            newsItem.urlToImage = article.urlToImage
            
            do {
                try self.context.save()
                coreDataResult.append(newsItem)
            } catch {
                print("ERROR OCCURRED \(error)")
            }
        }
        return coreDataResult
    }
    
//    func deleteAllRecordsFromCoredata(completion: ()->()) {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"news" )
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        do {
//            try context.execute(deleteRequest)
//            try CoreDataHandler.context.save()
//            completion()
//        } catch {
//            print("Failed to delete all data from core data: \(error)")
//        }
//    }
    
    func deleteAllRecordsFromCoredata() -> [News] {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
                try context.save()
                return []
            } catch {
                print("Error deleting data: \(error)")
            }
            return []
        }
    
    func deleteAllRecordsExceptBookmarks(query: String) -> [News]{

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "addToBookmarks")
        
        let predicate = NSPredicate(format: "isBookmarked == false")
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            return []
        } catch {
            print("Error deleting data: \(error)")
        }
        return []
    }
    
    
    func checkAvailablityInBookmark(url: String, selectedNewsCategory: CategoryList) -> Bool {
        
        let fetchRequest = NSFetchRequest<Bookmarks>(entityName: "Bookmarks")
        
        let predicate = NSPredicate(format: "category == %@ AND url == %@", selectedNewsCategory.rawValue, url)
        fetchRequest.predicate = predicate
        
        do {
            let matchedItems = try context.fetch(fetchRequest)
            print(matchedItems)
            return !matchedItems.isEmpty
            
        } catch {
            print(error)
        }
        return false
    }
    
    func removeFromBookmarks(url: String, selectedNewsCategory: CategoryList) {
        
        let fetchRequest = NSFetchRequest<Bookmarks>(entityName: "Bookmarks")
        
        let predicate = NSPredicate(format: "category == %@ AND url == %@", selectedNewsCategory.rawValue,url)
        fetchRequest.predicate = predicate
        
        do {
            let matchedItems = try context.fetch(fetchRequest)
            guard let obj = matchedItems.first else { return }
            context.delete(obj)
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func addToBookmarks(article: TableViewCellViewModel, selectedcategory: CategoryList) {
        article.isBookmarked = true
        
        let bookmarkArticle = Bookmarks(context: context)
        
        bookmarkArticle.title = article.title
        bookmarkArticle.category = selectedcategory.rawValue
        bookmarkArticle.content = article.content
        bookmarkArticle.author = article.author
        bookmarkArticle.sourceName = article.source
        bookmarkArticle.publishedAt = article.date
        bookmarkArticle.newsDescription = article.newsDescription
        bookmarkArticle.url = article.url
        bookmarkArticle.urlToImage = article.imgURL
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    

    
}
