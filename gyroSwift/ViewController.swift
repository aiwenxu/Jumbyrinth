import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var manager = CMMotionManager()
    var ballView : STBallView?
    @IBOutlet weak var d: UITextField!
    @IBOutlet weak var playground: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ballView = STBallView.init(frame: playground.bounds)
        playBall()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func playBall() {
        ballView!.backgroundColor = UIColor.clear
        self.playground.addSubview(ballView!)
        
        manager.deviceMotionUpdateInterval = 1 / 60
        
        manager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
            
            self.ballView!.accelleration = (motion?.gravity)!
    
            DispatchQueue.main.async {
                self.ballView!.updateLocation(multiplier: 1000)
                self.d.text = String("00:20:33");
            }
        }
        
        
    }
    
}
