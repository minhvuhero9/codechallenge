//
//  HomeVC.swift
//  CodeChallenge
//
//  Created by Minh Vu on 15/08/2024.
//

import UIKit

class HomeVC: UIViewController {
    private let vm: HomeVM

    @IBOutlet private weak var photoTV: UITableView!
    private let refreshControl = UIRefreshControl()
    private let searchBar = UISearchBar()

    init(vm: HomeVM) {
        self.vm = vm
        super.init(nibName: "HomeVC", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()
        setupTableView()
        setupRefreshControl()
        setupSearchBar()
        setupTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
    }
    
    private func loadData() {
        vm.getListPhoto()
        self.photoTV.reloadData()
    }
    
    private func reloadData() {
        self.vm.fetchDataSuccess = {
            CommonManager.hideLoading()
            DispatchQueue.main.async {
                self.photoTV.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
        self.vm.searchDataFailure = {
            self.showAlert(message: "Search text exceeds 15 characters.")
            self.searchBar.text = ""
            self.vm.clearSearch()
        }
    }
    
    private func setupTableView() {
        photoTV.delegate = self
        photoTV.dataSource = self
        photoTV.register(UINib.init(nibName: "PhotoCell", bundle: .main), forCellReuseIdentifier: "PhotoCell")
        photoTV.register(LoadMoreTableViewCell.self, forCellReuseIdentifier: "LoadMoreTableViewCell")
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        photoTV.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        // Fetch new data and update the table view
        vm.getListPhoto(isRefreshing: true)
        reloadData()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search by author or ID"
        navigationItem.titleView = searchBar
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Search", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vm.photoData.isEmpty {
            return 0
        }
        return vm.isFiltering ? vm.filteredPhotos.count : vm.photoData.count + 1

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == vm.photoData.count && !(vm.photoData.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreTableViewCell", for: indexPath) as? LoadMoreTableViewCell
            cell?.startLoading()
            return cell ?? UITableViewCell()
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as? PhotoCell else { return UITableViewCell()}
            let photo = vm.isFiltering ? vm.filteredPhotos[indexPath.row] : vm.photoData[indexPath.row]
            cell.bindData(data: photo)
            cell.getImageSuccess = {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == vm.photoData.count && !(vm.photoData.count == 0) {
            vm.getListPhoto()
        }
    }
}

extension HomeVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let validatedText = vm.validateSearchText(searchText)
        
        if searchText != validatedText {
            searchBar.text = validatedText
        }
        
        if validatedText.isEmpty {
            vm.clearSearch()
        } else {
            vm.searchPhotos(by: validatedText)
        }
    }
}


