clearlights = {}
	function clearlights:set() self.shader = DxShader('components/light_disable.fx',0,0,false,"object") if not self.shader then return root:setData('shader:clearlights',false) end self.shader:applyToWorldTexture("*")  return root:setData('shader:clearlights',true) end
	clearlights:set()
