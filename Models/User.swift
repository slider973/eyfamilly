import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable, Equatable, Hashable {
    let id: String
    var name: String
    var email: String
    var role: UserRole
    var deviceTokens: [String]
    
    enum UserRole: String, Codable {
        case parent
        case child
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case role
        case deviceTokens
    }
    
    init(id: String = UUID().uuidString, name: String, email: String, role: UserRole, deviceTokens: [String] = []) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
        self.deviceTokens = deviceTokens
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        role = try container.decode(UserRole.self, forKey: .role)
        deviceTokens = try container.decode([String].self, forKey: .deviceTokens)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(role, forKey: .role)
        try container.encode(deviceTokens, forKey: .deviceTokens)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

extension User {
    init?(from document: DocumentSnapshot) {
        guard let data = document.data(),
              let name = data["name"] as? String,
              let email = data["email"] as? String,
              let roleString = data["role"] as? String,
              let role = UserRole(rawValue: roleString),
              let deviceTokens = data["deviceTokens"] as? [String] else {
            return nil
        }
        self.init(id: document.documentID, name: name, email: email, role: role, deviceTokens: deviceTokens)
    }
    
    func isParent() -> Bool {
        return self.role == .parent
    }
    
    mutating func addDeviceToken(_ token: String) {
        if !deviceTokens.contains(token) {
            deviceTokens.append(token)
        }
    }
    
    var initials: String {
        let components = name.components(separatedBy: " ")
        return components.reduce("") { result, component in
            guard let first = component.first else { return result }
            return result + String(first).uppercased()
        }
    }
}

extension User: CustomStringConvertible {
    var description: String {
        return "User(id: \(id), name: \(name), email: \(email), role: \(role))"
    }
}
