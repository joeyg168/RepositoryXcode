//
//  DetailMovieViewController.swift
//  Movies
//
//  Created by Joseph Garcia on 8/7/19.
//  Copyright © 2019 Joseph Garcia. All rights reserved.
//

import UIKit

class DetailMovieViewController: UIViewController {
    @IBOutlet weak var labelTitleMovie: UILabel!
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var LabelOriginalTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelRelaseDate: UILabel!
    
    var imagePost = Data()
    var URLImage = String()
    var textTitle = String()
    var textOriginalTitle = String()
    var textDescription = String()
    var textRating = Double()
    var textRelaseDate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.imagePoster.image = UIImage(data: self.imagePost)
        }
        labelTitleMovie.text = textTitle
        LabelOriginalTitle.text = textOriginalTitle
        labelDescription.text = textDescription
        labelRating.text = "Rating:\(textRating)"
        labelRelaseDate.text = textRelaseDate
        // Do any additional setup after loading the view.
        
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
