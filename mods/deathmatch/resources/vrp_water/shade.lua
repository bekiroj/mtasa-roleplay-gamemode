water = {}
water.textures = {["/dds/smallnoise3d.dds"] = 'sRandomTexture',["/dds/cube_env256.dds"] = 'sReflectionTexture'}

function water:shade() if getVersion ().sortable < "1.1.0" then return false end self.shader = DxShader("components/shader/water.fx"); if not self.shader then return false end for i,v in pairs(self.textures) do self.texture = DxTexture('components/'..i); self.shader:setValue(v,self.texture) end self.shader:applyToWorldTexture('waterClear256') return true end
function water:set() if water:shade() then local r,g,b,a = 0, 128, 255, 150; self.shader:setValue("sWaterColor", r/255, g/255, b/255, a/255); end end
water:set()