//
//  MovieDataListViewController.swift
//  CriccBuzzMovieApp
//
//  Created by Samreen Thabassum on 30/07/24.
//

import UIKit

class MovieDataListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredData: [Movie] = []
    var isSearching = false
    
    var yearExpanded = true
    var genreExpanded = true
    var directorsExpanded = true
    var actorsExpanded = true
    var allmoviesExpanded = true
    
    var movies: [Movie] = []
    var year: [String] = []
    var genre: [String] = []
    var directors: [String] = []
    var actors: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MovieListCell", bundle: nil), forCellReuseIdentifier: "MovieListCell")
        self.searchBar.delegate = self
        
        self.loadData()
    }


    func loadData() {
        ServiceManager().loadJSON { movies, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let movies = movies else {
                print("No data received")
                return
            }
            DispatchQueue.main.async {
                self.movies = movies
                
                self.year = Array(Set(movies.map({$0.year}).filter({$0 != "N/A"}))).sorted()
                
                self.genre = movies.map({$0.genre}).filter({$0 != "N/A"})
                self.genre =  Array(Set(self.genre.flatMap({$0.split(separator: ",").map({$0.trimmingCharacters(in: .whitespaces)})}))).sorted()
                
                self.directors = movies.map({$0.director}).filter({$0 != "N/A"})
                self.directors = Array(Set(self.directors.flatMap({$0.split(separator: ",").map({$0.trimmingCharacters(in: .whitespaces)})}))).sorted()
                
                self.actors = movies.map({$0.actors}).filter({$0 != "N/A"})
                self.actors = Array(Set(self.actors.flatMap({$0.split(separator: ",").map({$0.trimmingCharacters(in: .whitespaces)})}))).sorted()
                
                self.tableView.reloadData()
            }
        }
    }
}

extension MovieDataListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.isSearching = false
            self.filteredData = self.movies
        } else {
            self.isSearching = true
            self.filteredData = Utils().filterMovies(by: searchText, in: self.movies)
            
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MovieDataListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.isSearching ? 1 : MovieDataList.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearching {
            return self.filteredData.count
        } else if let section = MovieDataList(rawValue: section) {
            switch section {
            case .year:
                return self.yearExpanded ? self.year.count : 0
            case .genre:
                return self.genreExpanded ? self.genre.count : 0
            case .directors:
                return self.directorsExpanded ? self.directors.count : 0
            case .actors:
                return self.actorsExpanded ? self.actors.count : 0
            case .allMovies:
                return self.allmoviesExpanded ? self.movies.count : 0
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isSearching {
            let movieListCell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
            movieListCell.title.text = "Title: " + self.filteredData[indexPath.row].title
            movieListCell.languages.text = "Languages: " + self.filteredData[indexPath.row].language
            movieListCell.thumbnail.load(url: URL(string: self.filteredData[indexPath.row].poster) ?? URL(fileURLWithPath: ""))
            movieListCell.year.text = "Year: " + self.filteredData[indexPath.row].year
            return movieListCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        if let section = MovieDataList(rawValue: indexPath.section) {
            switch section {
            case .year:
                cell.MovieDataLabel.text = self.year[indexPath.row]
            case .genre:
                cell.MovieDataLabel.text = self.genre[indexPath.row]
            case .directors:
                cell.MovieDataLabel.text = self.directors[indexPath.row]
            case .actors:
                cell.MovieDataLabel.text = self.actors[indexPath.row]
            case .allMovies:
                let movieListCell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
                movieListCell.title.text = "Title: " + self.movies[indexPath.row].title
                movieListCell.languages.text = "Languages: " + self.movies[indexPath.row].language
                movieListCell.thumbnail.load(url: URL(string: self.movies[indexPath.row].poster) ?? URL(fileURLWithPath: ""))
                movieListCell.year.text = "Year: " + self.movies[indexPath.row].year
                return movieListCell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let section = MovieDataList(rawValue: section) {
            return section.title
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.isSearching {
            let destinationVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController
            destinationVC?.movie = self.filteredData[indexPath.row]
            self.navigationController?.pushViewController(destinationVC!, animated: true)
        } else if let section = MovieDataList(rawValue: indexPath.section) {
            switch section {
            case .year:
                let movieYear = self.movies.filter({$0.year.contains(self.year[indexPath.row])})
                self.loadMovieList(movieYear)
            case .genre:
                let genreMovie = self.movies.filter({$0.genre.contains(self.genre[indexPath.row])})
                self.loadMovieList(genreMovie)
            case .directors:
                let directorMovie = self.movies.filter({$0.director.contains(self.directors[indexPath.row])})
                self.loadMovieList(directorMovie)
            case .actors:
                let actorMovie = self.movies.filter({$0.actors.contains(self.actors[indexPath.row])})
                self.loadMovieList(actorMovie)
            case .allMovies:
                let destinationVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController
                destinationVC?.movie = self.movies[indexPath.row]
                self.navigationController?.pushViewController(destinationVC!, animated: true)
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 4 {
//            return 200
//        }
//        return 50
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle(MovieDataList(rawValue: section)?.title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        
        return button
    }
    
    @objc func handleExpandClose(button: UIButton) {
        if let section = MovieDataList(rawValue: button.tag) {
            switch section {
            case .year:
                var indexPaths = [IndexPath]()
                for row in self.year.indices {
                    let indexPath = IndexPath(row: row, section: button.tag)
                    indexPaths.append(indexPath)
                }
                
                let isExpanded = self.yearExpanded
                self.yearExpanded = !isExpanded
                
                if isExpanded {
                    self.tableView.deleteRows(at: indexPaths, with: .fade)
                } else {
                    self.tableView.insertRows(at: indexPaths, with: .fade)
                }
            case .genre:
                var indexPaths = [IndexPath]()
                for row in self.genre.indices {
                    let indexPath = IndexPath(row: row, section: button.tag)
                    indexPaths.append(indexPath)
                }
                
                let isExpanded = self.genreExpanded
                self.genreExpanded = !isExpanded
                
                if isExpanded {
                    self.tableView.deleteRows(at: indexPaths, with: .fade)
                } else {
                    self.tableView.insertRows(at: indexPaths, with: .fade)
                }
            case .directors:
                var indexPaths = [IndexPath]()
                for row in self.directors.indices {
                    let indexPath = IndexPath(row: row, section: button.tag)
                    indexPaths.append(indexPath)
                }
                
                let isExpanded = self.directorsExpanded
                self.directorsExpanded = !isExpanded
                
                if isExpanded {
                    self.tableView.deleteRows(at: indexPaths, with: .fade)
                } else {
                    self.tableView.insertRows(at: indexPaths, with: .fade)
                }
            case .actors:
                var indexPaths = [IndexPath]()
                for row in self.actors.indices {
                    let indexPath = IndexPath(row: row, section: button.tag)
                    indexPaths.append(indexPath)
                }
                
                let isExpanded = self.actorsExpanded
                self.actorsExpanded = !isExpanded
                
                if isExpanded {
                    self.tableView.deleteRows(at: indexPaths, with: .fade)
                } else {
                    self.tableView.insertRows(at: indexPaths, with: .fade)
                }
            case .allMovies:
                var indexPaths = [IndexPath]()
                for row in self.movies.indices {
                    let indexPath = IndexPath(row: row, section: button.tag)
                    indexPaths.append(indexPath)
                }
                
                let isExpanded = self.allmoviesExpanded
                self.allmoviesExpanded = !isExpanded
                
                if isExpanded {
                    self.tableView.deleteRows(at: indexPaths, with: .fade)
                } else {
                    self.tableView.insertRows(at: indexPaths, with: .fade)
                }
            }
        }
    }
    
    func loadMovieList(_ data: [Movie]) {
        let destinationVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieListViewController") as? MovieListViewController
        destinationVC?.movies = data
        self.navigationController?.pushViewController(destinationVC!, animated: true)
    }
}
