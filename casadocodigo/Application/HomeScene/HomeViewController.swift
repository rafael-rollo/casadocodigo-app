//
//  ViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 09/04/21.
//

import UIKit

class HomeViewController: BaseNavbarItemsViewController {
    
    @IBOutlet weak var showcaseCollectionView: UICollectionView!
    @IBOutlet weak var searchFooter: SearchFooter!
    @IBOutlet weak var searchFooterBottomConstraint: NSLayoutConstraint!
   
    var showcase: [BookResponse] = []
    var isShowcaseUpToDate = false
    
    var filteredBooks: [BookResponse] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    var bookRepository: BookRepository
    let showcaseFlowLayoutImpl: ShowcaseFlowLayout = ShowcaseFlowLayout()
    let searchController = UISearchController(searchResultsController: nil)
    
    var navigationRightButtonItems: [NavigationBarItem] {
        guard UserDefaults.standard.getAuthenticated()?
                .role == Role.ADMIN else { return defaultNavigationButtonItems }

        return [.barSystemItem(.add, self, #selector(didBookAddingButtonPressed))]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showcaseCollectionView.delegate = self
        showcaseCollectionView.dataSource = self
        
        navigationItem.backButtonTitle = ""
        setupNavigationBar(itemsOnTheRight: navigationRightButtonItems)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(markShowcaseAsOutdated),
            name: .authorDeleted,
            object: nil
        )
        
        loadShowcase()

        setupSearchController()
        registerForKeyboardNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.isShowcaseUpToDate {
            return
        }
            
        loadShowcase()
    }
    
    override func didUserSignedIn() {
        super.didUserSignedIn()
        
        setupNavigationBar(itemsOnTheRight: navigationRightButtonItems)
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
    
    @objc func didBookAddingButtonPressed() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "BookFormViewController") as! BookFormViewController
        controller.delegate = self
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func filterBooksBySearchText(_ searchText: String) {
      filteredBooks = showcase.filter { (book: BookResponse) -> Bool in
        return book.title.lowercased().contains(searchText.lowercased())
      }
      
      showcaseCollectionView.reloadData()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main) { [weak self] (notification) in
                self?.toogleSearchFooterPosition(notification)
            }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main) { [weak self] (notification) in
                self?.toogleSearchFooterPosition(notification)
            }
    }
    
    func toogleSearchFooterPosition(_ notification: Notification) {
        guard notification.name == UIResponder.keyboardWillShowNotification else {
            searchFooterBottomConstraint.constant = .zero
            updateCollectionViewBottomInsetBy(.zero)
            
            view.layoutIfNeeded()
            return
        }
    
        guard let info = notification.userInfo,
              let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as?
                NSValue else { return }
        
        let tabBarHeight: CGFloat = tabBarController?.tabBar.frame.height ?? 0
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        let bottomOffset = keyboardHeight - tabBarHeight
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
          self.searchFooterBottomConstraint.constant = bottomOffset
          self.view.layoutIfNeeded()
        })
        
        updateCollectionViewBottomInsetBy(bottomOffset + Theme.spacing.xlarge)
    }
    
    func updateCollectionViewBottomInsetBy(_ bottomInset: CGFloat) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        showcaseCollectionView.contentInset = contentInsets
        showcaseCollectionView.scrollIndicatorInsets = contentInsets
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = isFiltering
            ? filteredBooks[indexPath.row]
            : showcase[indexPath.item]
        
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "BookDetailsViewController") as! BookDetailsViewController
        
        controller.delegate = self
        controller.selectedBook = selectedBook
    
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            searchFooter.setIsFiltering(filteredBooks.count, of: showcase.count)
            return filteredBooks.count
        }
        
        searchFooter.setNotFiltering()
        return showcase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let showcaseBook = isFiltering
            ? filteredBooks[indexPath.row]
            : showcase[indexPath.row]
        
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
            
            let sectionTitle = isFiltering
                ? "Busca por \"\(searchController.searchBar.text!)\""
                : "Todos os Livros"
            
            headerView.sectionTitle.label.text = sectionTitle
            return headerView
            
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

extension HomeViewController: UISearchResultsUpdating {
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
    
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Buscar livros",
            attributes: [.foregroundColor: UIColor.lightText]
        )
    
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
        
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterBooksBySearchText(searchBar.text!)
    }
}
