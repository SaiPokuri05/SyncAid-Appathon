// OpenAIClient.swift

import Foundation

class OpenAIClient {
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "OpenAI_API_Key") as? String

    func fetchActivityRecommendations(for hobbies: [String], location: String, completion: @escaping (Result<[Activity], Error>) -> Void) {
        guard let apiKey = apiKey else {
            print("Error: API key not found in Info.plist")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "API key not found"])))
            return
        }
        
        let prompt = """
        Based on the location \(location) and the interests \(hobbies.joined(separator: ", ")), recommend 5 interesting activities or events nearby. Provide links to these activities if possible.
        """
        print("Prompt: \(prompt)")
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 150,
            "temperature": 0.7
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            print("Request body serialized successfully")
        } catch {
            print("Error serializing request body: \(error)")
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("Error: No data received")
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    
                    if let errorDict = json["error"] as? [String: Any],
                       let errorMessage = errorDict["message"] as? String {
                        print("Error from OpenAI: \(errorMessage)")
                        
                        if errorMessage.contains("exceeded your current quota") {
                            completion(.success([Activity(name: "You have exceeded your OpenAI API quota. Please check your billing details or try again later.", url: nil)]))
                            return
                        }
                    }
                    
                    if let choices = json["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let text = message["content"] as? String {
                        let activities = text
                            .split(separator: "\n")
                            .compactMap { line -> Activity? in
                                let components = line.split(separator: "|")
                                guard !components.isEmpty else { return nil }
                                let name = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
                                let url = components.count > 1 ? URL(string: components[1].trimmingCharacters(in: .whitespacesAndNewlines)) : nil
                                return Activity(name: name, url: url)
                            }
                        
                        if activities.isEmpty {
                            print("No activities received, providing default activities.")
                            completion(.success(self.defaultActivities()))
                        } else {
                            print("Parsed activities: \(activities)")
                            completion(.success(activities))
                        }
                    } else {
                        print("Invalid response format")
                        completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                    }
                }
            } catch {
                print("Error parsing JSON response: \(error)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchAffirmations(for primaryDiagnosis: String, completion: @escaping (Result<[String], Error>) -> Void) {
            guard let apiKey = apiKey else {
                print("Error: API key not found in Info.plist")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "API key not found"])))
                return
            }
            
            let prompt = "Provide 3 daily short affirmations suitable for someone with \(primaryDiagnosis)."
            print("Prompt: \(prompt)")
            
            let url = URL(string: "https://api.openai.com/v1/chat/completions")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let requestBody: [String: Any] = [
                "model": "gpt-3.5-turbo",
                "messages": [
                    ["role": "user", "content": prompt]
                ],
                "max_tokens": 150,
                "temperature": 0.7
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
                print("Request body serialized successfully")
            } catch {
                print("Error serializing request body: \(error)")
                completion(.failure(error))
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Network error: \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    print("Error: No data received")
                    completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let text = message["content"] as? String {
                        
                        let affirmations = text.split(separator: "\n").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                        completion(.success(affirmations))
                        
                    } else {
                        completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                    }
                } catch {
                    print("Error parsing JSON response: \(error)")
                    completion(.failure(error))
                }
            }
            
            task.resume()
    }
    
    func fetchSuggestions(for primaryDiagnosis: String, completion: @escaping (Result<[String], Error>) -> Void) {
            guard let apiKey = apiKey else {
                print("Error: API key not found in Info.plist")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "API key not found"])))
                return
            }
            
            let prompt = """
            Based on a primary diagnosis of \(primaryDiagnosis), provide a few health activities and tips for the day that might improve well-being. Keep it short and uplifting.
            """
            print("Prompt: \(prompt)")
            
            let url = URL(string: "https://api.openai.com/v1/chat/completions")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let requestBody: [String: Any] = [
                "model": "gpt-3.5-turbo",
                "messages": [
                    ["role": "user", "content": prompt]
                ],
                "max_tokens": 100,
                "temperature": 0.7
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
                print("Request body serialized successfully")
            } catch {
                print("Error serializing request body: \(error)")
                completion(.failure(error))
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Network error: \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    print("Error: No data received")
                    completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let text = message["content"] as? String {
                        
                        // Split responses by line to create a list of suggestions
                        let suggestions = text.split(separator: "\n").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                        completion(.success(suggestions))
                    } else {
                        print("Invalid response format")
                        completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                    }
                } catch {
                    print("Error parsing JSON response: \(error)")
                    completion(.failure(error))
                }
            }
            
            task.resume()
    }
    
    // Fallback default activities
    private func defaultActivities() -> [Activity] {
        return [
            Activity(name: "Attend a local art class", url: nil),
            Activity(name: "Go hiking in a nearby nature reserve", url: nil),
            Activity(name: "Watch a documentary on cooking techniques", url: nil),
            Activity(name: "Participate in a book club discussion", url: nil),
            Activity(name: "Join a local sports meetup", url: nil),
            Activity(name: "Explore nearby historical sites", url: nil)
        ]
    }
    
}
