Shader "Unlit/Raymarch"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "black" {}
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


            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 wPos : TEXCOORD1;
            };

            float sdfSphere(float3 refrence, float3 centre,float r)
            {
                return length(refrence - centre)-r;
            }
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.wPos = mul(unity_ObjectToWorld,v.vertex);
           
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // sample the texture
             
            
                return -sign(sdfSphere(i.wPos.rgb,float3(0,0,0),3.2));
            }
            ENDCG
        }
    }
}
