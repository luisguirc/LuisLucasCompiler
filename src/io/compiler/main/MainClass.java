package io.compiler.main;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

import io.compiler.core.UFABCGrammarLexer;
import io.compiler.core.UFABCGrammarParser;
import io.compiler.core.ast.Program;

public class MainClass {
    public static void main(String[] args) {
        try {
            UFABCGrammarLexer lexer;
            UFABCGrammarParser parser;

            String language = "java";  // Default to Java
            String codeInput = "";

            // Check if an argument is passed; if so, use it as input
            if (args.length > 0) {
                codeInput = args[0];
                if (args.length > 1) {
                    language = args[1].toLowerCase();  // Set the language if provided
                }
                lexer = new UFABCGrammarLexer(CharStreams.fromString(codeInput));
            } else {
                lexer = new UFABCGrammarLexer(CharStreams.fromFileName("program.in"));
            }

            CommonTokenStream tokenStream = new CommonTokenStream(lexer);
            parser = new UFABCGrammarParser(tokenStream);

            parser.programa();
            System.out.println("Compilation successful. Target language: " + language);

            // Generate the code for the program
            Program program = parser.getProgram();

            if (args.length == 0) {
                // Write the output to a file if no argument is passed
                try {
                    File f = new File(program.getName() + "." + language);
                    FileWriter fr = new FileWriter(f);
                    PrintWriter pr = new PrintWriter(fr);
                    pr.println(program.generateTarget());
                    pr.close();
                } catch (IOException ex) {
                    ex.printStackTrace();
                }
            }

            System.out.println(program.generateTarget());;

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}