import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var manager = CMMotionManager()
    var ballView : STBallView?
    @IBOutlet weak var playground: UIView!
    @IBOutlet weak var timeDisplay: UILabel!
    
    var seconds = 0
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ballView = STBallView.init(frame: playground.bounds)
        
        playBall()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func bye() {
        dismiss(animated: true, completion: nil)
    }
    
    private func playBall() {
        runTimer()
        
        ballView!.backgroundColor = UIColor.clear
        self.playground.addSubview(ballView!)
        
        manager.deviceMotionUpdateInterval = 1 / 60
        
        manager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
            
            self.ballView!.accelleration = (motion?.gravity)!
            
            self.ballView!.jump = (motion?.userAcceleration)!
    
            DispatchQueue.main.async {
               
                
                self.ballView!.updateLocation(multiplier: 1000)
                
                if ((self.ballView!.currentPoint.x < self.ballView!.bounds.maxX)&&(self.ballView!.currentPoint.x > self.ballView!.bounds.maxX - 20)&&(self.ballView!.currentPoint.y < self.ballView!.bounds.maxY)&&(self.ballView!.currentPoint.y > self.ballView!.bounds.maxY - 20)) {
                    
                    self.timer.invalidate()
                    
                    //TODO: pass end time
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scoreDisplay")

                    
                    vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    self.present(vc, animated: true, completion: nil)
                    
                    self.manager.stopDeviceMotionUpdates()
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
