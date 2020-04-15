//
//  MovieDetail.swift
//  Movie App Final
//
//  Created by Awatef Ahmed on 1/4/20.
//  Copyright © 2020 Mostafa Samir. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData
class MovieDetail: UIViewController {

    //var obj:JsonModel!
    
   
    @IBOutlet weak var mywebview: UIWebView!
    var movArrJson = [Dictionary<String ,Any>]()
    var movArrDataPresent :NSManagedObject?
    var movArrJsonPresent :Dictionary<String ,Any>?
    
    var path="http://image.tmdb.org/t/p/w185/"
    
    @IBOutlet weak var titlelbl: UILabel!
    
    @IBOutlet weak var imagelbl: UIImageView!
    
    @IBOutlet weak var yearlbl: UILabel!
    
    @IBOutlet weak var overviewlbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if movArrJsonPresent != nil
        {
            titlelbl.text = movArrJsonPresent?["title"] as? String
            imagelbl.sd_setImage(with: URL(string: path+(movArrJsonPresent?["poster_path"] as? String)!), placeholderImage: UIImage(named: "p.png"))
          //  yearlbl.text = Date(string:movArrJsonPresent?["release_data"] as! String)
            overviewlbl.text = movArrJsonPresent?["overview"] as? String
            let url=URL(string: "https://api.themoviedb.org/3/movie/id/videos?api_key=fd330a4e763617bb7d8c0816d9d8dab6&language=en-US")
            let request=URLRequest(url: url!)
            print("Key")
            getVideo(videoCode: "key")
            
            
        }else
        {
           
            
            imagelbl.sd_setImage(with: URL(string: (movArrJsonPresent?["poster_path"] as? String)! ), placeholderImage: UIImage(named: "p.png"))
            
        }
        
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getVideo(videoCode:String){
        let url=URL(string:"https://www.youtube.com/embeded/\(videoCode)")
        mywebview.loadRequest(URLRequest(url: url!))
    }
    
    func Request(urlPath:String){
        
            let appDelegate=UIApplication.shared.delegate as!AppDelegate
            let contextview=appDelegate.persistentContainer.viewContext
            
            let url=URL(string: urlPath)
            let request=URLRequest(url: url!)
            let session=URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: request){ (data, response, error) in
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! Dictionary<String ,Any>
                    
                    if let arr =  json["results"] as? NSArray
                    {
                        self.movArrJson=[]
                        for i in 0..<arr.count
                        {
                            if let film = arr[i] as? Dictionary<String,Any>
                            {
                                self.movArrJson.append(film)
                            }}}}}}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
