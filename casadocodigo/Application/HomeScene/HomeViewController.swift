//
//  ViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 09/04/21.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var showcaseCollectionView: UICollectionView!
   
    var showcase: [BookResponse] = []
    var isShowcaseUpToDate = false
    var bookRepository: BookRepository
    let showcaseFlowLayoutImpl: ShowcaseFlowLayout = ShowcaseFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showcaseCollectionView.delegate = self
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
        
    func loadShowcase() {
        let indicator = UIActivityIndicatorView.customIndicator(to: self.view)
        indicator.startAnimating()
        
        bookRepository.showcase { [weak self] books in
            guard let self = self else { return }
    
            self.updateShowcase(with: books)
            indicator.stopAnimating()
            
        } failureHandler: {
            indicator.stopAnimating()
            Alert.show(title: "Ops", message: "Could not load the book showcase from the API", in: self)
        }

    }
    
    func updateShowcase(with books: [BookResponse]) {
        showcase = books
        isShowcaseUpToDate = true
        
        showcaseCollectionView.reloadData()
    }
    
    @objc func markShowcaseAsOutdated() {
        isShowcaseUpToDate = false
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = showcase[indexPath.item]
        
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "BookDetailsViewController") as! BookDetailsViewController
        
        controller.delegate = self
        controller.selectedBook = selectedBook
    
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
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
            return headerView.build(delegate: self)
            
        default:
            assert(false, "Invalid element type")
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.showcaseFlowLayoutImpl.sizeForItemOf(collectionView, layout: collectionViewLayout, atIndex: indexPath)
    }
}

extension HomeViewController: SectionTitleDelegate {
    func didAddButtonPressed(_ sender: UIButton) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "BookFormViewController") as! BookFormViewController
        controller.delegate = self
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension HomeViewController: BookFormViewControllerDelegate {
    func didBookCreated(_ book: BookResponse) {
        let updatedBookList: [BookResponse] = showcase + [book]
        updateShowcase(with: updatedBookList)
    }
    
    func didBookUpdated(_ book: BookResponse) {
        let updatedList: [BookResponse] = showcase.map{ $0.id == book.id ? book : $0 }
        updateShowcase(with: updatedList)
    }
}

extension HomeViewController: BookDetailsViewControllerDelegate {
    func didDeletingButtonPressed(_ sender: UIButton!, forBookIdentifiedBy id: Int) {
        let indicator = UIActivityIndicatorView.customIndicator(to: self.view)
        indicator.startAnimating()
        
        bookRepository.deleteBook(identifiedBy: id) { [weak self] in
            guard let self = self else { return }
            
            indicator.stopAnimating()
            self.updateShowcase(with: self.showcase.filter { $0.id != id })
            
        } failureHandler: {
            indicator.stopAnimating()
            Alert.show(title: "Ops!", message: "Could not possible to remove this book right now. Try again later!", in: self)
        }
    }
    
    func didEditingButtonPressed(_ sender: UIButton!, for book: BookResponse) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "BookFormViewController") as! BookFormViewController
        controller.delegate = self
        controller.selectedBook = book
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
