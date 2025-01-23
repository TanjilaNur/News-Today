//
//  Constants.swift
//  22. News App_MidTerm[12-18]
//
//  Created by BJIT on 14/1/23.
//

import Foundation
import UIKit

class Constants {
    private init(){}
    
    static let goToHome = "goToNewsHome"
    static let goToDetailsView = "goToDetailsViewController"
    static let goToDetailsBookmarkView = "goToDetailsFromBookmarks"
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    static func dateFormatter(date: String?) -> String {
            
            guard let date = date else {
                return ""
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let fetchedDate = formatter.date(from: date)
            
            let currentTime = Date.now
            
            let timeDifference = Calendar.current.dateComponents([.second], from: fetchedDate!, to: currentTime)
            let totalSeconds = timeDifference.second!
            
            let hour =  totalSeconds / 3600
            let minute = (totalSeconds % 3600) / 60
            
            return "🕒 \(hour == 0 ? "" : "\(hour)h") \(minute)m" //  ago

        }

}
