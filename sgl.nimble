# Package
version       = "0.1.0"
author        = "stisa"
description   = "SGL"
license       = "MIT"

srcDir = "src"

#skipDirs = @["templates"]

# Deps
requires: "nim >= 0.16.0"

import ospaths

task examples, "Build examples":
  mkdir "docs"/"examples"
  exec("exampler") # custom utility to generate example pages
  withdir "examples":
    for file in listfiles("."):
      if splitfile(file).ext == ".nim":
        echo ".."/"docs"/"examples"/file.changefileext("js") & " " & file
        exec "nim js -o:" & ".."/"docs"/"examples"/file.changefileext("js") & " " & file
  echo "DONE - Look inside /docs/examples, possibly serve it to a browser."

task docs, "Builds documentation":
  mkDir("docs"/"sgl")
  withdir "src":
    exec "nim doc2 --verbosity:0 --hints:off -o:"& ".."/"docs"/"sgl.html  sgl.nim"
    for file in listfiles("sgl"):
      if splitfile(file).ext == ".nim":
        echo ".."/"docs" / "sgl" / file.changefileext("html") & " " & file
        exec "nim doc2 --verbosity:0 --hints:off -o:" & ".." / "docs" / file.changefileext("html") & " " & file
    echo "DONE - Look inside /docs, possibly serve it to a browser."