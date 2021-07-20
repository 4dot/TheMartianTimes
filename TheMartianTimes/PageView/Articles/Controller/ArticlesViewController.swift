//
//  ArticlesViewController.swift
//  TheMartianTimes
//
//  Created by Chanick on 6/16/21.
//

import UIKit


class ArticlesViewController : UIViewController, Storyboarded {
    // Navigation Coordinate
    weak var coordinator: MainCoordinator?

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // Article ViewModel
    private var articleViewModel : ArticleViewModel!
        
    // Article DataSource
    private var dataSource : ArticleCollectionViewDataSource<ArticleCollectionViewCell, Article>!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bindViewModelForUpdate()
    }
    
    func configure() {
        // Create ViewModel
        self.articleViewModel = ArticleViewModel()
        
        // Fatch Articles
        self.articleViewModel.fatchArticles()
        
        self.collectionView.register(UINib(nibName:"ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ArticleCollectionViewCell.reuseIdentifier)
             
        //collectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: ArticleCollectionViewCell.reuseIdentifier)
        
        // CollectionView Custom Layout
        let layout = ArticleViewLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        
        configNavigationBar(self.articleViewModel.currentLanguage)
    }
    
    func configNavigationBar(_ currentLanguage: LanguageType) {
        let segmentItems = ["🇺🇸", "👽"]
        let control = UISegmentedControl(items: segmentItems)
        control.frame = CGRect(x: 0, y: 0, width: 100, height: 32)
        control.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        control.selectedSegmentIndex = currentLanguage.rawValue
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: control)
        

        // Add Logo Image on the Navigation bar
        let logoImg = UIImage(named: "logo")!
        let imageView = UIImageView(image: logoImg)
        imageView.contentMode = .scaleAspectFit
        
        self.tabBarController?.navigationItem.titleView = imageView
    }
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
        let language = LanguageType(rawValue: segmentedControl.selectedSegmentIndex)!
        
        print("selected Language: \(language)")
        switchLanguage(language)
    }
    
    func bindViewModelForUpdate() {
        // Bind Article Updater
        self.articleViewModel.bindArticleUpdater = { language in
            self.updateDataSource(language)
        }
        
        // Bind Language Change
        self.articleViewModel.bindLanguageUpdater = { language in
            self.updateDataSource(language)
        }
    }
    
    fileprivate func switchLanguage(_ languageType: LanguageType) {
        self.articleViewModel.currentLanguage = languageType
    }
    
    //
    // Update Collection View all when First data loaded and Changed Language
    // Because Cell height will be changed.
    //
    func updateDataSource(_ language: LanguageType) {
        self.dataSource = ArticleCollectionViewDataSource(cellIdentifier: ArticleCollectionViewCell.reuseIdentifier, items: self.articleViewModel.articles, configureCell: { (cell, article, indexPath) in
            let showSeprator = indexPath.row + 1 != self.collectionView.numberOfItems(inSection: 0)
            
            // Translate
            let translated = self.articleViewModel.translate(to: language, article: article)
            
            cell.configCell(indexPath.row,
                            translated.title,
                            translated.getShortBody(),
                            translated.getTopImage(),
                            showSeprator) { index, size in
                // update cell
                self.articleViewModel.updateImageSize(index, Int(size.width), Int(size.height))
            }
        })
        
        DispatchQueue.main.async {
            self.collectionView.dataSource = self.dataSource
            self.collectionView.reloadData()
        }
    }
}

extension ArticlesViewController : ArticleViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let article = articleViewModel.articles[indexPath.row]
        
        var imgHeight: CGFloat = 0
        if let articleImg = article.images.first (where: { $0.top_image == true }) {
            imgHeight = ArticleHelper.calculateImageHeight(articleImage: articleImg, scaledToWidth: cellWidth)
        }
        
        let titleHeight = ArticleHelper.calculateTitleHeight(text: article.title, cellWidth: cellWidth)
        let bodyHeight = ArticleHelper.calculateBodyHeight(text: article.getShortBody(), cellWidth: cellWidth)
        
        return titleHeight + bodyHeight + imgHeight + 60 // 40: seprator line
    }
}

// MARK: - UICollectionViewDelegate
extension ArticlesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = articleViewModel.articles[indexPath.row]
        (self.tabBarController as? MainTabBarController)?.coordinator?.showDetail(article)
    }
}
