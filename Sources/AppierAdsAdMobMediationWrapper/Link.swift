import AppierAdsAdMobMediation

// GMA instantiates the adapter only by class name, so nothing in an SPM app
// references it and the linker would drop it from the static xcframework.
// Referencing it here keeps it linked without asking integrators for -ObjC.
public let appierAdMobAdapterClasses: [AnyClass] = [APRAdAdapter.self]
