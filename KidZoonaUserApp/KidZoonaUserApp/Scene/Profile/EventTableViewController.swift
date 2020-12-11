//
//  EventTableViewController.swift
//  KidZoonaUserApp
//
//  Created by Marina Sameh on 6/6/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EventTableViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var name: NSArray = []
    var imgArr: NSArray = []
    var academyName: NSArray = []
    var date: NSArray = []
    
    var eventArr = [String]()
    var allEventKeys = [String]()
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getEventKeys()
    }
    
    fileprivate func getEventKeys (){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("User").child(uid).child("enrollment").child("event").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // guard let userDic = snapshot.value as? [String:Any] else {return}
            snapshot.children.forEach { (data) in
                let snap = data as! DataSnapshot
                let dict = snap.value as! [String: Any]
                let eventId = dict["eventId"] as? String
                //  print("eventId \(eventId)")
                self.eventArr.append(eventId ?? "nil")
                self.tableView.reloadData()
            }
            self.retriveDataFromAcadmeies()
            
            
        }) { (err) in
            print("Failed to fetch user post", err)
        }
    }
    

    fileprivate func retriveDataFromAcadmeies(){
        
        Database.database().reference().child("Academies").observe(.childAdded, with: { (snapshot) in
            snapshot.children.forEach { (data) in
                let snap = data as! DataSnapshot
                //  print(snap.key)
                
                if "\(snap.key)" == "Events"{
                    // print("found")
                    snap.children.forEach { (data2) in
                        let snap2 = data2 as! DataSnapshot
                        guard  let dict = snap2.value as? [String: Any] else {return}
                        //  print(snap2.key)
                        // print(self.eventArr)
                        for id in self.eventArr{
                            
                            if "\(snap2.key)" == id {
                                // print("is equel")
                                let event = Event(dictionary: dict)
                                self.events.append(event)
                                self.tableView.reloadData()
                                print("Event name: \(event.name)")
                            }
                        }
                    }
                }
                
            }
            
        }) { (err) in
            print("failed to fetch data envnt", err)
        }
        
    }
    
    //    fileprivate func retriveDataFromAcadmeies(){
    //
    //
    //        let ref = Database.database().reference().child("Academies")
    //        ref.observe( .value, with: {  snapshot in
    //            if let academiesList = snapshot.value as? [String : Any]{
    //                let academiesIds = academiesList.keys
    //                  print("AllKey\(academiesIds)")
    
    
    
    //                var eventss = [String]()
    
    
    //                for id in academiesIds{
    //                    guard let academyUid = academiesList[id] as? [String : Any] else {return}
    //                    guard let event  = (academyUid["Events"] as? [String : Any]) else {return}
    //
    //
    //                    guard let dataOfEverRegKeys = event["-M9ViRD41KfXjQifjTUC"] as? [String : Any] else {
    //                        print("Fy error u 7mora")
    //                        return}
    //
    //                    print("ya rab tb2a hia de : \(dataOfEverRegKeys)")
    
    //                    let eventX = Event(dictionary: dataOfEverRegKeys)
    //                    print("eventName \(eventX.name)")
    
    
    
    
    //                    print("EventZeftID: \(self.eventArr)")
    
    
    //                    let ev =  event?.keys
    //
    //                    for i in ev!{
    //                       eventss.append(i)
    //                    }
    
    //                    for key in self.eventArr{
    //                        print("my Keys: \(key)")
    //                        guard let dataOfEverRegKeys = event[key] as? [String : Any] else {
    //                            print("Fy error u 7mor")
    //                            return}
    //                        print("ya rab tb2a hia de : \(dataOfEverRegKeys)")
    //                        let event = Event(dictionary: dataOfEverRegKeys)
    //                        print("eventName \(event.name)")
    //
    //                    }
    
    // print("eventttttt : \(event?.keys)")
    
    //-M9ViRD41KfXjQifjTUC
    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    //                        for index in self.eventArr{
    //                           // print("Auto ID: \(index)")
    ////                            guard  let evntAuto  = event[] as? [String : Any] else {return}
    ////                            print("AutoIDData: \(evntAuto)")
    //                        }
    //
    //
    ////                        guard  let evntAuto  = event["-M9Vj0kJpfUXrW18RZVt"] as? [String : Any] else {return}
    ////                        print("AutoIDData: \(evntAuto)")
    //                    }
    
    
    //                    let eventsKey = event.keys
    //                    for key in eventsKey{
    //                        self.allEventKeys.append(key)
    //                    }
    
    //   print("all Key of Events: \(self.allEventKeys)")
    
    //event?["key"] = id  // Hena mask IDs kol Academy lw7dha
    //var event = Event(dictionary: information!) // hena d5lt goa el event root eli t7t kol academy
    //print("event key : \(event?.keys)") // hena mska kol el IDs bt3t el events bs kol events for one academy in one array
    
    
    
    
    
    //           }
    
    
    
    
    
    //                    print("EventV3 \(eventss)")
    //                    print("EventV4: \(self.eventArr)")
    
    //                    for i in eventss{
    //                        for j in self.eventArr{
    //                            if i == j {
    //                                print("yess \(i)")
    //                                let dataOfEverRegKeys = event?[i]
    //                                print("ya rab tb2a hia de : \(dataOfEverRegKeys)")
    //
    //                            }
    //                        }
    //                    }
    
    
    
    //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    //                    print("eventArr  :  \(self.eventArr.count)")
    //                    print("eventArr  :  \(self.eventArr)")
    //                }
    //            }
    //
    //        })
    
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventSegmentTableViewCell
        
        // cell.eventImg.image = imgArr[indexPath.row] as! UIImage
        cell.eventName.text! = events[indexPath.row].name
        cell.eventDate.text!  = events[indexPath.row].date
        
        let imagUrl = events[indexPath.row].image
        
        cell.eventImg?.sd_setImage(with: URL(string: imagUrl)!, placeholderImage: UIImage(named: "course4"))
        
        
        //  cell.academyName.text! = eventArr[indexPath.row]
        //  cell.eventDate.text! = date[indexPath.row] as! String
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("event Key: \(eventArr[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109
    }
    
}
