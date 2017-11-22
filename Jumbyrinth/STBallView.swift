
import UIKit
import CoreMotion

class STBallView: UIView {

    var lastUpdateTime: Date? = nil
    
    var imageWidth : CGFloat = 20
    var imageHeight : CGFloat = 20
    
    var accelleration = CMAcceleration()
    var jump = CMAcceleration()
    var imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    

    var ballXVelocity : Double = 0
    var ballYVelocity : Double = 0
    
    var ballZVelovity : Double = 0
    
    var bits = [[Bool]]()

    var z : Double = 0

    var currentPoint = CGPoint() {
        didSet{
            
            if currentPoint.x <=  imageWidth / 2 {
              currentPoint.x = imageWidth / 2
                ballXVelocity = -ballXVelocity * 0.5
            }
            
            if currentPoint.x >= bounds.size.width - imageWidth / 2 {
                currentPoint.x = bounds.size.width - imageWidth / 2
                ballXVelocity = -ballXVelocity * 0.5
            }
            
            if (self.z < 0.5) {
            
                for i in 0...Int(imageHeight/2) {
                    if (Int(currentPoint.x) + i >= Int(bounds.size.width)) {
                        break
                    }
                    if self.bits[Int(currentPoint.y)][Int(currentPoint.x) + i] {
                        ballXVelocity = min(-0.02, -ballXVelocity * 0.5)
                        break
                    }
                    
                    if (Int(currentPoint.x) - i <= 0) {
                        break
                    }
                    if self.bits[Int(currentPoint.y)][Int(currentPoint.x) - i] {
                        ballXVelocity = max(0.02, -ballXVelocity * 0.5)
                        break
                    }
                }
            }
            
            if currentPoint.y <= imageWidth / 2 {
                currentPoint.y = imageHeight / 2
                ballYVelocity = -ballYVelocity * 0.5

            }
            
            if currentPoint.y >= bounds.size.height - imageHeight / 2 {
                currentPoint.y = bounds.size.height - imageHeight / 2
                ballYVelocity = -ballYVelocity * 0.5
            }
            
            
            if (self.z < 0.5) {
                for i in 0...Int(imageHeight/2) {
                    if (Int(currentPoint.y) + i >= Int(bounds.size.height)) {
                        break
                    }
                    if self.bits[Int(currentPoint.y) + i][Int(currentPoint.x)] {
                        ballYVelocity = max(0.02, -ballYVelocity * 0.5)
                        break
                    }

                    if (Int(currentPoint.y) - i <= 0) {
                        break
                    }
                    if self.bits[Int(currentPoint.y) - i][Int(currentPoint.x)] {
                        ballYVelocity = min(-0.02, -ballYVelocity * 0.5)
                        break
                    }
                }
            }

            
            imageView.center = currentPoint
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        for _ in 0...(Int(frame.height) + 1) {
            var ww = [Bool]()
            for _ in 0...(Int(frame.width) + 1) {
                ww.append(false)
            }
            self.bits.append(ww)
            
        }
        setupUI()
        makeMaze()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeMaze() {
        drawVLine(x: 0, y: 0, length: Int(self.bounds.height))
        drawVLine(x: Int(self.bounds.width - 1), y: 0, length: Int(self.bounds.height))
        drawHLine(x: 30, y: 0, length: Int(self.bounds.width - 30))
        drawHLine(x: 0, y: Int(self.bounds.height - 1), length: Int(self.bounds.width - 30))

        
        drawHLine(x: 90, y: 60, length: 100)
        drawVLine(x: 90, y: 60, length: 110)
        drawVLine(x: 120, y: 60, length: 140)
        drawHLine(x: 0, y: 200, length: 120)
        drawVLine(x: 30, y: 0, length: 110)
        drawHLine(x: 30, y: 110, length: 30)
        drawHLine(x: 0, y: 140, length: 60)
        drawHLine(x: 30, y: 170, length: 60)
        drawVLine(x: 190, y: 60, length: 260)
        drawVLine(x: 60, y: 0, length: 80)
        drawHLine(x: 60, y: 30, length: 160)
        drawVLine(x: 220, y: 30, length: 90)
        drawHLine(x: 190, y: 150, length: 80)
        drawVLine(x: 245, y: 0, length: 50)
        drawVLine(x: 245, y: 80, length: 70)
        drawVLine(x: 270, y: 30, length: 120)
        drawHLine(x: 190, y: 320, length: 80)
        drawHLine(x: 220, y: 180, length: 81)
        drawVLine(x: 220, y: 180, length: 110)
        drawVLine(x: 245, y: 210, length: 110)
        drawVLine(x: 270, y: 180, length: 40)
        drawVLine(x: 270, y: 245, length: 105)
        drawHLine(x: 30, y: 350, length: 240)
        drawHLine(x: 30, y: 375, length: 270)
        drawVLine(x: 30, y: 230, length: 120)
        drawHLine(x: 30, y: 230, length: 120)
        drawVLine(x: 150, y: 170, length: 150)
        drawHLine(x: 60, y: 320, length: 90)
        drawVLine(x: 60, y: 260, length: 60)
        drawHLine(x: 60, y: 260, length: 60)
        drawVLine(x: 120, y: 260, length: 30)
        drawHLine(x: 90, y: 290, length: 30)
        drawVLine(x: 150, y: 60, length: 80)
        drawHLine(x: 150, y: 280, length: 20)
        drawHLine(x: 170, y: 225, length: 20)
        drawHLine(x: 150, y: 170, length: 20)
        drawHLine(x: 150, y: 110, length: 20)
    }
    
    private func drawHLine(x : Int, y : Int, length : Int) {
        let line = UIView(frame: CGRect(x: x, y: max(y - 1, 0), width: length, height: 3))
        line.backgroundColor = UIColor.darkGray
        self.addSubview(line)
        for i in x...x+length {
            self.bits[y][i] = true
        }
    }
    
    private func drawVLine(x : Int, y : Int, length : Int) {
        let line = UIView(frame: CGRect(x: max(0, x - 1), y: y, width: 3, height: length))
        line.backgroundColor = UIColor.darkGray
        self.addSubview(line)
        for i in y...y+length {
            self.bits[i][x] = true
        }
    }
    
    private func setupUI() {
      backgroundColor = UIColor.lightGray
      imageView.image = UIImage.init(named: "ball")
        addSubview(imageView)
        
        currentPoint = CGPoint(x: imageWidth/2, y: imageHeight/2)
        imageView.center = currentPoint
    }
    
    
    func updateLocation(multiplier : Double) {
        if (lastUpdateTime != nil) {
            let updatePeriod : Double = Date.init().timeIntervalSince(lastUpdateTime!)
            
            ballXVelocity = ballXVelocity + accelleration.x * updatePeriod
            ballYVelocity = ballYVelocity + accelleration.y * updatePeriod
            if (ballXVelocity > 0.3) {ballXVelocity = 0.3}
            
            if (ballXVelocity < -0.3) {ballXVelocity = -0.3}
            
            if (ballYVelocity > 0.3) {ballYVelocity = 0.3}
            
            if (ballYVelocity < -0.3) {ballXVelocity = -0.3}
            
            if (self.jump.z > 0.6) {
                ballZVelovity = self.jump.z * multiplier / 400;
            }
            
            if ((z > 0)||(ballZVelovity > 0)) {
                
                imageView.frame.size.width = imageWidth * CGFloat(1 + z / 100)
                imageView.frame.size.height = imageHeight * CGFloat(1 + z / 100)
                z = z + ballZVelovity
                ballZVelovity -= 0.2
            }
            
            if (z < 0) {
                z = 0
                ballZVelovity = 0;
                imageView.frame.size.width = imageWidth
                imageView.frame.size.height = imageHeight
                
            }
            
//            if (accelleration.z > -0.85) {
//                imageView.image = UIImage.init(named: "ball2");
//            }
//
//            if (accelleration.z < -0.98) {
//                imageView.image = UIImage.init(named: "ball");
//            }w
            
            let coefficient = updatePeriod * multiplier
            currentPoint = CGPoint(x: currentPoint.x + (CGFloat)(ballXVelocity * coefficient), y: currentPoint.y - (CGFloat)(ballYVelocity * coefficient))
        }
        lastUpdateTime = Date()
    }
}


