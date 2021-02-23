//
//  FavoriteCell.swift
//  FindAPet
//
//  Created by Leah Doskoez on 2/11/21.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
