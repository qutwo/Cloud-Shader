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
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
        
            #include "UnityCG.cginc"


            sampler2D _MainTex;
            sampler2D _CameraDepthTexture;
            sampler2D _GrabTexture;
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
               
               if((sign(sdfSphere(i.vertex.rgb,float3(750,450,500),500)))<0)
               {
                    return float4(1,1,1,1);
               }
               return float4(0,0,0,0);
            }
            ENDCG
            
               
        }
    }
}
