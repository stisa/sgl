# Package
version       = "0.1.0"
author        = "stisa"
description   = "NGL"
license       = "MIT"

srcDir = "src"

skipDirs = @["templates"]

# Deps
requires: "nim >= 0.16.0"

import ospaths

task examples, "Build examples":
  mkdir "docs"/"examples"
  exec("exampler") # custom utility to generate example pages
  withdir "examples":
    for file in listfiles("."):
      if splitfile(file).ext == ".nim":
        exec "nim js -o:" & ".."/"docs"/"examples"/file.changefileext("js") & " " & file

task docs, "Builds documentation":
  mkDir("docs"/"ngl")
  exec "nim doc2 --verbosity:0 --hints:off -o:docs/index.html  ngl.nim"
  for file in listfiles("ngl"):
    if splitfile(file).ext == ".nim":
      exec "nim doc2 --verbosity:0 --hints:off -o:" & "docs" /../ file.changefileext("html") & " " & file
  echo "DONE - Look inside /docs, possibly serve it to a browser."