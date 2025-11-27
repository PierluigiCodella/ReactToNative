//
//  FavouritesViewController.swift
//  ReactToNative
//
//  Created by Pierluigi Codella on 16/12/24.
//

import UIKit
import Combine

class FavouritesViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    
    let favouriteMovieList = ["The Godfather",
                              "The Shawshank Redemption",
                              "The Dark Knight",
                              "The Lord of the Rings: The Return of the King",
                              "Pulp Fiction", "Schindler's List",
                              "Inception",
                              "The Lord of the Rings: The Fellowship of the Ring",
                              "The Lord of the Rings: The Two Towers",
                              "The Matrix"]
    
    let label = UILabel()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserManager.shared.$isLoggedIn
            .receive(on: DispatchQueue.main)
            .sink { isLoggedIn in
                self.setLabelTitle(isLoggedIn: isLoggedIn)
                self.setTableViewVisibility(isLoggedIn: isLoggedIn)
            }.store(in: &cancellables)
        
        view.backgroundColor = .white
        label.text = "Favourite Movies"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true


        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true

    }

    func setLabelTitle(isLoggedIn: Bool) {
        if isLoggedIn {
            label.text = "Favourite Movies"
        } else {
            label.text = "Please login to see your favourite movies"
        }
    }

    func setTableViewVisibility(isLoggedIn: Bool) {
        tableView.isHidden = !isLoggedIn
    }
    
    
}

extension FavouritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteMovieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = favouriteMovieList[indexPath.row]
        return cell
    }
}

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = favouriteMovieList[indexPath.row]
        let alert = UIAlertController(title: "Movie Selected", message: movie, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

