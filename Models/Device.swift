import SwiftUI

struct Device: Identifiable {
    let id: UUID
    let name: String
    let type: DeviceType
    var isOn: Bool
}

enum DeviceType {
    case light, thermostat, speaker, other
}
