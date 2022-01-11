Shader "Unlit/HeightByBrightnessShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Height ("Height", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv0 : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Height;

            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.uv0 = TRANSFORM_TEX(v.uv0, _MainTex);

                float4 color = tex2Dlod(_MainTex, float4(v.uv0, 0, 0));
                float brightness = (color.r + color.g + color.b) / 3;
                v.vertex.y += brightness * _Height;
                
                i.vertex = UnityObjectToClipPos(v.vertex); // Goes last! Final setting of positions.
                return i;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                float4 texColor = tex2D( _MainTex, i.uv0 );
                
                return texColor;
            }
            ENDCG
        }
    }
}
