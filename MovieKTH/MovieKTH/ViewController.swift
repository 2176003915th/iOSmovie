//
//  ViewController.swift
//  MovieKTH
//
//  Created by Induk-cs  on 2024/06/05.
//

import UIKit

struct MovieData : Codable {
    let boxOfficeResult : BoxOfficeResult
}
struct BoxOfficeResult : Codable {
    let dailyBoxOfficeList : [DailyBoxOfficeList]
}
struct DailyBoxOfficeList : Codable {
    let movieNm : String
    let audiCnt : String
    let audiAcc : String
    let rank : String
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
        

    @IBOutlet weak var table: UITableView!
    
    var movieData : MovieData?
    
    var movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=c900fb4e24f236c592753d60e2ccca5b&targetDt="
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        movieURL += makeYesterdayString()
        getData()
    }
    
    func makeYesterdayString() -> String {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.day = -1 // 어제 날짜를 얻기 위해 -1을 사용합니다.
        
        if let yesterday = Calendar.current.date(byAdding: dateComponents, to: currentDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd" // "년도 4자리, 월 2자리, 일 2자리" 형식으로 설정합니다.
            return dateFormatter.string(from: yesterday)
        } else {
            return "날짜 계산 실패"
        }
    }
    
    func getData() {
        guard let url = URL(string: movieURL) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            guard let JSONdata = data else { return }
//            let dataString = String(data: JSONdata, encoding: .utf8)
//            print(dataString!)
            let decode = JSONDecoder()
            do {
                let decodedData  = try decode.decode(MovieData.self, from: JSONdata)
                print(decodedData.boxOfficeResult.dailyBoxOfficeList[0].movieNm)
                self.movieData = decodedData
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as!
        MyTableViewCell
        
        guard let mRank = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].rank
        else { return UITableViewCell() }
        guard let mName = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        else { return UITableViewCell() }
        cell.movieName.text = "[\(mRank)위] \(mName)"
        
        if let aAcc = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiAcc {
                   let numF = NumberFormatter()
                   numF.numberStyle = .decimal
                   let aAcc1 = Int(aAcc)!
                   let result = numF.string(for: aAcc1)!+"명"
                   cell.audiAccumulate.text = "누적 : \(result)"
                   //cell.audiCount.text = "어제:\(aCnt)명"
               }
        
        if let aCnt = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiCnt {
                   let numF = NumberFormatter()
                   numF.numberStyle = .decimal
                   let aCnt1 = Int(aCnt)!
                   let result2 = numF.string(for: aCnt1)!+"명"
                   cell.audiCount.text = "어제 : \(result2)"
                   //cell.audiCount.text = "어제:\(aCnt)명"
               }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //다른 뷰로 값넘김
        let dest = segue.destination as! DetailViewController
        let myIndexPath = table.indexPathForSelectedRow!
        let row = myIndexPath.row
//        print(row)
        dest.movieName =
        (movieData?.boxOfficeResult.dailyBoxOfficeList[row].movieNm)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "🍿박스오피스(영화진흥위원회제공:"+makeYesterdayString()+")🍿"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "🥺By TaeHyung Kim"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { //출력하는걸 몇번 반복
        return 1
    }

}

