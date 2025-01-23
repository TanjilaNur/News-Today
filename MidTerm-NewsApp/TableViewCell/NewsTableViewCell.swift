//
//  NewsTableViewCell.swift
//  MidTerm-NewsApp
//
//  Created by BJIT on 16/1/23.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var newsTitle: UILabel!
 
    @IBOutlet weak var newsDate: UILabel!
    
    @IBOutlet weak var bookmarkImgView: UIImageView!
    
    @IBOutlet weak var bookmarkBGView: UIView!
    
    @IBOutlet weak var sourceBGView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setValues(viewModel: TableViewCellViewModel) {
        newsTitle.text = viewModel.title
        
        //Assigning Pulished Time
        if let date = viewModel.date {
            let formattedDate = Constants.dateFormatter(date: date)
            newsDate.text = formattedDate
        } else {
            newsDate.text = "Published time unknown!"
        }
        
        //Settign-Up Image for each news in table
        newsImageView.sd_setImage(with: URL(string: viewModel.imgURL ?? "https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg")!, placeholderImage: nil, options: [.progressiveLoad])
    }
}
