//
//  CVViewController.swift
//  swift
//
//  Created by Denny Wongso on 27/12/22.
//

import Foundation
import UIKit

public class CVViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playerOne: UILabel!
    @IBOutlet weak var playerTwo: UILabel!
    @IBOutlet weak var message: UILabel!
    
    
    var isPlayerOne: Bool = true
    var game: [[Int]] = []
    private let sectionInsets = UIEdgeInsets(
      top: 5.0,
      left: 5.0,
      bottom: 5.0,
      right: 5.0)
    private let itemsPerRow: CGFloat = 3

    
    override public func viewDidLoad() {
        super.viewDidLoad()
        game.append([0, 0, 0])
        game.append([0, 0, 0])
        game.append([0, 0, 0])
        playerOne.textColor = isPlayerOne ? .red : .black
        playerTwo.textColor = !isPlayerOne ? .red : .black
    }
    
    @IBAction func restartClick(_ sender: Any) {
        game = []
        game.append([0, 0, 0])
        game.append([0, 0, 0])
        game.append([0, 0, 0])
        playerOne.textColor = isPlayerOne ? .red : .black
        playerTwo.textColor = !isPlayerOne ? .red : .black
        collectionView.reloadData()
    }
    
    public func rowAndColumn(_ num: Int) -> (Int, Int) {
        var start = 0
        if num < 3 {
            start = 0
        } else if num < 6 {
            start = 1
        } else {
            start = 2
        }
        return (start, num % 3)
    }
    
    public func isValid(_ row: Int, _ col: Int) -> Bool {
        return game[row][col] == 0
    }
}


extension CVViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tictactoe", for: indexPath) as! TicTacToeCell
        guard let defaultimage = UIImage(named: "empty_img") else {
            return cell
        }
        guard let ximage = UIImage(named: "x_img") else {
            return cell
        }
        guard let oimage = UIImage(named: "o_img") else {
            return cell
        }
        
        let rowAndCol = rowAndColumn(indexPath.row)
        
        if game[rowAndCol.0][rowAndCol.1] == 0 {
            cell.imageView.image = defaultimage
        } else if game[rowAndCol.0][rowAndCol.1] == 1 {
            cell.imageView.image = ximage
        } else {
            cell.imageView.image = oimage
        }
      return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let rowAndCol = rowAndColumn(indexPath.row)
        
        if !isValid(rowAndCol.0, rowAndCol.1) {
            message.text = "Invalid moved! try again!"
            message.textColor = .red
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: {[message](timer) in
                message?.text = ""
                message?.textColor = .black
                timer.invalidate()
            })
            return
        }
        game[rowAndCol.0][rowAndCol.1] = isPlayerOne ? 1 : 2
        isPlayerOne.toggle()
        playerOne.textColor = isPlayerOne ? .red : .black
        playerTwo.textColor = !isPlayerOne ? .red : .black
        collectionView.reloadData()

    }
    
}


// MARK: - Collection View Flow Layout Delegate
extension CVViewController: UICollectionViewDelegateFlowLayout {
    
  // 1
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    // 2
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = collectionView.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: round(widthPerItem) - 5, height: round(widthPerItem) - 5)
      
  }
  
  // 3
    public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return sectionInsets
  }
  
  // 4
public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return sectionInsets.left
  }
}
