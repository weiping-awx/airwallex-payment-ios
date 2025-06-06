//
//  SchemaPaymentReminderCell.swift
//  Airwallex
//
//  Created by Weiping Li on 2025/1/10.
//  Copyright © 2025 Airwallex. All rights reserved.
//

import UIKit

class SchemaPaymentReminderCell: UICollectionViewCell, ViewReusable {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "redirect", in: .paymentSheet)
        view.setContentHuggingPriority(.defaultLow + 10, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh + 10, for: .horizontal)
        return view
    }()
    
    private let label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .awxFont(.body2)
        view.textColor = .awxColor(.textPrimary)
        view.numberOfLines = 0
        view.text = NSLocalizedString("You will be redirected to complete your payment upon confirmation.", bundle: .paymentSheet, comment: "schema payment redirect reminder")
        return view
    }()
    
    private let stack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 8
        view.alignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(stack)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)
        
        let constraints = [
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
