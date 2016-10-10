

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if FIRAuth.auth()?.currentUser != nil {
            if observing == false {
                FIRDatabase.database().reference().child(CommonConst.PostPATH).observeEventType(.ChildAdded, withBlock: { snapshot in
                    if let uid = FIRAuth.auth()?.currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        self.postArray.insert(postData, atIndex: 0)
                    
                        self.tableView.reloadData()
                    }
                })
                
                FIRDatabase.database().reference().child(CommonConst.PostPATH).observeEventType(.ChildChanged, withBlock: { snapshot in
                    if let uid = FIRAuth.auth()?.currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        var index: Int = 0
                        for post in self.postArray {
                            if post.id == postData.id {
                                index = self.postArray.indexOf(post)!
                                break
                            }
                        }
                        self.postArray.removeAtIndex(index)
            
                        self.postArray.insert(postData, atIndex: index)
                        
                        self.tableView.reloadData()
                    }
                })
                
                observing = true
            }
        } else {
            if observing == true {
                
                postArray = []
                
                tableView.reloadData()
                
                FIRDatabase.database().reference().removeAllObservers()
                
                observing = false
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:event:)), forControlEvents:  UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func handleButton(sender: UIButton, event:UIEvent) {
        
        
        let touch = event.allTouches()?.first
        let point = touch!.locationInView(self.tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        //数ある中から選ぶ
        let postData = postArray[indexPath!.row]
        
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            if postData.isLiked {
                var index = -1
                for likeId in postData.likes {
                    if likeId == uid {
                        index = postData.likes.indexOf(likeId)!
                        break
                    }
                }
                postData.likes.removeAtIndex(index)
            } else {
                postData.likes.append(uid)
            }
            
            let imageString = postData.imageString
            let name = postData.name
            let caption = postData.caption
            let time = (postData.date?.timeIntervalSinceReferenceDate)! as NSTimeInterval
            let likes = postData.likes
            
            let post = ["caption": caption!, "image": imageString!, "name": name!, "time": time, "likes": likes]
            let postRef = FIRDatabase.database().reference().child(CommonConst.PostPATH)
            postRef.child(postData.id!).setValue(post)
             //辞書を作成してFirebaseに保存する どこで古いの消した？FireBaseの性質上しなくても良いらしい
        }
    }

}
