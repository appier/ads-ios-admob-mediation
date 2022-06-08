import GoogleMobileAds
import AppierAds

class AdConfiguration {
    private let adConfiguration: GADMediationAdConfiguration
    private let localExtras: APRAdExtras

    struct ServerExtras: Codable {
        var adUnitId: String?
        var zoneId: String?
    }

    init(with adConfiguration: GADMediationAdConfiguration) {
        self.adConfiguration = adConfiguration
        self.localExtras = adConfiguration.extras as? APRAdExtras ?? APRAdExtras()
        if let extrasStr = adConfiguration.credentials.settings["parameter"] as? String,
           let data = extrasStr.data(using: .utf8),
           let serverExtras = try? JSONDecoder().decode(ServerExtras.self, from: data) {
            syncExtras(with: serverExtras)
        }
    }

    private func syncExtras(with serverExtras: ServerExtras) {
        if let adUnitId = serverExtras.adUnitId {
            localExtras.set(key: .adUnitId, value: adUnitId)
        }
        if let zoneId = serverExtras.zoneId {
            localExtras.set(key: .zoneId, value: zoneId)
        }
    }

    func getLocalExtras() -> APRAdExtras {
        return localExtras
    }
}
