//
//  ArticleDetailViewController.swift
//  TheMartianTimes
//
//  Created by Chanick on 6/18/21.
//

import UIKit


class ArticleDetailViewController : UIViewController, Storyboarded {
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var coordinator: MainCoordinator?
    var article: Article?
    
    // Article ViewModel
    private var articleViewModel : ArticleViewModel!
    
    // Article DataSource
    private var dataSource : ArticleCollectionViewDataSource<ArticleCollectionViewCell, Article>!
    
    
    
    
    init(_ article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        //Storyboard initialization requires the super implementation
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        callToViewModelForUIUpdate()
    }
    
    func configure() {
        // Create ViewModel
        self.articleViewModel = ArticleViewModel()
        
        self.collectionView.register(UINib(nibName:"ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ArticleCollectionViewCell.reuseIdentifier)
        //collectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: ArticleCollectionViewCell.reuseIdentifier)
        
        // CollectionView Custom Layout
        let layout = ArticleViewLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
    }
    
    func callToViewModelForUIUpdate() {
        // Binding view and Model
        self.articleViewModel.bindArticleUpdater = { language in
            self.updateDataSource(language)
        }
        
        if let article = self.article {
            self.articleViewModel.setArticles([article])
        }
    }
    
    func updateDataSource(_ language: LanguageType) {
        self.dataSource = ArticleCollectionViewDataSource(cellIdentifier: ArticleCollectionViewCell.reuseIdentifier, items: self.articleViewModel.articles, configureCell: { (cell, article, indexPath) in
            let showSeprator = indexPath.row + 1 != self.collectionView.numberOfItems(inSection: 0)
            
            // Translate
            let translated = self.articleViewModel.translate(to: language, article: article)
            
            cell.configCell(indexPath.row, translated.title, translated.body, translated.getTopImage(), showSeprator)
        })
        
        DispatchQueue.main.async {
            self.collectionView.dataSource = self.dataSource
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - IBAction
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

extension ArticleDetailViewController : ArticleViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        guard let article = self.article else {
            return 0
        }
        
        var imgHeight: CGFloat = 0
        if let articleImg = article.images.first (where: { $0.top_image == true }) {
            imgHeight = ArticleHelper.calculateImageHeight(articleImage: articleImg, scaledToWidth: cellWidth)
        }
        
        let titleHeight = ArticleHelper.calculateTitleHeight(text: article.title, cellWidth: cellWidth)
        let bodyHeight = ArticleHelper.calculateBodyHeight(text: article.body, cellWidth: cellWidth)
        
        return titleHeight + bodyHeight + imgHeight  + 32 + 12 // 32px: top padding, 12px: bottom line view height
    }
}
