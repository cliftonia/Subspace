//
//  WebSocketManager.swift
//  Subspace
//
//  Created by Clifton Baggerman on 04/10/2025.
//

import Foundation
import os

// MARK: - WebSocket Message

/// Represents a message received from the WebSocket
struct WebSocketMessage: Codable, Sendable {
    let type: String
    let data: MessageData

    struct MessageData: Codable, Sendable {
        let id: String?
        let userId: String?
        let content: String?
        let kind: String?
        let isRead: Bool?
        let createdAt: String?
        let updatedAt: String?
    }
}

// MARK: - WebSocket Manager

/// Manages WebSocket connections for real-time updates
final class WebSocketManager: NSObject {
    // MARK: - Properties

    private(set) var isConnected = false
    private(set) var lastMessage: WebSocketMessage?

    // MARK: - Private Properties

    private let logger = Logger.app(category: "WebSocketManager")
    private var webSocketTask: URLSessionWebSocketTask?
    private let urlSession: URLSession
    private var userId: String?

    // Message handler
    var onMessageReceived: (@Sendable (WebSocketMessage) -> Void)?

    // MARK: - Initialization

    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.urlSession = URLSession(configuration: configuration)
        super.init()
    }

    // MARK: - Public Methods

    /// Connect to WebSocket server
    func connect(userId: String) {
        guard !isConnected else {
            logger.info("Already connected to WebSocket")
            return
        }

        self.userId = userId

        guard var urlComponents = URLComponents(string: "ws://localhost:8080/ws") else {
            logger.error("Invalid WebSocket URL")
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "userId", value: userId)
        ]

        guard let url = urlComponents.url else {
            logger.error("Failed to construct WebSocket URL")
            return
        }

        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()

        isConnected = true
        logger.info("Connected to WebSocket for user: \(userId)")

        // Start receiving messages
        receiveMessage()

        // Send ping periodically to keep connection alive
        startHeartbeat()
    }

    /// Disconnect from WebSocket server
    func disconnect() {
        guard isConnected else {
            return
        }

        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        isConnected = false

        logger.info("Disconnected from WebSocket")
    }

    /// Send a message through WebSocket
    func send(message: String) {
        guard isConnected else {
            logger.warning("Cannot send message: not connected")
            return
        }

        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { [weak self] error in
            if let error = error {
                self?.logger.error("WebSocket send error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Private Methods

    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self.handleMessage(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self.handleMessage(text)
                    }
                @unknown default:
                    break
                }

                // Continue receiving messages
                self.receiveMessage()

            case .failure(let error):
                self.logger.error("WebSocket receive error: \(error.localizedDescription)")
                self.isConnected = false

                // Attempt reconnect after delay
                DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                    if let userId = self.userId {
                        self.connect(userId: userId)
                    }
                }
            }
        }
    }

    private func handleMessage(_ text: String) {
        logger.debug("Received WebSocket message: \(text)")

        guard let data = text.data(using: .utf8) else {
            return
        }

        do {
            let decoder = JSONDecoder()
            let message = try decoder.decode(WebSocketMessage.self, from: data)
            lastMessage = message

            // Call the message handler
            onMessageReceived?(message)

            logger.info("Processed WebSocket message of type: \(message.type)")
        } catch {
            logger.error("Failed to decode WebSocket message: \(error.localizedDescription)")
        }
    }

    private func startHeartbeat() {
        Task {
            while isConnected {
                try? await Task.sleep(for: .seconds(30))

                if isConnected {
                    webSocketTask?.sendPing { [weak self] error in
                        if let error = error {
                            self?.logger.error("WebSocket ping error: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}
