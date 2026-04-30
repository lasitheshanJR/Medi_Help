import smtplib
import os
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders

def send_email():
    from_addr = "techlasi333@gmail.com"
    to_addr = "techlasi333@gmail.com"
    password = "yykn hnbp twix gtza"

    msg = MIMEMultipart()
    msg['From'] = from_addr
    msg['To'] = to_addr
    msg['Subject'] = "MediHelp Android APK Deployment"

    body = "The Android APK has been successfully built and is ready for deployment. Please find the attached file."
    msg.attach(MIMEText(body, 'plain'))

    filename = "app-release.apk"
    attachment_path = r"c:\Users\DELL\Downloads\Just_In-_Time-main\frontend\build\app\outputs\flutter-apk\app-release.apk"

    if not os.path.exists(attachment_path):
        print(f"Error: APK not found at {attachment_path}")
        return

    print(f"Attaching APK from {attachment_path}...")
    with open(attachment_path, "rb") as attachment:
        part = MIMEBase('application', 'octet-stream')
        part.set_payload(attachment.read())
        encoders.encode_base64(part)
        part.add_header('Content-Disposition', f"attachment; filename= {filename}")
        msg.attach(part)

    try:
        print("Connecting to SMTP server...")
        server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
        server.login(from_addr, password)
        print("Sending email...")
        text = msg.as_string()
        server.sendmail(from_addr, to_addr, text)
        server.quit()
        print("Email sent successfully!")
    except Exception as e:
        print(f"Failed to send email: {e}")

if __name__ == "__main__":
    send_email()
