function startImageDownload( playerToReceive )
    fetchRemote ( "http://www.example.com/image.jpg", myCallback, "", false, playerToReceive )
end
 
function myCallback( responseData, errno, playerToReceive )
    if errno == 0 then
        triggerClientEvent( playerToReceive, "onClientGotImage", resourceRoot, responseData )
    end
end