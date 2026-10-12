import os
import subprocess

input_dir = "./assets/audio"
output_dir = "./assets/audio_compressed"

os.makedirs(output_dir, exist_ok=True)

for file in os.listdir(input_dir):
    if file.endswith(".mp3") or file.endswith(".wav"):
        in_path = os.path.join(input_dir, file)
        out_path = os.path.join(output_dir, os.path.splitext(file)[0] + ".m4a")
        
        cmd = [
            "ffmpeg", "-y", "-i", in_path,
            "-vn",                  # إهمال أي فيديو/صورة غلاف ملحقة بالملف
            "-ac", "1",             # تحويل لـ Mono
            "-c:a", "aac",          # تحديد مشفر الصوت AAC صراحة
            "-b:a", "32k",          # معدل بت 32K
            "-ar", "22050",        # معدل عينة مناسب للخطب
            out_path
        ]
        subprocess.run(cmd)
        print(f"تم ضغط: {file}")