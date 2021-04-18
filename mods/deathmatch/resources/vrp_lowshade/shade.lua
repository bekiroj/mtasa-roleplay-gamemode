

Lowshade = {
    debug = false,
    texturelist = {
        {"components/2.png", "particleskid"},
        {"components/3.png", "cloudmasked"},
        {"components/3.png", "cardebris_01"},
        {"components/3.png", "cardebris_02"},
        {"components/3.png", "cardebris_03"},
        {"components/3.png", "cardebris_04"},
        {"components/3.png", "cardebris_05"},
        {"components/3.png", "cloudhigh"},
        {"components/off.png", "vehiclelights128"},
        {"components/on.png", "vehiclelightson128"},
    },

    index = function(self)
        
        for i = 1, #self.texturelist do 
            shader = DxShader("components/shader/texture.fx")
            shader:applyToWorldTexture(self.texturelist[i][2])
            shader:setValue('gTexture', DxTexture(self.texturelist[i][1]))
        end
        
        if self.debug then 
        end
    end,
}
Lowshade:index()