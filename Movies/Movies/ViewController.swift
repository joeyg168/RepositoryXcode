//
//  ViewController.swift
//  Movies
//
//  Created by Joseph Garcia on 8/6/19.
//  Copyright © 2019 Joseph Garcia. All rights reserved.
//

import UIKit

/** Structures to save the data from Json */
struct JsonFirstPart: Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [resultsMovies]
}

struct resultsMovies: Decodable {
    
    let vote_count: Int
    let id: Int
    let video: Bool
    let vote_average: Double
    let title: String
    let popularity: Double
    let poster_path: String
    let original_language: String
    let original_title: String
    let genre_ids: [Int]
    let backdrop_path: String
    let adult: Bool
    let overview: String
    let release_date: String
    
}




class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableMovies: UITableView!
    
    var dataMov = [resultsMovies]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let flagFirstCharge = UserDefaults.standard.bool(forKey: "firstCharge")
        /** Validation for service or cache */
        if flagFirstCharge == true {
            let data = UserDefaults.standard.object(forKey: "dataStorage") as! Data
            self.tableMovies.delegate = self
            self.tableMovies.dataSource = self
            do {
                /** Put all the data from json to the structures */
                let infoJson = try JSONDecoder().decode(JsonFirstPart.self, from: data)
                self.dataMov = infoJson.results
             
            } catch let jsonErr {
                print("Error serializing info in cache:", jsonErr)
            }
            DispatchQueue.main.async {
                self.tableMovies.reloadData()
            }
           
           
        } else {
            let i = 1
            UserDefaults.standard.set(i, forKey: "page")
            parseJSONtoStruct()
        }
        
        
        
        /** NotificationCenter detect when is another day and call the function */
        NotificationCenter.default.addObserver(self, selector:#selector(anotherDay), name:.NSCalendarDayChanged, object:nil)
        tableMovies.rowHeight = 180
        // Do any additional setup after loading the view, typically from a nib.
    
    }
    
    /** Function to change the flag and call the service again */
    @objc func anotherDay() {
        DispatchQueue.main.async{
            UserDefaults.standard.set(false, forKey: "firstCharge")
            var page = UserDefaults.standard.integer(forKey: "page")
            UserDefaults.standard.set(page += 1, forKey: "page")
        }
        
    }
    
    /** Fuction to print the number of elements in the table */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataMov.count
    }
    
    /** Fuction to print the data form de json in the table */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoviesTableViewCell
        
        cell.labelTitleMovie.text = dataMov[indexPath.row].title
       
        let url = URL(string: "https://image.tmdb.org/t/p/original" + dataMov[indexPath.row].poster_path)
        
      
            do {
                let data = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.imageMovie.image = UIImage(data: data)
                }
            } catch let errImg {
                print("Error in Image:", errImg)
            }
           
            
        
        
        cell.relaseDateLabel.text = "Estreno: " +
            dataMov[indexPath.row].release_date
        
        return cell
    }
    
    /** Pass data to the DetailMoviesViewController */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail" {
            let vc : DetailMovieViewController = segue.destination as! DetailMovieViewController
            let selectedRow = tableMovies.indexPathForSelectedRow?.row
            vc.textTitle = dataMov[selectedRow!].title
            vc.textOriginalTitle = dataMov[selectedRow!].original_title
            vc.textDescription = dataMov[selectedRow!].overview
            vc.textRating = dataMov[selectedRow!].popularity
            vc.textRelaseDate = dataMov[selectedRow!].release_date
            
            let url = URL(string: "https://image.tmdb.org/t/p/original" + dataMov[selectedRow!].poster_path)
            
            do {
                let data = try Data(contentsOf: url!)
                vc.imagePost = data
            } catch let errImg {
                print("Error in Image:", errImg)
            }
            
          
        }
       
    }
    
    
    
    
    
    /** Service call */
    func parseJSONtoStruct() {
        let page = UserDefaults.standard.integer(forKey: "page")
        print(page)
        let jsonUrlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=0d63b4e6799acc6015be636e6cc36217&language=es-Mx&page=2"
        let url = URL(string: jsonUrlString)
        
        self.tableMovies.delegate = self
        self.tableMovies.dataSource = self
        
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            let data = data
            
            
            do {
                /** Put all the data from json to the structures */
                let infoJson = try JSONDecoder().decode(JsonFirstPart.self, from: data!)
                
                UserDefaults.standard.set(data!, forKey: "dataStorage")
                self.dataMov = infoJson.results
                
                /** Flag for the cache */
                UserDefaults.standard.set(true, forKey: "firstCharge")
                
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
            /** Reload table when the service finish */
            DispatchQueue.main.async {
                self.tableMovies.reloadData()
            }
            
            }.resume()
        
       
        
    }


}

