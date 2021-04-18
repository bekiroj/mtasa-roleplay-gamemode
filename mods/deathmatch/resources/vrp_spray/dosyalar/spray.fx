// -------------------- //
// -------------------- //
// ------ HL-RPG ------ //
// ------ XENIUS ------ //
// ------- 2014 ------- //
// ------ HL-RPG ------ //
// -------------------- //
// -------------------- //

// Beállítások //
float4 gSprayColor = float4(255,255,255,200); // A spray alapértelmezett színje //
float4x4 gWorld : WORLD; // Ez nélkül nem indul el, world textúra //
float4x4 gView : VIEW; // Csak megnézzük, nem csinálunk vele mást //
float4x4 gProjection : PROJECTION;

// Funkciók //
texture gTexture0           < string textureState="0,Texture"; >;

// Sampler betöltése //
sampler texsampler = sampler_state{
    Texture = (gTexture0);
};

// Shader Input //
struct VertexShaderInput{
    float3 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoords : TEXCOORD0;
};

// PixelShaderInput //
struct PixelShaderInput{
    float4 Position  : POSITION;
    float4 Diffuse : COLOR0;
    float2 TexCoords : TEXCOORD0;
};

PixelShaderInput VertexShaderFunction(VertexShaderInput In){
    PixelShaderInput Out = (PixelShaderInput)0;
	float4 posWorld = mul(float4(In.Position,1), gWorld);
    float4 posWorldView = mul(posWorld, gView);
    Out.Position = mul(posWorldView, gProjection);
	Out.TexCoords = In.TexCoords;
    Out.Diffuse = saturate(gSprayColor);
    return Out;
}

float4 PixelShaderFunction(PixelShaderInput In) : COLOR0{
	float4 texel = tex2D(texsampler, In.TexCoords);
	float4 finalColor = texel * In.Diffuse;
	finalColor *= 0.23;
    return finalColor;
}

technique spray{
    pass P0{
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}


technique fallback{
    pass P0{
    }
}