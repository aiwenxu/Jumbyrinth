import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var levelNumber: Int = 0
    
    var manager = CMMotionManager()
    
    var set = false
    
    var ballView : STBallView?
    var sunView : SunMoonView?

    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var sun: UIView!
    @IBOutlet weak var playground: UIView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet var colorvie: ColorfulView!
    
    var seconds : Int = 0
    var timer = Timer()
    
    override func viewDidLoad() {
        
        colorvie.runUpdateTimer()
        
        if levelNumber == 6 {
            levelLabel.text = "Level X"
        }
        else {
            levelLabel.text = String(format: "Level %d", levelNumber)
        }
        
        seconds = 0
        self.view.alpha = 1
        
        super.viewDidLoad()
        
        if (!set) {
            ballView = STBallView.init(frame: playground.bounds, levelNumber: levelNumber)
            sunView = SunMoonView.init(frame: sun.bounds)
            set = true
        }
        playBall()
    }
    
    @IBAction func pausePushed(_ sender: Any) {
        
        self.view.alpha = 0.5
        self.manager.stopDeviceMotionUpdates()
        self.timer.invalidate()
        self.ballView?.pause = true
        print(self.ballView?.currentPoint as Any)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func bye() {
        dismiss(animated: true, completion: nil)
    }
    
    public func playBall() {
        runTimer()
        ballView!.backgroundColor = UIColor.clear
        self.playground.addSubview(ballView!)
        self.sun.addSubview(sunView!)
        
        manager.deviceMotionUpdateInterval = 1 / 24
        
        manager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
            
            self.ballView!.accelleration = (motion?.gravity)!
            
            self.ballView!.jump = (motion?.userAcceleration)!
    
            DispatchQueue.main.async {
               
                
                self.ballView!.updateLocation(multiplier: 1000)
                
                if ((self.ballView!.currentPoint.x < self.ballView!.bounds.maxX)&&(self.ballView!.currentPoint.x > self.ballView!.bounds.maxX - 20)&&(self.ballView!.currentPoint.y < self.ballView!.bounds.maxY)&&(self.ballView!.currentPoint.y > self.ballView!.bounds.maxY - 20)) {
                        self.manager.stopDeviceMotionUpdates()
                        self.timer.invalidate()
                    
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scoreDisplay") as! PopUpViewController

                        self.view.alpha = 0.3
                        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        self.present(vc, animated: true, completion: nil)
                    
                        vc.time.text = self.timeDisplay.text!
                        self.ballView?.pause = true
                }
            }
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTimer() {
        seconds += 1
        timeDisplay.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time:TimeInterval) -> String {
        let m = Int(time) / 6000
        let s = Int(time) / 100 % 60
        let ms = Int(time) % 100
        return String(format: "%02d:%02d:%02d", m, s, ms)
    }
    
}
