Shader"Unlit/Toonelize"
{
    Properties
    {
        _Albedo("Albedo",Color) = (1,1,1,1)
        _Shades("Shades", Range(1,20)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float worldNormal : TEXCOORD0;
            };
            float4 _Albedo;
            float _Shades;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //cari cos angle cahaya dan vektor normal
                //normalize vektor _WorldSpaceLightPos0 dan i.worldNormal lalu cari dot product matrixnya
                float cosineAngle = dot(normalize(i.worldNormal), normalize(_WorldSpaceLightPos0.xyz));
                //set min ke 0 kalau cahaya dibalik benda
                cosineAngle = max(cosineAngle,0.0);
    
                cosineAngle = floor(cosineAngle * _Shades) / _Shades;
    
                return _Albedo * cosineAngle;
            }
            ENDCG
        }
    }
}
