import UIKit

class ActivityCell: UITableViewCell {
    
    private let activityLabel = UILabel()
    private let activityImageView = UIImageView() // New image view for activity image
    private let linkIconImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        activityLabel.font = UIFont.systemFont(ofSize: 16)
        activityLabel.numberOfLines = 0
        activityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        activityImageView.contentMode = .scaleAspectFill
        activityImageView.layer.cornerRadius = 8
        activityImageView.clipsToBounds = true
        activityImageView.translatesAutoresizingMaskIntoConstraints = false
        
        linkIconImageView.image = UIImage(systemName: "link.circle")
        linkIconImageView.tintColor = .systemBlue
        linkIconImageView.isHidden = true
        linkIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(activityImageView)
        contentView.addSubview(activityLabel)
        contentView.addSubview(linkIconImageView)
        
        NSLayoutConstraint.activate([
            activityImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            activityImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            activityImageView.widthAnchor.constraint(equalToConstant: 60),
            activityImageView.heightAnchor.constraint(equalToConstant: 60),
            
            activityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            activityLabel.leadingAnchor.constraint(equalTo: activityImageView.trailingAnchor, constant: 10),
            activityLabel.trailingAnchor.constraint(equalTo: linkIconImageView.leadingAnchor, constant: -10),
            activityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            linkIconImageView.centerYAnchor.constraint(equalTo: activityLabel.centerYAnchor),
            linkIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            linkIconImageView.widthAnchor.constraint(equalToConstant: 24),
            linkIconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with activity: Activity) {
        activityLabel.text = activity.name
        activityImageView.image = activity.image // Assuming `Activity` has an `image` property
        linkIconImageView.isHidden = (activity.url == nil)
    }
}
