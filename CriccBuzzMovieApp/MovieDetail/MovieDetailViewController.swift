//
//  MovieDetailViewController.swift
//  CriccBuzzMovieApp
//
//  Created by Samreen Thabassum on 30/07/24.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var plot: UILabel!
    @IBOutlet weak var cast: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var movie: Movie?
    let slider = UISlider()
    var ratingArray: [Rating]?
    var ratingKeys: [String]?
    var ratingValues: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateData()
    }
    
    func updateData() {
        if let movie = self.movie {
            self.cast.text = "Cast & Crew: " + movie.actors
            self.thumbnail.load(url: URL(string: movie.poster) ?? URL(fileURLWithPath: ""))
            self.movieTitle.text = "Title: " + movie.title
            self.plot.text = "Plot: " + movie.plot
            self.releaseDate.text = "Release Date: " + movie.released
            self.rating.text = "Choose Rating: "
            self.genre.text = "Genre: " + movie.genre
            
            self.ratingArray = self.movie.map({$0.ratings})
            
            self.ratingKeys = self.ratingArray?.map({$0.source}).sorted()
            self.ratingKeys?.append("Imdb")
            self.ratingKeys?.sort()
            
            let sortedArr = self.ratingArray?.sorted(by: {$0.source < $1.source })
            self.ratingValues = sortedArr?.map({$0.value})
            let segmentedControl = UISegmentedControl(items: self.ratingKeys)
            
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
            
            // Configure the slider
            slider.minimumValue = 0
            slider.maximumValue = 10
            slider.value = Float(movie.imdbRating) ?? 0
        
            self.stackView.addArrangedSubview(segmentedControl)
            self.stackView.addArrangedSubview(slider)
        }
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        
        let selected = RatingSites(rawValue: sender.selectedSegmentIndex)

        switch selected {
        case .imdb:
            slider.minimumValue = 0
            slider.maximumValue = 10
            slider.value = Float(self.movie?.imdbRating ?? "0") ?? 0
            self.rating.text = "Imdb: " + String(slider.value)
        case .internetMovieDb:
            slider.minimumValue = 0
            slider.maximumValue = 10
            let sliderValue = self.ratingValues?[0].split(separator: "/").first
            slider.value = Float(sliderValue ?? "0") ?? 0
            self.rating.text = "InternetMovieDb: " + String(slider.value)
        case .metacritic:
            slider.minimumValue = 0
            slider.maximumValue = 100
            // Metacritic is not there
            if self.ratingValues?.count ?? 3 < 3 {
                let sliderValue = self.ratingValues?[1].split(separator: "%").first
                slider.value = Float(sliderValue ?? "0") ?? 0
                self.rating.text = "Rotten tomatoes: " + (self.ratingValues?[1] ?? "")
            } else {
                let sliderValue = self.ratingValues?[1].split(separator: "/").first
                slider.value = Float(sliderValue ?? "0") ?? 0
                self.rating.text = "Metacritic: " + String(slider.value)
            }
        case .rottenTomatoes:
            slider.minimumValue = 0
            slider.maximumValue = 100
            let sliderValue = self.ratingValues?[2].split(separator: "%").first
            slider.value = Float(sliderValue ?? "0") ?? 0
            self.rating.text = "Rotten tomatoes: " + (self.ratingValues?[2] ?? "")
        case .none:
            break
        }
    }
}
