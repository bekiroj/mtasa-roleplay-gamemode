local scX, scY = guiGetScreenSize();
local lps = { x = 383.705, y = -2028.377, z = 7.835, rz = 90 };  -- Position where player will be teleported after he leaves a cabin
local bdKey = { 'K', 'L' };                                      -- Keys to get inside [1] and outside [2] of the cabin ('K' and 'L' by default)
local belirlenen = dxCreateFont(":vrp_fonts/files/Roboto.ttf", 14)
local tstgs = {
  text = "Dönme dolaba binmek için '"..bdKey[ 1 ].."' tuşuna basın. Ücret: 10 $.",       -- Text that will show up when cabin gets closer to a player
  font = belirlenen,                                           -- Text font (can be a custom font too)
  scale = 0.7,                                                   -- Text scale
  color = tocolor( 255, 255, 255, 255 ),                         -- Text color
  shadow = tocolor( 0, 0, 0, 255 )                               -- Text shadow color
};

addEventHandler( 'onClientResourceStart', resourceRoot, function()
  engineReplaceCOL( engineLoadCOL( 'dosyalar/donmedolap.col' ), 3752 );
  triggerServerEvent( 'client_getCabinsCollision', localPlayer );
end );

addEventHandler( 'onClientResourceStop', resourceRoot, function()
  setCameraClip( true, true );
end );

addEventHandler( 'onClientElementStreamIn', root, function()
  if getElementModel( source ) == 3752 then
    engineReplaceCOL( engineLoadCOL( 'dosyalar/donmedolap.col' ), 3752 );
  end;
end );

addEvent( 'server_sendCabinsCollision', true );
addEventHandler( 'server_sendCabinsCollision', root, function( t )
  for i, col in ipairs( t ) do
    addEventHandler( 'onClientColShapeHit', col, function( player, dim )
      if player == localPlayer and dim then
        bindKey( bdKey[ 1 ], 'down', getInside, col );
        tstgs.text = "Dönme dolaba binmek için '"..bdKey[ 1 ].."' tuşuna basın. Ücret: 10 $.";
        addEventHandler( 'onClientRender', root, drawNotice );
        setCameraClip( false, true );
      end;
    end );
    
    addEventHandler( 'onClientColShapeLeave', col, function( player, dim )
      if player == localPlayer and dim then
        removeEventHandler( 'onClientRender', root, drawNotice );
        unbindKey( bdKey[ 1 ], 'down', getInside );
        unbindKey( bdKey[ 2 ], 'down', leaveCabin );
        setCameraClip( true, true );
      end;
    end );
  end;
end );

addEventHandler( 'onClientPlayerWasted', localPlayer, function()
  unbindKey( bdKey[ 1 ], 'down', getInside );
  unbindKey( bdKey[ 2 ], 'down', leaveCabin );
  removeEventHandler( 'onClientRender', root, drawNotice );
end );

function drawNotice()
  dxDrawText( tstgs.text, scX*0.5 - dxGetTextWidth( tstgs.text, tstgs.scale, tstgs.font )/2, scY*0.85 + 1, scX, scY, tstgs.shadow, tstgs.scale, tstgs.font );
  dxDrawText( tstgs.text, scX*0.5 - dxGetTextWidth( tstgs.text, tstgs.scale, tstgs.font )/2, scY*0.85, scX, scY, tstgs.color, tstgs.scale, tstgs.font );
end;

function getInside( key, state, col )
	if exports.vrp_global:hasMoney(getLocalPlayer(), 10) then
	  local x, y, z = getElementPosition( col );
	  setElementPosition( localPlayer, x - 0.5, y, z );
	  
	  triggerServerEvent("takeTheMoney", getLocalPlayer())
	  tstgs.text = "Dönme dolaptan inmek için '"..bdKey[ 2 ].."' tuşuna basın.";
	  unbindKey( bdKey[ 1 ], 'down', getInside );
	  bindKey( bdKey[ 2 ], 'down', leaveCabin );
	else
		outputChatBox("[!] #f0f0f0Dönme dolaba binmek için yeterli paranız yok.", 255, 0, 0, true)
	end
end;

function leaveCabin( key, state )
  setElementPosition( localPlayer, lps.x, lps.y, lps.z );
  setElementRotation( localPlayer, 0, 0, lps.rz );
  unbindKey( bdKey[ 2 ], 'down', leaveCabin );
end;