function hasSpaceForItem( ... )
	return call( getResourceFromName( "vrp_items" ), "hasSpaceForItem", ... )
end

function hasItem( element, itemID, itemValue )
	return call( getResourceFromName( "vrp_items" ), "hasItem", element, itemID, itemValue )
end

function getItemName( itemID )
	return call( getResourceFromName( "vrp_items" ), "getItemName", itemID )
end
