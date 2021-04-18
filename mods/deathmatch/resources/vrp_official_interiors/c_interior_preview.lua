local showIntPreview = false

addEvent( "onClientGotImage", true )
addEventHandler( "onClientGotImage", resourceRoot,
    function( pixels )
        if myTexture then
            destroyElement( myTexture )
        end
        myTexture = dxCreateTexture( pixels )
    end
)

function toggleInteriorPreviewer(state)
	showIntPreview = state
end