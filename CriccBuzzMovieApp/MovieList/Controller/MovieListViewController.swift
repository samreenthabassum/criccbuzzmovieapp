//
//  MovieListViewController.swift
//  CriccBuzzMovieApp
//
//  Created by Samreen Thabassum on 30/07/24.
//

import UIKit

class MovieListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MovieListCell", bundle: nil), forCellReuseIdentifier: "MovieListCell")
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieListCell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
        
        movieListCell.title.text = "Title: " + self.movies[indexPath.row].title
        movieListCell.languages.text = "Languages: " + self.movies[indexPath.row].language
        movieListCell.thumbnail.load(url: URL(string: self.movies[indexPath.row].poster) ?? URL(fileURLWithPath: ""))
        movieListCell.year.text = "Year: " + self.movies[indexPath.row].year
        
        return movieListCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destinationVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController
        destinationVC?.movie = self.movies[indexPath.row]
        self.navigationController?.pushViewController(destinationVC!, animated: true)
    }
}
