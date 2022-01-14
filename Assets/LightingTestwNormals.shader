Shader "Unlit/LightingTestwNormals"{
    Properties {
        _MainTex("Main texture", 2D) = "white" {}
        _NormalMap("Normals", 2D) = "bump" {}
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
            // #include "SharedFunctions.cginc"
            // #include "UnityLightingCommon.cginc"
            
            struct MeshData {
                float3 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT; // tangent dir = xyz, w = flip sign
                float2 uv0 : TEXCOORD0;
            };

            struct Interpolators {
                float4 vertex : SV_POSITION;
                float3 wPos : TEXCOORD0;
                float2 uv : TEXCOORD1;
                float3 normal : TEXCOORD2;
                float3 tangent : TEXCOORD3;
                float3 bitangent : TEXCOORD4;
            };

            float4 _Color;
            sampler2D _MainTex;
            sampler2D _NormalMap;
            float _Gloss;

            Interpolators vert (MeshData v) {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                // setting up tangent space
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.tangent = UnityObjectToWorldDir(v.tangent.xyz);
                float flipSign = v.tangent.w * unity_WorldTransformParams.w;
                o.bitangent = cross(o.normal, o.tangent) * flipSign;
                
                o.wPos = mul(UNITY_MATRIX_M, float4(v.vertex,1) ); // local to world
                o.uv = v.uv0;
                return o;
            }

            float3 frag (Interpolators i) : SV_Target {

                // normalize our stuff, if we want!
                i.tangent = normalize(i.tangent);
                i.bitangent = normalize(i.bitangent);
                i.normal = normalize(i.normal);

                // tangent space normal
                float3 tsNormal = UnpackNormal(tex2D( _NormalMap, i.uv )); // unpack unity's weird format

                // construct tangent space matrices
                float3x3 mtxWorldToTang = float3x3( i.tangent, i.bitangent, i.normal );
                float3x3 mtxTangToWorld = transpose( mtxWorldToTang );

                // transform from tangent space normals to world space normals
                float3 N = mul( mtxTangToWorld, tsNormal );
                
                float3 surfaceColor = tex2D( _MainTex, i.uv );
                return surfaceColor; //ApplyLighting( surfaceColor, N, i.wPos, _Gloss );
            }
            ENDCG
        }
    }
}