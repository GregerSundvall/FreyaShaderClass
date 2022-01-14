// #define TAU 6.28318530718
// // #include <UnityShaderVariables.cginc>
// //#include "UnityCG.cginc"
//
// // v =  lerp(a,b,t)
// // t = ilerp(a,b,v)
// float InvLerp( float a, float b, float v ){
//     return (v-a)/(b-a);
// }
// float4 InvLerp( float4 a, float4 b, float4 v ){
//     return (v-a)/(b-a);
// }
//
// float Lambert( float3 N, float3 L ) {
//     return saturate(dot(N,L));
// }
//
// float BlinnPhong( float3 N, float3 L, float3 V, float specExp ) {
//     float3 H = normalize( L + V );
//     return pow( max(0,dot(H,N)), specExp );
// }
//
// float3 ApplyLighting( float3 surfColor, float3 N, float3 wPos, float gloss ) {
//
//     // diffuse lighting
//     float3 L = UnityWorldSpaceLightDir(wPos); // light direction
//     float3 lightColor = _LightColor0;
//     float3 diffuse = Lambert(N,L)*lightColor;
//
//     // specular lighting
//     float3 V = normalize(_WorldSpaceCameraPos - wPos ); // direction to camera (view vector)
//     float specExp = exp2(1+gloss*12);
//     float specular = BlinnPhong(N,L,V,specExp) * lightColor;
//
//     // composite and return
//     return surfColor*diffuse + specular;
// }