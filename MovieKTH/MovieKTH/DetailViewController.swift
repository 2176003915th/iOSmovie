//
//  DetailViewController.swift
//  MovieKTH
//
//  Created by Induk-cs  on 2024/06/05.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var movieName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movieName
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //다른 뷰로 값넘김
        let dest = segue.destination as! MyPlatViewController
//        print(row)
        dest.movieName2 = navigationItem.title!
        
        if segue.identifier == "namuwiki" {
                    dest.buttonId = "https://namu.wiki/w/"
                } else if segue.identifier == "naver" {
                    dest.buttonId = "https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=1&ie=utf8&query="
                } else if segue.identifier == "youtube" {
                    dest.buttonId =
                    "https://www.youtube.com/results?search_query="
                }
    
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
