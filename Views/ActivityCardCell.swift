import UIKit

class ActivityCardCell: UICollectionViewCell {
    
    private let activityLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        activityLabel.font = UIFont.systemFont(ofSize: 16)
        activityLabel.numberOfLines = 0 // Allows label to wrap over multiple lines
        activityLabel.textColor = .darkGray
        activityLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityLabel)
        
        NSLayoutConstraint.activate([
            activityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            activityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            activityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            activityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    func configure(with activity: Activity) {
        activityLabel.text = activity.name
    }
}
