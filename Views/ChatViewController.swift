// ChatViewController.swift

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var currentChatProfile: Profile?
    private var messages: [Message] = []
    
    private let tableView = UITableView()
    private let messageInputContainerView = UIView()
    private let messageTextField = UITextField()
    private let sendButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupInputComponents()
        setupTableView()
    }
    
    func initiateChat(with profile: Profile) {
        currentChatProfile = profile
        title = "Chat with \(profile.name)"
        
        messages = [
            Message(text: "Hello, \(profile.name)!", isUserMessage: true),
            Message(text: "How are you doing today?", isUserMessage: true)
        ]
        
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "MessageCell") // Custom cell
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputContainerView.topAnchor)
        ])
    }
    
    private func setupInputComponents() {
        messageInputContainerView.backgroundColor = UIColor.systemGray6
        messageInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageInputContainerView)
        
        messageTextField.placeholder = "Type a message..."
        messageTextField.borderStyle = .roundedRect
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        messageInputContainerView.addSubview(messageTextField)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        messageInputContainerView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            messageInputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageInputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageInputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            messageInputContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            messageTextField.leadingAnchor.constraint(equalTo: messageInputContainerView.leadingAnchor, constant: 10),
            messageTextField.centerYAnchor.constraint(equalTo: messageInputContainerView.centerYAnchor),
            messageTextField.heightAnchor.constraint(equalToConstant: 35),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            
            sendButton.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(equalTo: messageInputContainerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func handleSend() {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        
        // Append the user's message
        messages.append(Message(text: text, isUserMessage: true))
        tableView.reloadData()
        
        // Scroll to the latest message
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        messageTextField.text = ""
        
        // Simulate a reply from the other user
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.messages.append(Message(text: "Reply from \(self.currentChatProfile?.name ?? "User")", isUserMessage: false))
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! ChatMessageCell
        cell.configure(with: messages[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
