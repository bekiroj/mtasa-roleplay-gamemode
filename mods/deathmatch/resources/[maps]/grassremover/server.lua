local shader = dxCreateShader("shader.fx")
local texture = dxCreateTexture("alpha.png")
dxSetShaderValue(shader, "gTexture", texture)

local leavesTextureNames = {
	"sm_Agave_1", "sm_josh_leaf", "sm_Agave_2", "sm_minipalm1", "sm_Agave_bloom", "clothline1_LAe", "deadpalm01", "kbplanter_plants1", "plantb256", "dead_fuzzy", "dead_agave",
	-- add texture name to the table what you want to make invisible
}

for _, name in ipairs(leavesTextureNames) do -- loader
	engineApplyShaderToWorldTexture(shader, name)
end

setWorldSpecialPropertyEnabled ( "randomfoliage", false )
removeWorldModel ( 859, 10000, 0, 0, 0 )
removeWorldModel ( 678, 10000, 0, 0, 0 )
removeWorldModel ( 677, 10000, 0, 0, 0 )
removeWorldModel ( 677, 10000, 0, 0, 0 )