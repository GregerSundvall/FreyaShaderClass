Shader "Unlit/SnowOnTop"{
    Properties {
        _MainTex ("Base Color", 2D) = "black" {}
        _FadeStart ("Fade Start", Range(0,1)) = 0
        _FadeEnd ("Fade End", Range(0,1)) = 1
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            #define TAU 6.28318530718
            
            struct MeshData {
                float3 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct Interpolators {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 localPos : TEXCOORD2;
                float3 normal : TEXCOORD3;
            };

            sampler2D _MainTex;
            float _FadeStart;
            float _FadeEnd;

            Interpolators vert( MeshData v ) {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                i.uv = v.uv0;
                i.localPos = v.vertex;
                i.normal = UnityObjectToWorldNormal( v.normal );
                //i.worldPos = mul(UNITY_MATRIX_M, float4(v.vertex,1));
                return i;
            }

            // v =  lerp(a,b,t)
            // t = ilerp(a,b,v)
            float InvLerp( float a, float b, float v ){
                return (v-a)/(b-a);
            }
            float InvLerp( float4 a, float4 b, float4 v ){
                return (v-a)/(b-a);
            }

            float4 frag( Interpolators i ) : SV_Target {
                float t = InvLerp( _FadeStart, _FadeEnd, i.normal.y );
                t = saturate( t ); // Mathf.Clamp01()
                float4 baseColor = tex2D( _MainTex, i.uv );
                float4 topColor = float4(1,1,1,1);
                return lerp( baseColor, topColor, t );
            }
            ENDCG
        }
    }
}