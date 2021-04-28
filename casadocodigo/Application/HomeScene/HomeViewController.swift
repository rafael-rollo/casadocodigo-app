//
//  ViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 09/04/21.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource {
   
    // MARK: Attributes
    
    var showcase: [BookShowcaseItem] = []
    var isShowcaseUpToDate = false
    
    var bookRepository: BookRepository
    let showcaseFlowLayoutImpl: UICollectionViewDelegateFlowLayout = ShowcaseFlowLayout()
    
    // MARK: IBOutlets
    
    @IBOutlet weak var showcaseCollectionView: UICollectionView!
    
    // MARK: View Lifecycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        showcaseCollectionView.delegate = self.showcaseFlowLayoutImpl
        showcaseCollectionView.dataSource = self
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(markShowcaseAsOutdated),
            name: .authorDeleted,
            object: nil
        )
        
        loadShowcase();
    }

    override func viewDidAppear(_ animated: Bool) {
        if self.isShowcaseUpToDate {
            return
        }
            
        loadShowcase()
    }
    
    // MARK: Constructors and Destructors
    
    init(bookRepository: BookRepository = BookRepository(), nibName: String?, bundle: Bundle?) {
        self.bookRepository = bookRepository
        super.init(nibName: nibName, bundle: bundle)
    }
        
    required init?(coder: NSCoder) {
        self.bookRepository = BookRepository()
        super.init(coder: coder)

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: UICVDataSource impl
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showcase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let showcaseBook = showcase[indexPath.row]
        
        guard let showcaseBookCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowcaseBookCell.reuseId, for: indexPath) as? ShowcaseBookCell else {
            fatalError("Invalid view cell type for showcase book. Please, check the configuration in the Cell and CollectionView's code or ib definition")
        }
        
        showcaseBookCell.setFrom(showcaseBook)
        return showcaseBookCell;
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ShowcaseHeaderView.reuseId, for: indexPath)
                    as? ShowcaseHeaderView else {
                fatalError("Invalid view type for book showcase header")
            }
            return headerView.build()
            
        default:
            assert(false, "Invalid element type")
        }
    }
    
    // MARK: View methods
    
    func loadShowcase() {
        let indicator = UIActivityIndicatorView.customIndicator(to: self.view)
        indicator.startAnimating()
        
        debugPrint(bookRepository)
        
        bookRepository.showcase { [weak self] books in
            guard let self = self else { return }
    
            self.updateShowcase(with: books)
            indicator.stopAnimating()
            
        } failureHandler: {
            indicator.stopAnimating()
            Alert.show(title: "Ops", message: "Could not load the book showcase from the API", in: self)
        }

    }
    
    func updateShowcase(with books: [BookShowcaseItem]) {
        showcase = books
        isShowcaseUpToDate = true
        
        showcaseCollectionView.reloadData()
    }
    
    @objc func markShowcaseAsOutdated() {
        isShowcaseUpToDate = false
    }
}

