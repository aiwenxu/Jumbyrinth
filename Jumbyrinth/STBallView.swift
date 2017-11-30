
import UIKit
import CoreMotion
import GameplayKit.GKRandomSource

class STBallView: UIView {

    var lastUpdateTime: Date? = nil
    var holes = [CGPoint]()
    var inhole = false
    
    var imageWidth : CGFloat = 20
    var imageHeight : CGFloat = 20
    
    var accelleration = CMAcceleration()
    var jump = CMAcceleration()
    var imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    var pause : Bool

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
            
            else if currentPoint.x >= bounds.size.width - imageWidth / 2 {
                currentPoint.x = bounds.size.width - imageWidth / 2
                ballXVelocity = -ballXVelocity * 0.5
            }
            
            else if (self.z < 0.5) {
            
                for i in 0...Int(imageWidth / 2) {
                    if (Int(currentPoint.x) + i >= Int(bounds.size.width)) {
                        break
                    }
                    if (Int(currentPoint.x) - i <= 0) {
                        break
                    }
                    
                    if self.bits[Int(currentPoint.y)][Int(currentPoint.x) + i] {
                        currentPoint.x = currentPoint.x - (imageWidth/2 - CGFloat(i))
                        ballXVelocity = min(0, -ballXVelocity * 0.5)
                        break
                    }
                    
                    if self.bits[Int(currentPoint.y)][Int(currentPoint.x) - i] {
                        currentPoint.x = currentPoint.x + (imageWidth/2 - CGFloat(i))
                        ballXVelocity = max(0, -ballXVelocity * 0.5)
                        break
                    }
                    
                }
            }
            
            if (currentPoint.y <= imageHeight / 2) {
                currentPoint.y = imageHeight / 2
                ballYVelocity = -ballYVelocity * 0.5

            }
            
            else if (currentPoint.y >= bounds.size.height - imageHeight / 2) {
                currentPoint.y = bounds.size.height - imageHeight / 2
                ballYVelocity = -ballYVelocity * 0.5
            }
            
            
            else if (self.z < 0.5) {
                for i in 0...Int(imageHeight / 2) {
                    if (Int(currentPoint.y) + i >= Int(bounds.size.height)) {
                        break
                    }
                    if (Int(currentPoint.y) - i <= 0)
                    {
                        break
                    }
            
                    if self.bits[Int(currentPoint.y) + i][Int(currentPoint.x)] {
                        currentPoint.y = currentPoint.y - (imageHeight/2 - CGFloat(i))
                        ballYVelocity = max(0, -ballYVelocity * 0.5)
                        break
                    }
                    
                    if self.bits[Int(currentPoint.y) - i][Int(currentPoint.x)] {
                        currentPoint.y = currentPoint.y + (imageHeight/2 - CGFloat(i))
                        ballYVelocity = min(0, -ballYVelocity * 0.5)
                        break
                    }
                    
                }
            }

            
            imageView.center = currentPoint
            
            var holeNum = -1
            
            var inholenow = false
            
            for i in 0...(holes.count - 1) {
                if (distance(holes[i], currentPoint) < 8) {
                    inholenow = true
                    holeNum = i
                    break
                }
            }
            
            if (inhole) {
                if (!inholenow) {
                    inhole = false
                }
            }
            else {
                if (inholenow) {
                    var d : Int
                    repeat {
                        d = Int(arc4random()) % holes.count
                        print(d)
                    } while d == holeNum
                    currentPoint = holes[d]
                    inhole = true
                }
            }
            
            imageView.center = currentPoint
        }
    }
    
    override init(frame: CGRect) {
        pause = false
        super.init(frame: frame)
        for _ in 0...(Int(frame.height) + 1) {
            var ww = [Bool]()
            for _ in 0...(Int(frame.width) + 1) {
                ww.append(false)
            }
            self.bits.append(ww)
            
        }
        
        makeMaze()
        setupUI()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeMaze() {
        drawVLine(x: 0, y: 0, length: Int(self.bounds.height))
        drawVLine(x: Int(self.bounds.width - 1), y: 0, length: Int(self.bounds.height))
        drawHLine(x: 30, y: 0, length: Int(self.bounds.width - 30))
        drawHLine(x: 0, y: Int(self.bounds.height - 1), length: Int(self.bounds.width - 30))
        
        makeRandomMaze(numOfRows: 20, numOfCols: 12)
        
        makeHoles(n: 25)
//        mazeLevel1();
    }
    
    
    //TODO: draw more mazes using the following format
    
    private func mazeLevel1() {
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
    
    private func makeRandomMaze(numOfRows: Int, numOfCols: Int) {

        var cells : [[Int]] = []
        for row in 0..<numOfRows {
            cells.append([Int]())
            for _ in 0..<numOfCols {
                cells[row].append(0)
            }
        }
        
        carvePassage(cx: 0, cy: 0, cells: &cells)
        
        let cellWidth = Int(self.bounds.width)/numOfCols
        let cellHeight = Int(self.bounds.height)/numOfRows
        for col in 0..<numOfRows {
            for row in 0..<numOfCols {
                let x = row * cellWidth
                let y = col * cellHeight
                if (cells[col][row] & 1) == 0 {
                    drawHLine(x: x, y: y, length: cellWidth)
                }
                if (cells[col][row] & 8 == 0) {
                    drawVLine(x: x, y: y, length: cellHeight)
                }
            }
        }
        
    }
    
    private func carvePassage(cx: Int, cy: Int, cells: inout [[Int]]) {
        
        let N : Int = 1
        let S : Int = 2
        let E : Int = 4
        let W : Int = 8
        let dx = [N: 0, S: 0, E: 1, W: -1]
        let dy = [N: -1, S: 1, E: 0, W: 0]
        let opposite = [N: S, S: N, E: W, W: E]
        
        let shuffledDirections : [Int] = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: [N, S, E, W]) as! [Int]
//        let shuffledDirections = [N, S, E, W]
        for direction in shuffledDirections {
            let nx = cx + dx[direction]!
            let ny = cy + dy[direction]!
            if (nx >= 0) && (nx <= cells[0].count - 1) && (ny >= 0) && (ny <= cells.count - 1) {
                if (cells[ny][nx] == 0) {
                    cells[cy][cx] |= direction
                    cells[ny][nx] |= opposite[direction]!
                    carvePassage(cx: nx, cy: ny, cells: &cells)
                }
                
            }
        }
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    func makeHoles(n : Int) {
        for _ in 1...n {
            var x : Int
            var y : Int
            repeat {
                x = Int(arc4random_uniform(UInt32(bounds.width - imageWidth))) + Int(imageWidth / 2)
                y = Int(arc4random_uniform(UInt32(bounds.height - imageHeight))) + Int(imageHeight / 2)
            } while !isValidHole(x: x, y: y)
            makeHole(x: x, y: y)
        }
    }
    
    func isValidHole(x : Int, y : Int) -> Bool {
        
        let this = CGPoint(x: CGFloat(x), y: CGFloat(y))
        
        if (distance(this, CGPoint(x: imageWidth/2, y: imageHeight/2)) <= 20) {
            return false;
        }
        
        if (distance(this, CGPoint(x: self.bounds.width - imageWidth/2, y: self.bounds.height - imageHeight/2)) <= 20) {
            return false;
        }
        
        for h in holes {
            if (distance(this, h) <= 20) {
                return false
            }
        }
        return true
    }

    private func makeHole(x: Int, y: Int) {
        let hole = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        hole.image = UIImage.init(named: "blackhole")
        addSubview(hole)
        hole.center = CGPoint(x: CGFloat(x), y: CGFloat(y))
        self.holes.append(hole.center)
    }
    
    private func drawHLine(x : Int, y : Int, length : Int) {
        let line = UIView(frame: CGRect(x: x, y: max(y - 1, 0), width: length, height: 3))
        line.backgroundColor = UIColor.gray
        self.addSubview(line)
        for i in x...x+length {
            self.bits[y][i] = true
        }
    }
    
    private func drawVLine(x : Int, y : Int, length : Int) {
        let line = UIView(frame: CGRect(x: max(0, x - 1), y: y, width: 3, height: length))
        line.backgroundColor = UIColor.gray
        self.addSubview(line)
        for i in y...y+length {
            self.bits[i][x] = true
        }
    }
    
    private func setupUI() {
        backgroundColor = UIColor.lightGray
        imageView.image = UIImage.init(named: "ball")
        imageView.contentMode = UIViewContentMode.scaleToFill
        addSubview(imageView)
        currentPoint = CGPoint(x: imageWidth/2, y: imageHeight/2)
        imageView.center = currentPoint
    }
    
    
    func updateLocation(multiplier : Double) {
        if (lastUpdateTime != nil)&&(!pause) {
            let updatePeriod : Double = Date.init().timeIntervalSince(lastUpdateTime!)
            
            if (z == 0) {
                ballXVelocity = ballXVelocity + accelleration.x * updatePeriod
                ballYVelocity = ballYVelocity + accelleration.y * updatePeriod
            }
            else {
                ballXVelocity = ballXVelocity + accelleration.x * updatePeriod * 0.3
                ballYVelocity = ballYVelocity + accelleration.y * updatePeriod * 0.3
            }
            
            
            if (ballXVelocity > 0.3) {ballXVelocity = 0.3}
            
            if (ballXVelocity < -0.3) {ballXVelocity = -0.3}
            
            if (ballYVelocity > 0.3) {ballYVelocity = 0.3}
            
            if (ballYVelocity < -0.3) {ballYVelocity = -0.3}
            
            if (self.jump.z > 0.6) {
                ballZVelovity = self.jump.z * multiplier / 400;
            }
            
            if ((z > 0)||(ballZVelovity > 0)) {
                
                imageView.frame.size.width = imageWidth * CGFloat(1 + z / 100)
                imageView.frame.size.height = imageHeight * CGFloat(1 + z / 100)
                z = z + ballZVelovity
                ballZVelovity -= 0.7
            }
            
            if (z < 0) {
                z = 0
                ballZVelovity = 0;
                imageView.frame.size.width = imageWidth
                imageView.frame.size.height = imageHeight
                
            }
            
            let coefficient = updatePeriod * multiplier
            currentPoint = CGPoint(x: currentPoint.x + (CGFloat)(ballXVelocity * coefficient), y: currentPoint.y - (CGFloat)(ballYVelocity * coefficient))
        }
        lastUpdateTime = Date()
        pause = false
    }
}


