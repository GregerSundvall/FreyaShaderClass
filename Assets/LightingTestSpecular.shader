Shader "Unlit/LightingTestSpecular"{
    Properties {
        _MainTex("Main texture", 2D) = "white" {}
        _Color ("Color", Color) = (0,0,0,1)
        _Gloss ("Gloss", Range(0,1)) = 1
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        Pass {
            Tags { "LightMode"="ForwardBase" }
                
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct MeshData {
                float3 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv0 : TEXCOORD0;
            };

            struct Interpolators {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
                float3 wPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            float4 _Color;
            sampler2D _MainTex;
            float _Gloss;

            Interpolators vert (MeshData v) {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(UNITY_MATRIX_M, float4(v.vertex,1) ); // local to world
                o.uv = v.uv0;
                return o;
            }

            float4 frag (Interpolators i) : SV_Target {

                // normalize our normals
                i.normal = normalize(i.normal);
                
                // diffuse lighting
                float3 lightDir = UnityWorldSpaceLightDir(i.wPos);
                float lambert = saturate(dot(i.normal,lightDir));
                float3 lightColor = _LightColor0;
                float3 diffuse = lambert*lightColor;
                
                float3 surfaceColor = tex2D( _MainTex, i.uv );

                // specular lighting
                float3 V = normalize(_WorldSpaceCameraPos - i.wPos ); // direction to camera (view vector)
                float3 H = normalize( lightDir + V );
                float specExp = exp2(1+_Gloss*12);
                float specular = pow( max(0,dot(H,i.normal)), specExp ) * lightColor;
                
                //return float4(surfaceColor*diffuse + specular,1);
                return pow(1 - dot(i.normal, V), specExp);;
            }
            ENDCG
        }
    }
}