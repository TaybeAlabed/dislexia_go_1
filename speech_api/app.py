from flask import Flask, request, jsonify
from flask_cors import CORS
import speech_recognition as sr
import difflib
import os

app = Flask(__name__)
CORS(app)

@app.route('/recognize', methods=['POST'])
def recognize():
    if 'audio' not in request.files or 'text' not in request.form:
        return jsonify({'error': 'Eksik veri'}), 400

    audio_file = request.files['audio']
    original_text = request.form['text']

    recognizer = sr.Recognizer()
    with sr.AudioFile(audio_file) as source:
        audio_data = recognizer.record(source)

    try:
        transcript = recognizer.recognize_google(audio_data, language='tr-TR')
    except sr.UnknownValueError:
        return jsonify({'error': 'Tanıma başarısız'}), 400

    # Kelime bazlı karşılaştırma
    expected_words = original_text.lower().split()
    spoken_words = transcript.lower().split()
    result = []

    for i in range(len(expected_words)):
        word = expected_words[i]
        matched = spoken_words[i] if i < len(spoken_words) else ''
        result.append({
            'word': word,
            'correct': word == matched
        })

    return jsonify({
        'transcript': transcript,
        'words': result
    })

if __name__ == '__main__':
    app.run(debug=True)
