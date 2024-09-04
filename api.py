from flask import Flask, request, jsonify, render_template
import subprocess

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/compile', methods=['POST'])
def compile_code():
    code = request.json.get('code', '')
    language = request.json.get('language', 'java').lower()  # Default to 'java'

    if not code:
        return jsonify({'error': 'No code provided'}), 400

    try:
        result = subprocess.run(
            [
                'java',
                '-Dfile.encoding=UTF-8',
                '-classpath',
                r"C:\Users\kendy\eclipse-workspace\LuisLucasCompiler\bin;C:\Users\kendy\eclipse-workspace\LuisLucasCompiler\antlr-4.13.2-complete.jar",
                'io.compiler.main.MainClass', code, language
            ],
            capture_output=True,
            text=True
        )
        
        # Get the full output from the compiler
        full_output = result.stdout

        # Split the output into lines and find where the actual code starts
        output_lines = full_output.splitlines()
        additional_info = []
        translated_code_lines = []
        capture_code = False

        for line in output_lines:
            if capture_code:
                translated_code_lines.append(line)
            else:
                if "Compilation successful" in line:
                    capture_code = True
                additional_info.append(line)

        translated_code = "\n".join(translated_code_lines)
        additional_info_text = "\n".join(additional_info)

        if result.returncode != 0:
            return jsonify({'error': 'Compilation failed', 'details': additional_info_text}), 500
        
        return jsonify({'translated_code': translated_code, 'additional_info': additional_info_text})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
