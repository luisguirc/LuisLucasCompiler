# LLCompiler (LuisLucasCompiler)

Luis Guilherme Redigolo Crosselli 11201920964
Lucas Kendy Shimizu Silva 11202020248

Before runnning the web compiler, install flask (note: you may change from "pip" to "pip3" depending on your local python installation)

    pip install flask

Then, simply run the "api.py" file with the command below on the command line (note: you may change from "python" to "python3" depending on your local python installation)

    python api.py



To generate ANTLR archives, use the command below:

    java -cp antlr-4.13.2-complete.jar org.antlr.v4.Tool UFABCGrammar.g4 -o src\io\compiler\core\ -package io.compiler.core
    
