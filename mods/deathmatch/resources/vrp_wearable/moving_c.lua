local sx, sy = guiGetScreenSize()
local self = {};
self.right = 0.715
self.bottom = 0.997
self.cuboid = 6
self.linecolors = {
  [2] = {215, 89, 89, 230, 0.5},--x
  [4] = {255, 0, 0, 230, 0.5},--y
  [6] = {181, 34, 203, 230, 0.5},--z
}
self.localisation = {}
self.clicked = false
self.cursortable = {}
self.defaultAttachPositions = {
  [1] = {0.5, 0, 0.6},
  [2] = {-0.5, 0, 0.6},
  [3] = {0, 0.5, 0.6},
  [4] = {0, -0.5, 0.6},
  [5] = {0, 0, 0.1},
  [6] = {0, 0, 1},
}

self.activeSlot = "arrowicon.png";

local x, y, z = 0.001, 0.001, 0.001
local rx, ry, rz = 1, 1, 1
local scale = 0.01
local wearable_bone = 1

local default_position = {0, 0, 0, 0, 0, 0, 1, 1, 1}
local cuboid_data = {0, 0, 0, 0.1, 0.1, 0.1}

local positions = {
  cuboids = {},
  images = {
    ["saveicon.png"] = {true, -55, 70, 1, {0, 0, 0, 0}, false, color = tocolor(175, 175, 175), src = "save.png"},
    ["arrowicon.png"] = {true, 20, 70, 1, {0, 0, 0, 0}, false, color = tocolor(225, 225, 225), src = "move.png"},
    ["rotation.png"] = {true, -5, 70, 1, {0, 0, 0, 0}, false, color = tocolor(225, 225, 225), src = "rotate.png"},
    ["resizeicon.png"] = {true, -30, 70, 1, {0, 0, 0, 0}, false, color = tocolor(225, 225, 225), src = "scale.png"},
    
    ["arrowiconx.png"] = {true, 20, 40, 6, {0, 0, 0, 0}, false, color = tocolor(255,39,39), src = "move.png"},
    ["arrowicony.png"] = {true, 20, 40, 3, {0, 0, 0, 0}, false, color = tocolor(124,197,118), src = "move.png"},
    ["arrowiconz.png"] = {true, 20, 40, 2, {0, 0, 0, 0}, false, color = tocolor(75,123,236), src = "move.png"},
    
    ["resizeiconx.png"] = {false, 20, 40, 6, {0, 0, 0, 0}, false, color = tocolor(255,39,39), src = "scale.png"},
    ["resizeicony.png"] = {false, 20, 40, 3, {0, 0, 0, 0}, false, color = tocolor(124,197,118), src = "scale.png"},
    ["resizeiconz.png"] = {false, 20, 40, 2, {0, 0, 0, 0}, false, color = tocolor(75,123,236), src = "scale.png"},
    
    ["rotationx.png"] = {false, 20, 40, 6, {0, 0, 0, 0}, false, color = tocolor(255,39,39), src = "rotate.png"},
    ["rotationy.png"] = {false, 20, 40, 3, {0, 0, 0, 0}, false, color = tocolor(124,197,118), src = "rotate.png"},
    ["rotationz.png"] = {false, 20, 40, 2, {0, 0, 0, 0}, false, color = tocolor(75,123,236), src = "rotate.png"},
  }
}

function drawnArtifacts()
    create_lines()
    icon_handler()
    create_icons()
end

function wearable_is_main_icon(index)
    local MAIN_ICON_TABLE = {
      ["arrowicon.png"] = true,
      ["rotation.png"] = true,
      ["resizeicon.png"] = true
    }
    if MAIN_ICON_TABLE[index] and positions.images[index][6] then
      return true
    end
end

function wearable_update_position(bool)
    if (bool == true) then
      x, y, z = 0.001, 0.001, -0.001
      rx, ry, rz = 1, 1, 1
      scale = 0.01
    elseif (bool == false) then
      x, y, z = -0.001, -0.001, 0.001
      rx, ry, rz = -1, -1, -1
      scale = -0.01
    end
end

function shutdown_moving()
    wearable_now_icon("move.png")
    if isElement(object) then
      destroyElement(x_line_object)
      destroyElement(y_line_object)
      destroyElement(z_line_object)
      for index = 1, self.cuboid do
        local cuboid_element_TEMP = positions.cuboids[index]
        destroyElement(cuboid_element_TEMP)
      end
      destroyElement(object)
      default_position = {0, 0, 0, 0, 0, 0, 1, 1, 1}
      showCursor(false)
    end
    self.clicked = false
    hover_index = nil
    removeEventHandler("onClientPreRender", root, drawnArtifacts)
end
addEventHandler("accounts:characters:spawn", root, shutdown_moving)

function wearable_now_icon(now_icon)
  local toggle_icons = {}
  toggle_icons['enable'] = {};
  toggle_icons['disable'] = {};
  if wearable_is_main_icon(now_icon) then
    return
  end
  if now_icon == "saveicon.png" then
    do
      local CURRENT_ITEM_POSITION = {
        objectID = objectID,
        bone = wearable_bone,
        dbid = objectDBID,
        position = {
          default_position[1],
          default_position[2],
          default_position[3],
          default_position[4],
          default_position[5],
          default_position[6],
          default_position[7],
          default_position[8],
          default_position[9]
        },
        default = default_pos
      }
      triggerServerEvent("wearable.savePositions", localPlayer, localPlayer, CURRENT_ITEM_POSITION)
      shutdown_moving()
    end
  elseif now_icon == "arrowicon.png" then
    toggle_icons = {
      ['enable'] = {"arrowiconx.png", "arrowicony.png", "arrowiconz.png"},
      ['disable'] = {"rotationx.png", "rotationy.png", "rotationz.png", "resizeiconx.png", "resizeicony.png", "resizeiconz.png"},
    };
    self.activeSlot = "arrowicon.png";
  elseif now_icon == "rotation.png" then
    toggle_icons = {
      ['enable'] = {"rotationx.png", "rotationy.png", "rotationz.png"},
      ['disable'] = {"arrowiconx.png", "arrowicony.png", "arrowiconz.png", "resizeiconx.png", "resizeicony.png", "resizeiconz.png"},
    };
    self.activeSlot = "rotation.png";
  elseif now_icon == "resizeicon.png" then
    toggle_icons = {
      ['enable'] = {"resizeiconx.png", "resizeicony.png", "resizeiconz.png"},
      ['disable'] = {"arrowiconx.png", "arrowicony.png", "arrowiconz.png", "rotationx.png", "rotationy.png", "rotationz.png"},
    };
    self.activeSlot = "resizeicon.png";
  end
  for _, data_enable in ipairs(toggle_icons['enable']) do
    positions.images[data_enable][1] = true
    positions.images[data_enable][6] = false
  end
  for _, data_enable in ipairs(toggle_icons['disable']) do
    positions.images[data_enable][1] = false
    positions.images[data_enable][6] = false
  end
end
function wearable_on_click_handler(button, state)
  if hover_index then
    if button == "left" and state == "down" then
      self.clicked = true
      if hover_index == "saveicon.png" then
        wearable_now_icon(hover_index)
      elseif hover_index == "arrowicon.png" then
        wearable_now_icon(hover_index)
      elseif hover_index == "rotation.png" then
        wearable_now_icon(hover_index)
      elseif hover_index == "resizeicon.png" then
        wearable_now_icon(hover_index)
      end
      return
    else
      self.clicked = false
    end
  elseif self.clicked then
    self.clicked = false
  end
  self.cursortable = {}
end
addEventHandler("onClientClick", root, wearable_on_click_handler)

function mouse_move_handler(_, _, C_X, C_Y, w_x, w_y, w_z)
    if hover_index and self.clicked and isCursorShowing() then
      if not next(self.cursortable) then
        self.cursortable = {
          C_X,
          C_Y,
          w_x,
          w_y,
          w_z
        }
      end
     
      cur_x, cur_y, cursor_wx, cursor_wy, cursor_wz = unpack(self.cursortable)
 
      self.localisation = {
        X = {cursor_wx, w_x},
        Y = {cursor_wy, w_y},
        Z = {cursor_wz, w_z}
      }
      if string.find(hover_index, "x") then
        CACHE_CHECK, CURR_CHECK = unpack(self.localisation.X)
      elseif string.find(hover_index, "y") then
        CACHE_CHECK, CURR_CHECK = unpack(self.localisation.Y)
      elseif string.find(hover_index, "rotationz") then
        CACHE_CHECK, CURR_CHECK = unpack(self.localisation.Y)
      elseif string.find(hover_index, "z") then
        CACHE_CHECK, CURR_CHECK = unpack(self.localisation.Z)
      else
        return
      end
      if CURR_CHECK < CACHE_CHECK then
        wearable_update_position(true)
      elseif CURR_CHECK > CACHE_CHECK then
        wearable_update_position(false)
      end
      if hover_index == "arrowiconx.png" then
        wearable_move_object("X")
      elseif hover_index == "arrowicony.png" then
        wearable_move_object("Y")
      elseif hover_index == "arrowiconz.png" then
        wearable_move_object("Z")
      elseif hover_index == "rotationx.png" then
        wearable_move_object("RX")
      elseif hover_index == "rotationy.png" then
        wearable_move_object("RY")
      elseif hover_index == "rotationz.png" then
        wearable_move_object("RZ")
      elseif string.find(hover_index, "resizeiconx.png") then
        wearable_move_object("OCX")
      elseif string.find(hover_index, "resizeicony.png") then
        wearable_move_object("OCY")
      elseif string.find(hover_index, "resizeiconz.png") then
        wearable_move_object("OCZ")
      end
      setCursorPosition(cur_x, cur_y)
    end
end
addEventHandler("onClientCursorMove", root, mouse_move_handler)

function wearable_check_position_exist()
    triggerServerEvent("wearable-system:requestPosition", localPlayer)
end

function wearable_recieve_position(ITEM_POSITION)
  if type(ITEM_POSITION) == "table" then
    exports.vrp_bone_attach:detachElementFromBone(object)
    local ITEM_X, ITEM_Y, ITEM_Z, ITEM_RX, ITEM_RY, ITEM_RZ, ITEM_SCALE = ITEM_POSITION[1], ITEM_POSITION[2], ITEM_POSITION[3], ITEM_POSITION[4], ITEM_POSITION[5], ITEM_POSITION[6], ITEM_POSITION[7]
    default_position = {
      ITEM_X,
      ITEM_Y,
      ITEM_Z,
      ITEM_RX,
      ITEM_RY,
      ITEM_RZ,
      ITEM_SCALE
    }
    exports.vrp_bone_attach:attachElementToBone(object, localPlayer, wearable_bone, ITEM_X, ITEM_Y, ITEM_Z, ITEM_RX, ITEM_RY, ITEM_RZ)
    setObjectScale(object, ITEM_SCALE)
    outputChatBox("Your previous set position has been retrieved!")
  end
end
addEvent("wearable-system:recievePosition", true)
addEventHandler("wearable-system:recievePosition", root, wearable_recieve_position)

function moving_object(objectID, dbid)
  objectDBID = dbid;
  default_pos, wearable_bone = findThemBonePosition(objectID);
  outputChatBox(wearable_bone)
  local bn, by, bz = getPedBonePosition(localPlayer, wearable_bone)
  object = createObject(objectID, 0, 0, 0)
  self.activeSlot = "arrowicon.png";
  local _, _, X_ATTACH, Y_ATTACH, Z_ATTACH, RX_ATTACH, RY_ATTACH, RZ_ATTACH = exports.vrp_bone_attach:getElementBoneAttachmentDetails(object)
  exports.vrp_bone_attach:attachElementToBone(object, localPlayer, wearable_bone, 0, 0, 0, 0, 0, 0)
  for index = 1, self.cuboid do
    local cubx, cuby, cubz, CUB_WIDTH, CUB_DEPTH, CUB_HEIGHT = unpack(cuboid_data)
    local X_OFF, Y_OFF, Z_OFF = unpack(self.defaultAttachPositions[index])
    local cuboid_element_TEMP = createColCuboid(cubx, cuby, bz, CUB_WIDTH, CUB_DEPTH, CUB_HEIGHT)
    attachElements(cuboid_element_TEMP, object, X_OFF, Y_OFF, 0, RX_ATTACH, RY_ATTACH, RZ_ATTACH)
    positions.cuboids[index] = cuboid_element_TEMP
  end
 
  x_line_object = createObject(1239, 0, 0, 0)
  setElementAlpha(x_line_object, 0)
  attachElements(x_line_object, object, 0.6, 0, 0, 0, 0, 0)
  setElementCollisionsEnabled(x_line_object, false)

  y_line_object = createObject(1239, 0, 0, 0)
  setElementAlpha(y_line_object, 0)
  attachElements(y_line_object, object, 0, 0.6, 0, 0, 0, 0)
  setElementCollisionsEnabled(y_line_object, false)

  z_line_object = createObject(1239, 0, 0, 0)
  setElementAlpha(z_line_object, 0)
  attachElements(z_line_object, object, 0, 0, 0.6, 0, 0, 0)
  setElementCollisionsEnabled(z_line_object, false)
  
  addEventHandler("onClientPreRender", root, drawnArtifacts)
  setElementDimension(object, getElementDimension(localPlayer))
  setElementInterior(object, getElementInterior(localPlayer))
end
function create_lines()
  local x, y, z = getElementPosition(object);
  local x2, y2, z2 = getElementPosition(x_line_object);
  dxDrawLine3D(x, y, z, x2, y2, z2, tocolor(255,39,39), 0.6)

  local x2, y2, z2 = getElementPosition(y_line_object);
  dxDrawLine3D(x, y, z, x2, y2, z2, tocolor(124,197,118), 0.6)

  local x2, y2, z2 = getElementPosition(z_line_object);
  dxDrawLine3D(x, y, z, x2, y2, z2, tocolor(75,123,236), 0.6)
  --[[
    local count = 0
    for index = 1, self.cuboid do
      count = count + 1
      local cuboid_element = positions.cuboids[index]
      if count == 2 then
        count = 0
        local X_R, Y_R, Z_R = getElementPosition(cuboid_element)
        local X_L, Y_L, Z_L = getElementPosition(positions.cuboids[index - 1])
        local R, G, B, A, LINE_THICK = unpack(self.linecolors[index])
        dxDrawLine3D(X_L, Y_L, Z_L, X_R, Y_R, Z_R, tocolor(R, G, B, A), LINE_THICK)
      end
    end
  ]]--
end
function icon_handler()
    local cur_x, cur_y
    self.overlay = false
    if not self.clicked and hover_index then
      hover_index = nil
    end
    if not isCursorShowing() then
      cur_x, cur_y = 0, 0
    else
      cur_x, cur_y = getCursorPosition()
    end
    cur_x, cur_y = cur_x * sx, cur_y * sy
    for index, data in pairs(positions.images) do
        local shownImage, _, _, _, dx_table = unpack(data)
        local ix, iy, iw, ih = unpack(dx_table)
        if shownImage then
          if ix ~= 0 or iy ~= 0 then
            if isInSlot3D(cur_x, cur_y, ix, iy, iw, ih) then
              if self.clicked then
                if index ~= hover_index then
                  self.overlay = true
                else
                  self.overlay = false
                end
              end
              if not self.overlay then
                hover_index = index
              end
            end
          end
        end
    end
end
function create_icons()
    for index, data in pairs(positions.images) do
      local shownImage, ix, iy, cubRoot = unpack(data)
      local cuboid_element = positions.cuboids[cubRoot]
      local cubx, cuby, cubz = getElementPosition(cuboid_element)
      if index == "arrowiconx.png" or index == "rotationx.png" or index == "resizeiconx.png" then
        cubx, cuby, cubz = getElementPosition(x_line_object)
      elseif index == "arrowicony.png" or index == "rotationy.png" or index == "resizeicony.png" then
        cubx, cuby, cubz = getElementPosition(y_line_object)
      elseif index == "arrowiconz.png" or index == "rotationz.png" or index == "resizeiconz.png" then
        cubx, cuby, cubz = getElementPosition(z_line_object)
      else
        cubx, cuby, cubz = getElementPosition(object)
      end
      if shownImage then
        local SCREEN_X, SCREEN_Y = getScreenFromWorldPosition(cubx, cuby, cubz, 0, false)
        
        if SCREEN_X or SCREEN_Y then
          SCREEN_Y = SCREEN_Y + 20
          local cx, cy, cz, _, _, _, _, cfov = getCameraMatrix()
          local cam_dist = getDistanceBetweenPoints3D(cubx, cuby, cubz + 0.06, cx, cy, cz)
          local U_sx = sx + self.right
          local U_sy = sy + self.bottom
          local posX = SCREEN_X - ix / cam_dist * sx / 800 / 70 * cfov
          local posY = SCREEN_Y - iy / cam_dist * sy / 600 / 70 * cfov
          local posW = 24 / cam_dist * U_sx / 800 / 70 * cfov
          local posH = 24 / cam_dist * U_sy / 600 / 70 * cfov
          positions.images[index][5] = {posX,posY,posW,posH}
          if self.activeSlot == index then
            dxDrawRectangle(posX, posY, posW, posH, tocolor(245, 245, 245))
          else
            dxDrawRectangle(posX, posY, posW, posH, data['color'])
          end
          if isInSlot(posX, posY, posW, posH) then
            dxDrawRectangle(posX, posY, posW, posH, tocolor(0, 0, 0, 100))
          end
          
          dxDrawImage(posX, posY, posW, posH, "files/"..data['src'])
        end
      end
    end
end
function wearable_move_object(POSITION_VALUE)
  exports.vrp_bone_attach:detachElementFromBone(object)
  if POSITION_VALUE == "X" then
    do
      local CURR_x = default_position[1]
      default_position[1] = CURR_x + x
    end
  elseif POSITION_VALUE == "Y" then
    do
      local CURR_y = default_position[2]
      default_position[2] = CURR_y + y
    end
  elseif POSITION_VALUE == "Z" then
    do
      local CURR_z = default_position[3]
      default_position[3] = CURR_z + z
    end
  elseif POSITION_VALUE == "RX" then
    do
      local CURR_rx = default_position[4]
      default_position[4] = CURR_rx + rx
    end
  elseif POSITION_VALUE == "RY" then
    do
      local CURR_ry = default_position[5]
      default_position[5] = CURR_ry + ry
    end
  elseif POSITION_VALUE == "RZ" then
    do
      local CURR_rz = default_position[6]
      default_position[6] = CURR_rz + rz
    end
  elseif POSITION_VALUE == "OCX" then
    local CURR_scale = default_position[7]
    default_position[7] = CURR_scale + scale
  elseif POSITION_VALUE == "OCY" then
    local CURR_scale = default_position[8]
    default_position[8] = CURR_scale + scale
  elseif POSITION_VALUE == "OCZ" then
    local CURR_scale = default_position[9]
    default_position[9] = CURR_scale + scale
  end
  local POSITION_ROWS = table.getn(default_position)
  for POSITION_OFFSET = 1, POSITION_ROWS do
    if POSITION_OFFSET > 0 and POSITION_OFFSET <= 3 then
      if default_position[POSITION_OFFSET] > 2 or default_position[POSITION_OFFSET] < -2 then
        default_position[POSITION_OFFSET] = 0
      end
    elseif POSITION_OFFSET > 3 and POSITION_OFFSET <= 6 and (default_position[POSITION_OFFSET] > 360 or default_position[POSITION_OFFSET] < -360) then
      default_position[POSITION_OFFSET] = 0
    end
  end
  rsx, rsy, rsz = getObjectScale(object)
  if rsx > 1.5 or rsx < 0.5 then
    default_position[7] = 1
  end
  if rsy > 1.5 or rsy < 0.5 then
    default_position[8] = 1
  end
  if rsz > 1.5 or rsz < 0.5 then
    default_position[9] = 1
  end
  setObjectScale(object, default_position[7], default_position[8], default_position[9])
  exports.vrp_bone_attach:attachElementToBone(object, localPlayer, wearable_bone, default_position[1], default_position[2], default_position[3], default_position[4], default_position[5], default_position[6])
end

function isInSlot3D(cur_x, cur_y, X, Y, W, H)
  local x_c = X < cur_x and cur_x < X + W
  local y_c = Y < cur_y and cur_y < Y + H
  return x_c and y_c
end