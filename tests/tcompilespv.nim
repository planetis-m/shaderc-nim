import shaderc
# import opengl

proc createShaderModule(source: string, kind: ShadercShaderKind,
                        filename: string = "", optimize = false) =
  let compiler = shadercCompilerInitialize()
  let options = shadercCompileOptionsInitialize()
  try:
    setTargetEnv(options, Opengl, 0)
    if optimize:
      setOptimizationLevel(options, Size)
    let module = compileIntoSpv(compiler, source.cstring, source.len.csize_t,
        ComputeShader, filename, "main", options)
    try:
      if module.getCompilationStatus() != Success:
        raise newException(ValueError, "Error compiling module - " & $module.getErrorMessage())
      # glShaderBinary(1, addr program, GL_SHADER_BINARY_FORMAT_SPIR_V, module.getBytes(),
      #                module.getLength().GLsizei)
    finally:
      module.release()
  finally:
    options.release()
    compiler.release()

proc main =
  # let program = glCreateShader(GL_COMPUTE_SHADER)
  createShaderModule(readFile("square.comp.glsl"), ComputeShader, "square")
  # glSpecializeShader(program, "main", 0, nil, nil)

main()
