from flask import Flask, request, jsonify, render_template
import subprocess
import os

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
        project_dir = os.path.dirname(os.path.abspath(__file__))
        bin_dir = os.path.join(project_dir, "bin")
        antlr_jar_path = os.path.join(project_dir, "antlr-4.13.2-complete.jar")

        classpath = f"{bin_dir};{antlr_jar_path}"
        
        print(language)

        result = subprocess.run(
            [
                'java',
                '-Dfile.encoding=UTF-8',
                '-classpath',
                classpath,
                'io.compiler.main.MainClass', code, language
            ],
            capture_output=True,
            text=True
        )
        if result.stderr:
            error_output = result.stderr
            return jsonify({'error': 'Compilation failed', 'details': error_output}), 500

        full_output = result.stdout

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

        return jsonify({'translated_code': translated_code, 'additional_info': additional_info_text})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
