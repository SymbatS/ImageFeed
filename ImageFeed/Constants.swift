import UIKit

enum Constants {
    static let accessKey = "TkhEU6rte3XjdEeImKNrfZtMqd1l0jl9ORTklWRuKYQ"
    static let secretKey = "lM72cAjPidpE6RaiwZpVGC9_WIZPsT06jJGZrqt5rdA"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static var defaultBaseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {
            fatalError("Invalid URL for defaultBaseURL")
        }
        return url
    }
}
