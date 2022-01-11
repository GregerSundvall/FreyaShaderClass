Shader "Unlit/SnowcappedTopsShader"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        
        _MainTex ("Texture", 2D) = "white" {}
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
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            float4 _ColorA;
            float4 _ColorB;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                i.uv0 = TRANSFORM_TEX(v.uv0, _MainTex);

                // transforms from local space to clip space
                // usually using the matrix called UNITY_MATRIX_MVP
                // model-view-projection matrix (local to clip space)
                i.vertex = UnityObjectToClipPos(v.vertex);
                // pass coordinates to the fragment shader
                i.worldNormal = UnityObjectToWorldNormal( v.normal );
                i.worldPos = mul( UNITY_MATRIX_M, float4( v.vertex) ); // world space
                i.uv0 = v.uv0; // world space

                
                return i;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                // sample the texture
                float4 texColor = tex2D( _MainTex, i.uv0 );
                float4 snow = (1,1,1,.8f);
                //float angleMultiplier = i.worldNormal
                float4 color = lerp(texColor, snow, saturate(i.worldPos.y -5) * i.worldNormal.y);
                
                return color;
            }
            ENDCG
        }
    }
}
