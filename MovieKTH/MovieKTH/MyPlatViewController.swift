//
//  MyPlatViewController.swift
//  MovieKTH
//
//  Created by Induk-cs  on 2024/06/05.
//

import UIKit
import WebKit

class MyPlatViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var movieName2 = ""
    var buttonId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movieName2
        // Do any additional setup after loading the view.
        
        let urlKorString = buttonId + movieName2
        print(urlKorString)
        let urlString = urlKorString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
  


}
