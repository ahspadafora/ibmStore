//
//  RatingView.swift
//  ibmStore
//
//  Created by Amber Spadafora on 8/24/21.
//

import UIKit

class RatingView: UIView {
    
    
    @IBOutlet weak var firstStarImgView: UIImageView!
    
    @IBOutlet weak var secondStarImgView: UIImageView!
    
    @IBOutlet weak var thirdStarImgView: UIImageView!
    
    @IBOutlet weak var fourthStarImgView: UIImageView!
    
    @IBOutlet weak var fifthStarImgView: UIImageView!
    
    var rating: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setRating(rating: Int) {
        var imageViewsToUpdate: [UIImageView] = []
        switch rating {
        case 5:
            imageViewsToUpdate.append(contentsOf: [firstStarImgView, secondStarImgView, thirdStarImgView, fourthStarImgView, fifthStarImgView])
        case 4:
            imageViewsToUpdate.append(contentsOf: [firstStarImgView, secondStarImgView, thirdStarImgView, fourthStarImgView])
        case 3:
            imageViewsToUpdate.append(contentsOf: [firstStarImgView, secondStarImgView, thirdStarImgView])
        case 2:
            imageViewsToUpdate.append(contentsOf: [firstStarImgView, secondStarImgView])
        case 1:
            imageViewsToUpdate.append(firstStarImgView)
        default:
            return
        }
        _ = imageViewsToUpdate.map{$0.image = UIImage(systemName: "star.fill")?.withTintColor(.blue)}
    }
    
    private func commonInit() {
        guard let view = Bundle.main.loadNibNamed("RatingView", owner: self, options: nil)?[0] as? UIView else { return }
        view.frame = self.bounds
        addSubview(view)
        self.firstStarImgView.image = UIImage(systemName: "star")?.withTintColor(.blue)
        self.secondStarImgView.image = UIImage(systemName: "star")?.withTintColor(.blue)
        self.thirdStarImgView.image = UIImage(systemName: "star")?.withTintColor(.blue)
        self.fourthStarImgView.image = UIImage(systemName: "star")?.withTintColor(.blue)
        self.fifthStarImgView.image = UIImage(systemName: "star")?.withTintColor(.blue)
    }

}
