

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class PostViewController: UIViewController {
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func handlePostButton(sender: UIButton) {
        let postRef = FIRDatabase.database().reference().child(CommonConst.PostPATH)
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)

        let ud = NSUserDefaults.standardUserDefaults()
        let name = ud.objectForKey(CommonConst.DisplayNameKey) as! String
        
        let time = NSDate.timeIntervalSinceReferenceDate()
        
        let postData = ["caption": textField.text!, "image": imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength), "name": name, "time": time]
        postRef.childByAutoId().setValue(postData)
        
        SVProgressHUD.showSuccessWithStatus("投稿しました")
        
         UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func handleCancelButton(sender: AnyObject) {
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

    
}
