//
//  AuthorsViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 09/04/21.
//

import UIKit

extension Notification.Name {
    static let authorDeleted = Notification.Name("An author has been removed")
}

class AuthorsViewController: CustomViewController {
    @IBOutlet weak var authorsCollectionView: UICollectionView!
    
    var authors: [AuthorResponse] = []
    var authorRepository: AuthorRepository
    
    var navigationRightButtonItems: [NavigationBarItem] {
        guard UserDefaults.standard.getAuthenticated()?
                .role == Role.ADMIN else { return defaultNavigationButtonItems }

        return [.barSystemItem(.add, self, #selector(didAuthorAddingButtonPressed(_:)))]
    }
    
    init(authorRepository: AuthorRepository = AuthorRepository(), nibName: String?, bundle: Bundle?) {
        self.authorRepository = authorRepository
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        self.authorRepository = AuthorRepository()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorsCollectionView.dataSource = self
        authorsCollectionView.delegate = self
        
        navigationItem.backButtonTitle = ""
        setupNavigationBar(itemsOnTheRight: navigationRightButtonItems)
        
        loadAuthorsList()
    }
    
    override func didUserSignedIn() {
        super.didUserSignedIn()
        
        setupNavigationBar(itemsOnTheRight: navigationRightButtonItems)
        authorsCollectionView.reloadData()
    }
    
    func loadAuthorsList() {
        let indicator = UIActivityIndicatorView.customIndicator(to: self.view)
        indicator.startAnimating()
        
        authorRepository.allAuthors { [weak self] authors in
            guard let self = self else { return }
            
            self.updateAuthorsList(with: authors)
            indicator.stopAnimating()
            
        } failureHandler: {
            indicator.stopAnimating()
            Alert.show(title: "Ops", message: "Could not possible to load our authors", in: self)
        }
    }
    
    func updateAuthorsList(with authors: [AuthorResponse]) {
        self.authors = authors
        authorsCollectionView.reloadData()
    }
    
    @objc func didAuthorAddingButtonPressed(_ sender: UIButton) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AuthorFormViewController") as! AuthorFormViewController
        controller.delegate = self
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension AuthorsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return authors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let author = authors[indexPath.row]
        
        guard let authorCell = collectionView.dequeueReusableCell(withReuseIdentifier: AuthorCell.reuseId, for: indexPath) as? AuthorCell else {
            fatalError("Invalid view cell type for author item. Please, check the configuration in the Cell and CollectionView's code or ib definition")
        }
        
        authorCell.delegate = self
        authorCell.setFrom(author)
        
        return authorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AuthorsHeaderView.reuseId, for: indexPath)
                    as? AuthorsHeaderView else {
                fatalError("Invalid view type for the authors header")
            }
            
            headerView.sectionTitle.label.text = "Nossos Autores"
            return headerView
            
        default:
            assert(false, "Invalid element type")
        }
    }
}

extension AuthorsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalMargin: CGFloat = 16
        
        let superviewWidth: CGFloat = collectionView.bounds.width
        let adjustedWidth = superviewWidth - horizontalMargin * 2
        
        return CGSize(width: adjustedWidth, height: 206)
    }
}

extension AuthorsViewController: AuthorFormViewControllerDelegate {
    func didAuthorCreated(_ author: AuthorResponse) {
        let allAuthors: [AuthorResponse] = self.authors + [author]
        updateAuthorsList(with: allAuthors)
    }
    
    func didAuthorUpdated(_ author: AuthorResponse) {
        let updatedList: [AuthorResponse] = authors.map{ $0.id == author.id ? author : $0 }
        updateAuthorsList(with: updatedList)
    }
}

extension AuthorsViewController: AuthorCellDelegate {
    
    func didRemovingButtonPressed(_ sender: UIButton!, forAuthorIdentifiedBy id: Int) {
        let indicator = UIActivityIndicatorView.customIndicator(to: self.view)
        indicator.startAnimating()
        
        authorRepository.deleteAuthor(identifiedBy: id) { [weak self] in
            guard let self = self else { return }
            
            indicator.stopAnimating()
            self.updateAuthorsList(with: self.authors.filter { $0.id != id })
            
            NotificationCenter.default.post(Notification(name: .authorDeleted))
            
        } failureHandler: {
            indicator.stopAnimating()
            Alert.show(title: "Ops!", message: "Could not possible to remove this author right now. Try again later!", in: self)
        }
    }
    
    func didEditingButtonPressed(_ sender: UIButton!, for author: AuthorResponse) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AuthorFormViewController") as! AuthorFormViewController
        controller.delegate = self
        controller.selectedAuthor = author
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
