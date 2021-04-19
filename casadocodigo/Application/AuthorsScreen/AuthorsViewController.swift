//
//  AuthorsViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 09/04/21.
//

import UIKit

class AuthorsViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Attributes
    
    var authors: [Author] = []
    
    // MARK: IBOutlets
    
    @IBOutlet weak var authorsTableView: UITableView!
    
    // MARK: View lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.authorsTableView.dataSource = self
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        
        AuthorRepository().allAuthors { authors in
            self.authors = authors
            self.authorsTableView.reloadData()
        } failureHandler: {
            Alert.show(title: "Ops", message: "Could not possible to load our authors", in: self)
        }
    }
    
    // MARK: UITVDataSource impl
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.authors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let author = self.authors[indexPath.row]
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = author.firstName
        
        return cell
    }
}
