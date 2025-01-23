//
//  m.swift
//  22. News App_MidTerm[12-18]
//
//  Created by BJIT on 14/1/23.
//

import UIKit

class TableViewCellViewModel {
    let source: String?
    let title : String?
    let newsDescription: String?
    let content: String?
    let author: String?
    let date: String?
    let imgURL: String?
    let url: String?
    var imgData: Data? = nil
    var isBookmarked: Bool
    
    init (source: String, title : String, description: String, content: String, author: String,imgURL: String, url: String,date: String, isBookmarked: Bool){

        self.source = source
        self.title = title
        self.newsDescription = description
        self.content = content
        self.author = author
        self.imgURL = imgURL
        self.url = url
        self.date = date
        self.isBookmarked = isBookmarked
    }
}
