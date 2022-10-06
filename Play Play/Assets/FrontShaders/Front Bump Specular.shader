Shader "Front/Front Bumped Specular" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_SpecMap ("Specular Map", 2D) = "white" {}
}
SubShader { 
	//Using the transparent queue +50 ensures us that this object will be rendered after all other
	//transparent objects, removing any possible alpha depth bugs. Using the transparent queue
	//instead of the geometry queue enables us to ignore zwriting properly
	Tags { "Queue"="Transparent+50" "IgnoreProjector"="True" "RenderType"="Transparent" }
	LOD 400
	ZTest Always
	ZWrite Off
	Fog { Mode Off }
	
CGPROGRAM
#pragma surface surf BlinnPhong
//One negative to adding the specular map to this shader was the need to up the target shader model 
//from 2.0 to  Shader model 3.0, hence '#pragma target 3.0'
#pragma target 3.0

sampler2D _MainTex;
sampler2D _BumpMap;
sampler2D _SpecMap;
fixed4 _Color;
half _Shininess;

struct Input {
	float2 uv_MainTex;
	float2 uv_BumpMap;
	float2 uv_SpecMap;
};

void surf (Input IN, inout SurfaceOutput o) {
	//I added a specular map to this modified bumped spec shader to better use the specular component
	//Typically the spec map should be a black and white image where black represents flat areas and
	//white represents shiny areas.
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 specTex = tex2D(_SpecMap, IN.uv_SpecMap);
	o.Albedo = tex.rgb * _Color.rgb;
	o.Gloss = tex.a* specTex.rgb;
	o.Alpha = tex.a * _Color.a;
	o.Specular = _Shininess * specTex.rgb;
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
}
ENDCG
}

FallBack "Specular"
}
