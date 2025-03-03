// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/DepthGrayscale" {
	SubShader{
		Tags{ "RenderType" = "Opaque" }

		Pass{
			CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

//			sampler2D _CameraDepthTexture;
			UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

			struct v2f {
				float4 pos : SV_POSITION;
				float4 scrPos:TEXCOORD0;
			};

			//Vertex Shader
			v2f vert(appdata_base v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.scrPos = ComputeScreenPos(o.pos);


				//for some reason, the y position of the depth texture comes out inverted
				//o.scrPos.y = 1 - o.scrPos.y;
				return o;
			}

			//Fragment Shader
			half4 frag(v2f i) : COLOR{
				//float depthValue = Linear01Depth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)).r);
				float depthValue = Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.scrPos));
				//float depthValue = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.scrPos);
				
				//float depthValue = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.scrPos));
				half4 depth;

				depth.r = depthValue;
				depth.g = depthValue;
				depth.b = depthValue;

				depth.a = 1;
				return depth;
			}
				ENDCG
		}
	}
	FallBack "Diffuse"
}