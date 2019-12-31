Shader "Unlit/CheckerShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_SecondTex("Texture", 2D) = "white" {}
		_Frequency("Frequency", Range(0.1,100)) = 2.0
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 100
			Pass {
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				// make fog work
				#pragma multi_compile_fog

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				 struct v2f
				{
					float2 uv : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					float4 vertex : SV_POSITION;
					float4 screenPos : TEXCOORD1;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				sampler2D _SecondTex;
				float4 _SecondTex_ST;
				float _Frequency;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					//o.screenPos = ComputeScreenPos(o.vertex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					int row = (int)(i.uv.y * _Frequency);
					int column = (int)(i.uv.x * _Frequency);
					fixed4 col1 = tex2D(_MainTex, i.uv);
					fixed4 col2 = tex2D(_SecondTex, i.uv);
					if (row % 2 == 0)
					{
						if (column % 2 == 0)
						{
							return col2;
						}

						return col1;
					}
					if (column % 2 == 0)
					{
						return col1;
					}
					return col2;
				}
				ENDCG
			}
		}
}