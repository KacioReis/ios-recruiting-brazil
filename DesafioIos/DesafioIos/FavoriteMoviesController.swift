//
//  FavoriteMoviesController.swift
//  DesafioConcrete
//
//  Created by Kacio Henrique Couto Batista on 05/12/19.
//  Copyright © 2019 Kacio Henrique Couto Batista. All rights reserved.
//

import UIKit
import SnapKit
class FavoriteMoviesController: UIViewController ,UISearchResultsUpdating{
    
    var favoriteMovies:[Movie] = getFavoritesMovies() {
        didSet{
            self.filterFavoriteMovies = self.favoriteMovies
        }
    }

    var filterFavoriteMovies:[Movie] = [] {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var tableView:UITableView = {
        let view = UITableView(frame: .zero)
        return view
    }()
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .blue
        self.view = view
        filterFavoriteMovies = favoriteMovies
        setupView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        makeSearchController()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.favoriteMovies = getFavoritesMovies()
        
    }
    func makeSearchController(){
        let searchController = UISearchController(nibName: nil, bundle: nil)
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        searchController.searchResultsUpdater = self
    }
    //MARK: - protocol function SearchBarController Updating
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == ""{
            filterFavoriteMovies = favoriteMovies
        }
        else {
            filterFavoriteMovies = favoriteMovies.filter({ movie in
                return movie.title.lowercased().contains(searchController.searchBar.text!.lowercased())
            })
        }
        self.tableView.reloadData()
    }
}
//MARK: - Protocols UITableViewDataSource and UITableViewDelegate
extension FavoriteMoviesController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterFavoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell:FavoriteMovieCellView = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? FavoriteMovieCellView
            else{
                return tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        }
        cell.movie = filterFavoriteMovies[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // remove the item from CoreData
            removeNSManagedObjectById(id: filterFavoriteMovies[indexPath.row].id)
            //get update Favorite Movies
            favoriteMovies = getFavoritesMovies()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
}

// MARK: - Protocols CodeView
extension FavoriteMoviesController:CodeView{
    func buildViewHierarchy() {
        self.view.addSubview(tableView)
    }
    
    func setupConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    func setupAdditionalConfiguration() {
        tableView.register(FavoriteMovieCellView.self, forCellReuseIdentifier: "myCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Movies"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "FilterIcon"), style: .done, target: nil, action: nil)
    }
    
    
}
