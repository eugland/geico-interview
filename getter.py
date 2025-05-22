import mss
from PIL import Image
import win32clipboard
import io
import keyboard
import pyautogui
import time

def screenshot_monitor_2_to_clipboard_and_paste():
    with mss.mss() as sct:
        if len(sct.monitors) < 3:
            print("❌ Monitor 2 not found.")
            return

        monitor2 = sct.monitors[2]
        sct_img = sct.grab(monitor2)
        img = Image.frombytes("RGB", sct_img.size, sct_img.rgb)

        output = io.BytesIO()
        img.convert("RGB").save(output, "BMP")
        data = output.getvalue()[14:]
        output.close()

        win32clipboard.OpenClipboard()
        win32clipboard.EmptyClipboard()
        win32clipboard.SetClipboardData(win32clipboard.CF_DIB, data)
        win32clipboard.CloseClipboard()

        print("✅ Screenshot from Monitor 2 copied to clipboard.")

        time.sleep(0.2)  # Slight delay before paste
        pyautogui.hotkey('ctrl', 'v')  # Simulate paste
        print("📋 Pasted into active window.")

# Bind to your macro: Ctrl + Alt + Shift + G
keyboard.add_hotkey("ctrl+alt+shift+g", screenshot_monitor_2_to_clipboard_and_paste)

print("🎯 Press Ctrl + Alt + Shift + G to capture & paste screenshot from Monitor 2.")
print("❌ Press ESC to quit.")
keyboard.wait("esc")
