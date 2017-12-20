//
//  BallView.swift
//  Jumbyrinth
//
//  Created by Shenghao Lin on 2017/11/16.
//  Copyright © 2017年 nyu.edu. All rights reserved.
//

import UIKit
import CoreMotion
import GameplayKit

// The class designed to control the ball and related motion in the actual game scene
// Also in charge of maze generation and drawing
// Part of ball movement updatelocation method referenced from: https://github.com/Stanbai/sensorDemo
class BallView: UIView {
    
    var levelNumber : Int = 0

    var lastUpdateTime: Date? = nil
    var holes = [CGPoint]()
    var inhole = false
    
    var imageWidth : CGFloat = 20
    var imageHeight : CGFloat = 20
    
    var accelleration = CMAcceleration()
    var jump = CMAcceleration()
    var imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    var pause : Bool

    var ballXV : Double = 0
    var ballYV : Double = 0
    var ballZV : Double = 0
    
    //the 2D array of boolean variable used to represent the status of each pixel on the screen: wall or empty
    var bits = [[Bool]]()

    var z : Double = 0

    // When a ball's position is updated, check if it touches any bounds in the playground
    // If so, a bounce is triggered
    var currentPoint = CGPoint() {
        didSet{
            
            //strict checks for outer bounds
            if currentPoint.x <=  imageWidth / 2 {
                currentPoint.x = imageWidth / 2
                ballXV = -ballXV * 0.5
            }
            else if currentPoint.x >= bounds.size.width - imageWidth / 2 {
                currentPoint.x = bounds.size.width - imageWidth / 2
                ballXV = -ballXV * 0.5
            }
            
            //when the ball's z parameter is less than 5, we consider its jump to be lower than the height of the wall
            //It will decect the wall around itself and make corresponding jump
                
            //horizontal bounce
            else if (self.z < 5) {
            
                for i in 0...Int(imageWidth / 2) {
                    if (Int(currentPoint.x) + i >= Int(bounds.size.width)) {
                        break
                    }
                    if (Int(currentPoint.x) - i <= 0) {
                        break
                    }
                    
                    if self.bits[Int(currentPoint.y)][Int(currentPoint.x) + i] {
                        currentPoint.x = currentPoint.x - (imageWidth/2 - CGFloat(i))
                        ballXV = min(0, -ballXV * 0.5)
                        break
                    }
                    
                    if self.bits[Int(currentPoint.y)][Int(currentPoint.x) - i] {
                        currentPoint.x = currentPoint.x + (imageWidth/2 - CGFloat(i))
                        ballXV = max(0, -ballXV * 0.5)
                        break
                    }
                    
                }
            }
            
            //strict checks for outer bounds
            if (currentPoint.y <= imageHeight / 2) {
                currentPoint.y = imageHeight / 2
                ballYV = -ballYV * 0.5

            }
            
            else if (currentPoint.y >= bounds.size.height - imageHeight / 2) {
                currentPoint.y = bounds.size.height - imageHeight / 2
                ballYV = -ballYV * 0.5
            }
            
            //verticle bounce against inner walls
            else if (self.z < 5) {
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
                        ballYV = max(0, -ballYV * 0.5)
                        break
                    }
                    
                    if self.bits[Int(currentPoint.y) - i][Int(currentPoint.x)] {
                        currentPoint.y = currentPoint.y + (imageHeight/2 - CGFloat(i))
                        ballYV = min(0, -ballYV * 0.5)
                        break
                    }
                    
                }
            }

            imageView.center = currentPoint
            
            //hole transportation
            var holeNum = -1
            var inholenow = false
            
            if (holes.count > 1) {
                for i in 0...(holes.count - 1) {
                    if (distance(holes[i], currentPoint) < 8) {
                        inholenow = true
                        holeNum = i
                        break
                    }
                }
            }
            
            //prevent inifinite transportation when in a hole
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
    
    // Make maze generation according to the level number and setup UI
    init(frame: CGRect, levelNumber: Int) {
        pause = false
        super.init(frame: frame)
        for _ in 0...(Int(frame.height) + 1) {
            var ww = [Bool]()
            for _ in 0...(Int(frame.width) + 1) {
                ww.append(false)
            }
            self.bits.append(ww)
        }
        
        makeMaze(levelNumber: levelNumber)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Method to draw mazes
    private func makeMaze(levelNumber: Int) {
        
        //draw outer bounds
        drawVLine(x: 0, y: 0, length: Int(self.bounds.height))
        drawVLine(x: Int(self.bounds.width - 1), y: 0, length: Int(self.bounds.height))
        drawHLine(x: 30, y: 0, length: Int(self.bounds.width - 30))
        drawHLine(x: 0, y: Int(self.bounds.height - 1), length: Int(self.bounds.width - 30))
        
        //fixed level 1-5
        if levelNumber == 1 {
            makeRandomMaze(numOfRows: 10, numOfCols: 7, seeded: true)
        }
        else if levelNumber == 2 {
            makeRandomMaze(numOfRows: 12, numOfCols: 8, seeded: true)
        }
        else if levelNumber == 3 {
            makeRandomMaze(numOfRows: 15, numOfCols: 9, seeded: true)
            makeRandomHoles(n: 8, seeded: 103321315)
        }
        else if levelNumber == 4 {
            makeRandomMaze(numOfRows: 16, numOfCols: 10, seeded: true)
            makeRandomHoles(n: 16, seeded: 7492948532)
        }
        else if levelNumber == 5 {
            makeRandomMaze(numOfRows: 18, numOfCols: 11, seeded: true)
            makeRandomHoles(n: 32, seeded: 213849321)
            
        }
            
        //level X
        else if levelNumber == 6 {
            let numOfRows = 20
            let numOfCols = 12
            let numOfHoles = 32
            makeRandomMaze(numOfRows: numOfRows, numOfCols: numOfCols, seeded: false)
            makeRandomHoles(n: numOfHoles, seeded: -1)
        }
    }

// Former Level 1 implementation
//    private func mazeLevel1() {
//        drawHLine(x: 90, y: 60, length: 100)
//        drawVLine(x: 90, y: 60, length: 110)
//        drawVLine(x: 120, y: 60, length: 140)
//        drawHLine(x: 0, y: 200, length: 120)
//        drawVLine(x: 30, y: 0, length: 110)
//        drawHLine(x: 30, y: 110, length: 30)
//        drawHLine(x: 0, y: 140, length: 60)
//        drawHLine(x: 30, y: 170, length: 60)
//        drawVLine(x: 190, y: 60, length: 260)
//        drawVLine(x: 60, y: 0, length: 80)
//        drawHLine(x: 60, y: 30, length: 160)
//        drawVLine(x: 220, y: 30, length: 90)
//        drawHLine(x: 190, y: 150, length: 80)
//        drawVLine(x: 245, y: 0, length: 50)
//        drawVLine(x: 245, y: 80, length: 70)
//        drawVLine(x: 270, y: 30, length: 120)
//        drawHLine(x: 190, y: 320, length: 80)
//        drawHLine(x: 220, y: 180, length: 81)
//        drawVLine(x: 220, y: 180, length: 110)
//        drawVLine(x: 245, y: 210, length: 110)
//        drawVLine(x: 270, y: 180, length: 40)
//        drawVLine(x: 270, y: 245, length: 105)
//        drawHLine(x: 30, y: 350, length: 240)
//        drawHLine(x: 30, y: 375, length: 270)
//        drawVLine(x: 30, y: 230, length: 120)
//        drawHLine(x: 30, y: 230, length: 120)
//        drawVLine(x: 150, y: 170, length: 150)
//        drawHLine(x: 60, y: 320, length: 90)
//        drawVLine(x: 60, y: 260, length: 60)
//        drawHLine(x: 60, y: 260, length: 60)
//        drawVLine(x: 120, y: 260, length: 30)
//        drawHLine(x: 90, y: 290, length: 30)
//        drawVLine(x: 150, y: 60, length: 80)
//        drawHLine(x: 150, y: 280, length: 20)
//        drawHLine(x: 170, y: 225, length: 20)
//        drawHLine(x: 150, y: 170, length: 20)
//        drawHLine(x: 150, y: 110, length: 20)
//    }
    
    // A method used to generate a random maze using a recursive backtracking algorithm. The reference is below.
    // The recursive backtracking algorithm: http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking
    // (There are also other maze generation algorithms on the site.)
    private func makeRandomMaze(numOfRows: Int, numOfCols: Int, seeded: Bool) {
        
        // Specify a random seed if a fixed maze is desired. Otherwise, just use the default random source.
        var randomSource = GKMersenneTwisterRandomSource.init()
        if seeded {
            randomSource = GKMersenneTwisterRandomSource.init(seed: 54748356234563257)
        }
        
        // Imagine the maze is initially a table of cells. The borderlines between the cells are taken down to make a maze.
        // So here we keep a matrix where each entry corresponds to a cell and encodes which borderlines (or walls) of the cell are taken down later.
        var cells : [[Int]] = []
        for row in 0..<numOfRows {
            cells.append([Int]())
            for _ in 0..<numOfCols {
                cells[row].append(0)
            }
        }
        
        // The method to carve the walls between the cells.
        carvePassage(randomSource: randomSource, cx: 0, cy: 0, cells: &cells)
        
        // Calculate how wide and how high each cell should appear on screen. Then according to the information in the matrix, draw the maze on screen using drawHLine and drawVLine.
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
    
    // The function to determine which walls between the cells should be taken down and record this information in the matrix that is passed in.
    private func carvePassage(randomSource: GKMersenneTwisterRandomSource, cx: Int, cy: Int, cells: inout [[Int]]) {
        
        // Define N, S, E, W to be 1, 2, 4, 8. Later use bit wise operation to record which walls in what direction are taken down.
        let N : Int = 1
        let S : Int = 2
        let E : Int = 4
        let W : Int = 8
        
        // A dictionary that keeps how the index of the cell changes if a step is taken in a direction. Used to conveniently calculate the next cell.
        let dx = [N: 0, S: 0, E: 1, W: -1]
        let dy = [N: -1, S: 1, E: 0, W: 0]
        
        // A dictionary that keeps the opposite direction of a direction. Used to conveniently "take down" the walls in the next cell.
        let opposite = [N: S, S: N, E: W, W: E]
        
        // The exploration of the maze should be random in order to generate interesting mazes. shuffledDirections will store a shuffled version of all possible directions [N, S, E, W].
        var shuffledDirections : [Int] = []
        shuffledDirections = randomSource.arrayByShufflingObjects(in: [N, S, E, W]) as! [Int]
        
        // This is the recursive backtracking algorithm.
        // Each time select a direction randomly.
        for direction in shuffledDirections {
            
            // Calculate the position of the next cell, which is the cell in the chosen direction of the current cell.
            let nx = cx + dx[direction]!
            let ny = cy + dy[direction]!
            
            // If the next cell is within the maze, proceed.
            if (nx >= 0) && (nx <= cells[0].count - 1) && (ny >= 0) && (ny <= cells.count - 1) {
                
                // If the next cell has not been visited (i.e., its corresponding entry is still 0), we take down the wall between the current cell and the next cell, and call carvePassage on the next cell. Otherwise, do nothing.
                if (cells[ny][nx] == 0) {
                    cells[cy][cx] |= direction
                    cells[ny][nx] |= opposite[direction]!
                    carvePassage(randomSource: randomSource, cx: nx, cy: ny, cells: &cells)
                }
                
            }
        }
    }
    
    // Function to calculate the distance between 2 CGPoint
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    // Method to make random holes of a given number
    func makeRandomHoles(n : Int, seeded : Int) {
        
        var randomSource = GKMersenneTwisterRandomSource.init()
        if (seeded != -1) {
            randomSource = GKMersenneTwisterRandomSource.init(seed: UInt64(seeded))
        }
        
        let randomDistribution = GKRandomDistribution.init(randomSource: randomSource, lowestValue: 0, highestValue: 1000)
        
        for _ in 1...n {
            var x : Int
            var y : Int
            
            //generate non-overlaping holes
            repeat {
                x = Int((CGFloat(randomDistribution.nextInt()) / CGFloat(1000)) * CGFloat(bounds.width - imageWidth)) + Int(imageWidth / 2)
                y = Int((CGFloat(randomDistribution.nextInt()) / CGFloat(1000)) * CGFloat(bounds.height - imageHeight)) + Int(imageHeight / 2)
            } while !isValidHole(x: x, y: y)
            makeHole(x: x, y: y)
        }
    }
    
    // Check if there is a hole overlaping
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

    // Method to make a single hole and add the hole's location to the hole list
    private func makeHole(x: Int, y: Int) {
        let hole = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        hole.image = UIImage.init(named: "blackhole")
        addSubview(hole)
        hole.center = CGPoint(x: CGFloat(x), y: CGFloat(y))
        self.holes.append(hole.center)
    }
    
    // Method drawing horizontal line on the maze
    // Also marking the pixels on the line to be true
    private func drawHLine(x : Int, y : Int, length : Int) {
        let line = UIView(frame: CGRect(x: x, y: max(y - 1, 0), width: length, height: 3))
        line.backgroundColor = UIColor.gray
        self.addSubview(line)
        for i in x...x+length {
            
            //wall mark
            self.bits[y][i] = true
        }
    }
    
    // Method drawing verticle line on the maze
    // Also marking the pixels on the line to be true
    private func drawVLine(x : Int, y : Int, length : Int) {
        let line = UIView(frame: CGRect(x: max(0, x - 1), y: y, width: 3, height: length))
        line.backgroundColor = UIColor.gray
        self.addSubview(line)
        for i in y...y+length {
            
            //wall mark
            self.bits[i][x] = true
        }
    }
    
    // Method to draw the background
    private func setupUI() {
        
        imageView.image = UIImage.init(named: "ball")
        imageView.contentMode = UIViewContentMode.scaleToFill
        addSubview(imageView)
        currentPoint = CGPoint(x: imageWidth/2, y: imageHeight/2)
        imageView.center = currentPoint
    }
    
    
    func updateLocation(multiplier : Double) {
        if (lastUpdateTime != nil)&&(!pause) {
            
            let updatePeriod = Date.init().timeIntervalSince(lastUpdateTime!)
            
            //the accelleration is different on the floor and on the sky
            //we do not apply the same rule to ballZV, as its trigger rule is different
            if (self.z < 2) {
                ballXV = ballXV + accelleration.x * updatePeriod
                ballYV = ballYV + accelleration.y * updatePeriod
            }
            else {
                ballXV = (ballXV + accelleration.x * updatePeriod * 0.6) * 0.8
                ballYV = (ballYV + accelleration.y * updatePeriod * 0.6) * 0.8
            }
            
            //Speed limit, making the game more reasonable
            if (ballXV > 0.3) {ballXV = 0.3}
            if (ballXV < -0.3) {ballXV = -0.3}
            if (ballYV > 0.3) {ballYV = 0.3}
            if (ballYV < -0.3) {ballYV = -0.3}
            
            //Only a large enough accerleration on z-axis can trigger jump
            //No jump on the sky
            if ((self.jump.z > 0.6)&&(self.z == 0)) {
                ballZV = self.jump.z * multiplier / 400;
            }
            
            //The ball size changes when it is on the sky
            //The acceleration and z-vocility changes during ball on the sky
            if ((self.z > 0)||(ballZV > 0)) {
                
                imageView.frame.size.width = imageWidth * CGFloat(1 + z / 100)
                imageView.frame.size.height = imageHeight * CGFloat(1 + z / 100)
                
                z = z + ballZV
                ballZV -= 0.7
            }
            
            //fall back to the ground
            if (z < 0) {
                z = 0
                
                //z-axis bounce
                if (ballZV < -1) {
                    ballZV = -ballZV * 0.5
                }
                else {
                    ballZV = 0;
                }
                
                imageView.frame.size.width = imageWidth
                imageView.frame.size.height = imageHeight
            }
            
            //update location of the ball in the maze
            let coefficient = updatePeriod * multiplier
            currentPoint = CGPoint(x: currentPoint.x + (CGFloat)(ballXV * coefficient), y: currentPoint.y - (CGFloat)(ballYV * coefficient))
        }
        
        //record the update
        lastUpdateTime = Date()
        pause = false
    }
}


