https://insights.stackoverflow.com/survey/2018#most-popular-technologies
https://insights.stackoverflow.com/survey/2019#most-popular-technologies
https://medium.com/@chungbkhn87/why-should-we-use-swift-over-objective-c-78b71725e63f

Don’t:

func print(_ string: String, options: String?) { ... }
func print(_ string: String) {
  print(string, options: nil)
}

Do:
func print(_ string: String, options: String? = nil) { ... }


Don’t:
if let _ = name {
  print("Name is not nil.")
}

Do:
if name != nil {
  print("Name is not nil.")
}

Don’t:

static let kAnimationDuration: TimeInterval = 0.3
static let kLowAlpha = 0.2
static let kAPIKey = "13511-5234-5234-59234"

Do:

enum Constant {
  enum UI {
    static let animationDuration: TimeInterval = 0.3
    static let lowAlpha: CGFloat = 0.2  
  }
  enum Analytics {
    static let apiKey = "13511-5234-5234-59234"
  }
}