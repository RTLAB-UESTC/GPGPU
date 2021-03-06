// 
// Copyright 2011-2013 Jeff Bush
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// 

#ifndef __PIXEL_SHADER_H
#define __PIXEL_SHADER_H

#include "vectypes.h"
#include "ParameterInterpolator.h"
#include "RenderTarget.h"
#include "VertexShader.h"

namespace render
{

class PixelShader
{
public:
	PixelShader(ParameterInterpolator *interp, RenderTarget *target);
	void fillMasked(int left, int top, unsigned short mask);
	void enableZBuffer(bool enabled)
	{
		fEnableZBuffer = enabled;
	}
	
	bool isZBufferEnabled() const
	{
		return fEnableZBuffer;
	}
	
	void enableBlend(bool enabled)
	{
		fEnableBlend = enabled;
	}
	
	bool isBlendEnabled() const
	{
		return fEnableBlend;
	}
	
	virtual void shadePixels(const vecf16 inParams[kMaxVertexParams], 
		vecf16 outColor[4], unsigned short mask) = 0;
private:
	RenderTarget *fTarget;
	ParameterInterpolator *fInterpolator;
	float fTwoOverWidth;
	float fTwoOverHeight;
	bool fEnableZBuffer;
	bool fEnableBlend;
};

}

#endif
