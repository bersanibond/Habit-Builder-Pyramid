

import Foundation

public struct PyramidProducts {
  
  public static let SwiftShopping = "com.henriquebersani.habitpyramid.unlimitedpyramids"
  
  public static let productIdentifiers: Set<ProductIdentifier> = [PyramidProducts.SwiftShopping]

  public static let store = IAPHelper(productIds: PyramidProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}
