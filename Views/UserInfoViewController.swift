import UIKit

protocol UserInfoViewControllerDelegate: AnyObject {
    func didCompleteProfileSetup(user: User)
}

class UserInfoViewController: UIViewController {
    
    weak var delegate: UserInfoViewControllerDelegate?
    
    // Labels and text fields
    private let nameLabel = createLabel(text: "Full Name")
    private let nameTextField = createTextField(placeholder: "John Doe")
    private let ageLabel = createLabel(text: "Age")
    private let ageTextField = createTextField(placeholder: "30", keyboardType: .numberPad)
    private let locationLabel = createLabel(text: "Location")
    private let locationTextField = createTextField(placeholder: "New York, NY")
    private let primaryDiagnosisLabel = createLabel(text: "Primary Diagnosis")
    private let primaryDiagnosisTextField = createTextField(placeholder: "Diabetes")
    private let hobbiesLabel = createLabel(text: "Hobbies")
    private let hobbiesTextField = createTextField(placeholder: "Reading, Hiking")
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = UIConstants.secondaryColor
        button.setTitleColor(UIConstants.buttonTextColor, for: .normal)
        button.titleLabel?.font = UIConstants.bodyFont
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.view.backgroundColor = UIConstants.backgroundColor
        setupUI()
    }
    
    private func setupUI() {
        // Arrange labels and text fields
        let elements = [
            (nameLabel, nameTextField),
            (ageLabel, ageTextField),
            (locationLabel, locationTextField),
            (primaryDiagnosisLabel, primaryDiagnosisTextField),
            (hobbiesLabel, hobbiesTextField)
        ]
        
        elements.forEach { (label, textField) in
            view.addSubview(label)
            view.addSubview(textField)
        }
        
        view.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        
        // Constraints
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameTextField.widthAnchor.constraint(equalToConstant: 280),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            ageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ageLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            ageTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ageTextField.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 5),
            ageTextField.widthAnchor.constraint(equalToConstant: 280),
            ageTextField.heightAnchor.constraint(equalToConstant: 40),
            
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 20),
            locationTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationTextField.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            locationTextField.widthAnchor.constraint(equalToConstant: 280),
            locationTextField.heightAnchor.constraint(equalToConstant: 40),
            
            primaryDiagnosisLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            primaryDiagnosisLabel.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 20),
            primaryDiagnosisTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            primaryDiagnosisTextField.topAnchor.constraint(equalTo: primaryDiagnosisLabel.bottomAnchor, constant: 5),
            primaryDiagnosisTextField.widthAnchor.constraint(equalToConstant: 280),
            primaryDiagnosisTextField.heightAnchor.constraint(equalToConstant: 40),
            
            hobbiesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hobbiesLabel.topAnchor.constraint(equalTo: primaryDiagnosisTextField.bottomAnchor, constant: 20),
            hobbiesTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hobbiesTextField.topAnchor.constraint(equalTo: hobbiesLabel.bottomAnchor, constant: 5),
            hobbiesTextField.widthAnchor.constraint(equalToConstant: 280),
            hobbiesTextField.heightAnchor.constraint(equalToConstant: 40),
            
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.topAnchor.constraint(equalTo: hobbiesTextField.bottomAnchor, constant: 30),
            continueButton.widthAnchor.constraint(equalToConstant: 200),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func continueTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let age = ageTextField.text, !age.isEmpty,
              let location = locationTextField.text, !location.isEmpty,
              let primaryDiagnosis = primaryDiagnosisTextField.text, !primaryDiagnosis.isEmpty,
              let hobbiesText = hobbiesTextField.text, !hobbiesText.isEmpty else {
            let alert = UIAlertController(title: "Missing Information", message: "Please fill in all fields to continue.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let hobbies = hobbiesText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let user = User(name: name, age: age, location: location, primaryDiagnosis: primaryDiagnosis, hobbies: hobbies)
        
        delegate?.didCompleteProfileSetup(user: user)
    }
    
    // Helper to create labels
    private static func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIConstants.subtitleFont
        label.textColor = UIConstants.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // Helper to create text fields
    private static func createTextField(placeholder: String, keyboardType: UIKeyboardType = .default) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIConstants.secondaryColor
        textField.font = UIConstants.bodyFont
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
