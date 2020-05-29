//
//  DoodleService.swift
//  GudTay
//
//  Created by Zev Eisenberg on 12/31/18.
//

// Built with the help of this tutorial: https://www.ralfebert.de/ios/tutorials/multipeer-connectivity/
import MultipeerConnectivity
import Swiftilities

protocol DoodleServiceDelegate: AnyObject {

    func doodleService(_ doodleService: DoodleService, did action: DoodleService.Action)

}

extension DoodleService {

    typealias Delegate = DoodleServiceDelegate

    enum Action {
        case connectedDevicesChanged(deviceNames: [String])
        case receivedImage(UIImage)
    }

}

final class DoodleService: NSObject {

    // Public Properties

    weak var delegate: Delegate?

    // Private Properties

    private let myPeerId: MCPeerID = { () -> MCPeerID in
        // Apple’s suggested archiving/unarchiving to prevent "ghost" peer IDs
        // https://developer.apple.com/documentation/multipeerconnectivity/mcpeerid
        let displayName = UIDevice.current.name

        let displayNameKey = "com.zeveisenberg.gudtay.displayName"
        let peerIdKey = "com.zeveisenberg.gudtay.peerId"

        let defaults = UserDefaults.standard
        let oldDisplayName = defaults.string(forKey: displayNameKey)

        do {
            if oldDisplayName == displayName {
                guard
                    let peerIdData = defaults.data(forKey: peerIdKey),
                    let unarchivedPeerId = try NSKeyedUnarchiver.unarchivedObject(ofClass: MCPeerID.self, from: peerIdData)
                    else { return MCPeerID(displayName: displayName) }
                return unarchivedPeerId
            }
            else {
                let peerId = MCPeerID(displayName: displayName)
                let peerIdData = try NSKeyedArchiver.archivedData(withRootObject: peerId, requiringSecureCoding: true)
                defaults.set(peerIdData, forKey: peerIdKey)
                defaults.set(displayName, forKey: displayNameKey)
                return peerId
            }
        }
        catch {
            Log.error("Error archiving or unarchiving peer ID: \(error)")
            return MCPeerID(displayName: displayName)
        }
    }()

    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser

    private lazy var session: MCSession = {
        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()

    override init() {
        serviceAdvertiser = MCNearbyServiceAdvertiser(
            peer: myPeerId,
            discoveryInfo: nil,
            serviceType: Constants.serviceType
        )

        serviceBrowser = MCNearbyServiceBrowser(
            peer: myPeerId,
            serviceType: Constants.serviceType
        )

        super.init()

        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()

        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }

    deinit {
        // Nil out delegates in attempt to prevent crash
        // https://stackoverflow.com/questions/22888367/multipeer-mcnearbybrowserservice-crashing
        serviceAdvertiser.delegate = nil
        serviceBrowser.delegate = nil
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }

    func sendImage(_ image: UIImage) {
        guard let data = image.pngData() else { return }
        if !session.connectedPeers.isEmpty {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
            catch {
                Log.error("error sending image: \(error)")
            }
        }
    }

}

extension DoodleService: MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        Log.error("\(#function), \(error)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }

}

extension DoodleService: MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        Log.error("\(#function), \(error)")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        Log.info("\(#function), \(peerID), \(info as Any)")
        // Deterministically defer to one device or the other
        // to prevent crossing the streams.
        // Assumes the peer IDs aren't the same.
        // via https://stackoverflow.com/a/19529933/255489
        let shouldInvite = myPeerId.displayName < peerID.displayName
        if shouldInvite {
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        Log.info("\(#function), \(peerID)")
    }

}

extension DoodleService: MCSessionDelegate {

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        Log.info("\(#function), \(peerID), \(state)")
        delegate?.doodleService(self, did: .connectedDevicesChanged(deviceNames: session.connectedPeers.map { $0.displayName }))
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        Log.info("\(#function), \(String(data: data, encoding: .utf8) ?? "<non-UTF-8 data with bytes: \(data.count)>"), \(peerID)")
        guard let image = UIImage(data: data) else { return }
        delegate?.doodleService(self, did: .receivedImage(image))
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        Log.info("\(#function), \(stream), \(streamName), \(peerID)")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        Log.info("\(#function), \(resourceName), \(peerID), \(progress)")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        Log.info("\(#function), \(resourceName), \(peerID), \(localURL as Any), \(error as Any)")
    }

}

private extension DoodleService {

    enum Constants {
        static let serviceType = "gudtay-doodle"
    }

}
