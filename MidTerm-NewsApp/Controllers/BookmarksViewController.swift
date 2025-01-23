//
//  BookmarksViewController.swift
//  MidTerm-NewsApp
//
//  Created by BJIT on 16/1/23.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tabView: UIView!
    
    private var bookmarkedArticels = [Bookmarks]()
    
    private var viewModels = [TableViewCellViewModel]()
    
    var selectedNewsCategory:CategoryList = .all
    
    var selectedIndexPath: IndexPath = [0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchNewsForBookmarks()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchTextField.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.goToDetailsBookmarkView {
            if let vc = segue.destination as? DetailsViewController {
                vc.delegate = self
                
                let viewModel = viewModels[selectedIndexPath.row]
                
                vc.viewModel = viewModel
                vc.selectedCategory = selectedNewsCategory
                vc.indexPath = selectedIndexPath
                vc.bookmarkBtnOpacity = 0
            }
        }
    }
    
    @IBAction func searchFieldTypingChanged(_ sender: UITextField) {
        fetchNewsForBookmarks()
        tableView.reloadData()
    }
    
    func setUpViews(){
        setSearchBarImage()
        topLabel.text = "Bookmarks"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchTextField.placeholder = ""
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize  = CGSize(width: 125, height: 35)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        tableView.layer.cornerRadius = 20
        tableView.clipsToBounds = true
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        tabView.layer.cornerRadius = 30
        tabView.clipsToBounds = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchNewsForBookmarks()
        tableView.reloadData()
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCellForBookmarks")
        
        let nib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CustomCollectionViewCell")
    }
    
    func setSearchBarImage(){
        let searchIcon  = UIImageView()
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        let uiView = UIView()
        uiView.addSubview(searchIcon)
        uiView.frame = CGRect(x: 10, y: 0, width: UIImage(systemName: "magnifyingglass")!.size.width+15, height: UIImage(systemName: "magnifyingglass")!.size.height)
        
        searchIcon.frame = CGRect(x: 10, y: 0, width: UIImage(systemName: "magnifyingglass")!.size.width, height: UIImage(systemName: "magnifyingglass")!.size.height)
        
        searchTextField.leftView = uiView
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.leftViewMode = .always
    }
    
    func fetchNewsForBookmarks(){
        bookmarkedArticels = CoreDataManager.shared.getMatchedRecordsForBookmarks(query: searchTextField.text ?? "", category: selectedNewsCategory)
        
        viewModels = bookmarkedArticels.compactMap({
            TableViewCellViewModel(source:$0.sourceName ?? "No Source!",
                                   title: $0.title ?? "No Title!",
                                   description: $0.newsDescription ?? "No desc",
                                   content: $0.content ?? "No content!",
                                   author: $0.author ?? "Unknown Author!",
                                   imgURL: $0.urlToImage ?? "https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg",
                                   url: $0.url ?? "",
                                   date: $0.publishedAt ?? "Date Unknown!",
                                   isBookmarked: true
            )
        })
    }
}

//MARK: -UICollectionViewDataSource
extension BookmarksViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryList.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        let item = CategoryList.allCases[indexPath.row]
        
        if item == selectedNewsCategory{
            cell.selectionView.backgroundColor = .white
            cell.selectionView.layer.cornerRadius = cell.selectionView.frame.height / 2
            cell.categoryLabel.backgroundColor = UIColor(named: "navy")
            cell.categoryLabel.alpha = 1
            
        } else {
            cell.selectionView.backgroundColor = UIColor(named: "navy")
            cell.categoryLabel.backgroundColor = UIColor(named: "navy")
            cell.categoryLabel.alpha = 0.7
        }

        cell.categoryLabel.text = item.rawValue.capitalized
        
        return cell
    }
}



//MARK: -UICollectionViewDelegate
extension BookmarksViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        selectedNewsCategory = CategoryList.allCases[indexPath.row]
        print("///////////////////SAD \(selectedNewsCategory)")
        fetchNewsForBookmarks()
        tableView.reloadData()
        collectionView.reloadData()
    }
    
}


//MARK: -UICollectionViewDelegateFlowLayout
extension BookmarksViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 125, height: 35)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


//MARK: -UITableViewDataSource
extension BookmarksViewController: UITableViewDataSource {
    
    //    MARK: Row Count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookmarkedArticels.count
    }
    
    //    MARK: TAble View Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCellForBookmarks", for: indexPath) as! NewsTableViewCell
        
        cell.setValues(viewModel: viewModels[indexPath.row])
        
        cell.bookmarkImgView.alpha = CoreDataManager.shared.checkAvailablityInBookmark(url: viewModels[indexPath.row].url!, selectedNewsCategory: self.selectedNewsCategory) ? 1 : 0
        cell.bookmarkBGView .alpha = CoreDataManager.shared.checkAvailablityInBookmark(url: viewModels[indexPath.row].url!, selectedNewsCategory: self.selectedNewsCategory) ? 1 : 0
        
        cell.bookmarkImgView.alpha = 0
        cell.bookmarkBGView.alpha = 0
        cell.newsImageView.layer.cornerRadius = 10
        
        return cell
    }
}


//MARK: -UITableViewDelegate
extension BookmarksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let viewModel = viewModels[indexPath.row]
        
        selectedIndexPath = indexPath
        performSegue(withIdentifier: Constants.goToDetailsBookmarkView , sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //    //MARK: Trailing Swipe Action(Delete)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let bookmarkAction = UIContextualAction(style: .destructive , title: nil) { [weak self] _,_,completion in
            
            guard let self = self else {return}
            CoreDataManager.shared.removeFromBookmarks(url: self.bookmarkedArticels[indexPath.row].url!, selectedNewsCategory: self.selectedNewsCategory)
            
            self.fetchNewsForBookmarks()
            tableView.reloadData()
            
            completion(true)
        }
        bookmarkAction.image = UIImage(systemName: "trash.fill")
        bookmarkAction.backgroundColor = .systemRed //UIColor(named: "navy")
        
        let swipeAction = UISwipeActionsConfiguration(actions: [bookmarkAction])
        swipeAction.performsFirstActionWithFullSwipe = true
        return swipeAction
    }
}


//MARK: -UpdateBookmarks
extension BookmarksViewController: UpdateBookmarks {
    func updateTableView(){
        tableView.reloadData()
    }
}


