package modchart.internal;

import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GLVertexArrayObject;
import modchart.math.Transform;
import openfl.display3D.textures.RectangleTexture;

class Renderer {
	static var quadVBO:GLBuffer;
	static var quadEBO:GLBuffer;

	// basic (default) shader
	static var basicProgram:GLProgram;
	static var basicVertexShader:GLShader;
	static var basicFragShader:GLShader;

	static var basicProgramTexAttribLocation:Int;

	static var bAttribLocModel:Int;
	static var bAttribLocView:Int;
	static var bAttribLocProj:Int;

	// static var bMatrixModel:Matrix4;
	static var bMatrixView:Matrix4;
	static var bMatrixProj:Matrix4;

	static var basicSetup:Bool = false;

	var programs:StringMap<GLProgram>;

	public function new() {
		if (!basicSetup) {
			// generate vbo and ebo
			// x-y-z-u-v
			var vertices = [
				-0.5,  0.5, 0.0, 0.0, 1.0,
				 0.5,  0.5, 0.0, 1.0, 1.0,
				-0.5, -0.5, 0.0, 0.0, 0.0,
				 0.5, -0.5, 0.0, 1.0, 0.0
			];

			var indices = [
				0, 1, 2,
				2, 1, 3
			];

			var verticesBytes = new Float32Array(vertices.length);
			for (i in 0...vertices.length) {
				verticesBytes[i] = vertices[i];
			}

			var indicesBytes = new UInt16Array(indices.length);
			for (i in 0...indices.length) {
				indicesBytes[i] = indices[i];
			}

			quadVBO = gl.createBuffer();
			gl.bindBuffer(GL.ARRAY_BUFFER, quadVBO);
			gl.bufferData(GL.ARRAY_BUFFER, verticesBytes, GL.STATIC_DRAW);

			quadEBO = gl.createBuffer();
			gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, quadEBO);
			gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, indicesBytes, GL.STATIC_DRAW);

			gl.bindBuffer(GL.ARRAY_BUFFER, null);
			gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);

			// generate shaders and program
			basicVertexShader = gl.createShader(gl.VERTEX_SHADER);
			gl.shaderSource(basicVertexShader, VERTEX_SHADER_SRC);
			gl.compileShader(basicVertexShader);

			var vertexStatus = gl.getShaderParameter(basicVertexShader, gl.COMPILE_STATUS);
			if (vertexStatus != null)
				ModchartLog("Failed to compile vertex frag shader: " + fragStatus);

			basicFragShader = gl.createShader(gl.FRAGMENT_SHADER);
			gl.shaderSource(basicFragShader, FRAGMENT_SHADER_SRC);
			gl.compileShader(basicFragShader);

			var fragStatus = gl.getShaderParameter(basicFragShader, gl.COMPILE_STATUS);
			if (fragStatus != null)
				ModchartLog("Failed to compile basic frag shader: " + fragStatus);

			basicProgram = gl.createProgram();
			gl.attachShader(basicProgram, basicVertexShader);
			gl.attachShader(basicProgram, basicFragShader);
			gl.linkProgram(basicProgram);

			var programStatus = gl.getProgramParameter(program, gl.LINK_STATUS);
			if (programStatus != null)
				ModchartLog("Failed to link basic shader program: " + programStatus);

			basicProgramTexAttribLocation = gl.getUniformLocation(glProgram, "tex");

			bAttribLocModel = gl.getUniformLocation(program, "model");
			bAttribLocView = gl.getUniformLocation(program, "view");
			bAttribLocProj = gl.getUniformLocation(program, "projection");

			basicSetup = true;
		}

		programs = new StringMap<GLProgram>();
	}

	// we never know
	var wasBlendEnabled:Bool;
	var wasDepthTest:Bool;

	public function prepare() {
		wasDepthTest = gl.isEnabled(gl.DEPTH_TEST);
		wasBlendEnabled = gl.isEnabled(gl.BLEND);

		if (!wasDepthTest)
			gl.enable(gl.DEPTH_TEST);
		if (!wasBlendEnabled)
			gl.enable(gl.BLEND);

		gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);

		gl.clearColor(0, 0, 0, 1);
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
	}

	public function flush() {
		if (!wasDepthTest)
			gl.disable(gl.DEPTH_TEST);
		if (!wasBlendEnabled)
			gl.disable(gl.BLEND);
	}

	public function drawQuad(texture:RectangleTexture, transform:Transform, ?program:String) {
		var glProgram:GLProgram = null;

		gl.enable(gl.DEPTH_TEST);
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

		if (program == null)
			glProgram = basicProgram;
		else
			glProgram = programs.get(program) ?? basicProgram;

		gl.activeTexture(gl.TEXTURE0);
		gl.bindTexture(gl.TEXTURE_2D, @:privateAccess texture.__textureID);

		gl.useProgram(glProgram);

		gl.uniform1i(basicProgramTexAttribLocation, 0);

		gl.bindBuffer(GL.ARRAY_BUFFER, quadVBO);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, quadEBO);

		gl.vertexAttribPointer(0, 3, gl.FLOAT, false, 5 * 4, 0);
		gl.enableVertexAttribArray(0);

		gl.vertexAttribPointer(1, 2, gl.FLOAT, false, 5 * 4, 3 * 4);
		gl.enableVertexAttribArray(1);

		gl.drawElements(GL.TRIANGLES, 6, GL.UNSIGNED_SHORT, 0);

		gl.bindBuffer(GL.ARRAY_BUFFER, null);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	}

	static final VERTEX_SHADER_SRC:String = "
        #version 330 core

        layout(location = 0) in vec3 aPos;
        layout(location = 1) in vec2 aUV;

        uniform mat4 model;
        uniform mat4 view;
        uniform mat4 projection;

        out vec2 vUV;

        void main()
        {
            gl_Position =
                projection *
                view *
                model *
                vec4(aPos, 1.0);

            vUV = aUV;
        }
    ";
	static final FRAGMENT_SHADER_SRC:String = "
        #version 330 core

        in vec2 vUV;

        out vec4 FragColor;

        uniform sampler2D tex;

        void main()
        {
            FragColor = texture(tex, vUV);
        }
    ";
}
