import Foundation
import SwiftUI

@MainActor
class YouTubeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var subscriberCount: Int = 0
    @Published var viewCount: Int = 0
    @Published var videoCount: Int = 0
    @Published var lastUpdated: Date?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - API Configuration
    // TODO: Replace with your actual API key and Channel ID
    private let apiKey = "YOUR_API_KEY_HERE"
    private let channelId = "YOUR_CHANNEL_ID_HERE"
    
    private let baseURL = "https://www.googleapis.com/youtube/v3/channels"
    
    // MARK: - Initializer
    init() {
        // Auto-fetch on app launch
        Task {
            await fetchStats()
        }
    }
    
    // MARK: - Fetch Stats Function
    func fetchStats() async {
        isLoading = true
        errorMessage = nil
        
        guard apiKey != "YOUR_API_KEY_HERE" && channelId != "YOUR_CHANNEL_ID_HERE" else {
            errorMessage = "API 키와 채널 ID를 설정해주세요."
            isLoading = false
            return
        }
        
        guard let url = buildURL() else {
            errorMessage = "잘못된 URL입니다."
            isLoading = false
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            let channelResponse = try decoder.decode(YouTubeChannelResponse.self, from: data)
            
            guard let channel = channelResponse.items.first else {
                errorMessage = "채널 정보를 찾을 수 없습니다."
                isLoading = false
                return
            }
            
            // Update published properties on main thread
            subscriberCount = Int(channel.statistics.subscriberCount) ?? 0
            viewCount = Int(channel.statistics.viewCount) ?? 0
            videoCount = Int(channel.statistics.videoCount) ?? 0
            lastUpdated = Date()
            isLoading = false
            
        } catch let decodingError as DecodingError {
            errorMessage = "데이터 파싱 오류: \(decodingError.localizedDescription)"
            isLoading = false
        } catch {
            errorMessage = "네트워크 오류: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    // MARK: - Helper Functions
    private func buildURL() -> URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "part", value: "statistics"),
            URLQueryItem(name: "id", value: channelId),
            URLQueryItem(name: "key", value: apiKey)
        ]
        return components?.url
    }
}

