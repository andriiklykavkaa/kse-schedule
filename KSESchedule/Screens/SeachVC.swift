//
//  ViewController.swift
//  KSE Schedule Beta
//
//  Created by Andrii Klykavka on 04.09.2024.
//

import UIKit
import CoreXLSX

class SearchVC: UIViewController {
    
    var searchController: UISearchController!
    var tableView: KSTableView!
    
    enum Section { case main }
    
    var students: [Student] = []
    var filteredStudents: [Student] = []
    var recentStudents: [Student] = []
    
    var diffableDataSource: UITableViewDiffableDataSource<Section, Student>?
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        students = ExcelManager.shared.getListOfStudents()
        recentStudents = StudentStorage.shared.recentStudents
        
        setupViewController()
        setupSearchController()
        setupTableView()
        configureDiffableDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData(on: recentStudents)
    }
    
    
    func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func setupSearchController() {
        searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    
    func setupTableView() {
        tableView = KSTableView()
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    func configureDiffableDataSource() {
        diffableDataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, student in
            let cell = tableView.dequeueReusableCell(withIdentifier: StudentCell.reuseID, for: indexPath) as! StudentCell
            cell.set(student)
            return cell
        })
    }
    
    
    func updateData(on students: [Student]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Student>()
        snapshot.appendSections([.main])
        snapshot.appendItems(students, toSection: .main)
        diffableDataSource?.apply(snapshot)
    }
}


extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text else { return }
        
        if filter.isEmpty {
            updateData(on: recentStudents)
            return
        }
        
        filteredStudents = UIHelper.filterSearchResult(in: students, with: filter)
        updateData(on: filteredStudents)
    }
}


extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let student = diffableDataSource?.itemIdentifier(for: indexPath) else { return }
        
        StudentStorage.shared.addStudent(student)
        recentStudents = StudentStorage.shared.recentStudents
        
        let studentVC = StudentVC()
        studentVC.student = student
        navigationController?.pushViewController(studentVC, animated: true)
        
        if searchController.searchBar.text?.isEmpty ?? true {
            updateData(on: recentStudents)
        }
        
        searchController.isActive = false
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let student = diffableDataSource?.itemIdentifier(for: indexPath) else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            StudentStorage.shared.removeStudent(student)
            self.recentStudents = StudentStorage.shared.recentStudents
            updateData(on: self.recentStudents)
            
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
