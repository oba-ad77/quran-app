import os
import re

audio_dir = "assets/audio_compressed"
if os.path.exists(audio_dir):
    files = os.listdir(audio_dir)
    
    def extract_number(filename):
        numbers = re.findall(r'\d+', filename)
        return int(numbers[0]) if numbers else 0

    sorted_files = sorted([f for f in files if f.lower().endswith(('.mp3', '.m4a', '.wav'))], key=extract_number)

    with open("lib/lectures_data.dart", "w", encoding="utf-8") as f:
        f.write("final List<Map<String, String>> lectures = [\n")
        for file in sorted_files:
            title_name = os.path.splitext(file)[0].replace("'", "\\'")
            f.write(f"  {{'title': '{title_name}', 'path': '{audio_dir}/{file}'}},\n")
        f.write("];\n")
    print("تم تحديث الأسماء والترتيب بنجاح!")