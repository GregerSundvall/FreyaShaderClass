Shader "Unlit/LineShader" { // path (not the asset path)
    Properties { // input data to this shader (per-material)
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _Frequency ("Blink Frequency", Float) = 1

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

            # define TAU 6.28

            struct MeshData {
                float3 vertex : POSITION;
                float2 uv0 : TEXCOORD0;

            };

            struct Interpolators {
                float4 vertex : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };

            float4 _ColorA;
            float4 _ColorB;
            float _Frequency;

            Interpolators vert ( MeshData v ) {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                i.uv0 = v.uv0;

                return i;
            }

            float4 frag (Interpolators i) : SV_Target {
                float t = sin(_Frequency * _Time.y * TAU) * 0.5 + 0.5; // SIne wave (Harmonic oscillation
                // float t = frac(_Time.y); // sawtooth wave
                // float t = round(frac(_Time.y)); // Square wave
                // float t = frac(_Time.y * _Frequency);

                float2 coords = i.uv0;
                float3 colorA = _ColorA.xyz;
                float3 colorB = _ColorB.xyz;
                
                float asdf = normalize(i.uv0.x * t);
                float4 colorsasdf = round(lerp(_ColorA, _ColorB, frac(coords.x + t)));
                
                //float4 colors = _ColorA * coords.x + _ColorB * coords.y;
                
                // float4 color = lerp(_ColorA, _ColorB, i.uv0.x);
                float4 color = float4(frac(coords + t), 0, 1);
                float4 color2 = float4(frac(coords + t), 0, 1);
                
                // return float4(coords, 0,1);
                return colorsasdf;
            }
            ENDCG
        }
    }
}