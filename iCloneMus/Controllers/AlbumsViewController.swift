//
//  AlbumsViewController.swift
//  ListAlbum
//
//  Created by Samir Akhmadi on 18.01.2022.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var albums = [Album]()
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupDelegate()
        setConstraints()
        setNavigationBar()
        setupSerachController()
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    private func setupDelegate(){
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchBar.delegate = self
    }
    
    private func setNavigationBar(){
        navigationItem.title = "Albums"
        
        navigationItem.searchController = searchController
        
        let userInfiButton = createCustomButton(selector: #selector(userInfoButtonTapped),title: nil, image: UIImage(systemName: "person.fill"))
        let logoutButton = createCustomButton(selector: #selector(logoutButtonTapped), title: "Log Out", image: nil)
        navigationItem.rightBarButtonItems = [userInfiButton, logoutButton]
    }
    
    private func setupSerachController(){
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    @objc func userInfoButtonTapped(){
        let userInfoVC = UserInfoViewController()
        navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
    @objc func logoutButtonTapped() {
        DataBase.shared.removeActiveUser()
        dismiss(animated: true)
    }
    
    private func fetchAlbums(albumName: String) {
        
        let urlString = "https://itunes.apple.com/search?term=\(albumName)&entity=album&attribute=albumTerm"
        
        NetworkDataFetch.shared.fetchAlbum(urlString: urlString) { [weak self] (albumModel, error) in
            
            if error == nil {
                guard let albumModel = albumModel else { return }
                
                if albumModel.results != [] {
                    let sortedAlbums = albumModel.results.sorted { (firstItem, secondItem) -> Bool in
                        return firstItem.collectionName.compare(secondItem.collectionName) == ComparisonResult.orderedAscending
                    }
                    self?.albums = sortedAlbums
                    self?.tableView.reloadData()
                } else {
                    self?.alertOk(title: "Error", message: "Album not found. Add some words")
                }
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }

}

//MARK: - UITableViewDataSource

extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlbumTableViewCell
        let album = albums[indexPath.row]
        cell.configureAlbumCell(album: album)
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension AlbumsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailAlbumVC = DetailAlbumViewController()
        let album = albums[indexPath.row]
        detailAlbumVC.album = album
        detailAlbumVC.title = album.artistName
        navigationController?.pushViewController(detailAlbumVC, animated: true)
    }
}


//MARK: - UISearchBarDelegate

extension AlbumsViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let text = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if text != "" {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                self?.fetchAlbums(albumName: text!)
            }
        }
    }
    
}

//MARK: - SetConstraints

extension AlbumsViewController {
    
    private func setConstraints(){
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
    }
    
}
