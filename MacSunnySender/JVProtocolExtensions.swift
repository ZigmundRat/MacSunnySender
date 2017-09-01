import Foundation


// Create a protocol (that can be imposed on any object)
protocol fullyExtendable{

	func extensionProperty(key:String)->Any?
	func extensionProperty(key:String, value:Any?)
}

// The protocol extension that acts as the protocols implementation
extension fullyExtendable{
	
	func extensionProperty(key:String)->Any?{
		var mutableKey = key
		return objc_getAssociatedObject(self, &mutableKey);
	}
	
	func extensionProperty(key:String, value:Any?){
		var mutableKey = key
		objc_setAssociatedObject(self, &mutableKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}
}

