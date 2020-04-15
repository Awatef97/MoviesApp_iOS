//
//  Home.swift
//  Movie App Final
//
//  Created by Awatef Ahmed on 1/3/20.
//  Copyright © 2020 Mostafa Samir. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage
import BTNavigationDropdownMenu
class Home: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var collectionview: UICollectionView!
    
    var movArrData = [NSManagedObject]()
    var movArrJson = [Dictionary<String ,Any>]()
    
    var flag = 0
    var count = 0
    var index = 0
    var path="http://image.tmdb.org/t/p/w185/"
    var menuView:BTNavigationDropdownMenu!
    let items=["highest rated","most Popular"];
    override func viewDidLoad() {
         super.viewDidLoad()
        menuView=BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title("Dropdown Menu"), items: items)
        self.navigationItem.titleView = menuView
        
        
       

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        Request(urlPath:  "https://api.themoviedb.org/3/discover/movie?api_key=fd330a4e763617bb7d8c0816d9d8dab6&language=en-US&page=1")
        self.collectionview.reloadData()
        
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            if(indexPath==0)
            {
                self?.Request(urlPath: "https://api.themoviedb.org/3/discover/movie?sort_by=vote_count.desc&api_key=fd330a4e763617bb7d8c0816d9d8dab6&language=en-US&page=1")
                self?.collectionview.reloadData()
            }
                
            else{
                self!.Request(urlPath: "https://api.themoviedb.org/3/discover/movie?api_key=fd330a4e763617bb7d8c0816d9d8dab6&language=en-US&page=1")
                self?.collectionview.reloadData()
                
            }
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if flag == 0
        {
            count = movArrJson.count
        }
        else if flag == 1
        {
            count = movArrData.count
        }
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MovieCell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCell
        if flag == 0
        {
            
            
             cell.image?.sd_setImage(with: URL(string: path+(movArrJson[indexPath.row]["poster_path"] as? String)!), placeholderImage: UIImage(named: "p.png"))
        
        }
        else if flag == 1
        {
            //cell.label.text = movArrData[indexPath.row].value(forKey: "title") as? String
            cell.image?.sd_setImage(with: URL(string: path+(movArrData[indexPath.row].value(forKey: "image") as? String)!), placeholderImage: UIImage(named: "p.png"))
        }
        
       
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) 
    {
        
        index = indexPath.row
        performSegue(withIdentifier: "nextpage", sender:nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let des = segue.destination as! MovieDetail
        if segue.identifier == "nextpage"
        {
            if flag == 0
            {
                des.movArrJsonPresent = movArrJson[index]
            }
            else if flag == 1
            {
                des.movArrDataPresent = movArrData[index]
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        return CGSize(width: width/2, height: height/2)
    }
    
    func Request(urlPath:String){
        if Reachability.isConnectedToNetwork()==true{
            flag=0
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
                            }
//                            let entity=NSEntityDescription.entity(forEntityName: "Movies", in: contextview)
//                            let movie1 = NSManagedObject(entity: entity!, insertInto: contextview)
//
//                            movie1.setValue(i["title"] as! String, forKey:"title")
//                            movie1.setValue(i["overview"]as! String, forKey: "overview")
//                            movie1.setValue(i["release_date"]as! Int32, forKey: "releaseyear")
//                            movie1.setValue(i["vote_average"]as! Double, forKey: "rate")
//                            movie1.setValue(i["poster_path"]as! String, forKey: "image")
//                                                    self.movArrData.append(movie1)
                            
                        }
                    }
                    
                    
                    
                    
                    
                    DispatchQueue.main.async
                        {
                            self.collectionview.reloadData()
                            print(self.movArrJson.count)
                    }
                }
                catch
                {
                    print("eror incatch of json")
                }
            }
            task.resume()
        }
        else
        {
            flag = 1
            let appDelegation = UIApplication.shared.delegate as! AppDelegate
            let contextview = appDelegation.persistentContainer.viewContext
            
            
            let fetching = NSFetchRequest<NSManagedObject>(entityName: "Movies")
            do
            {
                let fetch = try contextview.fetch(fetching)
                movArrData = fetch
            }
            catch
            {
                print("Error")
            }
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
