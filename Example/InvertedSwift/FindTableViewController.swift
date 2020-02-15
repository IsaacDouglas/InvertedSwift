//
//  FindTableViewController.swift
//  InvertedSwift_Example
//
//  Created by Isaac Douglas on 14/02/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import InvertedSwift

class FindTableViewController: UITableViewController {

    internal var invertedIndex: ISInvertedIndex!
    internal var filteredDocuments = [ISDocument]()
    internal var completeDocuments = [ISDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "InvertedSwift"
        self.setNavigation()
        
        self.completeDocuments = self.documents()
        self.filteredDocuments = self.completeDocuments
        
        self.tableView.register(cell: UITableViewCell.self)
        self.tableView.allowsSelection = false
        self.tableView.addFooterView()
        
        self.invertedIndex = ISInvertedIndex(stringProcess: StringProcess())
        self.invertedIndex.index(documents: self.completeDocuments)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDocuments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: UITableViewCell.identifier)
        
        let document = self.filteredDocuments[indexPath.row]
        cell.textLabel?.text = document.documentName()
        cell.detailTextLabel?.text = document.documentLines().joined(separator: "; ")
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return -1
    }

}

extension FindTableViewController {
    
    internal func setNavigation() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    internal func documents() -> [ISDocument] {
        let doc1 = Document(name: "doc1.txt", lines: ["Etiam et rhoncus nisl, non consectetur elit. Sed id ex nulla."])
        let doc2 = Document(name: "doc2.txt", lines: ["Sed quam ligula, feugiat vel rhoncus a, vulputate vitae justo."])
        let doc3 = Document(name: "doc3.txt", lines: ["Pellentesque turpis nunc, hendrerit quis volutpat nec, lobortis vitae metus."])
        let doc4 = Document(name: "doc4.txt", lines: ["Ut id consequat velit, vel porttitor ipsum. Nam fringilla hendrerit vestibulum. Nunc facilisis eget ex at porttitor."])
        let doc5 = Document(name: "doc5.txt", lines: ["Vestibulum nec luctus dui. Sed auctor erat at nisl sagittis vulputate."])
        let doc6 = Document(name: "doc6.txt", lines: ["Aliquam hendrerit arcu nec elit molestie eleifend."])
        let doc7 = Document(name: "doc7.txt", lines: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit."])
        let doc8 = Document(name: "doc8.txt", lines: ["Curabitur vulputate pharetra augue a condimentum. Pellentesque vel dapibus sem."])
        let doc9 = Document(name: "doc9.txt", lines: ["Praesent sit amet tincidunt justo, vitae vehicula felis."])
        return [doc1, doc2, doc3, doc4, doc5, doc6, doc7, doc8, doc9]
    }
}

extension FindTableViewController: UISearchBarDelegate {
    func completeItems() -> [ISDocument] {
        return self.completeDocuments
    }

    func filteredItems(items: [ISDocument]) {
        self.filteredDocuments = items
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let documents = self.invertedIndex.findDocument(text: searchText)
        
        if documents.isEmpty {
            self.filteredItems(items: self.completeItems())
        } else {
            self.filteredItems(items: documents)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filteredItems(items: self.completeItems())
    }
}
