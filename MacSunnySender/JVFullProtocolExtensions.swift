import Foundation
import ObjectiveC

// Create a protocol that can be imposed on any Class (but not on a value type)
protocol fullyExtendable{
	func extensionProperty(key:inout String)->Any?
	func extensionProperty(key:inout String,value:Any?)
}

// The protocol extension that acts as the protocols implementation
extension fullyExtendable{
	
	func extensionProperty(key:inout String)->Any?{
		return objc_getAssociatedObject(self, &key)
	}
	
	func extensionProperty(key:inout String, value:Any?){
		objc_setAssociatedObject(self, &key, "anassociated value", objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}
}

