//
//  UIColorTheme.swift
//  MyApp
//
//  Created by bongzniak on 2020/12/28.
//

import UIKit

enum Theme: Int {
  case light
  case dark
}

protocol BaseColor {
  static var background: UIColor { get }
  static var border: UIColor { get }
}

struct ThemeColor: BaseColor {
  static var background: UIColor {
    LightThemeColor.background
  }
  static var border: UIColor {
    LightThemeColor.background
  }
}

struct LightThemeColor: BaseColor {
  static var background: UIColor {
    0xF4F4F4.color
  }
  static var border: UIColor {
    0xF4F4F4.color
  }
}

struct DarkThemeColor: BaseColor {
  static var background: UIColor {
    0xF4F4F4.color
  }
  static var border: UIColor {
    0xF4F4F4.color
  }
}
