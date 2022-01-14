Shader "Unlit/Day2CodeALongBlink" { // path (not the asset path)
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
            };

            struct Interpolators {
                float4 vertex : SV_POSITION;
            };

            float4 _ColorA;
            float4 _ColorB;
            float _Frequency;

            Interpolators vert ( MeshData v ) {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                return i;
            }

            float4 frag (Interpolators i) : SV_Target {
                float t = sin(_Frequency * _Time.y * TAU) * 0.5 + 0.5; // SIne wave (Harmonic oscillation
                // float t = frac(_Time.y); // sawtooth wave
                // float t = round(frac(_Time.y)); // Square wave
                return lerp( _ColorA, _ColorB, t );
            }
            ENDCG
        }
    }
}