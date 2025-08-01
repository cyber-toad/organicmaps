layout (location = 0) in vec4 a_position;
layout (location = 1) in vec2 a_normal;
layout (location = 2) in vec2 a_colorTexCoords;

layout (location = 0) out vec2 v_colorTexCoords;

layout (binding = 0) uniform UBO
{
  mat4 u_modelView;
  mat4 u_projection;
  mat4 u_pivotTransform;
  vec2 u_contrastGamma;
  float u_opacity;
  float u_zScale;
  float u_interpolation;
  float u_isOutlinePass;
};

void main()
{
  vec4 pos = vec4(a_position.xyz, 1) * u_modelView;
  float normalLen = length(a_normal);
  vec4 n = vec4(a_position.xy + a_normal * kShapeCoordScalar, 0.0, 0.0) * u_modelView;
  vec4 norm = vec4(0.0, 0.0, 0.0, 0.0);
  if (dot(n, n) != 0.0)
    norm = normalize(n) * normalLen;
  vec4 shiftedPos = norm + pos;
  gl_Position = applyPivotTransform(shiftedPos * u_projection, u_pivotTransform, 0.0);
  v_colorTexCoords = a_colorTexCoords;
}
