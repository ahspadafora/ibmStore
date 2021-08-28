//
//  NoResultsView.swift
//  ibmStore
//
//  Created by Amber Spadafora on 8/24/21.
//

import UIKit

class EmptyTableView: UIView {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var messageLabel: UILabel!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        guard let view = Bundle.main.loadNibNamed("EmptyTableView", owner: self, options: nil)?[0] as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }

}
