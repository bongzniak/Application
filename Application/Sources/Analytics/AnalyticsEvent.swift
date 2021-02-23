//
//  AnalyticsEvent.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 09/06/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Firebase
import Umbrella

typealias MyAppAnalytics = Umbrella.Analytics<AnalyticsEvent>

enum AnalyticsEvent {
  case login
  case logout
}

extension AnalyticsEvent: EventType {
   func name(for provider: ProviderType) -> String? {
    switch self {
    case .login:
      switch provider {
      case is FirebaseProvider:
        return Firebase.AnalyticsEventLogin
      default:
        return "login"
      }

    case .logout:
      return "logout"
    }
  }

  func parameters(for provider: ProviderType) -> [String: Any]? {
    switch self {
    default:
      return nil
    }
  }
}
