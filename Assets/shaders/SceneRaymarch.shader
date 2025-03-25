Shader "Unlit/SceneRaymarch"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
       
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
            #include "Lighting.cginc"

            sampler2D _MainTex;
            sampler2D _CameraDepthTexture;
            float4 _MainTex_ST;
            float4 Quaternion_Cam;
            float4 Quaternion_Cube1;
            float4 Quaternion_Cube2;
            float3 Pos1;
            float3 Pos2;
            float3 Size1;
            float3 Size2;
            
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

            float3 rotateVector(float3 v, float4 q)
            {
                float3 qVec = float3(q.x, q.y, q.z);
                float3 t = 2.0 * cross(qVec, v);
                return v + q.w * t + cross(qVec, t);
            }
            
         
            float smin( float a, float b, float k )
            {
                k *= 16.0/3.0;
                float h = max( k-abs(a-b), 0.0 )/k;
                return min(a,b) - h*h*h*(4.0-h)*k*(1.0/16.0);
            }

             float sdfSphere(float3 refrence, float3 centre,float r)
            {
                return length(refrence - centre)- r ;
            }

            float sdfBox( float3 refrence,float3 centre, float3 b )
            {
                b *=0.5;
                float3 q = abs(refrence - centre) - b;
                return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
            }

            float sdf(float3 p)
            {
            
               
                float4 quat = float4(-Quaternion_Cube1.xyz, Quaternion_Cube1.w);
                float3 p0 = p - Pos1; 
                p0 = rotateVector(p0,quat);
                p0 += Pos1;
                float a = sdfBox(p0,Pos1,Size1);
                quat = float4(-Quaternion_Cube2.xyz,Quaternion_Cube2.w);
                float3 p1 = p - Pos2;
                p1 = rotateVector(p1,quat);
                p1 += Pos2;
                float b = sdfBox(p1,Pos2,Size2);
                return smin(a,b,1.);
                
            }

            float3 ComputeRayDirection(float2 uv)
            {
                float4 clip = float4(uv, 1.0, 1.0);
                float4 view = mul(unity_CameraInvProjection, clip);
                return normalize(view.xyz / -view.w);
            }
            
            float raymarch(float2 uv)
            {
                
                float t = 0;
                
                float3 r0 = _WorldSpaceCameraPos;
                float3 rd = ComputeRayDirection(uv);
                
                rd = rotateVector(rd, Quaternion_Cam);
                float3 p = float3(0.,0.,0.);
                for(int i = 0;i<80;i++)
                
                {
                    p = r0 + rd * t;
                    t += sdf(p);
                    if (t<0.1||t>1000)
                    {
                        break;
                    }
                }
                    
               
                return t;
            }

            float3 calcNormal(float3 p ) 
            {
                float eps = 0.0001; 
                float2 h = float2(eps,0);
                return normalize( float3(sdf(p+h.xyy) - sdf(p-h.xyy),sdf(p+h.yxy) - sdf(p-h.yxy),sdf(p+h.yyx) - sdf(p-h.yyx) ) );
            }
          
            

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.wPos = mul(unity_ObjectToWorld,v.vertex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                 float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture,i.uv);
                 depth = Linear01Depth(depth) * _ProjectionParams.z;
                 
                 float4 col = tex2D(_MainTex, i.uv);
                 float2 uv = (i.vertex.xy / _ScreenParams.xy) * 2.0 - 1.0; 
                 uv.x*=-1;
                 float d = raymarch(uv);
                 
              
                 if(d<1000 && d<depth)
                 {
                    float3 r0 = _WorldSpaceCameraPos;
                    float3 rd = ComputeRayDirection(uv);
                    
                    rd = rotateVector(rd, Quaternion_Cam);
                    float3 p = r0 + rd*d;
                    
                    
                    
                    
                    float3 N = calcNormal(p);
                 
                    float3 L = normalize(_WorldSpaceLightPos0.xyz);
                    
                 
                    float3 diffuseLight = saturate(dot(L,N)) * _LightColor0.xyz;
                    col = float4(saturate(float3(0.2,0.2,0.2)*0.2 + diffuseLight*0.5),1) ;
                 }
                    
                    
                    
                   
                 
                
              
                

                 return col;
            }
                 
                 
            ENDCG
        }
    }
}
