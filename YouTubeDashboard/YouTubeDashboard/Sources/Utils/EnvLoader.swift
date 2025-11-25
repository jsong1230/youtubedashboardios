import Foundation

class EnvLoader {
    static let shared = EnvLoader()
    
    private var env: [String: String] = [:]
    
    private init() {
        loadEnv()
    }
    
    private func loadEnv() {
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
            print("⚠️ .env file not found in bundle")
            return
        }
        
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            
            for line in lines {
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Skip empty lines and comments
                if trimmedLine.isEmpty || trimmedLine.hasPrefix("#") {
                    continue
                }
                
                // Parse KEY=VALUE format
                let parts = trimmedLine.split(separator: "=", maxSplits: 1)
                if parts.count == 2 {
                    let key = String(parts[0]).trimmingCharacters(in: .whitespaces)
                    let value = String(parts[1]).trimmingCharacters(in: .whitespaces)
                    env[key] = value
                }
            }
        } catch {
            print("⚠️ Error loading .env file: \(error.localizedDescription)")
        }
    }
    
    func get(_ key: String) -> String? {
        return env[key]
    }
    
    func get(_ key: String, defaultValue: String) -> String {
        return env[key] ?? defaultValue
    }
}

